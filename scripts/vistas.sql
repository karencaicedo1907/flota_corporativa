-- 2. Vistas
-- Vista para obtener vehículos con próximos mantenimientos
CREATE VIEW vehiculos_proximo_mantenimiento AS
SELECT 
    v.id_vehiculo,              
    v.marca,                     
    v.placa,                    
    v.modelo,                    
    mp.fecha_programada,         
 para el mantenimiento
FROM vehiculos v
JOIN mantenimientos_programados mp ON v.id_vehiculo = mp.vehiculo_id  
WHERE mp.fecha_programada > CURRENT_DATE  
ORDER BY mp.fecha_programada;          
-- Ver los resultados de la vista "vehiculos_proximo_mantenimiento"
SELECT * FROM vehiculos_proximo_mantenimiento;


-- Vista para calcular el consumo medio de combustible por vehículo y ruta
CREATE VIEW consumo_medio_combustible AS
SELECT 
    rv.vehiculo_id,                      
    r.nombre AS ruta,                     
    AVG(rv.combustible_consumido) AS consumo_medio  
FROM registros_viaje rv
JOIN rutas r ON rv.ruta_id = r.id_ruta  
GROUP BY rv.vehiculo_id, r.nombre;      

-- Ver los resultados de la vista "consumo_medio_combustible"
SELECT * FROM consumo_medio_combustible;


-- Vista para obtener el historial de incidentes por conductor
CREATE VIEW historial_incidentes_conductor AS
SELECT 
    c.nombre AS conductor,     
    i.fecha,                   
    i.descripcion,            
    i.gravedad                 
FROM incidentes i
JOIN conductores c ON i.conductor_id = c.id_conductor  
ORDER BY i.fecha DESC;         

-- Ver los resultados de la vista "historial_incidentes_conductor"
SELECT * FROM historial_incidentes_conductor;


-- Vista para obtener la asignación actual de vehículos
CREATE VIEW asignacion_actual_vehiculos AS
SELECT 
    v.placa,c.nombre AS conductor,a.fecha_inicio,a.fecha_fin                  
FROM asignaciones_vehiculo a
JOIN vehiculos v ON a.vehiculo_id = v.id_vehiculo  
JOIN conductores c ON a.conductor_id = c.id_conductor  
WHERE a.fecha_fin IS NULL OR a.fecha_fin > CURRENT_DATE;  

-- Ver los resultados de la vista "asignacion_actual_vehiculos"
SELECT * FROM asignacion_actual_vehiculos;


-- Vista para obtener vehículos sin seguro vigente
CREATE VIEW vehiculos_sin_seguro_vigente AS
SELECT DISTINCT ON (v.id_vehiculo)  
    v.id_vehiculo,v.placa,s.nombre_compañia,p.fecha_inicio,p.fecha_fin                      
FROM vehiculos v
INNER JOIN polizas p ON v.id_vehiculo = p.vehiculo_id  
INNER JOIN seguros s ON p.seguro_id = s.id_seguro     
WHERE p.fecha_fin < CURRENT_DATE  
ORDER BY v.id_vehiculo, p.fecha_fin DESC; 

-- Ver los resultados de la vista "vehiculos_sin_seguro_vigente"
SELECT * FROM vehiculos_sin_seguro_vigente;
