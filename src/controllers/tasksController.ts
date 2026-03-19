import type { Request, Response } from "express";
import * as taskService from "../services/taskService";

export const getTasks = async (_req: Request, res: Response) => {
    const tasks = await taskService.getAllTasks();
    res.json(tasks);
};

export const addTask = async (req: Request, res: Response) => {
    const { name } = req.body;

    if (!name) {
        return res.status(400).json({ error: "Name required" });
    }

    const newTask = await taskService.createTask(name);

    res.status(201).json(newTask);
};

export const deleteTask = async (req: Request, res: Response) => {
    const id = Number(req.params.id);

    if (Number.isNaN(id)) {
        return res.status(400).json({ error: "Invalid id" });
    }

    const deleted = await taskService.removeTask(id);

    if (!deleted) {
        return res.status(404).json({ error: "Task not found" });
    }

    res.status(204).send();
};
