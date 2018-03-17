CREATE TABLE tienda(
	rif VARCHAR(10) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	direccion VARCHAR(120) NOT NULL ENABLE,
	telefono CHAR(11) NOT NULL ENABLE,
	email VARCHAR(50), 
	estado CHAR(1) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT TIENDA_PK PRIMARY KEY (rif),
	CONSTRAINT TIENDA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT TIENDA_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE
);

CREATE TABLE cuenta(
	numero CHAR(20) NOT NULL ENABLE,
	tipo CHAR(1) NOT NULL ENABLE,
	banco VARCHAR(20) NOT NULL ENABLE,
	rif_tienda VARCHAR(10) NOT NULL ENABLE,
	estado CHAR(1) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT CUENTA_PK_NUMERO PRIMARY KEY (numero),
	CONSTRAINT CUENTA_FK_RIF_TIENDA FOREIGN KEY (rif_tienda) REFERENCES tienda(rif),
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
	CONSTRAINT EMP_PK PRIMARY KEY (cedula),
	CONSTRAINT EMP_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE, 
	CONSTRAINT EMP_CH_NRO_CTA CHECK (regexp_like (numero_cuenta, '^[[:digit:]]+$') AND length(numero_cuenta)='20') ENABLE
);

CREATE TABLE empleado_tecnico(
	cedula NUMBER(8) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	apellido VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11),
	numero_cuenta CHAR(20) NOT NULL ENABLE,
	nombre_banco VARCHAR(20) NOT NULL ENABLE,
	tipo VARCHAR(8),
	CONSTRAINT EMP_TEC_PK PRIMARY KEY (cedula),
	CONSTRAINT EMP_TEC_CH_TIPO CHECK (tipo IN('HARDWARE', 'SOFTWARE', 'AMBAS')) ENABLE,
	CONSTRAINT EMP_TEC_CH_TLF CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE, 
	CONSTRAINT EMP_TEC_CH_NRO_CTA CHECK (regexp_like (numero_cuenta, '^[[:digit:]]+$') AND length(numero_cuenta)='20') ENABLE
);

CREATE TABLE articulo(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia NUMBER(4) NOT NULL ENABLE,
	CONSTRAINT ART_PK PRIMARY KEY (codigo),
	CONSTRAINT ART_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT ART_CH_CANT_EXIST CHECK (cant_existencia >= 0) ENABLE
);

CREATE TABLE repuesto(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia NUMBER(4) NOT NULL ENABLE,
	CONSTRAINT REPU_PK PRIMARY KEY (codigo) ENABLE,
	CONSTRAINT REPU_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT REPU_CH_CANT_EXIST CHECK (cant_existencia >= 0) ENABLE
);

CREATE TABLE herramienta(
	codigo NUMBER NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	ced_tecnico NUMBER(8) DEFAULT NULL,
	CONSTRAINT HER_PK PRIMARY KEY (codigo),
	CONSTRAINT HER_FK_CED_TECNICO FOREIGN KEY (ced_tecnico) REFERENCES empleado_tecnico(cedula) ON DELETE SET NULL,
	CONSTRAINT HER_CH_COSTO CHECK (costo >= 0) ENABLE
);

CREATE TABLE cliente(
	doc_identidad NUMBER(10) NOT NULL ENABLE,
	nombre_completo VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11) NOT NULL ENABLE,
	direccion VARCHAR(120) NOT NULL ENABLE,
	email VARCHAR(50),
	estado CHAR(1) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT CLIENTE_PK PRIMARY KEY (doc_identidad),
	CONSTRAINT CLIENTE_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT CLIENTE_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') AND length(telefono)='11') ENABLE
);
--FALTA CHECK PARA VALIDAR EL EMAIL.

CREATE TABLE marca(
	codigo NUMBER NOT NULL ENABLE, 
	nombre VARCHAR(20) NOT NULL ENABLE,
	estado CHAR(1) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT MARCA_PK PRIMARY KEY (codigo),
	CONSTRAINT MARCA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
);

CREATE TABLE modelo(
	codigo NUMBER NOT NULL ENABLE, 
	nombre VARCHAR(20) NOT NULL ENABLE,
	codigo_marca NUMBER NOT NULL ENABLE,
	estado CHAR(1) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT MODELO_PK PRIMARY KEY (codigo),
	CONSTRAINT MODELO_FK_CODIGO_MARCA FOREIGN KEY (codigo_marca) REFERENCES marca(codigo) ON DELETE CASCADE,
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
	CONSTRAINT EQUIPO_FK_CODIGO_MODELO FOREIGN KEY (codigo_modelo) REFERENCES modelo(codigo),
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
	doc_identidad_cliente NUMBER(10) NOT NULL ENABLE,
	CONSTRAINT ORDEN_PK PRIMARY KEY (numero),
	CONSTRAINT ORDEN_FK_DOC_IDENTIDAD_CLIENTE FOREIGN KEY (doc_identidad_cliente) REFERENCES cliente(doc_identidad),
	CONSTRAINT ORDEN_CH_ESTADO CHECK (estado IN('EN ESPERA', ' ES REVISION', 'EN REPARACION', 'DEVUELTO', 'TERMINADO', 'ENTREGADO')) ENABLE,
	CONSTRAINT ORDEN_CH_PRECIO CHECK (precio >= 0) ENABLE,
	CONSTRAINT ORDEN_CH_TIPO_FALLA CHECK (tipo_falla IN('HARDWARE', 'SOFTWARE', 'AMBAS')) ENABLE
);


CREATE TABLE pertenece_a(
	numero_orden NUMBER NOT NULL ENABLE,
	serial_equipo VARCHAR(60) NOT NULL ENABLE,
	CONSTRAINT PERT_PK PRIMARY KEY (numero_orden,serial_equipo),
	CONSTRAINT PERT_FK_NUMERO_ORDEN FOREIGN KEY (numero_orden) REFERENCES orden(numero),
	CONSTRAINT PERT_FK_SERIAL_EQUIPO FOREIGN KEY (serial_equipo) REFERENCES equipo(serial_equipo)
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
	CONSTRAINT REP_PK PRIMARY KEY (fecha_hora,cedula_tecnico,numero_orden),
	CONSTRAINT REP_FK_NRO_ORDEN FOREIGN KEY (numero_orden) REFERENCES orden(numero),
	CONSTRAINT REP_FK_CED_TEC FOREIGN KEY (cedula_tecnico) REFERENCES empleado_tecnico(cedula),
	CONSTRAINT REP_CH_ESTADO CHECK (estado IN('TERMINADO', 'REPARANDO', 'EN_ESPERA')),
	CONSTRAINT REP_CH_TIPO_REP CHECK (tipo_reparacion IN('SOFTWARE', 'HARDWARE', 'AMBAS'))
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
	CONSTRAINT USA_FK_REPUESTO FOREIGN KEY (codigo_repuesto) REFERENCES repuesto(codigo),
	CONSTRAINT USA_FK_REPARACION FOREIGN KEY (fecha_hora_reparacion, cedula_tecnico_reparacion, numero_orden_reparacion) REFERENCES reparacion(fecha_hora, numero_orden, cedula_tecnico),
	CONSTRAINT USA_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT USA_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE proveedor(
	rif VARCHAR(10) NOT NULL ENABLE,
	nombre VARCHAR(20) NOT NULL ENABLE,
	fecha_registro DATE DEFAULT sysdate NOT NULL ENABLE,
	telefono NUMBER(11) NOT NULL ENABLE,
	direccion VARCHAR(50) NOT NULL ENABLE,
	email VARCHAR(50), --FALTA CHECK PARA EL EMAIL
	estado VARCHAR(8) DEFAULT 'A' NOT NULL ENABLE,
	CONSTRAINT PROVEEDOR_PK PRIMARY KEY (rif),
	CONSTRAINT PROVEEDOR_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT PROVEEDOR_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') and length(telefono)='11') ENABLE
);


CREATE TABLE factura_compra(
	fecha DATE DEFAULT sysdate NOT NULL ENABLE,
	total NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE,
	numero NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	tipo VARCHAR(7) NOT NULL ENABLE,
	CONSTRAINT FC_PK PRIMARY KEY (numero,rif_proveedor),
	CONSTRAINT FC_FK_RIF_PROVEEDOR FOREIGN KEY (rif_proveedor) REFERENCES proveedor(rif),
	CONSTRAINT FC_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
	CONSTRAINT FC_CH_TOTAL CHECK (total >= 0) ENABLE
);

CREATE TABLE actualiza_articulo(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_articulo NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACT_ART_PK PRIMARY KEY (rif_proveedor, codigo_articulo, numero_factura_compra),
	CONSTRAINT ACT_ART_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACT_ART_FK_ARTICULO FOREIGN KEY (codigo_articulo) REFERENCES articulo(codigo),
	CONSTRAINT ACT_ART_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT ACT_ART_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACT_ART_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE actualiza_repuesto(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_repuesto NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACT_REP_PK PRIMARY KEY (rif_proveedor, codigo_repuesto, numero_factura_compra),
	CONSTRAINT ACT_REP_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACT_REP_FK_REPUESTO FOREIGN KEY (codigo_repuesto) REFERENCES repuesto(codigo),
	CONSTRAINT ACT_REP_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT ACT_REP_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACT_REP_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE actualiza_herramienta( --Sin cantidad porque las herramientas se manejan por unidad.
	numero_factura_compra NUMBER NOT NULL ENABLE,
	codigo_herramienta NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACT_HERR_PK PRIMARY KEY (rif_proveedor, codigo_herramienta, numero_factura_compra),
	CONSTRAINT ACT_HERR_FK_FACTURA FOREIGN KEY (rif_proveedor,numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ACT_HERR_FK_HERRAMIENTA FOREIGN KEY (codigo_herramienta) REFERENCES herramienta(codigo),
	CONSTRAINT ACT_HERR_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACT_HERR_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE cuenta_por_pagar(
	numero_factura_compra NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	fecha DATE DEFAULT sysdate NOT NULL ENABLE,
	monto NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE,
	saldo NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE,
	CONSTRAINT CPP_PK PRIMARY KEY (numero_factura_compra, rif_proveedor),
	CONSTRAINT CPP_FK_FC FOREIGN KEY (numero_factura_compra,rif_proveedor) REFERENCES factura_compra(numero,rif_proveedor),
	CONSTRAINT CPP_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CPP_CH_SALDO CHECK (saldo >= 0) ENABLE
);

CREATE TABLE abono(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) DEFAULT 0 NOT NULL ENABLE,
	fecha_hora TIMESTAMP DEFAULT sysdate NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	numero_factura_compra NUMBER NOT NULL ENABLE,
	numero_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	CONSTRAINT ABONO_PK PRIMARY KEY (referencia,rif_proveedor,numero_factura_compra,fecha_hora),
	CONSTRAINT ABONO_FK_NRO_CTA FOREIGN KEY (numero_cuenta_tienda) REFERENCES cuenta(numero),
	CONSTRAINT ABONO_FK_FC FOREIGN KEY (rif_proveedor, numero_factura_compra) REFERENCES factura_compra(rif_proveedor,numero),
	CONSTRAINT ABONO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT ABONO_CH_NRO_CTA CHECK (regexp_like (numero_cuenta_tienda, '^[[:digit:]]+$') and length(numero_cuenta_tienda)='20')
);

CREATE TABLE factura_venta(
	numero NUMBER NOT NULL ENABLE, 
	fecha DATE DEFAULT sysdate NOT NULL ENABLE, 
	total NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE, 
	tipo VARCHAR(7) NOT NULL ENABLE,
	doc_identidad_cliente NUMBER(10) NOT NULL ENABLE,
	numero_orden NUMBER NOT NULL ENABLE,
	estado VARCHAR(10) NOT NULL ENABLE, --PENDIENTE ACTUALIZAR CUANDO SE INSERTE UNA CUENTA POR COBRAR CON UN NUMERO DE FACTURA PERTENECIENTE A ESTA TABLA, AUTOMATICAMENTE PASA A PENDIENTE Y SI LA MISMA CUENTA LLEGA A TENER SU SALDO A 0 ENTONCES PASA A PAGADA
	CONSTRAINT FV_PK PRIMARY KEY (numero),
	CONSTRAINT FV_FK_DOC_CLIENTE FOREIGN KEY (doc_identidad_cliente) REFERENCES cliente(doc_identidad),
	CONSTRAINT FV_FK_NUMERO_ORDEN FOREIGN KEY (numero_orden) REFERENCES orden(numero),
	CONSTRAINT FV_CH_TOTAL CHECK (total >= 0),
	CONSTRAINT FV_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
	CONSTRAINT FV_CH_ESTADO CHECK (estado IN('PAGADA', 'PENDIENTE', 'DEVUELTA'))
);

CREATE TABLE incluye(
	numero_factura_venta NUMBER NOT NULL ENABLE,
	codigo_articulo NUMBER NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	pvp NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT INCLUYE_PK PRIMARY KEY (codigo_articulo,numero_factura_venta),
	CONSTRAINT INCLUYE_FK_FACTURA FOREIGN KEY (numero_factura_venta) REFERENCES factura_venta(numero),
	CONSTRAINT INCLUYE_FK_ARTICULO FOREIGN KEY (codigo_articulo) REFERENCES articulo(codigo),
	CONSTRAINT INCLUYE_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT INCLUYE_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT INCLUYE_CH_PVP CHECK (pvp > 0)
);

CREATE TABLE cuenta_por_cobrar(
	numero_factura_venta NUMBER NOT NULL ENABLE,
	doc_identidad_cliente NUMBER(8) NOT NULL ENABLE,
	fecha DATE DEFAULT sysdate NOT NULL ENABLE,
	monto NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE,
	saldo NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE,
	CONSTRAINT CPC_PK PRIMARY KEY (numero_factura_venta, doc_identidad_cliente),
	CONSTRAINT CPC_FK_FACTURA_VENTA FOREIGN KEY (numero_factura_venta) REFERENCES factura_venta(numero),
	CONSTRAINT CPC_FK_DOC_ID_CLIENTE FOREIGN KEY (doc_identidad_cliente) REFERENCES cliente(doc_identidad),
	CONSTRAINT CPC_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CPC_CH_SALDO CHECK (saldo >= 0) ENABLE
);

CREATE TABLE pago(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) DEFAULT 0 NOT NULL ENABLE,
	fecha_hora TIMESTAMP DEFAULT sysdate NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	numero_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	numero_factura_venta NUMBER NOT NULL ENABLE,
	CONSTRAINT PAGO_PK PRIMARY KEY (referencia,numero_factura_venta,fecha_hora),
	CONSTRAINT PAGO_FK_NRO_CTA FOREIGN KEY (numero_cuenta_tienda) REFERENCES cuenta(numero),
	CONSTRAINT PAGO_FK_FV FOREIGN KEY (numero_factura_venta) REFERENCES factura_venta(numero),
	CONSTRAINT PAGO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT PAGO_CH_NRO_CTA CHECK (regexp_like (numero_cuenta_tienda, '^[[:digit:]]+$') and length(numero_cuenta_tienda)='20')
);

CREATE TABLE venta_web(
	numero NUMBER NOT NULL ENABLE, 
	estado VARCHAR(10) DEFAULT 'ESPERA' NOT NULL ENABLE, --ESTADOS PUEDEN SER CONFIRMADA, RECHADA O ESPERA
	fecha DATE NOT NULL ENABLE,
	monto_total NUMBER(10,2) DEFAULT 0 NOT NULL ENABLE, --ATRIBUTO DERIVADO
	doc_id_cliente NUMBER(8) NOT NULL ENABLE,
	tipo_retiro VARCHAR(10) DEFAULT 'FISICO' NOT NULL ENABLE, 
	direccion_envio VARCHAR(250),
	medio_envio VARCHAR(50),
	fecha_envio DATE,
	numero_guia NUMBER(20),
	CONSTRAINT VENTA_WEB_PK PRIMARY KEY (numero),
	CONSTRAINT VENTA_WEB_FK_DOC_CLIENTE FOREIGN KEY (doc_id_cliente) REFERENCES cliente(doc_identidad),
	CONSTRAINT VENTA_WEB_CH_MONTO CHECK (monto_total >= 0),
	CONSTRAINT VENTA_WEB_CH_TR CHECK (tipo_retiro IN('FISICO', 'DOMICILIO')),
	CONSTRAINT VENTA_WEB_CH_MENVIO CHECK (medio_envio IN('ZOOM', 'DOMESA', 'DHL', 'MRW', 'TEALCA')),
	CONSTRAINT VENTA_WEB_CH_ESTADO CHECK (estado IN('CONFIRMADA', 'RECHAZADA', 'ESPERA'))
);

CREATE TABLE emite(
	numero_factura_venta NUMBER NOT NULL ENABLE,
	numero_venta_web NUMBER NOT NULL ENABLE,
	CONSTRAINT EMITE_PK PRIMARY KEY (numero_venta_web),
	CONSTRAINT EMITE_FK_NRO_FACTURA FOREIGN KEY (numero_factura_venta) REFERENCES factura_venta(numero),
	CONSTRAINT EMITE_FK_NRO_VENTA_WEB FOREIGN KEY (numero_venta_web) REFERENCES venta_web(numero)
);

CREATE TABLE posee(
	codigo_articulo NUMBER NOT NULL ENABLE,
	numero_venta_web NUMBER NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	pvp NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT POSEE_PK PRIMARY KEY (codigo_articulo,numero_venta_web),
	CONSTRAINT POSEE_FK_ARTICULO FOREIGN KEY (codigo_articulo) REFERENCES articulo(codigo),
	CONSTRAINT POSEE_FK_NRO_VENTA_WEB FOREIGN KEY (numero_venta_web) REFERENCES venta_web(numero),
	CONSTRAINT POSEE_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT POSEE_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT POSEE_CH_PVP CHECK (pvp > 0)
);

--FALTAN TRIGGERS PARA ACTUALIZAR EL INVENTARIO CORRESPONDIENTE CADA VEZ QUE SE USE UN REPUESTO (USA) Y CUANDO SE VENDA EN UNA VENTA_WEB (POSEE)
--FALTAN TRIGGERS PARA CUANDO SE INSERTA UN ABONO/PAGO Y ES DE UNA CUENTA POR PAGAR/COBRAR, SE ACTUALICE EL SALDO DE LA MISMA.