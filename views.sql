--Vista de emitir reporte de los equipos asignados a los tecnicos y el estatus de la orden ordenado por tecnico y fecha de recepcion
CREATE VIEW vEquipo 
	AS SELECT tec.cedula, tec.nombre, ord.fecha_entrada, pert.serial_equipo, ord.estado 
	FROM empleado_tecnico tec 
	INNER JOIN reparacion rep 
	  ON tec.cedula = tec.cedula
	INNER JOIN orden ord
	  ON rep.numero_orden = ord.numero
	INNER JOIN pertenece_a pert 
	  ON pert.numero_orden = ord.numero
	ORDER BY tec.cedula ASC, ord.fecha_entrada ASC;

--Vista de los Reportes de los ingresos semanales obtenidos por tipo de reparacion 
CREATE VIEW vIngresoTipos
	AS SELECT equ.tipo, SUM(fac.total) AS INGRESO_SEMANAL
	FROM factura_venta fac 
	INNER JOIN pertenece_a pert
	  ON fac.numero_orden = pert.numero_orden
	INNER JOIN equipo equ 
	  ON equ.serial_equipo = pert.serial_equipo
	WHERE fac.fecha BETWEEN sysdate - 7 AND sysdate
	GROUP BY equ.tipo;

--Vista de los repuestos diarios utilizados en las ordenes 
CREATE VIEW vRepuesto 
	AS SELECT rep.codigo, rep.nombre, rep.costo, ord.numero, ord.estado, ord.concepto, ord.fecha_entrada, ord.fecha_salida
	FROM repuesto rep 
	INNER JOIN usa u 
	  ON rep.codigo = u.codigo_repuesto
	INNER JOIN orden ord
	  ON ord.numero = u.numero_orden_reparacion
	WHERE u.fecha_hora_reparacion BETWEEN sysdate - 7 AND sysdate;

--Vista de las ventas web por aprobar
CREATE VIEW vWebPorApro
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = 'ESPERA';

--Vista de las ventas web aprobadas
CREATE VIEW vWebApro
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = 'CONFIRMADA';

--Vista de las ventas web rechazadas
CREATE VIEW vWebRech
	AS SELECT numero, estado, fecha, doc_id_cliente, monto_total, tipo_retiro, medio_envio, direccion_envio, numero_guia, fecha_envio
	FROM venta_web
	WHERE estado = 'RECHAZADA';