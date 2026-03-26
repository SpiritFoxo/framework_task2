# framework_task2# framework_task2

Модульное Node.js-приложение с dependency injection контейнером. Модули загружаются динамически из конфига, порядок инициализации определяется топологической сортировкой зависимостей.

---

## Требования

| Вариант | Что нужно |
|---|---|
| Docker (рекомендуется) | Docker 24+ и Docker Compose v2 |
| Локально | Node.js 22+ |

---

## Быстрый старт с Docker

### 1. Клонировать репозиторий

```bash
git clone <repo-url>
cd framework_task2
```

### 2. Собрать и запустить

```bash
docker compose up --build
```

После запуска в консоли появится лог выполненных действий модулей, а в папке `./exports/` на хосте — файл `export.txt` с результатами экспорта.

### 3. Остановить

```bash
docker compose down
```

---

## Запуск тестов

```bash
docker compose run --rm test
```

Сервис `test` запускает встроенный test runner Node.js (`node --test`) и завершается автоматически.

---

## Структура проекта

```
framework_task2/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── node/
    ├── package.json
    ├── config/
    │   └── modules.json        # список активных модулей
    ├── modules/                # модули приложения
    │   ├── core.js
    │   ├── logging.js
    │   ├── validation.js
    │   ├── export.js
    │   └── report.js
    ├── src/
    │   ├── main.js             # точка входа
    │   ├── container.js        # DI-контейнер
    │   ├── moduleLoader.js     # загрузка и сортировка модулей
    │   └── errors.js
    └── test/
        └── moduleLoader.test.js
```

---

## Добавление нового модуля

1. Создать файл в `node/modules/`, например `mymodule.js`:

```js
export default {
  name: "MyModule",
  requires: ["Core"],        // зависимости — имена других модулей
  register(container) {
    container.addSingleton("action.mymodule", () => ({
      title: "Моё действие",
      async execute() {
        console.log("Привет из MyModule");
      }
    }));
  },
  async init(container) {}
};
```

2. Добавить имя файла в `node/config/modules.json`:

```json
{
  "modules": [
    "core.js",
    "logging.js",
    "validation.js",
    "export.js",
    "report.js",
    "mymodule.js"
  ]
}
```

3. Перезапустить контейнер:

```bash
docker compose up --build
```

---

## Локальный запуск (без Docker)

```bash
cd node
node src/main.js
```

Запуск тестов:

```bash
cd node
node --test
```

---

## Конфигурация Docker

| Сервис | Описание |
|---|---|
| `app` | Основное приложение, запускает все модули |
| `test` | Тест-раннер, запускается вручную через `run --rm test` |

Файл `export.txt` монтируется в `./exports/` на хосте через volume, чтобы данные сохранялись между запусками контейнера.