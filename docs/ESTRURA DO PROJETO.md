# Estrutura de Pastas do Projeto

Este documento descreve a estrutura de pastas do projeto Flutter com Firebase e Riverpod, explicando o propósito de cada pasta e arquivo.

## Estrutura Geral
```
lib/
├── main.dart
├── firebase_options.dart
├── app/
│   ├── app_widget.dart
│   ├── routes.dart
├── features/
│   ├── splash/
│   │   └── splash_page.dart
│   ├── home/
│   │   └── home_page.dart
│   ├── my_list/
│   │   └── my_list_page.dart
│   └── movie_info/
│       └── movie_info_page.dart
├── shared/
│   ├── repositories/
│   └── models/
```

---

## Descrição das Pastas

### 1. **`lib/`**
A pasta principal onde todo o código do projeto está localizado.

### 2. **`main.dart`**
O ponto de entrada da aplicação. Este arquivo:
- Inicializa o Firebase.
- Configura o aplicativo usando o widget `AppWidget`.

---

### 3. **`app/`**
Contém a configuração global do aplicativo.

#### 3.1 `app_widget.dart`
- Define o tema global, rotas e configurações do `MaterialApp`.
- Utiliza o `ProviderScope` para gerenciar o estado com Riverpod.

#### 3.2 `routes.dart`
- Centraliza as rotas do aplicativo.
- Define nomes de rotas e mapeia cada rota a uma página correspondente.

---

### 4. **`features/`**
Divisão do projeto em funcionalidades (ou módulos) independentes. Cada feature tem sua própria pasta contendo:
- **Página (UI):** Tela da funcionalidade.
- **Providers (Riverpod):** Gerenciamento de estado com Riverpod.

#### 4.1 `splash/`
- **`splash_page.dart`:** Tela inicial exibida enquanto o aplicativo carrega.

#### 4.2 `home/`
- **`home_page.dart`:** Tela principal do aplicativo, onde o usuário realiza buscas de filmes.
- **`home_provider.dart`:** Provider que gerencia o estado da home, como resultados de busca e ações relacionadas.

#### 4.3 `my_list/`
- **`my_list_page.dart`:** Tela que exibe a lista de filmes salvos pelo usuário.
- **`my_list_provider.dart`:** Provider que gerencia o estado relacionado à lista de filmes.

#### 4.4 `movie_info/`
- **`movie_info_page.dart`:** Tela com informações detalhadas de um filme.
- **`movie_info_provider.dart`:** Provider que gerencia o estado da página de informações do filme.

---

### 5. **`shared/`**
Contém componentes reutilizáveis e recursos compartilhados entre diferentes features.

#### 5.1 `widgets/`
- Armazena componentes de UI reutilizáveis, como botões e modais.

#### 5.2 `repositories/`
- Define classes para comunicação com APIs ou banco de dados.

#### 5.3 `models/`
- Contém as definições de dados, como modelos de filmes.

---

### 6. **`firebase_options.dart`**
Gerado automaticamente pelo Firebase CLI, este arquivo contém as configurações para inicializar o Firebase no projeto.

---

## Boas Práticas
- **Modularização:** Cada feature é isolada para facilitar manutenção e escalabilidade.
- **Reutilização:** Componentes compartilhados são armazenados em `shared/` para evitar duplicação.
- **Gerenciamento de Estado:** Riverpod é usado para separar lógica de negócios da interface.


