import dotenv from "dotenv";
dotenv.config();
import morgan from "morgan";
import express from "express";
import tasksRouter from "./routes/tasks";

const app = express();
const PORT = process.env.PORT; // uses env var if set in dotenv

// Middleware to parse JSON bodies
app.use(express.json());
//use morgan for logging
console.log("Morgan middleware initialized");
app.use(morgan("combined"));
// Health check endpoint

app.get("/health", (req, res) => {
    res.json({ status: "ok" });
});

// Mount the tasks router
app.use("/tasks", tasksRouter);

import type { Request, Response, NextFunction } from "express";

// Global error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
    console.error(err.stack);

    res.status(500).json({
        error: "Internal Server Error"
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});

