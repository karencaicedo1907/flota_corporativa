-- 6. Consultas
--1. Vehículos
SELECT v.placa, d.nombre AS departamento
FROM vehiculos v
INNER JOIN departamentos d ON v.departamento_id = d.id_departamento;

SELECT v.placa, p.numero_poliza
FROM vehiculos v
LEFT JOIN polizas p ON v.id_vehiculo = p.vehiculo_id;

SELECT placa, (SELECT COUNT(*) FROM registros_viaje rv WHERE rv.vehiculo_id = v.id_vehiculo) AS total_viajes
FROM vehiculos v;

SELECT placa, kilometraje_total
FROM vehiculos
WHERE kilometraje_total > (
    SELECT AVG(kilometraje_total) FROM vehiculos
);

--2. Conductores
SELECT c.nombre, a.fecha_inicio
FROM conductores c
INNER JOIN asignaciones_vehiculo a ON c.id_conductor = a.conductor_id
SELECT c.nombre, m.valor
FROM multas m
RIGHT JOIN conductores c ON m.conductor_id = c.id_conductor;
SELECT nombre, (SELECT COUNT(*) FROM incidentes i WHERE i.conductor_id = c.id_conductor) AS total_incidentes
FROM conductores c;
SELECT nombre
FROM conductores
WHERE id_conductor IN (
    SELECT DISTINCT conductor_id FROM multas WHERE pagada = false
);


--3.asignaciones_vehiculo
SELECT c.nombre, v.placa, a.fecha_inicio
FROM asignaciones_vehiculo a
INNER JOIN conductores c ON a.conductor_id = c.id_conductor
INNER JOIN vehiculos v ON a.vehiculo_id = v.id_vehiculo;
SELECT v.placa, a.fecha_fin
FROM vehiculos v
LEFT JOIN asignaciones_vehiculo a ON v.id_vehiculo = a.vehiculo_id;
SELECT conductor_id, (SELECT COUNT(*) FROM asignaciones_vehiculo a2 WHERE a2.conductor_id = a1.conductor_id) AS cantidad_asignaciones
FROM asignaciones_vehiculo a1
GROUP BY conductor_id;
SELECT vehiculo_id
FROM asignaciones_vehiculo
WHERE fecha_fin IS NULL AND vehiculo_id IN (
    SELECT id_vehiculo FROM vehiculos WHERE tipo = 'Camioneta'
);
--4.registros_viaje
SELECT v.placa, r.nombre AS ruta, rv.kilometros_recorridos
FROM registros_viaje rv
INNER JOIN vehiculos v ON rv.vehiculo_id = v.id_vehiculo
INNER JOIN rutas r ON rv.ruta_id = r.id_ruta;
SELECT v.placa, rv.combustible_consumido
FROM vehiculos v
LEFT JOIN registros_viaje rv ON v.id_vehiculo = rv.vehiculo_id;
SELECT vehiculo_id, 
       (SELECT AVG(kilometros_recorridos) FROM registros_viaje WHERE vehiculo_id = rv.vehiculo_id) AS promedio_km
FROM registros_viaje rv
GROUP BY vehiculo_id;
SELECT fecha, kilometros_recorridos
FROM registros_viaje
WHERE kilometros_recorridos > (
    SELECT MAX(kilometros_recorridos) FROM registros_viaje WHERE fecha < '2024-01-10'
);
select * from registros_viaje;
--5. mantenimientos_realizados
SELECT v.placa, t.nombre AS tipo_mantenimiento, m.fecha, m.costo
FROM mantenimientos_realizados m
INNER JOIN vehiculos v ON m.vehiculo_id = v.id_vehiculo
INNER JOIN tipos_mantenimiento t ON m.tipo_mantenimiento_id = t.id_mantenimiento;

SELECT v.placa, m.descripcion
FROM vehiculos v
LEFT JOIN mantenimientos_realizados m ON v.id_vehiculo = m.vehiculo_id;

SELECT vehiculo_id, 
       (SELECT SUM(costo) FROM mantenimientos_realizados WHERE vehiculo_id = m.vehiculo_id) AS total_gastado
FROM mantenimientos_realizados m
GROUP BY vehiculo_id;

SELECT descripcion
FROM mantenimientos_realizados
WHERE costo = (
    SELECT MAX(costo) FROM mantenimientos_realizados
);

--6.incidentes
SELECT c.nombre, v.placa, i.descripcion, i.gravedad
FROM incidentes i
INNER JOIN conductores c ON i.conductor_id = c.id_conductor
INNER JOIN vehiculos v ON i.vehiculo_id = v.id_vehiculo;

SELECT v.placa, i.gravedad
FROM vehiculos v
LEFT JOIN incidentes i ON v.id_vehiculo = i.vehiculo_id;

SELECT vehiculo_id, COUNT(*) AS total_incidentes
FROM incidentes
GROUP BY vehiculo_id
HAVING COUNT(*) > (
    SELECT AVG(total) FROM (
        SELECT COUNT(*) AS total FROM incidentes GROUP BY vehiculo_id
    ) AS promedio_incidentes
);

SELECT descripcion
FROM incidentes
WHERE gravedad = (
    SELECT gravedad FROM incidentes GROUP BY gravedad ORDER BY COUNT(*) DESC LIMIT 1
);
