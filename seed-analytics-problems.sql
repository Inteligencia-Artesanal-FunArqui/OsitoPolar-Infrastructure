-- =====================================================
-- OsitoPolar Analytics - Datos con Problemas para Demo
-- Ejecutar: docker exec -i ositopolar-mysql mysql -u root -pOsitoPolar2024! < seed-analytics-problems.sql
-- =====================================================

USE ositopolar_analytics;

-- Limpiar datos anteriores (opcional)
-- DELETE FROM temperature_readings;
-- DELETE FROM energy_readings;

-- =====================================================
-- EQUIPMENT 3: Freezer con PROBLEMAS de temperatura
-- Rango óptimo: -25°C a -18°C
-- Simulamos: puerta abierta, falla de compresor
-- =====================================================

-- Últimas 24 horas - Temperatura con anomalías
-- Hora 0-6: Normal
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -22.0, DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(3, -21.5, DATE_SUB(NOW(), INTERVAL 23 HOUR), 0, NOW(), NOW()),
(3, -22.2, DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(3, -21.8, DATE_SUB(NOW(), INTERVAL 21 HOUR), 0, NOW(), NOW()),
(3, -22.1, DATE_SUB(NOW(), INTERVAL 20 HOUR), 0, NOW(), NOW()),
(3, -21.7, DATE_SUB(NOW(), INTERVAL 19 HOUR), 0, NOW(), NOW());

-- Hora 6-12: Puerta abierta - temperatura sube gradualmente (WARNING)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -19.0, DATE_SUB(NOW(), INTERVAL 18 HOUR), 1, NOW(), NOW()),
(3, -16.5, DATE_SUB(NOW(), INTERVAL 17 HOUR), 1, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 16 HOUR), 2, NOW(), NOW()),
(3, -12.0, DATE_SUB(NOW(), INTERVAL 15 HOUR), 2, NOW(), NOW()),
(3, -10.5, DATE_SUB(NOW(), INTERVAL 14 HOUR), 2, NOW(), NOW()),
(3, -8.0, DATE_SUB(NOW(), INTERVAL 13 HOUR), 2, NOW(), NOW());

-- Hora 12-18: Recuperación parcial después de cerrar puerta
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -12.0, DATE_SUB(NOW(), INTERVAL 12 HOUR), 2, NOW(), NOW()),
(3, -15.0, DATE_SUB(NOW(), INTERVAL 11 HOUR), 1, NOW(), NOW()),
(3, -17.5, DATE_SUB(NOW(), INTERVAL 10 HOUR), 1, NOW(), NOW()),
(3, -19.0, DATE_SUB(NOW(), INTERVAL 9 HOUR), 0, NOW(), NOW()),
(3, -20.5, DATE_SUB(NOW(), INTERVAL 8 HOUR), 0, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 7 HOUR), 0, NOW(), NOW());

-- Hora 18-24: Segunda anomalía - Falla de compresor (CRITICAL)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -18.0, DATE_SUB(NOW(), INTERVAL 6 HOUR), 1, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 5 HOUR), 2, NOW(), NOW()),
(3, -10.0, DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(3, -6.0, DATE_SUB(NOW(), INTERVAL 3 HOUR), 2, NOW(), NOW()),
(3, -2.0, DATE_SUB(NOW(), INTERVAL 2 HOUR), 2, NOW(), NOW()),
(3, 0.0, DATE_SUB(NOW(), INTERVAL 1 HOUR), 2, NOW(), NOW());

-- Más datos históricos (últimos 7 días) con variaciones
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
-- Día -2
(3, -21.0, DATE_SUB(NOW(), INTERVAL 48 HOUR), 0, NOW(), NOW()),
(3, -20.5, DATE_SUB(NOW(), INTERVAL 47 HOUR), 0, NOW(), NOW()),
(3, -22.0, DATE_SUB(NOW(), INTERVAL 46 HOUR), 0, NOW(), NOW()),
(3, -15.0, DATE_SUB(NOW(), INTERVAL 45 HOUR), 1, NOW(), NOW()),
(3, -18.0, DATE_SUB(NOW(), INTERVAL 44 HOUR), 1, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 43 HOUR), 0, NOW(), NOW()),
-- Día -3
(3, -22.5, DATE_SUB(NOW(), INTERVAL 72 HOUR), 0, NOW(), NOW()),
(3, -21.8, DATE_SUB(NOW(), INTERVAL 71 HOUR), 0, NOW(), NOW()),
(3, -22.0, DATE_SUB(NOW(), INTERVAL 70 HOUR), 0, NOW(), NOW()),
(3, -20.0, DATE_SUB(NOW(), INTERVAL 69 HOUR), 0, NOW(), NOW()),
(3, -19.5, DATE_SUB(NOW(), INTERVAL 68 HOUR), 0, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 67 HOUR), 0, NOW(), NOW()),
-- Día -4 (otro incidente)
(3, -22.0, DATE_SUB(NOW(), INTERVAL 96 HOUR), 0, NOW(), NOW()),
(3, -16.0, DATE_SUB(NOW(), INTERVAL 95 HOUR), 1, NOW(), NOW()),
(3, -12.0, DATE_SUB(NOW(), INTERVAL 94 HOUR), 2, NOW(), NOW()),
(3, -18.0, DATE_SUB(NOW(), INTERVAL 93 HOUR), 1, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 92 HOUR), 0, NOW(), NOW()),
(3, -22.0, DATE_SUB(NOW(), INTERVAL 91 HOUR), 0, NOW(), NOW());

-- =====================================================
-- EQUIPMENT 1: Freezer Industrial - Estable pero con picos
-- Rango óptimo: -25°C a -15°C
-- =====================================================

INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(1, -20.5, DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(1, -20.0, DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(1, -19.5, DATE_SUB(NOW(), INTERVAL 20 HOUR), 0, NOW(), NOW()),
(1, -20.2, DATE_SUB(NOW(), INTERVAL 18 HOUR), 0, NOW(), NOW()),
(1, -17.0, DATE_SUB(NOW(), INTERVAL 16 HOUR), 0, NOW(), NOW()),
(1, -16.0, DATE_SUB(NOW(), INTERVAL 14 HOUR), 0, NOW(), NOW()),
(1, -18.5, DATE_SUB(NOW(), INTERVAL 12 HOUR), 0, NOW(), NOW()),
(1, -19.0, DATE_SUB(NOW(), INTERVAL 10 HOUR), 0, NOW(), NOW()),
(1, -20.0, DATE_SUB(NOW(), INTERVAL 8 HOUR), 0, NOW(), NOW()),
(1, -20.5, DATE_SUB(NOW(), INTERVAL 6 HOUR), 0, NOW(), NOW()),
(1, -19.8, DATE_SUB(NOW(), INTERVAL 4 HOUR), 0, NOW(), NOW()),
(1, -20.0, DATE_SUB(NOW(), INTERVAL 2 HOUR), 0, NOW(), NOW());

-- =====================================================
-- EQUIPMENT 2: Cámara Frigorífica - Con warning constante
-- Rango óptimo: 0°C a 5°C
-- =====================================================

INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(2, 5.5, DATE_SUB(NOW(), INTERVAL 24 HOUR), 1, NOW(), NOW()),
(2, 6.0, DATE_SUB(NOW(), INTERVAL 22 HOUR), 1, NOW(), NOW()),
(2, 6.5, DATE_SUB(NOW(), INTERVAL 20 HOUR), 1, NOW(), NOW()),
(2, 7.0, DATE_SUB(NOW(), INTERVAL 18 HOUR), 1, NOW(), NOW()),
(2, 6.8, DATE_SUB(NOW(), INTERVAL 16 HOUR), 1, NOW(), NOW()),
(2, 6.2, DATE_SUB(NOW(), INTERVAL 14 HOUR), 1, NOW(), NOW()),
(2, 5.8, DATE_SUB(NOW(), INTERVAL 12 HOUR), 1, NOW(), NOW()),
(2, 5.5, DATE_SUB(NOW(), INTERVAL 10 HOUR), 1, NOW(), NOW()),
(2, 6.0, DATE_SUB(NOW(), INTERVAL 8 HOUR), 1, NOW(), NOW()),
(2, 7.5, DATE_SUB(NOW(), INTERVAL 6 HOUR), 1, NOW(), NOW()),
(2, 8.0, DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(2, 7.2, DATE_SUB(NOW(), INTERVAL 2 HOUR), 1, NOW(), NOW());

-- =====================================================
-- ENERGY READINGS - Consumo con picos
-- =====================================================

-- Equipment 3: Consumo alto durante anomalías
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at) VALUES
(3, 1600, 'watts', DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(3, 1650, 'watts', DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(3, 2200, 'watts', DATE_SUB(NOW(), INTERVAL 20 HOUR), 1, NOW(), NOW()),
(3, 2800, 'watts', DATE_SUB(NOW(), INTERVAL 18 HOUR), 2, NOW(), NOW()),
(3, 3200, 'watts', DATE_SUB(NOW(), INTERVAL 16 HOUR), 2, NOW(), NOW()),
(3, 2500, 'watts', DATE_SUB(NOW(), INTERVAL 14 HOUR), 1, NOW(), NOW()),
(3, 1800, 'watts', DATE_SUB(NOW(), INTERVAL 12 HOUR), 0, NOW(), NOW()),
(3, 1650, 'watts', DATE_SUB(NOW(), INTERVAL 10 HOUR), 0, NOW(), NOW()),
(3, 1700, 'watts', DATE_SUB(NOW(), INTERVAL 8 HOUR), 0, NOW(), NOW()),
(3, 2100, 'watts', DATE_SUB(NOW(), INTERVAL 6 HOUR), 1, NOW(), NOW()),
(3, 2600, 'watts', DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(3, 3000, 'watts', DATE_SUB(NOW(), INTERVAL 2 HOUR), 2, NOW(), NOW());

-- Equipment 1: Consumo estable
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at) VALUES
(1, 3500, 'watts', DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(1, 3450, 'watts', DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(1, 3520, 'watts', DATE_SUB(NOW(), INTERVAL 20 HOUR), 0, NOW(), NOW()),
(1, 3480, 'watts', DATE_SUB(NOW(), INTERVAL 18 HOUR), 0, NOW(), NOW()),
(1, 3550, 'watts', DATE_SUB(NOW(), INTERVAL 16 HOUR), 0, NOW(), NOW()),
(1, 3500, 'watts', DATE_SUB(NOW(), INTERVAL 14 HOUR), 0, NOW(), NOW()),
(1, 3420, 'watts', DATE_SUB(NOW(), INTERVAL 12 HOUR), 0, NOW(), NOW()),
(1, 3480, 'watts', DATE_SUB(NOW(), INTERVAL 10 HOUR), 0, NOW(), NOW()),
(1, 3510, 'watts', DATE_SUB(NOW(), INTERVAL 8 HOUR), 0, NOW(), NOW()),
(1, 3490, 'watts', DATE_SUB(NOW(), INTERVAL 6 HOUR), 0, NOW(), NOW()),
(1, 3530, 'watts', DATE_SUB(NOW(), INTERVAL 4 HOUR), 0, NOW(), NOW()),
(1, 3500, 'watts', DATE_SUB(NOW(), INTERVAL 2 HOUR), 0, NOW(), NOW());

-- Equipment 2: Consumo con tendencia al alza (problema potencial)
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at) VALUES
(2, 5200, 'watts', DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(2, 5350, 'watts', DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(2, 5500, 'watts', DATE_SUB(NOW(), INTERVAL 20 HOUR), 1, NOW(), NOW()),
(2, 5680, 'watts', DATE_SUB(NOW(), INTERVAL 18 HOUR), 1, NOW(), NOW()),
(2, 5850, 'watts', DATE_SUB(NOW(), INTERVAL 16 HOUR), 1, NOW(), NOW()),
(2, 6000, 'watts', DATE_SUB(NOW(), INTERVAL 14 HOUR), 1, NOW(), NOW()),
(2, 6200, 'watts', DATE_SUB(NOW(), INTERVAL 12 HOUR), 2, NOW(), NOW()),
(2, 6350, 'watts', DATE_SUB(NOW(), INTERVAL 10 HOUR), 2, NOW(), NOW()),
(2, 6500, 'watts', DATE_SUB(NOW(), INTERVAL 8 HOUR), 2, NOW(), NOW()),
(2, 6680, 'watts', DATE_SUB(NOW(), INTERVAL 6 HOUR), 2, NOW(), NOW()),
(2, 6800, 'watts', DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(2, 7000, 'watts', DATE_SUB(NOW(), INTERVAL 2 HOUR), 2, NOW(), NOW());

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

SELECT '=== DATOS INSERTADOS ===' as info;
SELECT equipment_id, COUNT(*) as lecturas, MIN(temperature) as temp_min, MAX(temperature) as temp_max
FROM temperature_readings
GROUP BY equipment_id;

SELECT equipment_id, COUNT(*) as lecturas, AVG(consumption) as consumo_promedio
FROM energy_readings
GROUP BY equipment_id;

SELECT '=== ANOMALÍAS DETECTADAS ===' as info;
SELECT equipment_id, status, COUNT(*) as cantidad
FROM temperature_readings
GROUP BY equipment_id, status;

SELECT '=== COMPLETADO ===' as info;
