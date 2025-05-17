# Sistema de Seguimiento de Flotas de Vehículos Corporativos

## creamos las 15 entidades:

-  departamentos:
```
CREATE TABLE departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
    estado boolean
);
```
- seguros :
```
CREATE TABLE seguros (
    id_seguro SERIAL PRIMARY KEY,
    nombre_compañia VARCHAR(100),
    tipo_seguro VARCHAR(50)
        estado boolean
);
```
- tipos_mantenimiento:
```
CREATE TABLE tipos_mantenimiento (
    id_mantenimiento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
    estado boolean

);
```
- rutas:
```
CREATE TABLE rutas (
    id_ruta SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    origen VARCHAR(100),
    destino VARCHAR(100),
    distancia_km DECIMAL(6,2)
    estado boolean

);
```
- vehiculos:
```
CREATE TABLE vehiculos (
    id_vehiculo SERIAL PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    tipo VARCHAR(30),
    anio INTEGER,
    kilometraje_total INTEGER DEFAULT 0,
    departamento_id INTEGER REFERENCES departamentos(id_departamento)
    estado boolean

);
```
- conductores:
```
CREATE TABLE conductores (
    id_conductor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(20) UNIQUE NOT NULL,
    licencia_conduccion VARCHAR(50),
    telefono VARCHAR(20),
    correo VARCHAR(100) 
    estado boolean

);
```
- asignaciones_vehiculo:
```
CREATE TABLE asignaciones_vehiculo (
    id_asignacion_vehiculo SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    conductor_id INT REFERENCES conductores(id_conductor),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE
    estado boolean

);
```
- polizas:
```
CREATE TABLE polizas (
    id_poliza SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    seguro_id INT REFERENCES seguros(id_seguro),
    numero_poliza VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE,
    valor DECIMAL(10,2)
    estado boolean

);
```
- registros_viaje:
```
CREATE TABLE registros_viaje (
    id_registro_viaje SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    ruta_id INT REFERENCES rutas(id_ruta),
    fecha DATE,
    kilometros_recorridos INT,
    combustible_consumido DECIMAL(5,2),
    observaciones TEXT
    estado boolean

);
```
- mantenimientos_programados:
```
CREATE TABLE mantenimientos_programados (
    id_programado SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    tipo_mantenimiento_id INT REFERENCES tipos_mantenimiento(id_mantenimiento),
    fecha_programada DATE,
    kilometraje_programado INT,
    estado VARCHAR(20)
    estado boolean

);
```
- mantenimientos_realizados:
```
CREATE TABLE mantenimientos_realizados (
    id_realizados SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    tipo_mantenimiento_id INT REFERENCES tipos_mantenimiento(id_mantenimiento),
    fecha DATE,
    costo DECIMAL(10,2),
    descripcion TEXT
    estado boolean

);
```
- incidentes:
```
CREATE TABLE incidentes (
    id_incidente SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    conductor_id INT REFERENCES conductores(id_conductor),
    fecha DATE,
    descripcion TEXT,
    gravedad VARCHAR(50)
    estado boolean

);

```
- multas:
```
CREATE TABLE multas (
    id_multa SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    conductor_id INT REFERENCES conductores(id_conductor),
    fecha DATE,
    motivo TEXT,
    valor DECIMAL(10,2),
    pagada BOOLEAN DEFAULT FALSE
    estado boolean

);
```
- auditoria_general:
```
CREATE TABLE auditoria_general (
    id SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(100),
    id_referencia INT,
    usuario VARCHAR(100),
    operacion VARCHAR(10),
    fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    campo_1_nombre VARCHAR(100),
    campo_1_valor_viejo TEXT,
    campo_1_valor_nuevo TEXT,
    campo_2_nombre VARCHAR(100),
    campo_2_valor_viejo TEXT,
    campo_2_valor_nuevo TEXT,
    observaciones TEXT
    estado boolean
);

```
- talleres_mecanicos:
```
CREATE TABLE talleres_mecanicos (
    id_taller SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    ciudad VARCHAR(100)
);
```

### despues de crear las entidades y despues de insertar datos con este codigo:

```
INSERT INTO table ()VALUES();
```
## indexacion
### Índice para buscar vehículos por conductor
```
CREATE INDEX idx_conductor_vehiculo ON asignaciones_vehiculo(conductor_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'asignaciones_vehiculo';
```
### Índice para buscar vehículos por departamento
```
CREATE INDEX idx_departamento_vehiculo ON vehiculos(departamento_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'vehiculos';
```
### Índice para obtener mantenimientos pendientes
```
CREATE INDEX idx_mantenimiento_pendiente ON mantenimientos_programados(vehiculo_id, estado);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'mantenimientos_programados';
```

### Índice para historial de viajes por vehículo
```
CREATE INDEX idx_viaje_vehiculo ON registros_viaje(vehiculo_id);
SELECT * 
FROM pg_indexes 
WHERE tablename = 'registros_viaje';
```


## vistas
### Vista para obtener vehículos con próximos mantenimientos

```
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
```
#### Ver los resultados de la vista "vehiculos_proximo_mantenimiento"
```
SELECT * FROM vehiculos_proximo_mantenimiento;

```

### Vista para calcular el consumo medio de combustible por vehículo y ruta
```
CREATE VIEW consumo_medio_combustible AS
SELECT 
    rv.vehiculo_id,                      
    r.nombre AS ruta,                     
    AVG(rv.combustible_consumido) AS consumo_medio  
FROM registros_viaje rv
JOIN rutas r ON rv.ruta_id = r.id_ruta  
GROUP BY rv.vehiculo_id, r.nombre;  
```
#### Ver los resultados de la vista "consumo_medio_combustible"

```
SELECT * FROM consumo_medio_combustible;

```

### Vista para obtener el historial de incidentes por conductor
```
CREATE VIEW historial_incidentes_conductor AS
SELECT 
    c.nombre AS conductor,     
    i.fecha,                   
    i.descripcion,            
    i.gravedad                 
FROM incidentes i
JOIN conductores c ON i.conductor_id = c.id_conductor  
ORDER BY i.fecha DESC; 
```
#### Ver los resultados de la vista "historial_incidentes_conductor"

```
SELECT * FROM historial_incidentes_conductor;

```
### Ver los resultados de la vista "historial_incidentes_conductor"
```
CREATE VIEW asignacion_actual_vehiculos AS
SELECT 
    v.placa,c.nombre AS conductor,a.fecha_inicio,a.fecha_fin                  
FROM asignaciones_vehiculo a
JOIN vehiculos v ON a.vehiculo_id = v.id_vehiculo  
JOIN conductores c ON a.conductor_id = c.id_conductor  
WHERE a.fecha_fin IS NULL OR a.fecha_fin > CURRENT_DATE; 
```
#### Ver los resultados de la vista "asignacion_actual_vehiculos"

```
SELECT * FROM asignacion_actual_vehiculos;

```
### Vista para obtener vehículos sin seguro vigente
```
CREATE VIEW vehiculos_sin_seguro_vigente AS
SELECT DISTINCT ON (v.id_vehiculo)  
    v.id_vehiculo,v.placa,s.nombre_compañia,p.fecha_inicio,p.fecha_fin                      
FROM vehiculos v
INNER JOIN polizas p ON v.id_vehiculo = p.vehiculo_id  
INNER JOIN seguros s ON p.seguro_id = s.id_seguro     
WHERE p.fecha_fin < CURRENT_DATE  
ORDER BY v.id_vehiculo, p.fecha_fin DESC; 
```
#### Ver los resultados de la vista "vehiculos_sin_seguro_vigente"

```
SELECT * FROM vehiculos_sin_seguro_vigente;

```

## stored procedures
## insertar eliminar y actualizar un vehiculo

```
CREATE OR REPLACE PROCEDURE insertar_vehiculo(
    p_placa VARCHAR,
    p_marca VARCHAR,
    p_modelo VARCHAR,
    p_tipo VARCHAR,
    p_anio INTEGER,
    p_kilometraje_total INTEGER,
    p_departamento_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO vehiculos (placa, marca, modelo, tipo, anio, kilometraje_total, departamento_id)
    VALUES (p_placa, p_marca, p_modelo, p_tipo, p_anio, p_kilometraje_total, p_departamento_id);

    COMMIT;
    RAISE NOTICE 'Vehículo insertado correctamente';
END;
$$;
CALL insertar_vehiculo('XYZ121', 'Kia', 'Sportage', 'SUV', 2022, 35000, 2);
SELECT pg_get_functiondef(oid)
FROM pg_proc
WHERE proname = 'insertar_vehiculo';
```

```
CREATE OR REPLACE PROCEDURE actualizar_vehiculo(
    p_id INTEGER,
    p_placa VARCHAR,
    p_marca VARCHAR,
    p_modelo VARCHAR,
    p_tipo VARCHAR,
    p_anio INTEGER,
    p_kilometraje_total INTEGER,
    p_departamento_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    vehiculo_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM vehiculos WHERE id_vehiculo = p_id) INTO vehiculo_existe;

    IF vehiculo_existe THEN
        UPDATE vehiculos SET
            placa = p_placa,
            marca = p_marca,
            modelo = p_modelo,
            tipo = p_tipo,
            anio = p_anio,
            kilometraje_total = p_kilometraje_total,
            departamento_id = p_departamento_id
        WHERE id_vehiculo = p_id;

        COMMIT;
        RAISE NOTICE 'Vehículo con ID % actualizado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El vehículo con ID % no existe', p_id;
    END IF;
END;
$$;
```
```
CREATE OR REPLACE PROCEDURE eliminar_vehiculo(
    p_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    vehiculo_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM vehiculos WHERE id_vehiculo = p_id) INTO vehiculo_existe;

    IF vehiculo_existe THEN
        DELETE FROM vehiculos WHERE id_vehiculo = p_id;

        COMMIT;
        RAISE NOTICE 'Vehículo con ID % eliminado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El vehículo con ID % no existe', p_id;
    END IF;
END;
$$;
CALL insertar_vehiculo('XYZ122', 'Kia', 'Sportage', 'SUV', 2022, 35000, 2);
CALL actualizar_vehiculo(20,'XYZ122', 'Kia', 'Sportage', 'SUV', 2023, 35000, 2);
CALL eliminar_vehiculo(20);
SELECT *FROM vehiculos;
```

## insertar eliminar y actualizar un conductor
```
CREATE OR REPLACE PROCEDURE insertar_conductor(
    p_nombre VARCHAR,
    p_cedula VARCHAR,
    p_licencia_conduccion VARCHAR,
    p_telefono VARCHAR,
    p_correo VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO conductores (nombre, cedula, licencia_conduccion, telefono, correo)
    VALUES (p_nombre, p_cedula, p_licencia_conduccion, p_telefono, p_correo);

    COMMIT;
    RAISE NOTICE 'Conductor insertado correctamente';
END;
$$;
CREATE OR REPLACE PROCEDURE actualizar_conductor(
    p_id INTEGER,
    p_nombre VARCHAR,
    p_cedula VARCHAR,
    p_licencia_conduccion VARCHAR,
    p_telefono VARCHAR,
    p_correo VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    conductor_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM conductores WHERE id_conductor = p_id) INTO conductor_existe;

    IF conductor_existe THEN
        UPDATE conductores SET
            nombre = p_nombre,
            cedula = p_cedula,
            licencia_conduccion = p_licencia_conduccion,
            telefono = p_telefono,
            correo = p_correo
        WHERE id_conductor = p_id;

        COMMIT;
        RAISE NOTICE 'Conductor con ID % actualizado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El conductor con ID % no existe', p_id;
    END IF;
END;
$$;
```
```
CREATE OR REPLACE PROCEDURE eliminar_conductor(
    p_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    conductor_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM conductores WHERE id_conductor = p_id) INTO conductor_existe;

    IF conductor_existe THEN
        DELETE FROM conductores WHERE id_conductor = p_id;

        COMMIT;
        RAISE NOTICE 'Conductor con ID % eliminado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El conductor con ID % no existe', p_id;
    END IF;
END;
$$;
CALL insertar_conductor('Juan Pérez', '123456789', 'LIC-45678', '3123456789', 'juan@example.com');
CALL actualizar_conductor(16, 'Juan P. Obregon', '123456789', 'LIC-45678', '3123456789', 'juanpg@example.com');
CALL eliminar_conductor(16);
SELECT * FROM conductores;
```
```
--insertar eliminar y actualizar un mantenimiento--
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////77--
CREATE OR REPLACE PROCEDURE insertar_mantenimiento(
    p_vehiculo_id INT,
    p_tipo_mantenimiento_id INT,
    p_fecha DATE,
    p_costo DECIMAL,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO mantenimientos_realizados (vehiculo_id, tipo_mantenimiento_id, fecha, costo, descripcion)
    VALUES (p_vehiculo_id, p_tipo_mantenimiento_id, p_fecha, p_costo, p_descripcion);

    COMMIT;
    RAISE NOTICE 'Mantenimiento registrado correctamente';
END;
$$;
CREATE OR REPLACE PROCEDURE actualizar_mantenimiento(
    p_id INTEGER,
    p_vehiculo_id INTEGER,
    p_tipo_mantenimiento_id INTEGER,
    p_fecha DATE,
    p_costo DECIMAL,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    mantenimiento_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM mantenimientos_realizados WHERE id_realizados = p_id)
    INTO mantenimiento_existe;

    IF mantenimiento_existe THEN
        UPDATE mantenimientos_realizados SET
            vehiculo_id = p_vehiculo_id,
            tipo_mantenimiento_id = p_tipo_mantenimiento_id,
            fecha = p_fecha,
            costo = p_costo,
            descripcion = p_descripcion
        WHERE id_realizados = p_id;

        COMMIT;
        RAISE NOTICE 'Mantenimiento con ID % actualizado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El mantenimiento con ID % no existe', p_id;
    END IF;
END;
$$;
```
```
CREATE OR REPLACE PROCEDURE eliminar_mantenimiento(
    p_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    mantenimiento_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM mantenimientos_realizados WHERE id_realizados = p_id)
    INTO mantenimiento_existe;

    IF mantenimiento_existe THEN
        DELETE FROM mantenimientos_realizados WHERE id_realizados = p_id;

        COMMIT;
        RAISE NOTICE 'Mantenimiento con ID % eliminado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El mantenimiento con ID % no existe', p_id;
    END IF;
END;
$$;
CALL insertar_mantenimiento(1, 2, '2024-10-15', 350000.00, 'Cambio de aceite y filtros');
CALL actualizar_mantenimiento(16, 1, 2, '2024-10-21', 4000.00, 'Mantenimiento ofensivo');
CALL eliminar_mantenimiento(16);
SELECT *FROM mantenimientos_realizados;
```

## insertar eliminar y actualizar un registro del viaje
```
CREATE OR REPLACE PROCEDURE insertar_registro_viaje(
    p_vehiculo_id INT,
    p_ruta_id INT,
    p_fecha DATE,
    p_kilometros_recorridos INT,
    p_combustible_consumido DECIMAL,
    p_observaciones TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO registros_viaje (vehiculo_id, ruta_id, fecha, kilometros_recorridos, combustible_consumido, observaciones)
    VALUES (p_vehiculo_id, p_ruta_id, p_fecha, p_kilometros_recorridos, p_combustible_consumido, p_observaciones);

    COMMIT;
    RAISE NOTICE 'Registro de viaje insertado correctamente';
END;
$$;
```
```
CREATE OR REPLACE PROCEDURE actualizar_registro_viaje(
    p_id INTEGER,
    p_vehiculo_id INTEGER,
    p_ruta_id INTEGER,
    p_fecha DATE,
    p_kilometros_recorridos INTEGER,
    p_combustible_consumido DECIMAL,
    p_observaciones TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    registro_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM registros_viaje WHERE id_registro_viaje = p_id)
    INTO registro_existe;

    IF registro_existe THEN
        UPDATE registros_viaje SET
            vehiculo_id = p_vehiculo_id,
            ruta_id = p_ruta_id,
            fecha = p_fecha,
            kilometros_recorridos = p_kilometros_recorridos,
            combustible_consumido = p_combustible_consumido,
            observaciones = p_observaciones
        WHERE id_registro_viaje = p_id;

        COMMIT;
        RAISE NOTICE 'Registro de viaje con ID % actualizado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El registro de viaje con ID % no existe', p_id;
    END IF;
END;
$$;
```
```
CREATE OR REPLACE PROCEDURE eliminar_registro_viaje(
    p_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    registro_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM registros_viaje WHERE id_registro_viaje = p_id)
    INTO registro_existe;

    IF registro_existe THEN
        DELETE FROM registros_viaje WHERE id_registro_viaje = p_id;

        COMMIT;
        RAISE NOTICE 'Registro de viaje con ID % eliminado correctamente', p_id;
    ELSE
        RAISE EXCEPTION 'El registro de viaje con ID % no existe', p_id;
    END IF;
END;
$$;
```
## para llamarlos:
```
CALL insertar_registro_viaje(1, 3, '2024-11-01', 180, 12.5, 'Viaje sin novedades');
```
```
CALL actualizar_registro_viaje(16, 1, 3, '2024-11-05', 150, 14.0, 'Se presentó lluvia');
```
```
CALL eliminar_registro_viaje(16);
SELECT *FROM registros_viaje;
```

## triggers
### crear funcion de mantenimientos:
```
CREATE OR REPLACE FUNCTION fn_auditoria_mantenimientos() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'mantenimientos_programados', NEW.id_programado, current_user, 'INSERT',
            'fecha_programada', NULL, NEW.fecha_programada::TEXT,
            'estado', NULL, NEW.estado);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'mantenimientos_programados', NEW.id_programado, current_user, 'UPDATE',
            'fecha_programada', OLD.fecha_programada::TEXT, NEW.fecha_programada::TEXT,
            'estado', OLD.estado, NEW.estado);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'mantenimientos_programados', OLD.id_programado, current_user, 'DELETE',
            'fecha_programada', OLD.fecha_programada::TEXT, NULL,
            'estado', OLD.estado, NULL);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```
## crear trigger para mantenimintos_programados:
```
CREATE TRIGGER tr_auditoria_mantenimientos
AFTER INSERT OR UPDATE OR DELETE ON mantenimientos_programados
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_mantenimientos();
```
## crear funcion para multas: 
```
CREATE OR REPLACE FUNCTION fn_auditoria_multas() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'multas', NEW.id_multa, current_user, 'INSERT',
            'motivo', NULL, NEW.motivo,
            'valor', NULL, NEW.valor::TEXT);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'multas', NEW.id_multa, current_user, 'UPDATE',
            'motivo', OLD.motivo, NEW.motivo,
            'valor', OLD.valor::TEXT, NEW.valor::TEXT);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_general (
            tabla_afectada, id_referencia, usuario, operacion,
            campo_1_nombre, campo_1_valor_viejo, campo_1_valor_nuevo,
            campo_2_nombre, campo_2_valor_viejo, campo_2_valor_nuevo)
        VALUES (
            'multas', OLD.id_multa, current_user, 'DELETE',
            'motivo', OLD.motivo, NULL,
            'valor', OLD.valor::TEXT, NULL);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```
## crear trigger de multas:
```
CREATE TRIGGER tr_auditoria_multas
AFTER INSERT OR UPDATE OR DELETE ON multas
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_multas();
```
### para llamar
```
SELECT *FROM registros_viaje;
SELECT *FROM mantenimientos_programados;
SELECT *FROM multas;
SELECT * FROM auditoria_general;


INSERT INTO registros_viaje (vehiculo_id, ruta_id, fecha, kilometros_recorridos, combustible_consumido, observaciones)
VALUES (3, 2, '2025-04-30', 140, 13.5, 'Viaje programado a acevedo');
UPDATE registros_viaje
SET kilometros_recorridos = 1000, observaciones = 'Ajuste por GPS'
WHERE id_registro_viaje = 11;
DELETE FROM registros_viaje WHERE id_registro_viaje = 9;

INSERT INTO mantenimientos_programados (vehiculo_id, tipo_mantenimiento_id, fecha_programada, kilometraje_programado, estado)
VALUES (5, 2, '2025-05-10', 50000, 'Pendiente');
UPDATE mantenimientos_programados
SET estado = 'Realizado'
WHERE id_programado = 11;
DELETE FROM mantenimientos_programados WHERE id_programado = 7;

INSERT INTO multas (vehiculo_id, conductor_id, fecha, motivo, valor, pagada)
VALUES (1, 4, '2025-04-25', 'Exceso de velocidad', 200000, FALSE);
UPDATE multas
SET valor = 10000
WHERE id_multa = 11;
DELETE FROM multas WHERE id_multa =9;

SELECT * FROM multas;
SELECT*FROM mantenimientos_programados;
SELECT * FROM registros_viaje
SELECT * FROM auditoria_general;
truncate table auditoria_general;
```
## funciones
### vehiculos:
```
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
```
### llamado:
```
SELECT calcular_km_recorridos(1, '2024-01-01', '2024-12-31');
```

## 2. Verificar si un vehículo tiene seguro vigente
```
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
```
### llamado
```
SELECT tiene_seguro_vigente(1);
```

## Conductores
### 1. Contar incidentes registrados por conductor
```
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
```

###  2. Obtener última asignación de un conductor
```
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
```
### llamado
```
SELECT * FROM ultima_asignacion_conductor(2);
```

## MantenimientosRealizados

### 1. Obtener fecha del último mantenimiento
```
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
```
###  2. Contar mantenimientos realizados por tipo
```
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
```
### llamado
```
SELECT contar_mantenimientos_por_tipo('Cambio de aceite');
```

## RegistrosViaje
### 1. Calcular consumo total de combustible por vehículo
```
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
```
### llamada
```
SELECT total_combustible(2);
```

### 2. Obtener la ruta más recorrida por un vehículo
```
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
```
### llamado
```
SELECT ruta_mas_recorrida(3);

```
## consultas
### 1. Vehículos
```
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
```
### 2. Conductores
```
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
```
### 3.asignaciones_vehiculo
```
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
```

### 4.registros_viaje
```
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
```

### 5. mantenimientos_realizados
```
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
```
### 6.incidentes
```
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
```
#### llamado
```
SELECT descripcion
FROM incidentes
WHERE gravedad = (
    SELECT gravedad FROM incidentes GROUP BY gravedad ORDER BY COUNT(*) DESC LIMIT 1
);

```
## cte
### Ejemplo 1: CTE para calcular kilometraje total por vehículo y mostrar solo los que han recorrido más de 300 km
```
WITH kilometraje_por_vehiculo AS (
    SELECT
        v.id_vehiculo,
        v.placa,
        SUM(rv.kilometros_recorridos) AS total_km
    FROM vehiculos v
    INNER JOIN registros_viaje rv ON v.id_vehiculo = rv.vehiculo_id
    GROUP BY v.id_vehiculo, v.placa
)
```
### llamado
```
SELECT *
FROM kilometraje_por_vehiculo
WHERE total_km > 300;
```


### Ejemplo 2: CTE para ver los mantenimientos realizados con costo mayor al promedio de todos los mantenimientos
```
WITH promedio_costos AS (
    SELECT AVG(costo) AS costo_promedio
    FROM mantenimientos_realizados
),
mantenimientos_costosos AS (
    SELECT *
    FROM mantenimientos_realizados
    WHERE costo > (SELECT costo_promedio FROM promedio_costos)
)
```
### llamado
```
SELECT * FROM mantenimientos_costosos;

```
## seguridad
## crear roles:
```
CREATE ROLE admin_role;
CREATE ROLE conductor_role;
CREATE ROLE gestor_flota_role;
CREATE ROLE mecanico_role;
CREATE ROLE cliente_role;
```
## crear usuarios:
```
CREATE USER admin WITH PASSWORD 'admin123';
GRANT admin_role TO admin;

CREATE USER conductor WITH PASSWORD 'conductor123';
GRANT conductor_role TO conductor;

CREATE USER gestor_flota WITH PASSWORD 'gestor_flota123';
GRANT gestor_flota_role TO gestor_flota;

CREATE USER mecanico WITH PASSWORD 'mecanico123';
GRANT mecanico_role TO mecanico;

CREATE USER cliente WITH PASSWORD 'cliente123';
GRANT cliente_role TO cliente;
```

## PERMISOS POR ROL

```
GRANT CONNECT ON DATABASE flota_corporativa TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

GRANT CONNECT ON DATABASE flota_corporativa TO conductor_role;
GRANT SELECT, INSERT, UPDATE ON registros_viaje, incidentes TO conductor_role;
GRANT SELECT ON vehiculos TO conductor_role;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE registros_viaje_id_registro_viaje_seq, incidentes_id_incidente_seq TO conductor_role;

GRANT CONNECT ON DATABASE flota_corporativa TO mecanico_role;
GRANT SELECT ON mantenimientos_programados TO mecanico_role;
GRANT INSERT,UPDATE,SELECT ON tipos_mantenimiento,mantenimientos_realizados TO mecanico_role;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE tipos_mantenimiento_id_mantenimiento_seq TO mecanico_role;

GRANT CONNECT ON DATABASE flota_corporativa TO  gestor_flota_role;
GRANT SELECT, INSERT, UPDATE ON vehiculos, rutas, mantenimientos_programados, departamentos, polizas, multas, seguros, conductores, auditoria_general TO  gestor_flota_role;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE vehiculos_id_vehiculo_seq,rutas_id_ruta_seq,polizas_id_poliza_seq,multas_id_multa_seq,seguros_id_seguro_seq,conductores_id_conductor_seq, 
auditoria_general_id_seq TO  gestor_flota_role;

GRANT CONNECT ON DATABASE flota_corporativa TO cliente_role;
GRANT SELECT ON departamentos TO cliente_role;
GRANT USAGE, SELECT ON SEQUENCE departamentos_id_departamento_seq TO cliente_role;

-- Ver todos los roles del sistema
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles;

SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public';
```










