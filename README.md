# FCM Messaging

Este repositório contém exemplos e scripts para o envio de notificações push utilizando Firebase Cloud Messaging (FCM). O objetivo é demonstrar como obter tokens FCM — tanto por meio de Cloud Functions quanto diretamente pelo app usando Dart — e como enviar notificações personalizadas aos usuários.
> ⚠️ **Aviso**  
> Isto **não representa uma implementação completa** de um sistema de notificações com FCM. A documentação está incompleta e serve apenas como base para estudos ou personalizações futuras. Ainda assim, os passos abaixo e os scripts fornecidos podem ser úteis como guia inicial.

## Pré-requisitos

- Node.js e npm instalados.
- Firebase CLI configurado.
- Projeto Firebase configurado com Firestore e Firebase Cloud Messaging habilitados.

## Como Usar

### Configuração do Firebase
1. Certifique-se de que o Firebase Admin SDK está configurado corretamente.
2. Atualize as regras do Firestore para permitir o acesso necessário às coleções `users`, `fcm_tokens`, e `principal`.

### Implantação das Funções
1. Navegue até o diretório do projeto.
2. Execute o comando para implantar as funções:
   ```bash
   firebase deploy --only functions
   ```

# Uso no Cliente
- Utilize as funções Dart para gerenciar tokens FCM no lado do cliente (chamando a function ou com o próprio dart).
- Certifique-se de que o aplicativo cliente está configurado para receber notificações push.