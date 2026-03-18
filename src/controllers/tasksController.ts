import type { Request, Response } from "express";
import type {Task} from "../models/tasks";

let tasks: Task[] = [];

export const getTasks = (_req: Request, res: Response) => {
    res.json(tasks);
};

export const addTask = (req: Request, res: Response) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ error: "Name required" });
    const newTask: Task = { id: tasks.length + 1, name };
    tasks.push(newTask);
    res.status(201).json(newTask);
};

export const deleteTask = (req: Request, res: Response) => {
    const rawId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
    if (!rawId) return res.status(400).json({ error: "Invalid id" });

    const id = Number(rawId);
    if (Number.isNaN(id)) return res.status(400).json({ error: "Invalid id" });

    tasks = tasks.filter(task => task.id !== id);
    res.status(204).send();
};
