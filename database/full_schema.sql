-- Water Supply Management System - Complete Database Script
-- This script creates the database, all tables, and inserts initial data.

-- -----------------------------------------------------------------------------
-- 0. DATABASE CREATION
-- -----------------------------------------------------------------------------
-- drop database water_supply_db;
CREATE DATABASE IF NOT EXISTS water_supply_db;
USE water_supply_db;

-- Disable foreign key checks for bulk operations
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 1. USERS & ROLES
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255),
  `password` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `profile_image_path` VARCHAR(255),
  `phone` VARCHAR(50) NOT NULL,
  `role` ENUM('ADMIN', 'EMPLOYEE', 'USER') NOT NULL,
  `active` BOOLEAN DEFAULT TRUE,
  `created_at` DATETIME NOT NULL,
  `payment_rate` DOUBLE, -- For employees
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 2. PRODUCTS (Water Jars, Accessories)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(500),
  `price` DOUBLE NOT NULL,
  `stock_quantity` INT NOT NULL,
  `category` ENUM('BOTTLE', 'TANKER', 'DISPENSER', 'ACCESSORIES') NOT NULL,
  `image_path` VARCHAR(255),
  `active` BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 3. ORDERS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `total_amount` DOUBLE NOT NULL,
  `status` ENUM('PLACED', 'ASSIGNED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PLACED',
  `payment_method` ENUM('CASH_ON_DELIVERY', 'CARD_PAYMENT', 'ONLINE_PAYMENT') DEFAULT 'CASH_ON_DELIVERY',
  `assigned_employee_id` BIGINT,
  `placed_at` DATETIME NOT NULL,
  `assigned_at` DATETIME,
  `delivered_at` DATETIME,
  `order_summary` VARCHAR(1000),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_orders_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 4. ORDER ITEMS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity` INT NOT NULL,
  `price_per_unit` DOUBLE NOT NULL,
  `total_price` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 5. BILLING (Monthly Water Supply Bills)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `bills`;
CREATE TABLE `bills` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `billing_month` INT NOT NULL,
  `billing_year` INT NOT NULL,
  `consumption_amount` DOUBLE NOT NULL,
  `rate_per_unit` DOUBLE NOT NULL,
  `total_amount` DOUBLE NOT NULL,
  `due_date` DATE NOT NULL,
  `paid` BOOLEAN NOT NULL DEFAULT FALSE,
  `paid_at` DATETIME,
  `generated_at` DATETIME NOT NULL,
  `immutable` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_bills_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 6. DELIVERY SCHEDULES
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `delivery_schedules`;
CREATE TABLE `delivery_schedules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `employee_id` BIGINT NOT NULL,
  `order_id` BIGINT NOT NULL,
  `scheduled_date` DATE NOT NULL,
  `route_details` VARCHAR(500),
  `status` ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
  `meter_reading` DOUBLE,
  `created_at` DATETIME NOT NULL,
  `started_at` DATETIME,
  `completed_at` DATETIME,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_schedule_employee` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_schedule_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 7. COMPLAINTS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `complaints`;
CREATE TABLE `complaints` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `subject` VARCHAR(255),
  `complaint_type` ENUM('WATER_SHORTAGE', 'LEAKAGE', 'BILLING_ISSUE', 'QUALITY_ISSUE', 'OTHER') NOT NULL,
  `description` VARCHAR(1000) NOT NULL,
  `status` ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED') NOT NULL DEFAULT 'OPEN',
  `assigned_employee_id` BIGINT,
  `created_at` DATETIME NOT NULL,
  `in_progress_at` DATETIME,
  `resolved_at` DATETIME,
  `admin_reply` VARCHAR(1000),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_complaints_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_complaints_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 8. WATER CONSUMPTION
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `water_consumption`;
CREATE TABLE `water_consumption` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `date` DATE NOT NULL,
  `consumption_amount` DOUBLE NOT NULL,
  `current_meter_reading` DOUBLE NOT NULL,
  `previous_meter_reading` DOUBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_consumption_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 9. EMPLOYEE EARNINGS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `employee_earnings`;
CREATE TABLE `employee_earnings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `employee_id` BIGINT NOT NULL,
  `delivery_schedule_id` BIGINT NOT NULL,
  `earning_amount` DOUBLE NOT NULL,
  `paid` BOOLEAN NOT NULL DEFAULT FALSE,
  `paid_at` DATETIME,
  `salary_payment_id` BIGINT,
  `earned_at` DATETIME NOT NULL,
  `immutable` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_earnings_employee` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_earnings_schedule` FOREIGN KEY (`delivery_schedule_id`) REFERENCES `delivery_schedules` (`id`),
  CONSTRAINT `fk_earnings_payment` FOREIGN KEY (`salary_payment_id`) REFERENCES `salary_payments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 9b. SALARY PAYMENTS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `salary_payments`;
CREATE TABLE `salary_payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `employee_id` BIGINT NOT NULL,
  `amount` DOUBLE NOT NULL,
  `payment_date` DATETIME NOT NULL,
  `period_start` DATE NOT NULL,
  `period_end` DATE NOT NULL,
  `pdf_path` VARCHAR(255),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_salary_employee` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 10. ADMIN ACTIVITY LOGS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `admin_activity_logs`;
CREATE TABLE `admin_activity_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `admin_id` BIGINT NOT NULL,
  `action` VARCHAR(255) NOT NULL,
  `entity_type` VARCHAR(255) NOT NULL,
  `entity_id` VARCHAR(255),
  `details` TEXT,
  `ip_address` VARCHAR(255),
  `timestamp` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_logs_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 11. NOTIFICATIONS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(255) NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `is_read` BOOLEAN DEFAULT FALSE,
  `recipient_id` BIGINT,
  `related_entity` VARCHAR(255),
  `related_entity_id` BIGINT,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notifications_recipient` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 12. SYSTEM SETTINGS
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `setting_key` VARCHAR(255) NOT NULL,
  `setting_value` VARCHAR(255) NOT NULL,
  `updated_by` BIGINT,
  `updated_at` DATETIME,
  PRIMARY KEY (`setting_key`),
  CONSTRAINT `fk_settings_updater` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- INITIAL DATA SEEDING (Empty)
-- -----------------------------------------------------------------------------
-- NOTE: The Java backend (DataInitializer.java) will automatically seed 
-- default users (Admin, Employee, User) and initial products if the tables are empty.
-- This ensures all passwords are correctly hashed using BCrypt.

-- Default Roles explanation:
-- All users (Admin, Employee, Customer) are stored in the 'users' table.
-- They are distinguished by the 'role' column (ADMIN, EMPLOYEE, USER).

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
select * from users;

