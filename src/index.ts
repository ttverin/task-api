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
        console.log("DATABASE_URL =", process.env.DATABASE_URL);

        await pool.query("SELECT 1");
        console.log("DB connected");

        await runMigrations(pool);
        console.log("Migrations done");

        app.listen(PORT, () => {
            console.log(`Server running on ${PORT}`);
        });

    } catch (err) {
        console.error("Startup failed:", err);
    }
}
