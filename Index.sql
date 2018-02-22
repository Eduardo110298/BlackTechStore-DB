/* Indices para DATABASE BlackTechStore

	EN PROCESO...
*/

-- CREATE INDEX nombre_indice ON nombre_tabla (columna, columna1,….);


CREATE INDEX cant_Repu_idx ON repuesto(nombre,cant_existencia); -- Indice para agilizar la busqueda de la existencia de repuestos


CREATE INDEX estatus_equi_idx ON (); 


CREATE INDEX estatus_orden_idx ON orden(estatus);


CREATE INDEX estatus_pago_idx ON pago(fecha,tipo,doc_identidad_cliente);