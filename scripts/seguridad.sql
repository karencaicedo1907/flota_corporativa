-- 8. Seguridad

CREATE ROLE admin_role;
CREATE ROLE conductor_role;
CREATE ROLE gestor_flota_role;
CREATE ROLE mecanico_role;
CREATE ROLE cliente_role;


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


-- PERMISOS POR ROL


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





