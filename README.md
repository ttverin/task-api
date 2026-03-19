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

## Run with Docker

This project includes a `Dockerfile`, so you can build and run the API in a container.

### Build the image

```bash
docker build -t task-api .
```

### Run the container

If PostgreSQL is running on your Mac, use `host.docker.internal` so the container can reach the database on the host machine:

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

Then test it with:

```bash
curl -i http://localhost:3000/health
```

### Use an env file instead of many `-e` flags

Because `.env` is excluded by `.dockerignore`, it is not copied into the image. Pass environment variables at runtime instead:

```bash
docker run --rm -p 3000:3000 --env-file .env.docker task-api
```

Do not use the current local `.env` file as-is for Docker, because it contains `DB_HOST=localhost`. Inside the container, `localhost` points to the container itself, not your Mac.

Create a Docker-specific env file such as `.env.docker`:

```dotenv
PORT=3000
DB_USER=teet
DB_HOST=host.docker.internal
DB_NAME=taskdb
DB_PASSWORD=
DB_PORT=5432
```

Then run:

```bash
docker run --rm -p 3000:3000 --env-file .env.docker task-api
```

### Notes

- The image exposes port `3000`
- The app now defaults to port `3000` if `PORT` is not set
- If PostgreSQL is running in another container, `DB_HOST` should be that container or service name instead of `host.docker.internal`
- The `tasks` table must already exist before the API can read or write tasks

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

### `password authentication failed`

Your `.env` database credentials do not match your local PostgreSQL setup.

### `port already in use`

Change `PORT` in `.env` to another free port and restart the app.

### npm warning about `always-auth`

If you see this warning:

```text
npm warn Unknown user config "always-auth"
```

it comes from your npm configuration, not from this project. You can remove it with:

```bash
npm config delete always-auth
```


