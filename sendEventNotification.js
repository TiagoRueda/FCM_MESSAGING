const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Título: sendEventNotification
// Descrição: Esta função é acionada sempre que há uma alteração na coleção 'principal/{eventId}' no Firestore.
//             Quando um evento é criado, a função envia uma notificação push para todos os usuários com
//             o título e a descrição do evento.
// Autor: TiagoRueda

exports.sendEventNotification = functions.firestore.document('principal/{eventId}')
    .onWrite(async (change, context) => {
        try {
            const eventId = context.params.eventId;

            console.log(`Evento recebido eventId=${eventId}`);

            const eventType = !change.after.exists ? 'deleted' :
                (!change.before.exists ? 'created' : 'updated');

            console.log(`Tipo de evento: ${eventType}`);

            if (eventType === 'created') {
                const eventData = change.after.data();
                const title = eventData.title;
                const body = eventData.body;

                console.log(`Título do evento: ${title}, descrição: ${body}`);

                const notificationPromises = [];

                const usersQuerySnapshot = await admin.firestore().collection('users').get();
                usersQuerySnapshot.forEach((userDoc) => {
                    const userData = userDoc.data();
                    const userUid = userData.uid;

                    console.log(`Usuário UID: ${userUid}`);

                    const parameter_data = JSON.stringify({ docCentral: `principal/${eventId}` });
                    console.log(`Parametro page: ${parameter_data}`);

                    const userRef = admin.firestore().collection(`users/${userUid}/fcm_token`);
                    const tokensPromise = userRef.get().then(async (tokensSnapshot) => {
                        tokensSnapshot.forEach(async (tokenDoc) => {
                            const tokenData = tokenDoc.data();
                            const fcmToken = tokenData.fcm_token;

                            if (fcmToken) {
                                const message = {
                                    notification: {
                                        title: title,
                                        body: body,
                                    },
                                    data: {
                                        initialPageName: 'page',
                                        parameterData: parameter_data
                                    },
                                    android: {
                                        priority: "high",
                                        notification: {
                                            icon: 'ic_launcher_background',
                                            color: "#0b5297",
                                        },
                                    },
                                    apns: {
                                        payload: {
                                            aps: {
                                                badge: 1,
                                            },
                                        },
                                    },
                                    token: fcmToken,
                                };

                                await admin.messaging().send(message);
                                console.log(`Notificação enviada com sucesso para o usuário: ${userUid}`);
                            } else {
                                console.log(`O usuário ${userUid} não possui um token FCM.`);
                            }
                        });
                    });
                    notificationPromises.push(tokensPromise);
                });

                await Promise.all(notificationPromises);
            }
        } catch (error) {
            console.error('Erro ao enviar notificação:', error);
        }
    });
