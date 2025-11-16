-- ==============================================================================
-- OsitoPolar Microservices - Database Initialization
-- ==============================================================================
-- This script creates all 8 databases for the microservices architecture
-- ==============================================================================

-- IAM Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_iam CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Profiles Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_profiles CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Equipment Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_equipment CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Work Orders Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_workorders CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Service Requests Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_servicerequests CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Subscriptions Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_subscriptions CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Notifications Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_notifications CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Analytics Service Database
CREATE DATABASE IF NOT EXISTS ositopolar_analytics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Show created databases
SHOW DATABASES LIKE 'ositopolar%';
