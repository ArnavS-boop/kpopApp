import "dotenv/config";
import express from "express";
import { db } from "./db.js";

const app = express();

console.log("Prisma connected:", !!db);

app.get("/health", async (_req, res) => {
  const result = await db.$queryRaw`SELECT NOW()`;
  res.json({ status: "ok", db: result });
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});