-- 4.Triggers
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

CREATE TRIGGER tr_auditoria_mantenimientos
AFTER INSERT OR UPDATE OR DELETE ON mantenimientos_programados
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_mantenimientos();



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

CREATE TRIGGER tr_auditoria_multas
AFTER INSERT OR UPDATE OR DELETE ON multas
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_multas();


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