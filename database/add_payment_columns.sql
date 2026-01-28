-- Migration Script: Add Payment Tracking to Orders Table
-- Run this script to add payment tracking columns to the orders table

USE water_supply_db;

-- Add paid and paidAt columns to orders table
ALTER TABLE `orders` 
ADD COLUMN `paid` BOOLEAN NOT NULL DEFAULT FALSE AFTER `order_summary`,
ADD COLUMN `paid_at` DATETIME NULL AFTER `paid`;

-- Update existing orders to be unpaid by default
UPDATE `orders` SET `paid` = FALSE WHERE `paid` IS NULL;

SELECT 'Migration completed successfully!' AS status;
