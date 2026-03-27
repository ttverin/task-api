# Task API

Simple REST API for tasks using Node.js, TypeScript, Express, and PostgreSQL.

## Endpoints

- `GET /health` — health check
- `GET /tasks` — list all tasks
- `POST /tasks` — create a task
- `DELETE /tasks/:id` — delete a task by id

## Tech stack

- Node.js + TypeScript
- Express
- PostgreSQL
- `pg` for database access
- `morgan` for request logging
- `dotenv` for local environment variables

## Prerequisites

- Node.js 20+
- npm
- PostgreSQL (if running locally)
- Docker + Docker Compose (if running containers)

## Option 1: Run locally (Node + local Postgres)

Install dependencies:

```bash
npm install
```

Create DB and table:

```bash
psql postgres
```

```sql
CREATE DATABASE taskdb;
\c taskdb
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);
```

Create `.env` in project root:

```dotenv
PORT=4000
DB_USER=postgres
DB_HOST=localhost
DB_NAME=taskdb
DB_PASSWORD=postgres
DB_PORT=5432
```

Run API:

```bash
npm run dev
```

Health check:

```bash
curl -i http://localhost:4000/health
```

## Option 2: Run with Docker Compose (recommended)

This starts both services:

- `db` on `5432`
- `api` on `3000`

Start:

```bash
docker compose up --build
```

Detached mode:

```bash
docker compose up -d --build
```

Stop:

```bash
docker compose down
```

Reset DB volume (reruns `docker/init.sql`):

```bash
docker compose down -v
docker compose up -d --build
```

## Option 3: Run only API container (use host Postgres)

Build image:

```bash
docker build -t task-api .
```

Run image:

```bash
docker run --rm -p 3000:3000 \
  -e PORT=3000 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e DB_NAME=taskdb \
  task-api
```

Use `DB_HOST=host.docker.internal` on macOS/Windows when the DB runs on your host machine.

## Test API with curl

For local run (`PORT=4000`):

```bash
BASE_URL=http://localhost:4000
```

For Docker Compose/API container (`PORT=3000`):

```bash
BASE_URL=http://localhost:3000
```

Health:

```bash
curl -i "$BASE_URL/health"
```

List tasks:

```bash
curl -i "$BASE_URL/tasks"
```

Create task:

```bash
curl -i -X POST "$BASE_URL/tasks" \
  -H "Content-Type: application/json" \
  -d '{"name":"Task1"}'
```

Delete task:

```bash
curl -i -X DELETE "$BASE_URL/tasks/1"
```

## Scripts

```bash
npm run dev
npm run build
npm start
npm run lint
```

## CI lint note

If GitHub Actions fails on lint, make sure dependencies are installed first:

```bash
npm ci
npm run lint
```

## Troubleshooting

### `{"error":"Internal Server Error"}` on `POST /tasks`

Usually one of these:

- DB credentials/host are wrong
- `tasks` table does not exist
- wrong DB host for runtime mode (`localhost` for local app, `db` for Compose, `host.docker.internal` for container to host DB)

Check API logs:

```bash
docker compose logs -f api
```

### `relation "tasks" does not exist`

Create the table manually, or recreate Compose volume:

```bash
docker compose down -v
docker compose up -d --build
```

### `taskdb-#` in `psql`

You have an unfinished SQL statement. End with `;` or cancel with `Ctrl+C`.

### `npm warn Unknown user config "always-auth"`

This comes from local npm config, not project code:

```bash
npm config delete always-auth
```


