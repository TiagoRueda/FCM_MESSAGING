import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Título: addDocumentToFirestore
// Descrição: Função responsável por adicionar um novo documento à coleção 'principal/event' no Firestore. 
//             O documento serve como gatilho para o 'corpo' da notificação a ser enviada.
// Autor: TiagoRueda

void addDocumentToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Timestamp timestamp = Timestamp.now();

  await firestore.collection('principal/event').add({
    "title": "Titulo da msg",
    "body": "Corpo da msg",
    "data": timestamp,
    "page": "page"
  }).then((value) {
    print("Documento adicionado com sucesso!");
  }).catchError((error) {
    print("Erro ao adicionar documento: $error");
  });
}