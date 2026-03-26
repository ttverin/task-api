# Task API

A small REST API for managing tasks with Node.js, TypeScript, Express, and PostgreSQL.

## What it does

- `GET /health` — health check
- `GET /tasks` — list all tasks
- `POST /tasks` — create a task
- `DELETE /tasks/:id` — delete a task by id

## Tech stack

- Node.js
- TypeScript
- Express
- PostgreSQL
- `pg` for database access
- `morgan` for request logging
- `dotenv` for local environment variables

## Prerequisites

Make sure you have these installed locally:

- Node.js 20+ recommended
- npm
- PostgreSQL

## Quick start

Choose one path:

### A) Local Node + local Postgres

```bash
npm install
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

```bash
npm run dev
curl -i http://localhost:4000/health
```

### B) Docker Compose (API + DB)

```bash
docker compose up --build
curl -i http://localhost:3000/health
```

Use `http://localhost:4000` for local `.env` flow and `http://localhost:3000` for Docker Compose flow.

## Project setup

Install dependencies:

```bash
npm install
```

## Environment variables

This project reads configuration from `.env`.

Current local example:

```dotenv
PORT=4000
DB_USER=teet
DB_HOST=localhost
DB_NAME=taskdb
DB_PASSWORD=
DB_PORT=5432
```

### What each variable means

- `PORT` — port the Express server listens on
- `DB_USER` — PostgreSQL username
- `DB_HOST` — PostgreSQL host, usually `localhost`
- `DB_NAME` — PostgreSQL database name
- `DB_PASSWORD` — PostgreSQL password
- `DB_PORT` — PostgreSQL port, usually `5432`

If your local PostgreSQL user or password differs, update `.env` before starting the app.

## Set up PostgreSQL locally

Start PostgreSQL, then connect with `psql`:

```bash
psql postgres
```

Create the database:

```sql
CREATE DATABASE taskdb;
```

Connect to it:

```sql
\c taskdb
```

Create the `tasks` table:

```sql
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);
```

You can verify it exists with:

```sql
SELECT * FROM tasks;
```

## Run locally

Start the development server:

```bash
npm run dev
```

The app uses `PORT` from `.env`. With the current sample config, it starts at:

```text
http://localhost:4000
```

## Build and run production output

Compile TypeScript:

```bash
npm run build
```

Run the compiled app:

```bash
npm start
```

## Lint and checks

This repo uses ESLint flat config in `eslint.config.mjs`.

```bash
npm run lint
npm run build
```

If lint fails in CI with `eslint: command not found`, install dependencies with `npm ci` (or `npm install`) before running `npm run lint`.

## Run with Docker Compose

The easiest container setup is `docker-compose.yml`, which starts:

- `db` — PostgreSQL 15
- `api` — the Task API on port `3000`

### Start the stack

```bash
docker compose up --build
```

Run in detached mode:

```bash
docker compose up -d --build
```

Stop the stack:

```bash
docker compose down
```

### Test the Compose stack

```bash
curl -i http://localhost:3000/health
```

```bash
curl -i http://localhost:3000/tasks
```

```bash
curl -i -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{"name":"Task1"}'
```

```bash
curl -i -X DELETE http://localhost:3000/tasks/1
```

### Important: database initialization only runs on first volume creation

The Compose setup mounts `docker/init.sql` into Postgres:

```text
/docker-entrypoint-initdb.d/init.sql
```

That script creates the `tasks` table, but Postgres only runs files in that directory when the database volume is initialized for the first time.

If you already started Postgres before adding or changing `docker/init.sql`, the existing `pgdata` volume will be reused and the script will not run again.

If that happens, you may see an error like:

```text
relation "tasks" does not exist
```

To rebuild the database from scratch and re-run the init script:

```bash
docker compose down -v
docker compose up -d --build
```

Use `down -v` only when you are okay deleting the Compose database data.

### Current Compose credentials

The current `docker-compose.yml` uses:

```text
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=taskdb
```

The API container connects with matching values:

```text
DB_HOST=db
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=taskdb
PORT=3000
```

## Run with Docker only

If you want to run only the API container and use a PostgreSQL instance running on your Mac, build the image first:

```bash
docker build -t task-api .
```

Then run it:

```bash
docker run --rm -p 3000:3000 \
  -e PORT=3000 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5432 \
  -e DB_USER=teet \
  -e DB_PASSWORD= \
  -e DB_NAME=taskdb \
  task-api
```

Do not use the local `.env` file as-is for this container flow, because `DB_HOST=localhost` would point to the container itself.

You can instead create a `.env.docker` file and run:

```bash
docker run --rm -p 3000:3000 --env-file .env.docker task-api
```

Suggested `.env.docker` for macOS host Postgres:

```dotenv
PORT=3000
DB_USER=teet
DB_HOST=host.docker.internal
DB_NAME=taskdb
DB_PASSWORD=
DB_PORT=5432
```


## API examples

### Health check

```bash
curl -i http://localhost:4000/health
```

### Get all tasks

```bash
curl -i http://localhost:4000/tasks
```

### Create a task

```bash
curl -i -X POST http://localhost:4000/tasks \
  -H "Content-Type: application/json" \
  -d '{"name":"buy milk"}'
```

### Delete a task

```bash
curl -i -X DELETE http://localhost:4000/tasks/1
```

## Expected local workflow

Typical local flow:

1. Start PostgreSQL
2. Make sure `.env` matches your local database settings
3. Create the `taskdb` database
4. Create the `tasks` table
5. Run `npm install`
6. Run `npm run dev`
7. Test with the curl commands above

## Troubleshooting

### `relation "tasks" does not exist`

You started the app before creating the table. Run the SQL in the PostgreSQL setup section.

For Docker Compose, this also happens when `docker/init.sql` was added after the volume already existed. Recreate with:

```bash
docker compose down -v
docker compose up -d --build
```

### `password authentication failed`

Your `.env` database credentials do not match your local PostgreSQL setup.

### `port already in use`

Change `PORT` in `.env` to another free port and restart the app.

### `{"error":"Internal Server Error"}` on `POST /tasks`

Most common causes:

- API cannot connect to Postgres (wrong host/user/password/db/port)
- `tasks` table does not exist
- local app points to `localhost`, but containerized app should use `DB_HOST=db` in Compose

Check API logs with:

```bash
docker compose logs -f api
```

### `taskdb-#` prompt in `psql`

`taskdb-#` means your SQL statement is incomplete (usually missing `;`). Finish with `;` or cancel with `Ctrl+C`.

### npm warning about `always-auth`

If you see this warning:

```text
npm warn Unknown user config "always-auth"
```

it comes from your npm configuration, not from this project. You can remove it with:

```bash
npm config delete always-auth
```


