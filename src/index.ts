import dotenv from "dotenv";
dotenv.config();

import express from "express";
import morgan from "morgan";

import { pool } from "./config/db";
import tasksRouter from "./routes/tasks";
import { runMigrations } from "./db/migrate";

import type { Request, Response, NextFunction } from "express";


// -------------------- APP --------------------
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(morgan("combined"));

console.log("Morgan middleware initialized");

// Health check
app.get("/health", (_req, res) => {
    res.json({ status: "ok" });
});

// Routes (inject pool if needed)
app.use("/tasks", tasksRouter);

// Error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
    console.error(err.stack);
    res.status(500).json({ error: "Internal Server Error" });
});

// -------------------- STARTUP --------------------
async function start() {
    try {
        console.log("Running DB migrations...");
        await runMigrations(pool);

        app.listen(PORT, () => {
            console.log(`Server running on http://localhost:${PORT}`);
        });

    } catch (err) {
        console.error("Failed to start app:", err);
        process.exit(1);
    }
}

start();
