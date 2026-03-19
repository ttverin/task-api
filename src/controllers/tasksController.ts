import type { Request, Response } from "express";
import * as taskService from "../services/taskService";

export const getTasks = (_req: Request, res: Response) => {
    const tasks = taskService.getAllTasks();
    res.json(tasks);
};

export const addTask = (req: Request, res: Response) => {
    const { name } = req.body;

    if (!name) {
        return res.status(400).json({ error: "Name required" });
    }

    const newTask = taskService.createTask(name);

    console.log(`[TASKS] Created task id=${newTask.id}`);

    res.status(201).json(newTask);
};

export const deleteTask = (req: Request, res: Response) => {
    const rawId = Array.isArray(req.params.id)
        ? req.params.id[0]
        : req.params.id;

    if (!rawId) {
        return res.status(400).json({ error: "Invalid id" });
    }

    const id = Number(rawId);

    if (Number.isNaN(id)) {
        return res.status(400).json({ error: "Invalid id" });
    }

    const deleted = taskService.removeTask(id);

    if (!deleted) {
        return res.status(404).json({ error: "Task not found" });
    }

    res.status(204).send();
};
