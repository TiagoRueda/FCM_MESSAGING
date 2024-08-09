import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addFCMToken(String userID) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _tokensCollection =
      _firestore.collection('users').doc(userID).collection('fcm_token');
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  String? token = await fcm.getToken();

  if (token != null) {
    QuerySnapshot querySnapshot = await _tokensCollection.where('fcm_token', isEqualTo: token).get();
    if (querySnapshot.docs.isEmpty) {
      try {
        await _tokensCollection.add({'fcm_token': token});
        print('Token FCM adicionado com sucesso!');
      } catch (error) {
        print('Erro ao adicionar token FCM: $error');
      }
    } else {
      print('Token FCM já existe na coleção.');
    }
  }
}

Future<void> deleteFCM(String userID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _tokensCollection =
        _firestore.collection('user').doc(userID).collection('fcm_token');
    final FirebaseMessaging fcm = FirebaseMessaging.instance;

    String? token = await fcm.getToken();

    if (token != null) {
      QuerySnapshot querySnapshot = await _tokensCollection.get();
      querySnapshot.docs.forEach((doc) async {
        final fcmToken = doc['fcm_token'];
        if (fcmToken == token) {
          try {
            await _tokensCollection.doc(doc.id).delete();
            print('Documento deletado com sucesso!');
          } catch (error) {
            print('Erro ao deletar documento: $error');
          }
        }
      });
  }
}
