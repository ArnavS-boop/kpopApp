-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'MODERATOR', 'ADMIN');

-- CreateEnum
CREATE TYPE "Condition" AS ENUM ('MINT', 'NEAR_MINT', 'GOOD', 'FAIR');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "isVerified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'USER';

-- CreateTable
CREATE TABLE "Listing" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "condition" "Condition" NOT NULL,
    "sellerCountry" TEXT NOT NULL,
    "shipsWorldwide" BOOLEAN NOT NULL DEFAULT false,
    "isSold" BOOLEAN NOT NULL DEFAULT false,
    "sellerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Listing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "approved" BOOLEAN NOT NULL DEFAULT false,
    "usageCount" INTEGER NOT NULL DEFAULT 0,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ListingTag" (
    "listingId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "ListingTag_pkey" PRIMARY KEY ("listingId","tagId")
);

-- CreateTable
CREATE TABLE "ShippingRegion" (
    "id" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "listingId" TEXT NOT NULL,

    CONSTRAINT "ShippingRegion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Tag_slug_key" ON "Tag"("slug");

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ListingTag" ADD CONSTRAINT "ListingTag_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "Listing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ListingTag" ADD CONSTRAINT "ListingTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShippingRegion" ADD CONSTRAINT "ShippingRegion_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "Listing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
