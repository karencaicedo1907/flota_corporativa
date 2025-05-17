-- 3. Stored Procedures
--insertar eliminar y actualizar un vehiculo--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////7--
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

--insertar eliminar y actualizar un conductor--
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////--
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

--insertar eliminar y actualizar un registro del viaje--
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
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
CALL insertar_registro_viaje(1, 3, '2024-11-01', 180, 12.5, 'Viaje sin novedades');
CALL actualizar_registro_viaje(16, 1, 3, '2024-11-05', 150, 14.0, 'Se presentó lluvia');
CALL eliminar_registro_viaje(16);
SELECT *FROM registros_viaje;

