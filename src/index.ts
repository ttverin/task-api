import express from "express";
import tasksRouter from "./routes/tasks";

const app = express();
const PORT = process.env.PORT || 3000; // use env variable if set

// Middleware to parse JSON bodies
app.use(express.json());

// Health check endpoint
app.get("/health", (req, res) => {
    res.json({ status: "ok" });
});

// Mount the tasks router
app.use("/tasks", tasksRouter);

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});

