-- 1. Indexación
-- Índice para buscar vehículos por conductor
CREATE INDEX idx_conductor_vehiculo ON asignaciones_vehiculo(conductor_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'asignaciones_vehiculo';


-- Índice para buscar vehículos por departamento
CREATE INDEX idx_departamento_vehiculo ON vehiculos(departamento_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'vehiculos';


-- Índice para obtener mantenimientos pendientes
CREATE INDEX idx_mantenimiento_pendiente ON mantenimientos_programados(vehiculo_id, estado);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'mantenimientos_programados';


-- Índice para historial de viajes por vehículo
CREATE INDEX idx_viaje_vehiculo ON registros_viaje(vehiculo_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'registros_viaje';