-- =====================================================
-- OsitoPolar Analytics - Datos Completos para Demo
-- Ejecutar: docker exec -i ositopolar-mysql mysql -u root -pOsitoPolar2024! < seed-analytics-complete.sql
-- =====================================================
-- Cubre:
-- - Readings basicos (temperatura y energia)
-- - Daily summaries (promedios)
-- - Health score (varianza, tendencias)
-- - Anomaly detection (puerta abierta, compresor, corte luz)
-- - Cost analysis (60 dias para comparacion)
-- - Maintenance forecast (datos historicos)
-- =====================================================

USE ositopolar_analytics;

-- Limpiar datos anteriores
DELETE FROM temperature_readings WHERE equipment_id IN (1, 2, 3);
DELETE FROM energy_readings WHERE equipment_id IN (1, 2, 3);

-- =====================================================
-- EQUIPMENT 1: Freezer Industrial - ESTABLE (referencia)
-- Rango optimo: -25 a -18 C
-- Owner ID: 1
-- =====================================================

-- Ultimos 60 dias - Lecturas cada 2 horas (para cost analysis)
-- Dia 1-30 (periodo anterior) - Estable
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 1,
       -21.0 + (RAND() * 2 - 1), -- Variacion minima -22 a -20
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       0, NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) b
    WHERE a.N + b.N * 10 < 30
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- Dia 31-60 (periodo actual) - Estable
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 1,
       -21.0 + (RAND() * 2 - 1),
       DATE_SUB(NOW(), INTERVAL (30 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       0, NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) b
    WHERE a.N + b.N * 10 < 30
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- Energy Equipment 1 - Consumo estable ~3500W
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at)
SELECT 1,
       3500 + (RAND() * 200 - 100), -- 3400-3600W
       'watts',
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       0, NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) b
    WHERE a.N + b.N * 10 < 60
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- =====================================================
-- EQUIPMENT 2: Camara Frigorifica - WARNING CONSTANTE
-- Rango optimo: 0 a 5 C (pero esta funcionando a 5.5-8)
-- Owner ID: 1
-- =====================================================

-- Ultimos 60 dias - Siempre un poco fuera de rango
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 2,
       6.0 + (RAND() * 2), -- 6-8 grados (fuera del rango 0-5)
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       1, -- WARNING
       NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) b
    WHERE a.N + b.N * 10 < 60
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- Energy Equipment 2 - Consumo en aumento (problema potencial)
-- Periodo anterior: 5200-5500W
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at)
SELECT 2,
       5200 + (RAND() * 300),
       'watts',
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       0, NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) b
    WHERE a.N + b.N * 10 < 30
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- Periodo actual: 6500-7200W (aumento 25%)
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at)
SELECT 2,
       6500 + (RAND() * 700),
       'watts',
       DATE_SUB(NOW(), INTERVAL (30 - seq) DAY) + INTERVAL (hour_val * 2) HOUR,
       CASE WHEN RAND() > 0.3 THEN 1 ELSE 2 END, -- Warning/Critical
       NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) b
    WHERE a.N + b.N * 10 < 30
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11) hours;

-- =====================================================
-- EQUIPMENT 3: Freezer con PROBLEMAS CRITICOS
-- Rango optimo: -25 a -18 C
-- Owner ID: 1
-- Muestra: puerta abierta, falla compresor, recuperaciones
-- =====================================================

-- === ULTIMAS 48 HORAS - DETALLE PARA ANOMALY DETECTION ===

-- Hora 0-8: Normal
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -22.0, DATE_SUB(NOW(), INTERVAL 48 HOUR), 0, NOW(), NOW()),
(3, -21.5, DATE_SUB(NOW(), INTERVAL 47 HOUR), 0, NOW(), NOW()),
(3, -22.2, DATE_SUB(NOW(), INTERVAL 46 HOUR), 0, NOW(), NOW()),
(3, -21.8, DATE_SUB(NOW(), INTERVAL 45 HOUR), 0, NOW(), NOW()),
(3, -22.1, DATE_SUB(NOW(), INTERVAL 44 HOUR), 0, NOW(), NOW()),
(3, -21.7, DATE_SUB(NOW(), INTERVAL 43 HOUR), 0, NOW(), NOW()),
(3, -22.0, DATE_SUB(NOW(), INTERVAL 42 HOUR), 0, NOW(), NOW()),
(3, -21.5, DATE_SUB(NOW(), INTERVAL 41 HOUR), 0, NOW(), NOW());

-- Hora 8-16: PUERTA ABIERTA - subida gradual (WARNING -> CRITICAL)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -19.0, DATE_SUB(NOW(), INTERVAL 40 HOUR), 1, NOW(), NOW()),
(3, -16.5, DATE_SUB(NOW(), INTERVAL 39 HOUR), 1, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 38 HOUR), 2, NOW(), NOW()),
(3, -12.0, DATE_SUB(NOW(), INTERVAL 37 HOUR), 2, NOW(), NOW()),
(3, -10.5, DATE_SUB(NOW(), INTERVAL 36 HOUR), 2, NOW(), NOW()),
(3, -8.0, DATE_SUB(NOW(), INTERVAL 35 HOUR), 2, NOW(), NOW()),
(3, -6.5, DATE_SUB(NOW(), INTERVAL 34 HOUR), 2, NOW(), NOW()),
(3, -5.0, DATE_SUB(NOW(), INTERVAL 33 HOUR), 2, NOW(), NOW());

-- Hora 16-24: RECUPERACION (puerta cerrada)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -8.0, DATE_SUB(NOW(), INTERVAL 32 HOUR), 2, NOW(), NOW()),
(3, -11.0, DATE_SUB(NOW(), INTERVAL 31 HOUR), 2, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 30 HOUR), 2, NOW(), NOW()),
(3, -16.5, DATE_SUB(NOW(), INTERVAL 29 HOUR), 1, NOW(), NOW()),
(3, -18.0, DATE_SUB(NOW(), INTERVAL 28 HOUR), 1, NOW(), NOW()),
(3, -19.5, DATE_SUB(NOW(), INTERVAL 27 HOUR), 0, NOW(), NOW()),
(3, -20.5, DATE_SUB(NOW(), INTERVAL 26 HOUR), 0, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 25 HOUR), 0, NOW(), NOW());

-- Hora 24-32: Normal de nuevo
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -21.5, DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(3, -22.0, DATE_SUB(NOW(), INTERVAL 23 HOUR), 0, NOW(), NOW()),
(3, -21.8, DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(3, -22.1, DATE_SUB(NOW(), INTERVAL 21 HOUR), 0, NOW(), NOW()),
(3, -21.5, DATE_SUB(NOW(), INTERVAL 20 HOUR), 0, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 19 HOUR), 0, NOW(), NOW()),
(3, -20.5, DATE_SUB(NOW(), INTERVAL 18 HOUR), 0, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 17 HOUR), 0, NOW(), NOW());

-- Hora 32-40: FALLA DE COMPRESOR - subida rapida y sostenida
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -18.0, DATE_SUB(NOW(), INTERVAL 16 HOUR), 1, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 15 HOUR), 2, NOW(), NOW()),
(3, -10.0, DATE_SUB(NOW(), INTERVAL 14 HOUR), 2, NOW(), NOW()),
(3, -6.0, DATE_SUB(NOW(), INTERVAL 13 HOUR), 2, NOW(), NOW()),
(3, -3.0, DATE_SUB(NOW(), INTERVAL 12 HOUR), 2, NOW(), NOW()),
(3, 0.0, DATE_SUB(NOW(), INTERVAL 11 HOUR), 2, NOW(), NOW()),
(3, 2.0, DATE_SUB(NOW(), INTERVAL 10 HOUR), 2, NOW(), NOW()),
(3, 4.0, DATE_SUB(NOW(), INTERVAL 9 HOUR), 2, NOW(), NOW());

-- Hora 40-48: Sigue subiendo (compresor aun fallando)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, 5.0, DATE_SUB(NOW(), INTERVAL 8 HOUR), 2, NOW(), NOW()),
(3, 6.0, DATE_SUB(NOW(), INTERVAL 7 HOUR), 2, NOW(), NOW()),
(3, 7.0, DATE_SUB(NOW(), INTERVAL 6 HOUR), 2, NOW(), NOW()),
(3, 7.5, DATE_SUB(NOW(), INTERVAL 5 HOUR), 2, NOW(), NOW()),
(3, 8.0, DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(3, 8.2, DATE_SUB(NOW(), INTERVAL 3 HOUR), 2, NOW(), NOW()),
(3, 8.5, DATE_SUB(NOW(), INTERVAL 2 HOUR), 2, NOW(), NOW()),
(3, 8.8, DATE_SUB(NOW(), INTERVAL 1 HOUR), 2, NOW(), NOW());

-- === DATOS HISTORICOS (dias 3-60) para maintenance forecast ===
-- Con incidentes periodicos

-- Dias 3-10: Estable
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 3,
       -21.0 + (RAND() * 2 - 1),
       DATE_SUB(NOW(), INTERVAL (10 - seq) DAY) + INTERVAL (hour_val * 3) HOUR,
       0, NOW(), NOW()
FROM (SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7) hours;

-- Dia 11-12: Incidente #1
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -21.0, DATE_SUB(NOW(), INTERVAL 11 DAY), 0, NOW(), NOW()),
(3, -15.0, DATE_SUB(NOW(), INTERVAL 11 DAY) + INTERVAL 6 HOUR, 1, NOW(), NOW()),
(3, -10.0, DATE_SUB(NOW(), INTERVAL 11 DAY) + INTERVAL 12 HOUR, 2, NOW(), NOW()),
(3, -18.0, DATE_SUB(NOW(), INTERVAL 11 DAY) + INTERVAL 18 HOUR, 1, NOW(), NOW()),
(3, -21.0, DATE_SUB(NOW(), INTERVAL 10 DAY) + INTERVAL 6 HOUR, 0, NOW(), NOW());

-- Dias 13-25: Estable
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 3,
       -21.5 + (RAND() * 1.5),
       DATE_SUB(NOW(), INTERVAL (25 - seq) DAY) + INTERVAL (hour_val * 4) HOUR,
       0, NOW(), NOW()
FROM (SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5) hours;

-- Dia 26-27: Incidente #2
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at) VALUES
(3, -22.0, DATE_SUB(NOW(), INTERVAL 27 DAY), 0, NOW(), NOW()),
(3, -18.0, DATE_SUB(NOW(), INTERVAL 27 DAY) + INTERVAL 4 HOUR, 1, NOW(), NOW()),
(3, -14.0, DATE_SUB(NOW(), INTERVAL 27 DAY) + INTERVAL 8 HOUR, 2, NOW(), NOW()),
(3, -12.0, DATE_SUB(NOW(), INTERVAL 27 DAY) + INTERVAL 12 HOUR, 2, NOW(), NOW()),
(3, -16.0, DATE_SUB(NOW(), INTERVAL 27 DAY) + INTERVAL 16 HOUR, 1, NOW(), NOW()),
(3, -20.0, DATE_SUB(NOW(), INTERVAL 27 DAY) + INTERVAL 20 HOUR, 0, NOW(), NOW()),
(3, -21.5, DATE_SUB(NOW(), INTERVAL 26 DAY), 0, NOW(), NOW());

-- Dias 28-45: Estable
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 3,
       -21.0 + (RAND() * 2 - 1),
       DATE_SUB(NOW(), INTERVAL (45 - seq) DAY) + INTERVAL (hour_val * 4) HOUR,
       0, NOW(), NOW()
FROM (SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14
      UNION SELECT 15 UNION SELECT 16 UNION SELECT 17) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5) hours;

-- Dias 46-60: Mas variacion (equipo envejeciendo)
INSERT INTO temperature_readings (equipment_id, temperature, timestamp, status, created_at, updated_at)
SELECT 3,
       -20.5 + (RAND() * 3 - 1.5), -- Mayor variacion
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 4) HOUR,
       CASE WHEN RAND() > 0.85 THEN 1 ELSE 0 END,
       NOW(), NOW()
FROM (SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5) hours;

-- === ENERGY EQUIPMENT 3 - Correlacionado con temperatura ===

-- Ultimas 48 horas - Picos durante anomalias
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at) VALUES
-- Normal (hora 0-8)
(3, 1600, 'watts', DATE_SUB(NOW(), INTERVAL 48 HOUR), 0, NOW(), NOW()),
(3, 1650, 'watts', DATE_SUB(NOW(), INTERVAL 46 HOUR), 0, NOW(), NOW()),
(3, 1620, 'watts', DATE_SUB(NOW(), INTERVAL 44 HOUR), 0, NOW(), NOW()),
(3, 1680, 'watts', DATE_SUB(NOW(), INTERVAL 42 HOUR), 0, NOW(), NOW()),
-- Puerta abierta - compresor trabaja mas (hora 8-16)
(3, 2200, 'watts', DATE_SUB(NOW(), INTERVAL 40 HOUR), 1, NOW(), NOW()),
(3, 2600, 'watts', DATE_SUB(NOW(), INTERVAL 38 HOUR), 2, NOW(), NOW()),
(3, 2900, 'watts', DATE_SUB(NOW(), INTERVAL 36 HOUR), 2, NOW(), NOW()),
(3, 3200, 'watts', DATE_SUB(NOW(), INTERVAL 34 HOUR), 2, NOW(), NOW()),
-- Recuperacion (hora 16-24)
(3, 2800, 'watts', DATE_SUB(NOW(), INTERVAL 32 HOUR), 2, NOW(), NOW()),
(3, 2400, 'watts', DATE_SUB(NOW(), INTERVAL 30 HOUR), 1, NOW(), NOW()),
(3, 2000, 'watts', DATE_SUB(NOW(), INTERVAL 28 HOUR), 1, NOW(), NOW()),
(3, 1700, 'watts', DATE_SUB(NOW(), INTERVAL 26 HOUR), 0, NOW(), NOW()),
-- Normal (hora 24-32)
(3, 1650, 'watts', DATE_SUB(NOW(), INTERVAL 24 HOUR), 0, NOW(), NOW()),
(3, 1620, 'watts', DATE_SUB(NOW(), INTERVAL 22 HOUR), 0, NOW(), NOW()),
(3, 1680, 'watts', DATE_SUB(NOW(), INTERVAL 20 HOUR), 0, NOW(), NOW()),
(3, 1600, 'watts', DATE_SUB(NOW(), INTERVAL 18 HOUR), 0, NOW(), NOW()),
-- Falla compresor - consumo erratico (hora 32-40)
(3, 800, 'watts', DATE_SUB(NOW(), INTERVAL 16 HOUR), 2, NOW(), NOW()),
(3, 2500, 'watts', DATE_SUB(NOW(), INTERVAL 14 HOUR), 2, NOW(), NOW()),
(3, 500, 'watts', DATE_SUB(NOW(), INTERVAL 12 HOUR), 2, NOW(), NOW()),
(3, 3000, 'watts', DATE_SUB(NOW(), INTERVAL 10 HOUR), 2, NOW(), NOW()),
-- Compresor fallando (hora 40-48)
(3, 400, 'watts', DATE_SUB(NOW(), INTERVAL 8 HOUR), 2, NOW(), NOW()),
(3, 2800, 'watts', DATE_SUB(NOW(), INTERVAL 6 HOUR), 2, NOW(), NOW()),
(3, 300, 'watts', DATE_SUB(NOW(), INTERVAL 4 HOUR), 2, NOW(), NOW()),
(3, 250, 'watts', DATE_SUB(NOW(), INTERVAL 2 HOUR), 2, NOW(), NOW());

-- Historico energia (dias 3-60)
INSERT INTO energy_readings (equipment_id, consumption, unit, timestamp, status, created_at, updated_at)
SELECT 3,
       1650 + (RAND() * 200 - 100),
       'watts',
       DATE_SUB(NOW(), INTERVAL (60 - seq) DAY) + INTERVAL (hour_val * 4) HOUR,
       0, NOW(), NOW()
FROM (
    SELECT a.N + b.N * 10 AS seq
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
          UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) b
    WHERE a.N + b.N * 10 < 58 AND a.N + b.N * 10 > 2
) days
CROSS JOIN (SELECT 0 AS hour_val UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5) hours;

-- =====================================================
-- VERIFICACION
-- =====================================================

SELECT '=== RESUMEN DE DATOS ===' as info;
SELECT equipment_id,
       COUNT(*) as total_lecturas,
       MIN(temperature) as temp_min,
       MAX(temperature) as temp_max,
       AVG(temperature) as temp_promedio
FROM temperature_readings
GROUP BY equipment_id
ORDER BY equipment_id;

SELECT equipment_id,
       SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as normal,
       SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as warning,
       SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) as critical
FROM temperature_readings
GROUP BY equipment_id
ORDER BY equipment_id;

SELECT equipment_id,
       COUNT(*) as total_lecturas,
       MIN(consumption) as consumo_min,
       MAX(consumption) as consumo_max,
       AVG(consumption) as consumo_promedio
FROM energy_readings
GROUP BY equipment_id
ORDER BY equipment_id;

SELECT '=== DATOS PARA DEMO LISTOS ===' as info;
SELECT 'Equipment 1: Freezer estable (referencia)' as descripcion;
SELECT 'Equipment 2: Camara frigorifica con warnings constantes + consumo en aumento' as descripcion;
SELECT 'Equipment 3: Freezer con falla de compresor activa (CRITICO)' as descripcion;
