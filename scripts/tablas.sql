-- departametos:
CREATE TABLE departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
    estado boolean
);

--seguros :

CREATE TABLE seguros (
    id_seguro SERIAL PRIMARY KEY,
    nombre_compañia VARCHAR(100),
    tipo_seguro VARCHAR(50)
        estado boolean
);

--tipos_mantenimiento:
CREATE TABLE tipos_mantenimiento (
    id_mantenimiento SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT
    estado boolean

);

--rutas:
CREATE TABLE rutas (
    id_ruta SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    origen VARCHAR(100),
    destino VARCHAR(100),
    distancia_km DECIMAL(6,2)
    estado boolean

);
--vehiculos:
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
--conductores:
CREATE TABLE conductores (
    id_conductor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(20) UNIQUE NOT NULL,
    licencia_conduccion VARCHAR(50),
    telefono VARCHAR(20),
    correo VARCHAR(100) 
    estado boolean

);
--asignaciones_vehiculo:
CREATE TABLE asignaciones_vehiculo (
    id_asignacion_vehiculo SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    conductor_id INT REFERENCES conductores(id_conductor),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE
    estado boolean

);
--polizas:
}CREATE TABLE polizas (
    id_poliza SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    seguro_id INT REFERENCES seguros(id_seguro),
    numero_poliza VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE,
    valor DECIMAL(10,2)
    estado boolean

);
--registros_viaje:
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
--mantenimientos_programados:
CREATE TABLE mantenimientos_programados (
    id_programado SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    tipo_mantenimiento_id INT REFERENCES tipos_mantenimiento(id_mantenimiento),
    fecha_programada DATE,
    kilometraje_programado INT,
    estado VARCHAR(20)
    estado boolean

);
--mantenimientos_realizados:
CREATE TABLE mantenimientos_realizados (
    id_realizados SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    tipo_mantenimiento_id INT REFERENCES tipos_mantenimiento(id_mantenimiento),
    fecha DATE,
    costo DECIMAL(10,2),
    descripcion TEXT
    estado boolean

);
--incidentes:
CREATE TABLE incidentes (
    id_incidente SERIAL PRIMARY KEY,
    vehiculo_id INT REFERENCES vehiculos(id_vehiculo),
    conductor_id INT REFERENCES conductores(id_conductor),
    fecha DATE,
    descripcion TEXT,
    gravedad VARCHAR(50)
    estado boolean

);

--multas:
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
--auditoria_general:
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
--talleres_mecanicos:
CREATE TABLE talleres_mecanicos (
    id_taller SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    ciudad VARCHAR(100)
);

