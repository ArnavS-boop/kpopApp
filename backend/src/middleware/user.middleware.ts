import jwt from "jsonwebtoken";
import { Request, Response, NextFunction } from "express";
import { db } from "../db.js";

const JWT_SECRET = process.env.JWT_SECRET!;

export const authMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) return res.status(401).json({ message: "No token" });

  const token = authHeader.split(" ")[1];

  try {
    const payload = jwt.verify(token, JWT_SECRET) as { userId: string };
    const user = await db.user.findUnique({ where: { id: payload.userId } });

    if (!user) {
      return res.status(401).json({ message: "Invalid token" });
    }

    (req as any).userId = payload.userId;
    next();
  } catch {
    res.status(401).json({ message: "Invalid token" });
  }
};