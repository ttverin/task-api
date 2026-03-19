import type { Task } from "../models/tasks";

let tasks: Task[] = [];

export const getAllTasks = (): Task[] => {
    return tasks;
};

export const createTask = (name: string): Task => {
    const newTask: Task = {
        id: tasks.length + 1,
        name
    };

    tasks.push(newTask);
    return newTask;
};

export const removeTask = (id: number): boolean => {
    const initialLength = tasks.length;

    tasks = tasks.filter(task => task.id !== id);

    return tasks.length !== initialLength;
};
