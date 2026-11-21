
# Desafio de Cadastro de Veículos — Dart e Supabase

Aplicação desenvolvida em Dart para realizar o cadastro e o gerenciamento de veículos em um banco de dados Supabase, por meio de um menu interativo no terminal.

## Configuração da conexão

Para executar o projeto, é necessário configurar as credenciais de conexão com o Supabase.

1. Clone o repositório:

```bash
git clone https://github.com/andreaortega10/desafio-dart-veiculos.git
```

2. Acesse a pasta do projeto:

```bash
cd desafio-dart-veiculos
```

3. Instale as dependências:

```bash
dart pub get
```

4. Crie um arquivo `.env` na raiz do projeto, seguindo o modelo abaixo:

```env
SUPABASE_URL=sua_url_do_supabase
SUPABASE_PUBLISHABLE_KEY=sua_chave_publica_do_supabase
```

Substitua os valores pelas credenciais do seu projeto Supabase.

**Importante:** o arquivo `.env` real não deve ser enviado ao repositório. Ele está incluído no `.gitignore` para evitar o versionamento das credenciais.

## Execução

Com a conexão configurada, execute o comando abaixo na raiz do projeto:

```bash
dart run bin/main.dart
```

O sistema apresentará um menu com as seguintes opções:

1. Cadastrar veículo
2. Listar veículos
3. Atualizar veículo
4. Excluir veículo
0. Sair

## Operações CRUD

A aplicação permite realizar todas as operações de gerenciamento de veículos:

- **Create:** cadastrar novos veículos.
- **Read:** listar os veículos cadastrados.
- **Update:** atualizar os dados de um veículo pelo ID.
- **Delete:** excluir um veículo pelo ID, mediante confirmação.

Todas as operações podem ser realizadas na mesma execução do programa, sem a necessidade de reiniciá-lo entre as etapas.

## Repositório

[GitHub — Desafio Dart Veículos](https://github.com/andreaortega10/desafio-dart-veiculos)
