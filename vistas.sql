--Vista de emitir reporte de los equipos asignados a los tecnicos y el estatus de la orden ordenado por tecnico y fecha de recepcion
CREATE VIEW vEquipo 
	AS SELECT tecnico.cedula, tecnico.nombre, orden.fec_ent, pertenece_a.serial, orden.estado 
	from tecnico tec 
	INNER JOIN reparacion rep 
	  on tec.cedula = rep.cedula
	INNER JOIN orden ord
	  on rep.nro_orden = ord.nro_orden
	INNER JOIN pertenece_a pert 
	  on pert.nro_orden = ord.nro_orden
	ORDER BY tecnico.cedula, orden.fec_ent ASC;

--Vista de los Reportes de los ingresos semanales obtenidos por tipo de reparacion 
CREATE VIEW vIngresoTipos
	AS equipo.tipo, SUM(factura.total)
	from factura fac 
	INNER JOIN pertenece_a pert
	  on fac.nro_orden = pert.nro_orden
	INNER JOIN equipo equ 
	  on equ.serial = pert.serial
	WHERE factura.fecha BETWEEN sysdate - 7 AND sysdate
	GROUP BY (equipo.tipo);