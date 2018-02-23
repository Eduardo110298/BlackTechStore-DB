--Vista de emitir reporte de los equipos asignados a los tecnicos y el estatus de la orden ordenado por tecnico y fecha de recepcion
CREATE VIEW vEquipo 
	AS SELECT tecnico.cedula, tecnico.nombre, orden.fecha_entrada, pertenece_a.serial, orden.estado 
	FROM tecnico tec 
	INNER JOIN reparacion rep 
	  ON tec.cedula_tecnico = rep.cedula
	INNER JOIN orden ord
	  ON rep.numero_orden = ord.numero
	INNER JOIN pertenece_a pert 
	  ON pert.numero_orden = ord.numero
	ORDER BY tecnico.cedula, orden.fec_ent ASC;

--Vista de los Reportes de los ingresos semanales obtenidos por tipo de reparacion 
CREATE VIEW vIngresoTipos
	AS equipo.tipo, SUM(factura.total)
	FROM factura fac 
	INNER JOIN pertenece_a pert
	  ON fac.numero_orden = pert.numero_orden
	INNER JOIN equipo equ 
	  ON equ.serial_equipo = pert.serial_equipo
	WHERE factura.fecha BETWEEN sysdate - 7 AND sysdate
	GROUP BY (equipo.tipo);

--Vista de los repuestos diarios utilizados en las ordenes 
CREATE VIEW vRepuesto 
	AS SELECT repuesto.codigo, repuesto.nombre, repuesto.costo, orden.numero_orden_reparacion, orden.estado, orden.concepto, orden.fecha_entrada, orden.fecha_salida
	FROM repuesto rep 
	INNER JOIN usa u 
	  ON u.codigo = rep.codigo_repuesto
	INNER JOIN orden ord
	  ON ord.numero_orden = u.numero_orden_reparacion
	WHERE usa.fecha_hora_reparacion BETWEEN sysdate - 7 AND sysdate;

--Vista de las ventas web por aprobar
CREATE VIEW vWebPorApro
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = "ESPERA";

--Vista de las ventas web aprobadas
CREATE VIEW vWebApro
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = "CONFIRMADA";

--Vista de las ventas web rechazadas
CREATE VIEW vWebRech
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = "RECHAZADA";