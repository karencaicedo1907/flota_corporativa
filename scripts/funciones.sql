-- 5.Funciones
-- Vehículos
-- 1. Calcular kilómetros recorridos entre dos fechas
CREATE OR REPLACE FUNCTION calcular_km_recorridos(
    p_vehiculo_id INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS INT AS $$
DECLARE
    total_km INT;
BEGIN
    SELECT SUM(kilometros_recorridos)
    INTO total_km
    FROM registros_viaje
    WHERE vehiculo_id = p_vehiculo_id
      AND fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

    RETURN COALESCE(total_km, 0);
END;
$$ LANGUAGE plpgsql;

SELECT calcular_km_recorridos(1, '2024-01-01', '2024-12-31');

-- 2. Verificar si un vehículo tiene seguro vigente
CREATE OR REPLACE FUNCTION tiene_seguro_vigente(p_vehiculo_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    vigente BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM polizas
        WHERE vehiculo_id = p_vehiculo_id
          AND CURRENT_DATE BETWEEN fecha_inicio AND fecha_fin
    ) INTO vigente;

    RETURN vigente;
END;
$$ LANGUAGE plpgsql;

SELECT tiene_seguro_vigente(1);

-- Conductores
-- 1. Contar incidentes registrados por conductor
CREATE OR REPLACE FUNCTION contar_incidentes_conductor(p_conductor_id INT)
RETURNS INT AS $$
DECLARE
    total_incidentes INT;
BEGIN
    SELECT COUNT(*) INTO total_incidentes
    FROM incidentes
    WHERE conductor_id = p_conductor_id;

    RETURN total_incidentes;
END;
$$ LANGUAGE plpgsql;

SELECT contar_incidentes_conductor(2);

-- 2. Obtener última asignación de un conductor
CREATE OR REPLACE FUNCTION ultima_asignacion_conductor(p_conductor_id INT)
RETURNS TABLE (
    vehiculo_id INT,
    fecha_inicio DATE,
    fecha_fin DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT a.vehiculo_id, a.fecha_inicio, a.fecha_fin
    FROM asignaciones_vehiculo a
    WHERE a.conductor_id = p_conductor_id
    ORDER BY a.fecha_inicio DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM ultima_asignacion_conductor(2);


-- MantenimientosRealizados
-- 1. Obtener fecha del último mantenimiento
CREATE OR REPLACE FUNCTION ultimo_mantenimiento(p_vehiculo_id INT)
RETURNS DATE AS $$
DECLARE
    fecha_ultima DATE;
BEGIN
    SELECT MAX(fecha) INTO fecha_ultima
    FROM mantenimientos_realizados
    WHERE vehiculo_id = p_vehiculo_id;

    RETURN fecha_ultima;
END;
$$ LANGUAGE plpgsql;

SELECT ultimo_mantenimiento(1);

-- 2. Contar mantenimientos realizados por tipo
CREATE OR REPLACE FUNCTION contar_mantenimientos_por_tipo(p_tipo VARCHAR)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM mantenimientos_realizados mr
    JOIN tipos_mantenimiento tm ON mr.tipo_mantenimiento_id = tm.id_mantenimiento
    WHERE tm.nombre = p_tipo;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT contar_mantenimientos_por_tipo('Cambio de aceite');


-- RegistrosViaje
-- 1. Calcular consumo total de combustible por vehículo
CREATE OR REPLACE FUNCTION total_combustible(p_vehiculo_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(combustible_consumido) INTO total
    FROM registros_viaje
    WHERE vehiculo_id = p_vehiculo_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

SELECT total_combustible(2);

-- 2. Obtener la ruta más recorrida por un vehículo
CREATE OR REPLACE FUNCTION ruta_mas_recorrida(p_vehiculo_id INT)
RETURNS TEXT AS $$
DECLARE
    nombre_ruta TEXT;
BEGIN
    SELECT r.nombre
    INTO nombre_ruta
    FROM registros_viaje rv
    JOIN rutas r ON rv.ruta_id = r.id_ruta
    WHERE rv.vehiculo_id = p_vehiculo_id
    GROUP BY r.nombre
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    RETURN nombre_ruta;
END;
$$ LANGUAGE plpgsql;

SELECT ruta_mas_recorrida(3);


