-- 7. Optimización: Uso de CTEs

-- Ejemplo 1: CTE para calcular kilometraje total por vehículo y mostrar solo los que han recorrido más de 300 km
WITH kilometraje_por_vehiculo AS (
    SELECT
        v.id_vehiculo,
        v.placa,
        SUM(rv.kilometros_recorridos) AS total_km
    FROM vehiculos v
    INNER JOIN registros_viaje rv ON v.id_vehiculo = rv.vehiculo_id
    GROUP BY v.id_vehiculo, v.placa
)
SELECT *
FROM kilometraje_por_vehiculo
WHERE total_km > 300;



-- Ejemplo 2: CTE para ver los mantenimientos realizados con costo mayor al promedio de todos los mantenimientos
WITH promedio_costos AS (
    SELECT AVG(costo) AS costo_promedio
    FROM mantenimientos_realizados
),
mantenimientos_costosos AS (
    SELECT *
    FROM mantenimientos_realizados
    WHERE costo > (SELECT costo_promedio FROM promedio_costos)
)
SELECT * FROM mantenimientos_costosos;
