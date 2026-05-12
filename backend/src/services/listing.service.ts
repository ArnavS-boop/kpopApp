import { db } from "../db.js";

const ACCEPTABLE_CONDITIONS: Record<string, string> = {
  mint: "MINT",
  "near mint": "NEAR_MINT",
  good: "GOOD",
  fair: "FAIR",
  used: "FAIR",
};

export const createListing = async (
  sellerId: string,
  data: {
    title: string;
    description: string;
    price: number;
    condition: string;
    sellerCountry: string;
    shipsWorldwide: boolean;
    tagNames: string[];
    shippingRegions?: string[];
  }
) => {
  if (!data.title.trim() || !data.description.trim()) {
    throw new Error("Listing title and description are required");
  }

  if (data.price <= 0) {
    throw new Error("Price must be greater than 0");
  }

  const normalizedCondition = data.condition.trim().toLowerCase();
  const condition = ACCEPTABLE_CONDITIONS[normalizedCondition];

  if (!condition) {
    throw new Error("Invalid listing condition");
  }

  return db.$transaction(async (tx) => {
    const normalizedTagNames = data.tagNames
      .map((name) => name.trim())
      .filter(Boolean);

    const uniqueTagNames = [...new Set(normalizedTagNames)];

    const tags = await Promise.all(
      uniqueTagNames.map(async (name) => {
        const slug = name.toLowerCase().replace(/\s+/g, "-");

        return tx.tag.upsert({
          where: { slug },
          update: {
            usageCount: { increment: 1 },
          },
          create: {
            name,
            slug,
            createdById: sellerId,
            usageCount: 1,
          },
        });
      })
    );

    const listing = await tx.listing.create({
      data: {
        title: data.title,
        description: data.description,
        price: data.price,
        condition: condition as any,
        sellerCountry: data.sellerCountry,
        shipsWorldwide: data.shipsWorldwide,
        sellerId,
        shippingRegions: {
          create: (data.shippingRegions || []).map((country) => ({
            country: country.trim(),
          })),
        },
        tags: {
          create: tags.map((tag) => ({
            tagId: tag.id,
          })),
        },
      },
      include: {
        seller: {
          select: {
            id: true,
            username: true,
            role: true,
            isVerified: true,
          },
        },
        tags: {
          include: {
            tag: true,
          },
        },
      },
    });

    return listing;
  });
};

export const getListings = async () => {
  return db.listing.findMany({
    include: {
      seller: {
        select: {
          id: true,
          username: true,
          role: true,
          isVerified: true,
        },
      },
      tags: {
        include: { tag: true },
      },
    },
  });
};