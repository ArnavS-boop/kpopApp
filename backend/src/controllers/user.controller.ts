import { Request, Response } from "express";
import { registerUser, loginUser } from "../services/user.service.js";
import { createListing, getListings } from "../services/listing.service.js";

export const registerHandler = async (req: Request, res: Response) => {
  try {
    const { email, username, password } = req.body;

    if (!email || !username || !password) {
      return res.status(400).json({ message: "Missing fields" });
    }

    const result = await registerUser(email, username, password);

    res.status(201).json(result);
  } catch (error: any) {
    res.status(400).json({ message: error.message || "Registration failed" });
  }
};

export const loginHandler = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: "Missing fields" });
    }

    const result = await loginUser(email, password);

    res.json(result);
  } catch (error: any) {
    res.status(401).json({ message: error.message || "Login failed" });
  }
};


export const createListingHandler = async (req: Request, res: Response) => {
  try {
    const sellerId = (req as any).userId;

    const listing = await createListing(sellerId, req.body);

    res.status(201).json(listing);
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
};

export const getListingsHandler = async (_req: Request, res: Response) => {
  const listings = await getListings();
  res.json(listings);
};