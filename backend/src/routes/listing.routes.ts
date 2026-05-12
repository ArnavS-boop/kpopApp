import { Router } from "express";
import { authMiddleware } from "../middleware/user.middleware";
import { createListingHandler, getListingsHandler } from "../controllers/user.controller";


const router = Router();

router.post("/", authMiddleware, createListingHandler);
router.get("/", getListingsHandler);

export default router;