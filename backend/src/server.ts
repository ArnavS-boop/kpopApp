import "dotenv/config";
import express from "express";
import cors from "cors";
import userRoutes from "./routes/user.routes.js";
import { db } from "./db.js";
import { authMiddleware } from "./middleware/user.middleware.js";
import listingRoutes from "./routes/listing.routes.js";
import { checkEnv } from "./utils/env.js";

process.on("exit", (code) => {
  console.log("Process exiting with code:", code);
});

process.on("uncaughtException", (err) => {
  console.error("Uncaught exception:", err);
});

process.on("unhandledRejection", (err) => {
  console.error("Unhandled rejection:", err);
});

checkEnv();

const app = express();

app.use(cors({ origin: true, credentials: true }));
app.use(express.json());

/**
 * Health Check
 */
app.get("/health", async (_req, res) => {
  try {
    await db.$queryRaw`SELECT 1`;
    res.json({ status: "ok" });
  } catch (err) {
    res.status(500).json({ status: "db error" });
  }
});

/**
 * Routes
 */
app.use("/auth", userRoutes);
app.use("/listings", listingRoutes);


/**
 * Protected Route Example
 */
app.get("/me", authMiddleware, async (req, res) => {
  try {
    const userId = (req as any).userId;

    const user = await db.user.findUnique({
        where: { id: userId },
        select: {
            id: true,
            email: true,
            username: true,
            role: true,
            isVerified: true,
            createdAt: true,
        },
    });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(user);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
});

// General error handler
app.use((err: any, _req: any, res: any, _next: any) => {
  console.error("Unhandled middleware error:", err);
  res.status(err.status || 500).json({ message: err.message || "Internal Server Error" });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

