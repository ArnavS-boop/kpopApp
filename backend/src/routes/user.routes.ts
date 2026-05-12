import { Router } from "express";
import { registerHandler, loginHandler } from "../controllers/user.controller.js";

const router = Router();

router.post("/register", registerHandler);
router.post("/login", loginHandler);

export default router;