-- Creación de bases de datos para cada microservicio
CREATE DATABASE IF NOT EXISTS ositopolar_iam;
CREATE DATABASE IF NOT EXISTS ositopolar_profiles;
CREATE DATABASE IF NOT EXISTS ositopolar_equipment;
CREATE DATABASE IF NOT EXISTS ositopolar_workorders;
CREATE DATABASE IF NOT EXISTS ositopolar_servicerequests;
CREATE DATABASE IF NOT EXISTS ositopolar_subscriptions;
CREATE DATABASE IF NOT EXISTS ositopolar_notifications;
CREATE DATABASE IF NOT EXISTS ositopolar_analytics;

-- Asignación de privilegios
-- NOTA: En un entorno de producción, se recomienda crear usuarios específicos para cada servicio
-- con contraseñas seguras, en lugar de usar 'root'.
GRANT ALL PRIVILEGES ON ositopolar_iam.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_profiles.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_equipment.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_workorders.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_servicerequests.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_subscriptions.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_notifications.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON ositopolar_analytics.* TO 'root'@'%';

-- Aplicar los cambios de privilegios
FLUSH PRIVILEGES;
