import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { db } from "../db.js";

const JWT_SECRET = process.env.JWT_SECRET!;

export const registerUser = async (
  email: string,
  username: string,
  password: string
) => {
  const existing = await db.user.findFirst({
    where: {
      OR: [{ email }, { username }],
    },
  });

  if (existing) {
    throw new Error("Email or username already in use");
  }

  if (password.length < 8) {
    throw new Error("Password must be at least 8 characters");
  }

  const hashed = await bcrypt.hash(password, 10);

  const user = await db.user.create({
    data: {
      email,
      username,
      passwordHash: hashed,
    },
  });

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, {
    expiresIn: "7d",
  });

  const { passwordHash, ...safeUser } = user;
  return { user: safeUser, token };
};

export const loginUser = async (email: string, password: string) => {
  const user = await db.user.findUnique({
    where: { email },
  });

  if (!user) throw new Error("Invalid credentials");

  const valid = await bcrypt.compare(password, user.passwordHash);

  if (!valid) throw new Error("Invalid credentials");

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, {
    expiresIn: "7d",
  });

  const { passwordHash, ...safeUser } = user;
  return { user: safeUser, token };
};

