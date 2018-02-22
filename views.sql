--Vista de emitir reporte de los equipos asignados a los tecnicos y el estatus de la orden ordenado por tecnico y fecha de recepcion
CREATE VIEW vEquipo 
	AS SELECT tecnico.cedula, tecnico.nombre, orden.fec_ent, pertenece_a.serial, orden.estado 
	FROM tecnico tec 
	INNER JOIN reparacion rep 
	  ON tec.cedula = rep.cedula
	INNER JOIN orden ord
	  ON rep.nro_orden = ord.nro_orden
	INNER JOIN pertenece_a pert 
	  ON pert.nro_orden = ord.nro_orden
	ORDER BY tecnico.cedula, orden.fec_ent ASC;

--Vista de los Reportes de los ingresos semanales obtenidos por tipo de reparacion 
CREATE VIEW vIngresoTipos
	AS equipo.tipo, SUM(factura.total)
	FROM factura fac 
	INNER JOIN pertenece_a pert
	  ON fac.nro_orden = pert.nro_orden
	INNER JOIN equipo equ 
	  ON equ.serial = pert.serial
	WHERE factura.fecha BETWEEN sysdate - 7 AND sysdate
	GROUP BY (equipo.tipo);

--Vista de los repuestos diarios utilizados en las ordenes 
CREATE VIEW vRepuesto 
	AS SELECT repuesto.codigo, repuesto.nombre, repuesto.costo, orden.nro_orden, orden.estado, orden.concepto, orden.fec_ent, orden.fec_sal
	FROM repuesto rep 
	INNER JOIN usa u 
	  ON u.codigo = rep.codigo
	INNER JOIN orden ord
	  ON ord.nro_orden = u.nro_orden;