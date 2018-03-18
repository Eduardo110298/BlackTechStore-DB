--Triggers for autoincrement values.
CREATE OR REPLACE TRIGGER articulo_key_trigger 
BEFORE INSERT ON articulo 
FOR EACH ROW
BEGIN
  :NEW.codigo := articulo_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER repuesto_key_trigger 
BEFORE INSERT ON repuesto 
FOR EACH ROW
BEGIN
  :NEW.codigo := repuesto_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER herramienta_key_trigger 
BEFORE INSERT ON herramienta 
FOR EACH ROW
BEGIN
  :NEW.codigo := herramienta_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER marca_key_trigger 
BEFORE INSERT ON marca 
FOR EACH ROW
BEGIN
  :NEW.codigo := marca_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER modelo_key_trigger 
BEFORE INSERT ON modelo 
FOR EACH ROW
BEGIN
  :NEW.codigo := modelo_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER orden_key_trigger 
BEFORE INSERT ON orden 
FOR EACH ROW
BEGIN
  :NEW.numero := orden_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER factura_compra_key_trigger 
BEFORE INSERT ON factura_compra 
FOR EACH ROW
BEGIN
  :NEW.numero := factura_compra_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER factura_venta_key_trigger 
BEFORE INSERT ON factura_venta 
FOR EACH ROW
BEGIN
  :NEW.numero := factura_venta_key_sequence.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER venta_web_key_trigger 
BEFORE INSERT ON venta_web 
FOR EACH ROW
BEGIN
  :NEW.numero := venta_web_key_sequence.NEXTVAL;
END;
/
--Triggers for company constraints
CREATE OR REPLACE TRIGGER detalles_fv_trigger
  AFTER INSERT ON incluye
  FOR EACH ROW
BEGIN
  UPDATE factura_venta SET total = total + :NEW.subtotal WHERE numero = :NEW.numero_factura_venta;
  UPDATE articulo SET cant_existencia = cant_existencia - :NEW.cantidad WHERE codigo = :NEW.codigo_articulo;
END;
/

CREATE OR REPLACE TRIGGER detalles_fc_art_trigger
  AFTER INSERT ON actualiza_articulo
  FOR EACH ROW
DECLARE
  costo_actual NUMBER(10,2);
  costo_nuevo NUMBER(10,2);
BEGIN
  UPDATE factura_compra SET total = total + :NEW.subtotal WHERE numero = :NEW.numero_factura_compra;
  UPDATE articulo SET cant_existencia = cant_existencia + :NEW.cantidad WHERE codigo = :NEW.codigo_articulo;
  SELECT costo INTO costo_actual FROM articulo WHERE codigo = :NEW.codigo_articulo;
  costo_nuevo := :NEW.costo * 1.3;
  IF costo_nuevo > costo_actual THEN
    UPDATE articulo SET costo = costo_nuevo WHERE codigo = :NEW.codigo_articulo;
  END IF;  
END;
/
CREATE OR REPLACE TRIGGER detalles_fc_rep_trigger
  AFTER INSERT ON actualiza_repuesto
  FOR EACH ROW
DECLARE
  costo_actual NUMBER(10,2);
  costo_nuevo NUMBER(10,2);
BEGIN
  UPDATE factura_compra SET total = total + :NEW.subtotal WHERE numero = :NEW.numero_factura_compra;
  UPDATE repuesto SET cant_existencia = cant_existencia + :NEW.cantidad WHERE codigo = :NEW.codigo_repuesto;
  SELECT costo INTO costo_actual FROM repuesto WHERE codigo = :NEW.codigo_repuesto;
  costo_nuevo := :NEW.costo * 1.3;
  IF costo_nuevo > costo_actual THEN
    UPDATE repuesto SET costo = costo_nuevo WHERE codigo = :NEW.codigo_repuesto;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER detalles_fc_herr_trigger
  AFTER INSERT ON actualiza_herramienta
  FOR EACH ROW
BEGIN
  UPDATE factura_compra SET total = total + :NEW.subtotal WHERE numero = :NEW.numero_factura_compra;
  UPDATE herramienta SET costo = :new.costo WHERE codigo = :NEW.codigo_herramienta; 
END;
/
CREATE OR REPLACE TRIGGER uso_repuesto_trigger
  AFTER INSERT ON usa
  FOR EACH ROW
BEGIN
  UPDATE repuesto SET cant_existencia = cant_existencia - :NEW.cantidad WHERE codigo = :NEW.codigo_repuesto;
END;
/
--TRIGGER PARA CAMBIO DE ESTADO DE LA ORDEN AL CAMBIAR TODAS LAS REPARACIONES DE LA MISMA A TERMINADO
CREATE OR REPLACE TRIGGER orden_actualizar_estado
  AFTER UPDATE ON reparacion
  FOR EACH ROW
DECLARE
  cant_rep NUMBER;
BEGIN
  SELECT COUNT(estado) INTO cant_rep FROM reparacion WHERE numero_orden = :OLD.numero_orden AND estado != 'TERMINADO';
  IF cant_rep = 0 THEN
    UPDATE orden SET estado = 'TERMINADO' WHERE  numero = :OLD.numero_orden;
  END IF;
END;
/
--ACTUALIZACION DE EL REPUESTO EN INVENTARIO CUANDO HACE UN INSERT EN USA
CREATE OR REPLACE TRIGGER rep_act_inventario
  AFTER INSERT ON usa
  FOR EACH ROW
BEGIN
  UPDATE repuesto SET cant_existencia = cant_existencia - :NEW.cantidad WHERE codigo = :OLD.codigo_repuesto;
END;
/





















-- --ACTUALIZACION DE EL ARTICULO EN INVENTARIO EN VENTA WEB
-- CREATE OR REPLACE TRIGGER articulo_actualizacion_inventario
--   AFTER INSERT ON posee
--   FOR EACH ROW
-- BEGIN
--   UPDATE articulo SET cant_existencia = cant_existencia - :NEW.cantidad WHERE codigo = :OLD.codigo_articulo;
-- END;

-- --ACTUALIZACION DE EL RESPUESTO EN EL INVENTARIO CUANDO HACE UN UPDATE EN USA
-- CREATE OR REPLACE TRIGGER repuesto_actualizacion_inventario
--   AFTER UPDATE ON usa
--   FOR EACH ROW
-- BEGIN
--   IF :NEW.cantidad > :OLD.cantidad
--    UPDATE repuesto SET cant_existencia = cant_existencia - (:NEW.cantidad - :OLD.cantidad) WHERE codigo = :OLD.codigo_repuesto
-- END;

-- -- ACTUALIZACION DEL SALDO EN CUENTA POR PAGAR CUANDO HAGA UN INSERT EN ABONO
--CREATE OR REPLACE TRIGGER cuenta_por_cobrar_actualizacion_saldo
--  AFTWE INSERT ON abono
--  FOR EACH ROW
--DECLARE
--  cantidad_saldo NUMBER(10,2)
--BEGIN
--  SELECT saldo INTO cantidad_saldo FROM cuenta_por_pagar WHERE numero_factura_compra = :NEW.numero_factura_compra AND rif_proveedor = :NEW.rif_proveedor
--  IF cantidad_saldo >= :NEW.monto -- EL SALDO DE LA CUENTA POR PAGAR NO PUEDE QUEDAR EN NEGATIVO
--    UPDATE cuenta_por_pagar SET saldo = saldo - :NEW.monto WHERE numero_factura_compra = :NEW:numero_factura_compra AND rif_proveedor = :NEW.rif_proveedor
--END;

-- -- ACTUALIZACION DEL SALDO EN CUENTA POR COBRAR CUANDO HAGA UN INSERT EN PAGO
--CREATE OR REPLACE TRIGGER cuenta_por_cobrar_actualizacion_saldo
--  AFTWE INSERT ON pago
--  FOR EACH ROW
--DECLARE
--  cantidad_saldo NUMBER(10,2)
--BEGIN
--  SELECT saldo INTO cantidad_saldo FROM cuenta_por_cobrar WHERE numero_factura_venta = :NEW.numero_factura_venta
--  IF cantidad_saldo >= :NEW.monto -- EL SALDO DE LA CUENTA POR COBRAR NO PUEDE QUEDAR EN NEGATIVO
--    UPDATE cuenta_por_cobrar SET saldo = saldo - :NEW.monto WHERE numero_factura_venta = :NEW:numero_factura_venta
--END;

-- --TRIGGERS PARA LA ACCION REFERENCIAL UPDATE EN LAS TABLAS

-- --UPDATE DEL CODIGO DE LA MARCA EN LA TABLA MODELO
-- CREATE OR REPLACE TRIGGER marca_foreign_key
--   AFTER UPDATE ON marca
--   FOR EACH ROW
-- BEGIN
--   IF :OLD.codigo != :NEW.codigo THEN
--     UPDATE modelo SET codigo_marca = :NEW.codigo WHERE codigo_marca = :OLD.codigo
--   END IF;
-- END;

-- --UPDATE DEL CODIGO DE LA MODELO EN LA TABLA EQUIPO
-- CREATE OR REPLACE TRIGGER equipo_foreign_key
--   AFTER UPDATE ON modelo
--   FOR EACH ROW
-- BEGIN
--   IF :OLD.codigo != :NEW.codigo THEN
--     UPDATE equipo SET codigo_modelo = :NEW.codigo WHERE codigo_modelo= :OLD.codigo
--   END IF;
-- END;

-- --UPDATE DEL CODIGO DEL REPUESTO EN LA TABLA USA Y ACTUALIZA_REPUESTO
-- CREATE OR REPLACE TRIGGER repuesto_foreign_key
--   AFTER UPDATE ON repuesto
--   FOR EACH ROW
-- BEGIN
--   IF :OLD.codigo != :NEW.codigo THEN
--     UPDATE usa SET codigo_respuesto = :NEW.codigo WHERE codigo_respuesto = :OLD.codigo
--     UPDATE actualiza_repuesto SET codigo_respuesto = :NEW.codigo WHERE codigo_respuesto = :OLD.codigo
--   END IF;
-- END;

-- --UPDATE DEL CODIGO DEL ARTICULO EN LA TABLA INCLUYE, POSEE Y ACTUALIZA_ARTICULO
-- CREATE OR REPLACE TRIGGER articulo_foreign_key
--   AFTER UPDATE ON articulo
--   FOR EACH ROW
-- BEGIN
--   IF :OLD.codigo != :NEW.codigo THEN
--     UPDATE incluye SET codigo_articulo = :NEW.codigo WHERE codigo_articulo = :OLD.codigo
--     UPDATE posee SET codigo_articulo = :NEW.codigo WHERE codigo_articulo = :OLD.codigo
--     UPDATE actualiza_articulo SET codigo_articulo = :NEW.codigo WHERE codigo_articulo = :OLD.codigo
--   END IF;
-- END;

-- --UPDATE DEL CODIGO DEL HERRAMIENTA EN LA TABLA ACTUALIZA HERRAMIENTA
-- CREATE OR REPLACE TRIGGER herramienta_foreign_key
--   AFTER UPDATE ON herramienta
--   FOR EACH ROW
-- BEGIN
--   IF :OLD.codigo != :NEW.codigo THEN
--     UPDATE actualiza_herramienta SET codigo_herramienta = :NEW.codigo WHERE codigo_herramienta = :OLD.codigo
--   END IF;
-- END;
-- --FIN DE LOS TRIGGERS PARA LAS ACCIONES REFLERENCIALES (ON UPDATE)

-- (...)

