import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addDocumentToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Crie um timestamp para os campos de data
  Timestamp timestamp = Timestamp.now();

  // Adicione o documento à coleção desejada
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
