import express from "express";

const app = express();
const PORT = 4000; // different port to avoid conflicts

let tasks: { id: number; name: string }[] = [];

app.use(express.json());

app.get("/health", (req, res) => {
    res.json({ status: "ok", uptime: process.uptime() })
});

app.get ("/tasks", (req, res) => {
    res.json(tasks);
});

app.post("/tasks", (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: "Name is required" });
    const newTask = { id: tasks.length + 1, name };
    tasks.push(newTask);
    res.status(201).json(newTask);
});

app.delete("/tasks:id", (req, res) => {
    const id = Number(req.params.id);
    if (Number.isNaN(id)) return res.status(400).json({ error: "Invalid id" });

    tasks = tasks.filter(task => task.id !== id);
    res.status(204).send();
});

app.listen(PORT, () => console.log(`Test server running on port ${PORT}`));

