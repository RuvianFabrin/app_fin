Controle Financeiro Pessoal - App Flutter
Um aplicativo completo de controle financeiro pessoal, desenvolvido com Flutter. Permite um gerenciamento detalhado das suas finanças, organizado por mês e ano, com armazenamento local seguro usando SQLite.

(Sugestão: Grave um GIF mostrando a navegação entre as telas e a adição de uma nova transação)

🚀 Principais Funcionalidades
📅 Controle Mensal: Crie e gerencie um controle financeiro para cada mês/ano, permitindo uma visão clara da sua evolução financeira.

©️ Clonagem de Mês: Copie toda a estrutura de um mês (transações, cartões, etc.) para um novo mês, facilitando o planejamento recorrente.

💸 Lançamentos (Entradas e Despesas):

Adicione, edite e exclua transações de entrada e saída.

Agrupe despesas por categoria para uma análise mais clara.

Marque despesas como "Pagas" para um controle de fluxo de caixa preciso.

💳 Gestão de Cartões de Crédito:

Cadastre múltiplos cartões de crédito.

Controle o limite, o valor atual da fatura, a data de vencimento e o melhor dia para compra.

💰 Investimentos: Registre e acompanhe o total de seus investimentos.

🛍️ Compras Futuras: Planeje e visualize gastos futuros para se preparar financeiramente.

🚨 Dívidas: Monitore dívidas e valores pendentes de pagamento.

💾 Persistência Local: Todos os dados são salvos localmente no seu dispositivo usando um banco de dados SQLite, garantindo privacidade e acesso offline.

✨ Interface Moderna:

Tema escuro (Brightness.dark) e uso de Material 3.

Formatação de moeda automática para o padrão brasileiro (R$).

Autocomplete inteligente de categorias para agilizar o cadastro.

🛠️ Estrutura do Projeto (Single-file main.dart)
Todo o código-fonte está contido em um único arquivo, main.dart, e está organizado nas seguintes seções:

Modelos de Dados: Classes FinancialControl, Transaction, CreditCard, FuturePurchase, Investment e Debt que definem a estrutura dos dados do aplicativo.

Helper do Banco de Dados: A classe DatabaseHelper (padrão Singleton) que gerencia todas as operações do banco de dados SQLite (CRUD - Create, Read, Update, Delete) e as migrações de versão.

App & Telas (UI):

FinancialControlApp: Widget principal que configura o MaterialApp, tema e localização.

HomePage: Tela inicial que lista todos os controles mensais criados.

ControlPage: Tela de detalhes onde o usuário visualiza e gerencia todas as informações de um mês específico (despesas, entradas, cartões, etc.).

🔧 Tecnologias Utilizadas
Framework: Flutter

Linguagem: Dart

Banco de Dados: sqflite - Para persistência de dados local.

Formatação: intl - Para formatação de datas e moeda.

Manipulação de Path: path - Para construção de caminhos de banco de dados.

▶️ Como Executar
Clone o repositório:

Bash

git clone https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
Navegue até o diretório do projeto:

Bash

cd SEU-REPOSITORIO
Instale as dependências:

Bash

flutter pub get
Execute o aplicativo:

Bash

flutter run
📈 Possíveis Melhorias
Este é um projeto com uma base sólida. Algumas ideias para futuras versões:

[ ] Refatoração: Dividir o main.dart em arquivos separados por funcionalidade (models, database, views/pages, widgets) para melhor organização.

[ ] Gráficos e Relatórios: Adicionar gráficos (pizza, barras) para uma visualização mais intuitiva das despesas por categoria e do balanço mensal.

[ ] Backup e Restauração: Implementar uma função para exportar e importar o banco de dados.

[ ] Notificações: Criar lembretes para contas a pagar próximas do vencimento.

[ ] Sincronização na Nuvem: Oferecer a opção de sincronizar os dados entre dispositivos usando um backend (ex: Firebase).

📄 Licença
Este projeto é distribuído sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.