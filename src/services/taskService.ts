import { pool } from "../config/db";
import type { Task } from "../models/tasks";

export const getAllTasks = async (): Promise<Task[]> => {
    const result = await pool.query("SELECT * FROM tasks ORDER BY id");
    return result.rows;
};

export const createTask = async (name: string): Promise<Task> => {
    const result = await pool.query(
        "INSERT INTO tasks (name) VALUES ($1) RETURNING *",
        [name]
    );

    return result.rows[0];
};

export const removeTask = async (id: number): Promise<boolean> => {
    const result = await pool.query(
        "DELETE FROM tasks WHERE id = $1",
        [id]
    );

    return (result.rowCount ?? 0) > 0;
};
