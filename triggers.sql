--Triggers for autoincrement values.
CREATE OR REPLACE TRIGGER articulo_key_trigger 
BEFORE INSERT ON articulo 
FOR EACH ROW
BEGIN
  :NEW.codigo := articulo_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER repuesto_key_trigger 
BEFORE INSERT ON repuesto 
FOR EACH ROW
BEGIN
  :NEW.codigo := repuesto_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER herramienta_key_trigger 
BEFORE INSERT ON herramienta 
FOR EACH ROW
BEGIN
  :NEW.codigo := herramienta_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER marca_key_trigger 
BEFORE INSERT ON marca 
FOR EACH ROW
BEGIN
  :NEW.codigo := marca_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER modelo_key_trigger 
BEFORE INSERT ON modelo 
FOR EACH ROW
BEGIN
  :NEW.codigo := modelo_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER orden_key_trigger 
BEFORE INSERT ON orden 
FOR EACH ROW
BEGIN
  :NEW.numero := orden_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER factura_compra_key_trigger 
BEFORE INSERT ON factura_compra 
FOR EACH ROW
BEGIN
  :NEW.numero := factura_compra_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER factura_venta_key_trigger 
BEFORE INSERT ON factura_venta 
FOR EACH ROW
BEGIN
  :NEW.numero := factura_venta_key_sequence.NEXTVAL
END;

CREATE OR REPLACE TRIGGER venta_web_key_trigger 
BEFORE INSERT ON venta_web 
FOR EACH ROW
BEGIN
  :NEW.numero := venta_web_key_sequence.NEXTVAL
END;

--Triggers for company constraints
-- (...)