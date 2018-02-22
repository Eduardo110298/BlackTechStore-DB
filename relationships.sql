CREATE TABLE tienda(
	rif VARCHAR(10) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	direccion VARCHAR(120) NOT NULL ENABLE,
	telefono CHAR(11) NOT NULL ENABLE,
	email VARCHAR(50), 
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT TIENDA_PK PRIMARY KEY (rif),
	CONSTRAINT TIENDA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT TIENDA_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE
);

CREATE TABLE cuenta(
	numero CHAR(20) NOT NULL ENABLE,
	tipo CHAR(1) NOT NULL ENABLE,
	banco VARCHAR(20) NOT NULL ENABLE,
	rif_tienda VARCHAR(10) NOT NULL ENABLE,
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT CUENTA_PK_NUMERO PRIMARY KEY (numero),
	CONSTRAINT CUENTA_FK_RIF_TIENDA FOREIGN KEY rif_tienda REFERENCES tienda(rif)
	CONSTRAINT CUENTA_CH_TIPO CHECK (tipo IN('A','C')) ENABLE,
	CONSTRAINT CUENTA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT CUENTA_CH_NUMERO CHECK (regexp_like (numero, '^[[:digit:]]+$') AND length(numero)='20') ENABLE
);

CREATE TABLE empleado(
	cedula NUMBER(8) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	apellido VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11),
	numero_cuenta CHAR(20) NOT NULL ENABLE,
	nombre_banco VARCHAR(20) NOT NULL ENABLE,
	CONSTRAINT EMPLEADO_PK PRIMARY KEY (cedula),
	CONSTRAINT EMPLEADO_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE, 
	CONSTRAINT EMPLEADO_CH_NRO_CUENTA CHECK (regexp_like (numero_cuenta, '^[[:digit:]]+$') AND length(numero_cuenta)='20') ENABLE
);

CREATE TABLE empleado_tecnico(
	cedula NUMBER(8) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	apellido VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11),
	numero_cuenta CHAR(20) NOT NULL ENABLE,
	nombre_banco VARCHAR(20) NOT NULL ENABLE,
	tipo VARCHAR(8),
	CONSTRAINT EMPLEADO_TECNICO_PK PRIMARY KEY (cedula),
	CONSTRAINT EMPLEADO_TECNICO_CH_TIPO CHECK (tipo IN('HARDWARE', 'SOFTWARE', 'AMBAS')) ENABLE,
	CONSTRAINT EMPLEADO_TECNICO_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE, 
	CONSTRAINT EMPLEADO_TECNICO_CH_NRO_CUENTA CHECK (regexp_like (numero_cuenta, '^[[:digit:]]+$') AND length(numero_cuenta)='20') ENABLE
);

CREATE TABLE articulo(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia NUMBER(4) NOT NULL ENABLE,
	CONSTRAINT ARTICULO_PK PRIMARY KEY (codigo),
	CONSTRAINT ARTICULO_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT ARTICULO_CH_CANT_EXISTENCIA CHECK (cant_existencia >= 0) ENABLE,
);

CREATE TABLE repuesto(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia INTEGER(4) NOT NULL ENABLE,
	CONSTRAINT REPUESTO_PK PRIMARY KEY (cod_repuesto) ENABLE,
	CONSTRAINT REPUESTO_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT RESPUESTO_CH_CANT_EXISTENCIA CHECK (cant_existencia >= 0) ENABLE,
);

CREATE TABLE herramienta(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	ced_tecnico NUMBER(8),
	CONSTRAINT HERRAMIENTA_PK PRIMARY KEY (codigo),
	CONSTRAINT HERRAMIENTA_FK_CED_TECNICO FOREIGN KEY ced_tecnico REFERENCES empleado_tecnico(cedula),
	CONSTRAINT HERRAMIENTA_CH COSTO CHECK (costo >= 0) ENABLE
);

CREATE TABLE cliente(
	doc_identidad NUMBER(10) NOT NULL ENABLE,
	nombre_completo VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11) NOT NULL ENABLE,
	direccion VARCHAR(120) NOT NULL ENABLE,
	email VARCHAR(50),
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT CLIENTE_PK PRIMARY KEY (doc_identidad),
	CONSTRAINT CLIENTE_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT CLIENTE_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE
);
--FALTA CHECK PARA VALIDAR EL EMAIL.

CREATE TABLE marca(
	codigo NUMBER NOT NULL ENABLE, 
	nombre VARCHAR(20) NOT NULL ENABLE,
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT MARCA_PK PRIMARY KEY (codigo),
	CONSTRAINT MARCA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
);

CREATE TABLE modelo(
	codigo NUMBER NOT NULL ENABLE, 
	nombre VARCHAR(20) NOT NULL ENABLE,
	codigo_marca NUMBER NOT NULL ENABLE,
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT MODELO_PK PRIMARY KEY (codigo),
	CONSTRAINT MODELO_FK_CODIGO_MARCA FOREIGN KEY codigo_marca REFERENCES marca(codigo),
	CONSTRAINT MODELO_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
);

CREATE TABLE equipo(
	serial_equipo VARCHAR(60) NOT NULL ENABLE,
	imei VARCHAR(60),
	descripcion VARCHAR(120),
	codigo_modelo NUMBER NOT NULL ENABLE,
	tipo VARCHAR(11) NOT NULL ENABLE,
	CONSTRAINT EQUIPO_PK PRIMARY KEY (serial_equipo),
	CONSTRAINT EQUIPO_UK_IMEI UNIQUE (imei),
	CONSTRAINT EQUIPO_FK_CODIGO_MODELO FOREIGN KEY codigo_modelo REFERENCES modelo(codigo),
	CONSTRAINT EQUIPO_CH_TIPO CHECK (tipo IN('TABLET','COMPUTADOR', 'LAPTOP','CELULAR')) ENABLE
);

CREATE TABLE orden(
	numero NUMBER NOT NULL ENABLE,
	estado VARCHAR(13) NOT NULL ENABLE,
	concepto VARCHAR(120) NOT NULL ENABLE,
	fecha_entrada DATE NOT NULL ENABLE,
	fecha_salida DATE NOT NULL ENABLE,
	precio NUMBER(10,2) NOT NULL ENABLE,
	tipo_falla VARCHAR(25) NOT NULL ENABLE,
	doc_identidad_cliente VARCHAR(8) NOT NULL ENABLE,
	CONSTRAINT ORDEN_PK PRIMARY KEY (numero),
	CONSTRAINT ORDEN_FK_DOC_IDENTIDAD_CLIENTE FOREIGN KEY doc_identidad_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT ORDEN_CH_ESTADO CHECK (estado IN('EN ESPERA', ' ES REVISION', 'EN REPARACION', 'DEVUELTO', 'TERMINADO', 'ENTREGADO')) ENABLE,
	CONSTRAINT ORDEN_CH_PRECIO CHECK (precio >= 0) ENABLE,
	CONSTRAINT ORDEN_CH_TIPO_FALLA CHECK (tipo_falla IN('HARDWARE', 'SOFTWARE', 'AMBAS')) ENABLE
);


CREATE TABLE pertenece_a(
	numero_orden NUMBER NOT NULL ENABLE,
	serial_equipo VARCHAR(60) NOT NULL ENABLE,
	CONSTRAINT PERTENECE_PK PRIMARY KEY (numero_orden,serial_equipo),
	CONSTRAINT PERTENECE_FK_NUMERO_ORDEN FOREIGN KEY numero_orden REFERENCES orden(numero),
	CONSTRAINT PERTENECE_FK_SERIAL_EQUIPO FOREIGN KEY serial_equipo REFERENCES equipo(serial_equipo)
);

CREATE TABLE reparacion(
	fecha_inicio DATE NOT NULL ENABLE,
	fecha_fin DATE NOT NULL ENABLE,
	fecha_hora TIMESTAMP DEFAULT sysdate NOT NULL ENABLE,
	numero_orden NUMBER NOT NULL ENABLE,
	cedula_tecnico NUMBER(8) NOT NULL ENABLE,
	comision NUMBER(10,2) NOT NULL ENABLE,
	tipo_reparacion VARCHAR(8) NOT NULL ENABLE,
	descripcion VARCHAR(200),
	estado VARCHAR(9) NOT NULL ENABLE,
	CONSTRAINT REPARACION_PK PRIMARY KEY (fecha_hora,cedula_tecnico,numero_orden),
	CONSTRAINT REPARACION_FK_NUMERO_ORDEN FOREIGN KEY numero_orden REFERENCES orden(numero),
	CONSTRAINT REPARACION_FK_CEDULA_TECNICO FOREIGN KEY cedula_tecnico REFERENCES empleado_tecnico(cedula),
	CONSTRAINT REPARACION_CH_ESTADO CHECK (estado IN('TERMINADO', 'REPARANDO', 'EN_ESPERA')),
	CONSTRAINT REPARACION_CH_TIPO_REPARACION CHECK (tipo_reparacion IN('SOFTWARE', 'HARDWARE', 'AMBAS'))
);

CREATE TABLE usa(
	codigo_repuesto NUMBER NOT NULL ENABLE,
	fecha_hora_reparacion TIMESTAMP NOT NULL ENABLE,
	numero_orden_reparacion NUMBER NOT NULL ENABLE,
	cedula_tecnico_reparacion NUMBER(8) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	observacion VARCHAR(120),
	cantidad NUMBER NOT NULL ENABLE,
	CONSTRAINT USA_PK PRIMARY KEY (codigo_repuesto, fecha_hora_reparacion, numero_orden_reparacion, cedula_tecnico_reparacion),
	CONSTRAINT USA_FK_REPUESTO FOREIGN KEY cod_repuesto REFERENCES repuesto(cod_repuesto),
	CONSTRAINT USA_FK_REPARACION FOREIGN KEY (fecha_hora_reparacion, cedula_tecnico_reparacion, numero_orden_reparacion) REFERENCES reparacion(fecha_hora, numero_orden, cedula_tecnico)	
	CONSTRAINT USA_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT USA_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE proveedor(
	rif VARCHAR(10) NOT NULL ENABLE,
	nombre VARCHAR(20) NOT NULL ENABLE,
	fecha_registro DATE NOT NULL ENABLE DEFAULT sysdate,
	telefono NUMBER(11) NOT NULL ENABLE,
	direccion VARCHAR(50) NOT NULL ENABLE,
	email VARCHAR(50), --FALTA CHECK PARA EL EMAIL
	estado VARCHAR(8) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT PROVEEDOR_PK PRIMARY KEY (rif),
	CONSTRAINT PROVEEDOR_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
	CONSTRAINT PROVEEDOR_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') and length(telefono)='11') ENABLE
);


CREATE TABLE factura_compra(
	fecha DATE NOT NULL ENABLE DEFAULT sysdate,
	total NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	numero NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	tipo VARCHAR(7) NOT NULL ENABLE,
	CONSTRAINT FACTURA_COMPRA_PK PRIMARY KEY (numero,rif_proveedor),
	CONSTRAINT FACTURA_COMPRA_FK_RIF_PROVEEDOR FOREIGN KEY rif_proveedor REFERENCES proveedor(rif),
	CONSTRAINT FACTURA_COMPRA_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
	CONSTRAINT FACTURA_COMPRA_CH_TOTAL CHECK (total >= 0) ENABLE
);

CREATE TABLE actualiza_articulo(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_articulo NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACTUALIZA_ARTICULO_PK PRIMARY KEY (rif_proveedor, codigo_articulo, numero_factura_compra),
	CONSTRAINT ACTUALIZA_ARTICULO_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACTUALIZA_ARTICULO_FK_ARTICULO FOREIGN KEY codigo_articulo REFERENCES articulo(codigo)
	CONSTRAINT ACTUALIZA_ARTICULO_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT ACTUALIZA_ARTICULO_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACTUALIZA_ARTICULO_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE actualiza_repuesto(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_repuesto NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACTUALIZA_REPUESTO_PK PRIMARY KEY (rif_proveedor, codigo_repuesto, numero_factura_compra),
	CONSTRAINT ACTUALIZA_REPUESTO_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACTUALIZA_REPUESTO_FK_REPUESTO FOREIGN KEY codigo_repuesto REFERENCES repuesto(codigo)
	CONSTRAINT ACTUALIZA_REPUESTO_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT ACTUALIZA_REPUESTO_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACTUALIZA_REPUESTO_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE actualiza_herramienta( --Sin cantidad porque las herramientas se manejan por unidad.
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_herramienta NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACTUALIZA_HERRAMIENTA_PK PRIMARY KEY (rif_proveedor, codigo_herramienta, numero_factura_compra),
	CONSTRAINT ACTUALIZA_HERRAMIENTA_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACTUALIZA_HERRAMIENTA_FK_HERRAMIENTA FOREIGN KEY codigo_herramienta REFERENCES herramienta(codigo)
	CONSTRAINT ACTUALIZA_HERRAMIENTA_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACTUALIZA_HERRAMIENTA_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE cuenta_por_pagar(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	fecha DATE NOT NULL ENABLE DEFAULT sysdate,
	monto NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	saldo NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	CONSTRAINT CUENTA_POR_PAGAR_PK PRIMARY KEY (numero_factura_compra, rif_proveedor),
	CONSTRAINT CUENTA_POR_PAGAR_FK_FACTURA_COMPRA FOREIGN KEY (numero_factura_compra,rif_proveedor) REFERENCES factura_compra(numero,rif_proveedor),
	CONSTRAINT CUENTA_POR_PAGAR_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CUENTA_POR_PAGAR_CH_SALDO CHECK (saldo >= 0) ENABLE
);

CREATE TABLE abono(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	fecha DATE NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	rif_proveedor_factura_compra VARCHAR(10) NOT NULL ENABLE,
	numero_factura_compra_factura_compra NUMBER NOT NULL ENABLE,
	rif_proveedor_cuenta_por_cobrar VARCHAR(10) NOT NULL ENABLE,
	numero_factura_compra_cuenta_por_cobrar NUMBER NOT NULL ENABLE,
	numero_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	CONSTRAINT ABONO_PK PRIMARY KEY (referencia,rif_proveedor,nro_factura_compra),
	CONSTRAINT ABONO_FK_NRO_CUENTA FOREIGN KEY numero_cuenta_tienda REFERENCES cuenta(numero),
	CONSTRAINT ABONO_FK_FACTURA_COMPRA FOREIGN KEY (rif_proveedor_factura_compra, numero_factura_compra_factura_compra) REFERENCES factura_compra(rif_proveedor,numero), --DUDA CON LA PROFESORA: DEBO REPETIR ESTA CLAVE DESDE CUENTA POR PAGAR Y DESDE FACTURA?
	CONSTRAINT ABONO_FK_CUENTA_POR_COBRAR FOREIGN KEY (rif_proveedor_cuenta_por_cobrar, numero_factura_compra_cuenta_por_cobrar) REFERENCES cuenta_por_cobrar(rif_proveedor,numero_factura_compra), --DUDA CON LA PROFESORA: DEBO REPETIR ESTA CLAVE DESDE CUENTA POR PAGAR Y DESDE FACTURA?
	CONSTRAINT ABONO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT ABONO_CH_NUMERO_CUENTA_TIENDA CHECK (regexp_like (numero_cuenta_tienda, '^[[:digit:]]+$') and length(numero_cuenta_tienda)='20')	
);

CREATE TABLE factura_venta(
	numero NUMBER NOT NULL ENABLE, 
	fecha DATE NOT NULL ENABLE DEFAULT sysdate, 
	total NUMBER(10,2) NOT NULL ENABLE DEFAULT 0, 
	tipo VARCHAR(7) NOT NULL ENABLE,
	doc_identidad_cliente VARCHAR(8) NOT NULL ENABLE,
	numero_orden NUMBER NOT NULL ENABLE,
	estado VARCHAR(10) NOT NULL ENABLE, --PENDIENTE ACTUALIZAR CUANDO SE INSERTE UNA CUENTA POR COBRAR CON UN NUMERO DE FACTURA PERTENECIENTE A ESTA TABLA, AUTOMATICAMENTE PASA A PENDIENTE Y SI LA MISMA CUENTA LLEGA A TENER SU SALDO A 0 ENTONCES PASA A PAGADA
	CONSTRAINT FACTURA_PK PRIMARY KEY (numero),
	CONSTRAINT FACTURA_FK_DOC_CLIENTE FOREIGN KEY doc_identidad_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT FACTURA_FK_NUMERO_ORDEN FOREIGN KEY numero_orden REFERENCES orden(numero),
	CONSTRAINT FACTURA_CH_TOTAL CHECK (total >= 0),
	CONSTRAINT FACTURA_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
	CONSTRAINT FACTURA_CH_ESTADO CHECK (estado IN('PAGADA', 'PENDIENTE', 'DEVUELTA'))
);

CREATE TABLE incluye(
	nro_factura NUMBER NOT NULL ENABLE,
	cod_articulo NUMBER NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	pvp NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT INCLUYE_PK PRIMARY KEY (cod_articulo,nro_factura),
	CONSTRAINT INCLUYE_FK_FACTURA FOREIGN KEY nro_factura REFERENCES factura(nro_factura),
	CONSTRAINT INCLUYE_FK_ARTICULO FOREIGN KEY cod_articulo REFERENCES articulo(codigo),
	CONSTRAINT INCLUYE_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT INCLUYE_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT INCLUYE_CH_PVP CHECK (pvp > 0)
);

CREATE TABLE cuenta_por_cobrar(
	numero_factura_venta NUMBER NOT NULL ENABLE,
	doc_identidad_cliente NUMBER(8) NOT NULL ENABLE,
	fecha DATE NOT NULL ENABLE DEFAULT sysdate,
	monto NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	saldo NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	CONSTRAINT CUENTA_POR_COBRAR_PK PRIMARY KEY (numero_factura_venta, doc_identidad_cliente),
	CONSTRAINT CUENTA_POR_COBRAR_FK_FACTURA_VENTA FOREIGN KEY numero_factura_venta REFERENCES factura_venta(numero),
	CONSTRAINT CUENTA_POR_COBRAR_FK_DOC_ID_CLIENTE FOREIGN KEY doc_identidad_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT CUENTA_POR_COBRAR_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CUENTA_POR_COBRAR_CH_SALDO CHECK (saldo >= 0) ENABLE
);

CREATE TABLE pago(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	fecha DATE NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	doc_identidad_cliente_cuenta_por_cobrar VARCHAR(10) NOT NULL ENABLE,
	numero_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	numero_factura_venta_factura_venta NUMBER NOT NULL ENABLE,
	numero_factura_venta_cuenta_por_cobrar NUMBER NOT NULL ENABLE,
	CONSTRAINT PAGO_PK PRIMARY KEY (referencia,rif_proveedor,nro_factura),
	CONSTRAINT PAGO_FK_NRO_CUENTA FOREIGN KEY numero_cuenta_tienda REFERENCES cuenta(numero),
	CONSTRAINT PAGO_FK_FACTURA_VENTA FOREIGN KEY numero_factura_venta_factura_venta REFERENCES factura_venta(numero),
	CONSTRAINT PAGO_FK_CUENTA_POR_COBRAR FOREIGN KEY (numero_factura_venta_cuenta_por_cobrar,doc_identidad_cliente_cuenta_por_cobrar) REFERENCES cuenta_por_cobrar(numero_factura_venta,doc_identidad_cliente),
	CONSTRAINT PAGO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT PAGO_CH_NUMERO_CUENTA_TIENDA CHECK (regexp_like (numero_cuenta_tienda, '^[[:digit:]]+$') and length(numero_cuenta_tienda)='20')	
);

CREATE TABLE venta_web(
	numero NUMBER NOT NULL ENABLE, 
	estado VARCHAR(10) NOT NULL ENABLE DEFAULT 'ESPERA', --ESTADOS PUEDEN SER CONFIRMADA, RECHADA O ESPERA
	fecha DATE NOT NULL ENABLE,
	monto_total NUMBER(10,2) NOT NULL ENABLE DEFAULT 0, --ATRIBUTO DERIVADO
	doc_id_cliente NUMBER(8) NOT NULL ENABLE,
	tipo_retiro VARCHAR(10) NOT NULL ENABLE DEFAULT 'FISICO', 
	dir_envio VARCHAR(250),
	medio_envio VARCHAR(50),
	fecha_envio DATE,
	n_guia NUMBER(20),
	CONSTRAINT VENTA_WEB_PK PRIMARY KEY (nro_venta),
	CONSTRAINT VENTA_WEB_FK_DOC_CLIENTE FOREIGN KEY doc_id_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT VENTA_WEB_CH_MONTO CHECK (monto_total >= 0),
	CONSTRAINT VENTA_WEB_CH_TR CHECK (tipo_retiro IN('FISICO', 'DOMICILIO')),
	CONSTRAINT VENTA_WEB_CH_MENVIO CHECK (medio_envio IN('ZOOM', 'DOMESA', 'DHL', 'MRW', 'TEALCA')),
	CONSTRAINT VENTA_WEB_CH_ESTADO CHECK (estado IN('CONFIRMADA', 'RECHAZADA', 'ESPERA'))
);

CREATE TABLE emite(
	numero_factura_venta NUMBER NOT NULL ENABLE,
	numero_venta_web NUMBER NOT NULL ENABLE,
	CONSTRAINT EMITE_PK PRIMARY KEY nro_venta_web,
	CONSTRAINT EMITE_FK_NUMERO_FACTURA FOREIGN KEY numero_factura_venta REFERENCES factura_venta(numero),
	CONSTRAINT EMITE_FK_NUMERO_VENTA_WEB FOREIGN KEY numero_venta_web REFERENCES venta_web(numero),
);

CREATE TABLE posee(
	codigo_articulo NUMBER NOT NULL ENABLE,
	numero_venta_web NUMBER NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	pvp NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT PAGO_PK PRIMARY KEY (codigo_articulo,numero_venta_web),
	CONSTRAINT PAGO_FK_ARTICULO FOREIGN KEY codigo_articulo REFERENCES articulo(codigo),
	CONSTRAINT PAGO_FK_NUMERO_VENTA_WEB FOREIGN KEY numero_venta_web REFERENCES venta_web(numero),
	CONSTRAINT PAGO_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT PAGO_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT PAGO_CH_PVP CHECK (pvp > 0)
);

--FALTAN ACCIONES REFERENCIALES
--FALTAN TRIGGERS PARA SECUENCIAS DE AUTOINCREMENTO
--FALTAN TRIGGERS PARA ACTUALIZACION DEL TOTAL DE LAS FACTURAS TANTO DE COMPRA COMO DE VENTA, AL INSERTAR EN SUS DETALLES.
--FALTAN TRIGGERS PARA ACTUALIZAR EL INVENTARIO CORRESPONDIENTE CADA VEZ QUE SE INSERTE UN DETALLE EN UNA FACTURA DE COMRRA O DE VENTA. ASI COMO TAMBIEN AL USAR UN REPUESTO O AL VENDERLO EN UNA VENTA_WEB
--FALTAN TRIGGERS PARA CAMBIO DE ESTADO DE LA ORDEN AL CAMBIAR TODAS LAS REPARACIONES DE LA MISMA A TERMINADO
--FALTAN INDICES ALTERNOS
--FALTAN VISTAS PARA LOS USUARIOS