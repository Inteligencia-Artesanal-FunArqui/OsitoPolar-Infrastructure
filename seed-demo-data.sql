-- =====================================================
-- OsitoPolar - Script de Datos Demo
-- Ejecutar en Azure VM via SSH
-- =====================================================

-- =====================================================
-- PARTE 1: EQUIPOS PARA OWNER (con Analytics completas)
-- =====================================================

-- Primero verificar qué owners existen
SELECT 'Owners existentes:' as info;
SELECT id, user_id, first_name, last_name FROM ositopolar_profiles.owners LIMIT 5;

-- Usar el primer owner disponible (o el ID 1 si existe)
SET @owner_id = (SELECT COALESCE(MIN(id), 1) FROM ositopolar_profiles.owners);
SELECT CONCAT('Usando Owner ID: ', @owner_id) as info;

-- Insertar 10 equipos para el Owner
INSERT INTO ositopolar_equipment.equipment
(equipment_identifier, name, type, model, manufacturer, serial_number, code, cost, technical_details, status, is_powered_on, installation_date, current_temperature, set_temperature, optimal_temp_min, optimal_temp_max, location_name, location_address, location_latitude, location_longitude, energy_current, energy_unit, energy_average, owner_id, owner_type, ownership_type, notes, created_at, updated_at)
VALUES
-- Equipo 1: Freezer Industrial
(UUID(), 'Freezer Industrial Alpha', 'Freezer', 'FZ-5000', 'CoolTech Pro', 'SN-DEMO-001', 'DEMO-EQ-001', 15000.00, 'Freezer industrial de alta capacidad 500L, compresor dual, -30°C a -18°C', 'Active', 1, DATE_SUB(NOW(), INTERVAL 180 DAY), -20.5, -18.0, -25.0, -15.0, 'Almacén Principal', 'Av. Industrial 123, Lima', -12.0464, -77.0428, 3500.0, 'watts', 3250.0, @owner_id, 'Owner', 'Owned', 'Equipo principal de congelación', NOW(), NOW()),

-- Equipo 2: Cámara Frigorífica
(UUID(), 'Cámara Frigorífica Beta', 'ColdRoom', 'CR-3000', 'ArcticStore', 'SN-DEMO-002', 'DEMO-EQ-002', 25000.00, 'Cámara frigorífica modular 20m³, control digital, 0°C a 5°C', 'Active', 1, DATE_SUB(NOW(), INTERVAL 120 DAY), 2.5, 3.0, 0.0, 5.0, 'Centro de Distribución', 'Jr. Comercio 456, Lima', -12.0553, -77.0311, 5200.0, 'watts', 4800.0, @owner_id, 'Owner', 'Owned', 'Almacenamiento de productos frescos', NOW(), NOW()),

-- Equipo 3: Refrigerador Comercial
(UUID(), 'Refrigerador Display Gamma', 'Refrigerator', 'RD-200', 'FreshView', 'SN-DEMO-003', 'DEMO-EQ-003', 8500.00, 'Refrigerador exhibidor vertical, vidrio templado, LED', 'Active', 1, DATE_SUB(NOW(), INTERVAL 90 DAY), 4.0, 4.0, 2.0, 6.0, 'Tienda Norte', 'Av. Primavera 789, Lima', -12.0890, -77.0012, 1800.0, 'watts', 1650.0, @owner_id, 'Owner', 'Owned', 'Exhibición de bebidas', NOW(), NOW()),

-- Equipo 4: Freezer Vertical
(UUID(), 'Freezer Vertical Delta', 'Freezer', 'FV-400', 'IceMaster', 'SN-DEMO-004', 'DEMO-EQ-004', 6500.00, 'Freezer vertical 400L, 5 niveles, descongelación automática', 'Active', 1, DATE_SUB(NOW(), INTERVAL 200 DAY), -18.0, -18.0, -22.0, -16.0, 'Sucursal Centro', 'Jr. Unión 321, Lima', -12.0475, -77.0308, 2200.0, 'watts', 2000.0, @owner_id, 'Owner', 'Owned', 'Almacenamiento de helados', NOW(), NOW()),

-- Equipo 5: Cámara de Congelación
(UUID(), 'Cámara Congelación Epsilon', 'ColdRoom', 'CC-8000', 'PolarMax', 'SN-DEMO-005', 'DEMO-EQ-005', 45000.00, 'Cámara de congelación industrial 50m³, -35°C, sistema redundante', 'Active', 1, DATE_SUB(NOW(), INTERVAL 365 DAY), -28.0, -25.0, -35.0, -20.0, 'Planta Principal', 'Av. Argentina 1500, Callao', -12.0600, -77.1200, 12000.0, 'watts', 11000.0, @owner_id, 'Owner', 'Owned', 'Congelación de productos del mar', NOW(), NOW()),

-- Equipo 6: Refrigerador Bajo Mostrador
(UUID(), 'Refrigerador Mostrador Zeta', 'Refrigerator', 'RM-150', 'ChefCool', 'SN-DEMO-006', 'DEMO-EQ-006', 4200.00, 'Refrigerador bajo mostrador 150L, acero inoxidable', 'Active', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), 3.5, 4.0, 1.0, 5.0, 'Cocina Central', 'Calle Gourmet 55, Miraflores', -12.1186, -77.0306, 950.0, 'watts', 880.0, @owner_id, 'Owner', 'Owned', 'Conservación de ingredientes frescos', NOW(), NOW()),

-- Equipo 7: Freezer Horizontal
(UUID(), 'Freezer Horizontal Eta', 'Freezer', 'FH-600', 'DeepFreeze', 'SN-DEMO-007', 'DEMO-EQ-007', 5800.00, 'Freezer horizontal tipo cofre 600L, bajo consumo', 'Active', 1, DATE_SUB(NOW(), INTERVAL 150 DAY), -22.0, -20.0, -25.0, -18.0, 'Bodega Sur', 'Av. Pachacutec 2000, Villa El Salvador', -12.2125, -76.9425, 1600.0, 'watts', 1450.0, @owner_id, 'Owner', 'Owned', 'Almacén de carnes', NOW(), NOW()),

-- Equipo 8: Vitrina Refrigerada
(UUID(), 'Vitrina Refrigerada Theta', 'Refrigerator', 'VR-250', 'ShowCool', 'SN-DEMO-008', 'DEMO-EQ-008', 7200.00, 'Vitrina refrigerada curva para pastelería, iluminación LED', 'Active', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 5.0, 5.0, 3.0, 7.0, 'Pastelería Dulce', 'Av. Larco 890, Miraflores', -12.1230, -77.0280, 1400.0, 'watts', 1300.0, @owner_id, 'Owner', 'Owned', 'Exhibición de postres', NOW(), NOW()),

-- Equipo 9: Mini Freezer
(UUID(), 'Mini Freezer Iota', 'Freezer', 'MF-100', 'CompactIce', 'SN-DEMO-009', 'DEMO-EQ-009', 1800.00, 'Mini freezer portátil 100L, ideal para espacios reducidos', 'Active', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), -16.0, -15.0, -20.0, -12.0, 'Oficina Admin', 'Jr. Lampa 456, Centro de Lima', -12.0453, -77.0311, 450.0, 'watts', 400.0, @owner_id, 'Owner', 'Owned', 'Snacks congelados', NOW(), NOW()),

-- Equipo 10: Cámara Refrigerada Móvil
(UUID(), 'Cámara Móvil Kappa', 'ColdRoom', 'CMM-500', 'MobileCold', 'SN-DEMO-010', 'DEMO-EQ-010', 35000.00, 'Contenedor refrigerado móvil 10m³, autónomo 48hrs', 'Active', 1, DATE_SUB(NOW(), INTERVAL 240 DAY), 1.0, 2.0, -2.0, 4.0, 'Flota de Transporte', 'Terminal Pesquero, Ventanilla', -11.8833, -77.1167, 8500.0, 'watts', 7800.0, @owner_id, 'Owner', 'Owned', 'Transporte de productos perecibles', NOW(), NOW());

SELECT 'Equipos de Owner creados exitosamente' as resultado;

-- =====================================================
-- PARTE 2: LECTURAS DE TEMPERATURA Y ENERGÍA (30 días)
-- Para Analytics básicas y avanzadas
-- =====================================================

-- Crear procedimiento para generar lecturas
DELIMITER //

DROP PROCEDURE IF EXISTS GenerateReadings//

CREATE PROCEDURE GenerateReadings()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE eq_id INT;
    DECLARE base_temp DECIMAL(5,2);
    DECLARE base_energy DECIMAL(10,2);
    DECLARE reading_time DATETIME;
    DECLARE temp_variation DECIMAL(5,2);
    DECLARE energy_variation DECIMAL(10,2);

    -- Cursor para equipos del owner
    DECLARE done INT DEFAULT FALSE;
    DECLARE equipment_cursor CURSOR FOR
        SELECT id, current_temperature, energy_current
        FROM ositopolar_equipment.equipment
        WHERE owner_type = 'Owner' AND serial_number LIKE 'SN-DEMO-%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN equipment_cursor;

    equipment_loop: LOOP
        FETCH equipment_cursor INTO eq_id, base_temp, base_energy;
        IF done THEN
            LEAVE equipment_loop;
        END IF;

        -- Generar 30 días de lecturas (4 lecturas por día = 120 lecturas)
        SET i = 0;
        WHILE i < 120 DO
            SET reading_time = DATE_SUB(NOW(), INTERVAL (30 - FLOOR(i/4)) DAY);
            SET reading_time = DATE_ADD(reading_time, INTERVAL (i MOD 4) * 6 HOUR);

            -- Variación de temperatura (-2 a +2 grados)
            SET temp_variation = base_temp + (RAND() * 4 - 2);

            -- Variación de energía (-10% a +10%)
            SET energy_variation = base_energy * (0.9 + RAND() * 0.2);

            -- Insertar lectura de temperatura
            INSERT INTO ositopolar_analytics.temperature_readings
            (equipment_id, temperature, timestamp, status)
            VALUES (eq_id, temp_variation, reading_time,
                CASE
                    WHEN ABS(temp_variation - base_temp) > 3 THEN 2  -- Critical
                    WHEN ABS(temp_variation - base_temp) > 1.5 THEN 1  -- Warning
                    ELSE 0  -- Normal
                END);

            -- Insertar lectura de energía
            INSERT INTO ositopolar_analytics.energy_readings
            (equipment_id, consumption, unit, timestamp, status)
            VALUES (eq_id, energy_variation, 'watts', reading_time, 0);

            SET i = i + 1;
        END WHILE;

    END LOOP;

    CLOSE equipment_cursor;
END//

DELIMITER ;

-- Ejecutar procedimiento
CALL GenerateReadings();

SELECT 'Lecturas generadas exitosamente' as resultado;
SELECT COUNT(*) as total_temperature_readings FROM ositopolar_analytics.temperature_readings;
SELECT COUNT(*) as total_energy_readings FROM ositopolar_analytics.energy_readings;

-- =====================================================
-- PARTE 3: EQUIPOS PARA PROVIDER (Rental Marketplace)
-- =====================================================

-- Verificar providers existentes
SELECT 'Providers existentes:' as info;
SELECT id, user_id, company_name FROM ositopolar_profiles.providers LIMIT 5;

-- Usar el primer provider disponible (o crear uno si no existe)
SET @provider_id = (SELECT COALESCE(MIN(id), 1) FROM ositopolar_profiles.providers);
SELECT CONCAT('Usando Provider ID: ', @provider_id) as info;

-- Insertar equipos para el Rental Marketplace
INSERT INTO ositopolar_equipment.equipment
(equipment_identifier, name, type, model, manufacturer, serial_number, code, cost, technical_details, status, is_powered_on, installation_date, current_temperature, set_temperature, optimal_temp_min, optimal_temp_max, location_name, location_address, location_latitude, location_longitude, energy_current, energy_unit, energy_average, owner_id, owner_type, ownership_type, rental_monthly_fee, rental_provider_id, rental_start_date, rental_end_date, notes, created_at, updated_at)
VALUES
-- Rental 1: Freezer económico
(UUID(), 'Freezer Compacto Alquiler', 'Freezer', 'FC-200', 'RentCool', 'SN-RENT-001', 'RENT-EQ-001', 3500.00, 'Freezer compacto ideal para pequeños negocios, bajo consumo energético', 'Active', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), -18.0, -18.0, -22.0, -15.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 1200.0, 'watts', 1100.0, @provider_id, 'Provider', 'Owned', 150.00, @provider_id, NULL, NULL, 'Disponible para alquiler inmediato', NOW(), NOW()),

-- Rental 2: Cámara frigorífica mediana
(UUID(), 'Cámara Fría Express', 'ColdRoom', 'CFE-15', 'QuickCold', 'SN-RENT-002', 'RENT-EQ-002', 18000.00, 'Cámara frigorífica modular 15m³, fácil instalación, ideal para eventos', 'Active', 1, DATE_SUB(NOW(), INTERVAL 90 DAY), 2.0, 2.0, 0.0, 5.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 4500.0, 'watts', 4200.0, @provider_id, 'Provider', 'Owned', 450.00, @provider_id, NULL, NULL, 'Perfecto para catering y eventos', NOW(), NOW()),

-- Rental 3: Refrigerador exhibidor
(UUID(), 'Vitrina Exhibidora Premium', 'Refrigerator', 'VEP-300', 'ShowFresh', 'SN-RENT-003', 'RENT-EQ-003', 9500.00, 'Vitrina refrigerada de alta visibilidad, 3 niveles, iluminación LED integrada', 'Active', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 4.0, 4.0, 2.0, 6.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 1600.0, 'watts', 1500.0, @provider_id, 'Provider', 'Owned', 200.00, @provider_id, NULL, NULL, 'Ideal para tiendas y supermercados', NOW(), NOW()),

-- Rental 4: Freezer industrial grande
(UUID(), 'Freezer Industrial XL', 'Freezer', 'FI-1000', 'MegaFreeze', 'SN-RENT-004', 'RENT-EQ-004', 28000.00, 'Freezer industrial de alta capacidad 1000L, sistema de enfriamiento rápido', 'Active', 1, DATE_SUB(NOW(), INTERVAL 120 DAY), -25.0, -22.0, -30.0, -18.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 6500.0, 'watts', 6000.0, @provider_id, 'Provider', 'Owned', 650.00, @provider_id, NULL, NULL, 'Para grandes volúmenes de almacenamiento', NOW(), NOW()),

-- Rental 5: Mini refrigerador móvil
(UUID(), 'Mini Cooler Portátil', 'Refrigerator', 'MCP-50', 'PortaCool', 'SN-RENT-005', 'RENT-EQ-005', 1200.00, 'Refrigerador portátil 50L, funciona con 12V/220V, ideal para delivery', 'Active', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 5.0, 5.0, 2.0, 8.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 150.0, 'watts', 140.0, @provider_id, 'Provider', 'Owned', 80.00, @provider_id, NULL, NULL, 'Solución móvil para delivery', NOW(), NOW()),

-- Rental 6: Cámara de congelación profesional
(UUID(), 'Cámara Congelación Pro', 'ColdRoom', 'CCP-30', 'ProFreeze', 'SN-RENT-006', 'RENT-EQ-006', 55000.00, 'Cámara de congelación profesional 30m³, -40°C, control remoto incluido', 'Active', 1, DATE_SUB(NOW(), INTERVAL 200 DAY), -32.0, -30.0, -40.0, -25.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 15000.0, 'watts', 14000.0, @provider_id, 'Provider', 'Owned', 950.00, @provider_id, NULL, NULL, 'Máxima capacidad de congelación', NOW(), NOW()),

-- Rental 7: Refrigerador para farmacia
(UUID(), 'Refrigerador Farmacéutico', 'Refrigerator', 'RF-250', 'MediCool', 'SN-RENT-007', 'RENT-EQ-007', 12000.00, 'Refrigerador certificado para medicamentos, rango 2-8°C, alarma de temperatura', 'Active', 1, DATE_SUB(NOW(), INTERVAL 75 DAY), 4.0, 4.0, 2.0, 8.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 800.0, 'watts', 750.0, @provider_id, 'Provider', 'Owned', 350.00, @provider_id, NULL, NULL, 'Certificado para uso farmacéutico', NOW(), NOW()),

-- Rental 8: Freezer de helados
(UUID(), 'Freezer Exhibidor Helados', 'Freezer', 'FEH-400', 'IceCream Pro', 'SN-RENT-008', 'RENT-EQ-008', 7500.00, 'Freezer exhibidor para helados con tapa de vidrio curvo, -25°C', 'Active', 1, DATE_SUB(NOW(), INTERVAL 50 DAY), -22.0, -20.0, -25.0, -18.0, 'Depósito Central Alquileres', 'Av. Colonial 500, Lima', -12.0550, -77.0800, 2200.0, 'watts', 2000.0, @provider_id, 'Provider', 'Owned', 250.00, @provider_id, NULL, NULL, 'Perfecto para heladerías', NOW(), NOW());

SELECT 'Equipos de Rental Marketplace creados exitosamente' as resultado;

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================

SELECT '=== RESUMEN DE DATOS DEMO ===' as info;

SELECT 'Equipos por tipo de owner:' as info;
SELECT owner_type, COUNT(*) as cantidad FROM ositopolar_equipment.equipment WHERE serial_number LIKE 'SN-DEMO-%' OR serial_number LIKE 'SN-RENT-%' GROUP BY owner_type;

SELECT 'Equipos disponibles en Rental Marketplace:' as info;
SELECT id, name, type, rental_monthly_fee as precio_mensual
FROM ositopolar_equipment.equipment
WHERE owner_type = 'Provider'
AND rental_monthly_fee IS NOT NULL
AND rental_start_date IS NULL;

SELECT 'Lecturas de Analytics:' as info;
SELECT 'Temperature Readings' as tipo, COUNT(*) as total FROM ositopolar_analytics.temperature_readings
UNION ALL
SELECT 'Energy Readings' as tipo, COUNT(*) as total FROM ositopolar_analytics.energy_readings;

SELECT '=== SCRIPT COMPLETADO ===' as info;
