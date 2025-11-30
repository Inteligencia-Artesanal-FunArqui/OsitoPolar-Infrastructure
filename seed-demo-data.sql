-- =====================================================
-- OsitoPolar - Script de Datos Demo v2
-- Ejecutar: docker exec -i ositopolar-mysql mysql -u root -pOsitoPolar2024! < seed-demo-data.sql
-- =====================================================

-- Usar Owner ID 1 y Provider ID 3 (ya existen en la BD)
SET @owner_id = 1;
SET @provider_id = 3;

SELECT CONCAT('Creando equipos para Owner ID: ', @owner_id) as info;
SELECT CONCAT('Creando equipos para Provider ID: ', @provider_id) as info;

-- =====================================================
-- PARTE 1: EQUIPOS PARA OWNER
-- =====================================================

INSERT INTO ositopolar_equipment.equipment
(equipment_identifier, name, type, model, manufacturer, serial_number, code, cost, technical_details, status, is_powered_on, installation_date, current_temperature, set_temperature, optimal_temperature_min, optimal_temperature_max, location_name, location_address, location_latitude, location_longitude, energy_consumption_current, energy_consumption_unit, energy_consumption_average, owner_id, owner_type, ownership_type, notes, created_at, updated_at)
VALUES
(UUID(), 'Freezer Industrial Alpha', 'Freezer', 'FZ-5000', 'CoolTech Pro', 'SN-DEMO-001', 'DEMO-EQ-001', 15000.00, 'Freezer industrial 500L, compresor dual', 'Active', 1, DATE_SUB(NOW(), INTERVAL 180 DAY), -20.5, -18.0, -25.0, -15.0, 'Almacén Principal', 'Av. Industrial 123, Lima', -12.04640000, -77.04280000, 3500.0, 'watts', 3250.0, @owner_id, 'Owner', 'Owned', 'Equipo principal', NOW(), NOW()),
(UUID(), 'Cámara Frigorífica Beta', 'ColdRoom', 'CR-3000', 'ArcticStore', 'SN-DEMO-002', 'DEMO-EQ-002', 25000.00, 'Cámara frigorífica 20m³', 'Active', 1, DATE_SUB(NOW(), INTERVAL 120 DAY), 2.5, 3.0, 0.0, 5.0, 'Centro Distribución', 'Jr. Comercio 456, Lima', -12.05530000, -77.03110000, 5200.0, 'watts', 4800.0, @owner_id, 'Owner', 'Owned', 'Productos frescos', NOW(), NOW()),
(UUID(), 'Refrigerador Display Gamma', 'Refrigerator', 'RD-200', 'FreshView', 'SN-DEMO-003', 'DEMO-EQ-003', 8500.00, 'Refrigerador exhibidor', 'Active', 1, DATE_SUB(NOW(), INTERVAL 90 DAY), 4.0, 4.0, 2.0, 6.0, 'Tienda Norte', 'Av. Primavera 789', -12.08900000, -77.00120000, 1800.0, 'watts', 1650.0, @owner_id, 'Owner', 'Owned', 'Bebidas', NOW(), NOW()),
(UUID(), 'Freezer Vertical Delta', 'Freezer', 'FV-400', 'IceMaster', 'SN-DEMO-004', 'DEMO-EQ-004', 6500.00, 'Freezer vertical 400L', 'Active', 1, DATE_SUB(NOW(), INTERVAL 200 DAY), -18.0, -18.0, -22.0, -16.0, 'Sucursal Centro', 'Jr. Unión 321', -12.04750000, -77.03080000, 2200.0, 'watts', 2000.0, @owner_id, 'Owner', 'Owned', 'Helados', NOW(), NOW()),
(UUID(), 'Cámara Congelación Epsilon', 'ColdRoom', 'CC-8000', 'PolarMax', 'SN-DEMO-005', 'DEMO-EQ-005', 45000.00, 'Cámara congelación 50m³', 'Active', 1, DATE_SUB(NOW(), INTERVAL 365 DAY), -28.0, -25.0, -35.0, -20.0, 'Planta Principal', 'Av. Argentina 1500', -12.06000000, -77.12000000, 12000.0, 'watts', 11000.0, @owner_id, 'Owner', 'Owned', 'Productos mar', NOW(), NOW()),
(UUID(), 'Refrigerador Mostrador Zeta', 'Refrigerator', 'RM-150', 'ChefCool', 'SN-DEMO-006', 'DEMO-EQ-006', 4200.00, 'Bajo mostrador 150L', 'Active', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), 3.5, 4.0, 1.0, 5.0, 'Cocina Central', 'Calle Gourmet 55', -12.11860000, -77.03060000, 950.0, 'watts', 880.0, @owner_id, 'Owner', 'Owned', 'Ingredientes', NOW(), NOW()),
(UUID(), 'Freezer Horizontal Eta', 'Freezer', 'FH-600', 'DeepFreeze', 'SN-DEMO-007', 'DEMO-EQ-007', 5800.00, 'Freezer cofre 600L', 'Active', 1, DATE_SUB(NOW(), INTERVAL 150 DAY), -22.0, -20.0, -25.0, -18.0, 'Bodega Sur', 'Av. Pachacutec 2000', -12.21250000, -76.94250000, 1600.0, 'watts', 1450.0, @owner_id, 'Owner', 'Owned', 'Carnes', NOW(), NOW()),
(UUID(), 'Vitrina Refrigerada Theta', 'Refrigerator', 'VR-250', 'ShowCool', 'SN-DEMO-008', 'DEMO-EQ-008', 7200.00, 'Vitrina pastelería', 'Active', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 5.0, 5.0, 3.0, 7.0, 'Pastelería Dulce', 'Av. Larco 890', -12.12300000, -77.02800000, 1400.0, 'watts', 1300.0, @owner_id, 'Owner', 'Owned', 'Postres', NOW(), NOW()),
(UUID(), 'Mini Freezer Iota', 'Freezer', 'MF-100', 'CompactIce', 'SN-DEMO-009', 'DEMO-EQ-009', 1800.00, 'Mini freezer 100L', 'Active', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), -16.0, -15.0, -20.0, -12.0, 'Oficina Admin', 'Jr. Lampa 456', -12.04530000, -77.03110000, 450.0, 'watts', 400.0, @owner_id, 'Owner', 'Owned', 'Snacks', NOW(), NOW()),
(UUID(), 'Cámara Móvil Kappa', 'ColdRoom', 'CMM-500', 'MobileCold', 'SN-DEMO-010', 'DEMO-EQ-010', 35000.00, 'Contenedor móvil 10m³', 'Active', 1, DATE_SUB(NOW(), INTERVAL 240 DAY), 1.0, 2.0, -2.0, 4.0, 'Flota Transporte', 'Terminal Pesquero', -11.88330000, -77.11670000, 8500.0, 'watts', 7800.0, @owner_id, 'Owner', 'Owned', 'Perecibles', NOW(), NOW());

SELECT '10 equipos de Owner creados' as resultado;

-- =====================================================
-- PARTE 2: EQUIPOS PARA PROVIDER (Rental Marketplace)
-- =====================================================

INSERT INTO ositopolar_equipment.equipment
(equipment_identifier, name, type, model, manufacturer, serial_number, code, cost, technical_details, status, is_powered_on, installation_date, current_temperature, set_temperature, optimal_temperature_min, optimal_temperature_max, location_name, location_address, location_latitude, location_longitude, energy_consumption_current, energy_consumption_unit, energy_consumption_average, owner_id, owner_type, ownership_type, rental_monthly_fee, rental_provider_id, rental_start_date, rental_end_date, notes, created_at, updated_at)
VALUES
(UUID(), 'Freezer Compacto Alquiler', 'Freezer', 'FC-200', 'RentCool', 'SN-RENT-001', 'RENT-EQ-001', 3500.00, 'Freezer compacto bajo consumo', 'Active', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), -18.0, -18.0, -22.0, -15.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 1200.0, 'watts', 1100.0, @provider_id, 'Provider', 'Owned', 150.00, @provider_id, NULL, NULL, 'Alquiler inmediato', NOW(), NOW()),
(UUID(), 'Cámara Fría Express', 'ColdRoom', 'CFE-15', 'QuickCold', 'SN-RENT-002', 'RENT-EQ-002', 18000.00, 'Cámara modular 15m³ para eventos', 'Active', 1, DATE_SUB(NOW(), INTERVAL 90 DAY), 2.0, 2.0, 0.0, 5.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 4500.0, 'watts', 4200.0, @provider_id, 'Provider', 'Owned', 450.00, @provider_id, NULL, NULL, 'Eventos y catering', NOW(), NOW()),
(UUID(), 'Vitrina Exhibidora Premium', 'Refrigerator', 'VEP-300', 'ShowFresh', 'SN-RENT-003', 'RENT-EQ-003', 9500.00, 'Vitrina 3 niveles LED', 'Active', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 4.0, 4.0, 2.0, 6.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 1600.0, 'watts', 1500.0, @provider_id, 'Provider', 'Owned', 200.00, @provider_id, NULL, NULL, 'Tiendas y supermercados', NOW(), NOW()),
(UUID(), 'Freezer Industrial XL', 'Freezer', 'FI-1000', 'MegaFreeze', 'SN-RENT-004', 'RENT-EQ-004', 28000.00, 'Freezer 1000L enfriamiento rápido', 'Active', 1, DATE_SUB(NOW(), INTERVAL 120 DAY), -25.0, -22.0, -30.0, -18.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 6500.0, 'watts', 6000.0, @provider_id, 'Provider', 'Owned', 650.00, @provider_id, NULL, NULL, 'Gran capacidad', NOW(), NOW()),
(UUID(), 'Mini Cooler Portátil', 'Refrigerator', 'MCP-50', 'PortaCool', 'SN-RENT-005', 'RENT-EQ-005', 1200.00, 'Portátil 50L 12V/220V delivery', 'Active', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 5.0, 5.0, 2.0, 8.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 150.0, 'watts', 140.0, @provider_id, 'Provider', 'Owned', 80.00, @provider_id, NULL, NULL, 'Delivery móvil', NOW(), NOW()),
(UUID(), 'Cámara Congelación Pro', 'ColdRoom', 'CCP-30', 'ProFreeze', 'SN-RENT-006', 'RENT-EQ-006', 55000.00, 'Cámara pro 30m³ -40°C remoto', 'Active', 1, DATE_SUB(NOW(), INTERVAL 200 DAY), -32.0, -30.0, -40.0, -25.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 15000.0, 'watts', 14000.0, @provider_id, 'Provider', 'Owned', 950.00, @provider_id, NULL, NULL, 'Máxima congelación', NOW(), NOW()),
(UUID(), 'Refrigerador Farmacéutico', 'Refrigerator', 'RF-250', 'MediCool', 'SN-RENT-007', 'RENT-EQ-007', 12000.00, 'Certificado medicamentos 2-8°C', 'Active', 1, DATE_SUB(NOW(), INTERVAL 75 DAY), 4.0, 4.0, 2.0, 8.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 800.0, 'watts', 750.0, @provider_id, 'Provider', 'Owned', 350.00, @provider_id, NULL, NULL, 'Uso farmacéutico', NOW(), NOW()),
(UUID(), 'Freezer Exhibidor Helados', 'Freezer', 'FEH-400', 'IceCream Pro', 'SN-RENT-008', 'RENT-EQ-008', 7500.00, 'Exhibidor helados vidrio curvo', 'Active', 1, DATE_SUB(NOW(), INTERVAL 50 DAY), -22.0, -20.0, -25.0, -18.0, 'Depósito Alquileres', 'Av. Colonial 500, Lima', -12.05500000, -77.08000000, 2200.0, 'watts', 2000.0, @provider_id, 'Provider', 'Owned', 250.00, @provider_id, NULL, NULL, 'Heladerías', NOW(), NOW());

SELECT '8 equipos de Rental Marketplace creados' as resultado;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

SELECT '=== RESUMEN ===' as info;
SELECT owner_type, COUNT(*) as cantidad FROM ositopolar_equipment.equipment WHERE serial_number LIKE 'SN-DEMO-%' OR serial_number LIKE 'SN-RENT-%' GROUP BY owner_type;

SELECT 'Equipos en Rental Marketplace:' as info;
SELECT equipment_id, name, type, rental_monthly_fee as precio_mes FROM ositopolar_equipment.equipment WHERE owner_type = 'Provider' AND rental_monthly_fee IS NOT NULL AND rental_start_date IS NULL;

SELECT '=== COMPLETADO ===' as info;
