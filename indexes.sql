SET serveroutput ON
CREATE INDEX reparacion_estado_equipo ON reparacion(estado) -- Indice para agilizar la busqueda del estado de un equipo
/
CREATE INDEX repuesto_cant_existencia ON repuesto(nombre,cant_existencia)-- Indice para agilizar la busqueda de la existencia de repuestos
/
CREATE INDEX orden_estado ON orden(estado) -- Indice para agilizar la busqueda del estado de la orden
/
CREATE INDEX venta_web_estado ON venta_web(estado) -- Indice para agilizar la busqueda de los estados en las ventas web
/