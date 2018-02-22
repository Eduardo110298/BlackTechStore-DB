/* Indices para DATABASE BlackTechStore

	EN PROCESO...
*/

-- CREATE INDEX nombre_indice ON nombre_tabla (columna, columna1,….);


CREATE INDEX repuesto_cant_existencia ON repuesto(nombre,cant_existencia); -- Indice para agilizar la busqueda de la existencia de repuestos


CREATE INDEX reparacion_estatus_equipo ON reparacion(estatus); --


CREATE INDEX estatus_orden ON orden(estatus);


CREATE INDEX estatus_pago ON pago(fecha,tipo,doc_identidad_cliente);
