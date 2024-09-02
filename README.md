Descrição do Projeto
O Contas Compartilhadas é um aplicativo móvel desenvolvido para ajudar grupos de pessoas, como famílias ou amigos, a gerenciar suas finanças coletivas. O aplicativo permite que os usuários registrem receitas, despesas e visualizem relatórios financeiros detalhados. O objetivo principal é promover transparência e organização nas finanças compartilhadas.

Funcionalidades
Cadastro de Usuários e Grupos:
Criação de perfil de usuário.
Criação de grupos financeiros com convites via email.
Registro de Renda e Gastos:
Cadastro de renda fixa.
Registro de despesas fixas e variáveis.
Visualização de Dados:
Gráficos comparativos de receitas e despesas.
Relatórios financeiros filtrados por período.

Segurança:
Autenticação via Firebase Authentication.
Criptografia de dados sensíveis.

Tecnologias Utilizadas
Linguagem: Dart
Framework: Flutter
Banco de Dados: Firebase Firestore
Autenticação: Firebase Authentication
Gerenciamento de Estado: Provider

Configuração do Ambiente
Pré-requisitos
Flutter SDK: Instalar Flutter
Firebase CLI: Instalar Firebase CLI
Conta Firebase: Criar uma conta no Firebase
Passo a Passo
Clone o Repositório:

bash
Copiar código
git clone https://github.com/usuario/contas-compartilhadas.git
cd contas-compartilhadas
Instale as Dependências:

bash
Copiar código
flutter pub get
Configure o Firebase:

Crie um novo projeto no Firebase Console.
Adicione um aplicativo Android e/ou iOS ao projeto.
Baixe o arquivo google-services.json (para Android) ou GoogleService-Info.plist (para iOS) e coloque-o na pasta apropriada (android/app ou ios/Runner).
No Firebase Console, ative os serviços de Firestore e Authentication.
Configure as regras do Firestore e da Authentication conforme necessário.
Configure o Firebase CLI:

bash
Copiar código
firebase login
firebase init
Execução do Projeto

Inicie o Aplicativo:

bash
Copiar código
flutter run
Monitoramento do Firebase:

Acesse o Firebase Console para monitorar autenticação de usuários e dados do Firestore.
