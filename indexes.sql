/* Indices para DATABASE BlackTechStore */

-- CREATE INDEX nombre_indice ON nombre_tabla (columna, columna1,…);

CREATE INDEX reparacion_estatus_equipo ON reparacion(estatus); -- Indice para agilizar la busqueda del estado de un equipo

CREATE INDEX repuesto_cant_existencia ON repuesto(nombre,cant_existencia);-- Indice para agilizar la busqueda de la existencia de repuestos

CREATE INDEX orden_estatus ON orden(estatus); -- Indice para agilizar la busqueda del estado de la orden

CREATE INDEX ventaWeb_estatus ON venta_web(estatus); -- Indice para agilizar la busqueda de los estados en las ventas web

