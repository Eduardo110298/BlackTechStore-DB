--ENTIDADES FUERTES
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
	codigo NUMBER NOT NULL ENABLE, --HACER TRIGGER PARA AUTO INCREMENTAR ESTE CAMPO
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia NUMBER(4) NOT NULL ENABLE,
	CONSTRAINT ARTICULO_PK PRIMARY KEY (codigo),
	CONSTRAINT ARTICULO_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT ARTICULO_CH_CANT_EXISTENCIA CHECK (cant_existencia >= 0) ENABLE,
);

CREATE SEQUENCE incarticulo --SECUENCIA PARA CODIGO DEL ARTICULO EN LA TABLA ARTICULO 
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE repuesto(
	codigo NUMBER NOT NULL ENABLE, --HACER UN TRIGGER PARA LA INSERCION Y SE AUTOINCREMENTE EL CAMPO
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	cant_existencia INTEGER(4) NOT NULL ENABLE,
	CONSTRAINT REPUESTO_PK PRIMARY KEY (cod_repuesto) ENABLE,
	CONSTRAINT REPUESTO_CH_COSTO CHECK (costo >= 0) ENABLE,
	CONSTRAINT RESPUESTO_CH_CANT_EXISTENCIA CHECK (cant_existencia >= 0) ENABLE,
);

CREATE SEQUENCE cvrep --SECUENCIA PARA EL NUMERO DE VENTA EN LA TABLA VENTA WEB 
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE herramienta(
	codigo NUMBER NOT NULL ENABLE, --HACER EL TRIGGER PARA ESTE ATRIBUTO AUTOINCREMENTAL
	costo NUMBER(10,2) NOT NULL ENABLE,
	nombre VARCHAR(50) NOT NULL ENABLE,
	descripcion VARCHAR(120),
	ced_tecnico NUMBER(8),
	CONSTRAINT HERRAMIENTA_PK PRIMARY KEY (codigo),
	CONSTRAINT HERRAMIENTA_FK_CED_TECNICO FOREIGN KEY ced_tecnico REFERENCES empleado_tecnico(cedula),
	CONSTRAINT HERRAMIENTA_CH COSTO CHECK (costo >= 0) ENABLE
);

CREATE SEQUENCE cvherramienta --SECUENCIA PARA CODIGO DE LA HERRAMIENTA DE LA TABLA HERRAMIENTA 
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE cliente(
	doc_identidad NUMBER(10) NOT NULL ENABLE,
	nombre_completo VARCHAR(50) NOT NULL ENABLE,
	telefono CHAR(11) NOT NULL ENABLE,
	direccion VARCHAR(120) NOT NULL ENABLE,
	email VARCHAR(50),
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT CLIENTE_PK PRIMARY KEY (doc_identidad),
	CONSTRAINT CLIENTE_CH_ESTADO CHECK (estado IN('A','I')) ENABLE,
	CONSTRAINT CLIENTE_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') and length(telefono)='11') ENABLE
);

CREATE TABLE marca(
	nro_marca NUMBER NOT NULL ENABLE, --HACER EL TRIGGER QUE AUMENTA EL VALOR DEL CAMPO
	nombre VARCHAR(20) NOT NULL ENABLE,
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT MARCA_PK PRIMARY KEY (nro_marca),
	CONSTRAINT MARCA_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
);

CREATE SEQUENCE cvmarca --SECUENCIA EL CAMPO AUTOINCREMENTAL NUMERO DE LA MARCA DE LA TABLA MARCA
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE modelo(
	nro_modelo NUMBER NOT NULL ENABLE, --CAMPO AUTOINCREMENTAL HACER TRIGGER
	nombre VARCHAR(20) NOT NULL ENABLE,
	nro_marca NUMBER NOT NULL ENABLE,
	estado CHAR(1) NOT NULL ENABLE DEFAULT 'A',
	CONSTRAINT MODELO_PK PRIMARY KEY (nro_modelo),
	CONSTRAINT MODELO_FK_NRO_MARCA FOREIGN KEY nro_marca REFERENCES marca(nro_marca),
	CONSTRAINT MODELO_CH_ESTADO CHECK (estado IN('A','I')) ENABLE
);

CREATE SEQUENCE cvmodelo --SECUENCIA EL CAMPO AUTOINCREMENTAL NUMERO DEL MODELO DE LA TABLA MODELO
	START WITH 1
	INCREMENT BY 1;


CREATE TABLE cuenta_por_cobrar(
	nro_factura NUMBER NOT NULL ENABLE,
	doc_id_cliente NUMBER(8) NOT NULL ENABLE,
	fecha DATE NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	saldo NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	CONSTRAINT CUENTA_POR_COBRAR_PK PRIMARY KEY (nro_factura, doc_id_cliente),
	CONSTRAINT CUENTA_POR_COBRAR_DOC_ID_CLIENTE FOREIGN KEY doc_id_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT CUENTA_POR_COBRAR_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CUENTA_POR_COBRAR_CH_SALDO CHECK (saldo >= 0) ENABLE
);

CREATE TABLE cuenta_por_pagar(
	nro_factura_compra NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	fecha DATE NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	saldo NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	CONSTRAINT CUENTA_POR_PAGAR_PK PRIMARY KEY (nro_factura, rif_proveedor),
	CONSTRAINT CUENTA_POR_PAGAR_FK_RIF_PROVEEDOR FOREIGN KEY rif_proveedor REFERENCES proveedor(rif_proveedor),
	CONSTRAINT CUENTA_POR_PAGAR_CH_MONTO CHECK (monto >= 0) ENABLE,
	CONSTRAINT CUENTA_POR_PAGAR_CH_SALDO CHECK (saldo >= 0) ENABLE
);


CREATE TABLE equipo(
	eq_serial VARCHAR(60) NOT NULL ENABLE,
	imei VARCHAR(60),
	descripcion VARCHAR(120),
	nro_modelo NUMBER NOT NULL ENABLE,
	tipo VARCHAR(11) NOT NULL ENABLE,
	CONSTRAINT EQUIPO_PK PRIMARY KEY (eq_serial),
	CONSTRAINT EQUIPO_FK FOREIGN KEY nro_modelo REFERENCES modelo(nro_modelo),
	CONSTRAINT EQUIPO_CH_TIPO CHECK (tipo IN('TABLET','COMPUTADOR', 'LAPTOP','CELULAR')) ENABLE
);


CREATE TABLE factura(
	num_factura NUMBER NOT NULL ENABLE, --HACER UN TRIGGER PARA LA INSERCION Y SE AUTOINCREMENTE EL CAMPO
	forma_pago VARCHAR(15) NOT NULL ENABLE,
	fecha DATE NOT NULL ENABLE, 
	total NUMBER(10,2) NOT NULL ENABLE DEFAULT 0, 
	tipo VARCHAR(7) NOT NULL ENABLE,
	doc_id_cliente VARCHAR(8) NOT NULL ENABLE,
	num_orden NUMBER NOT NULL ENABLE,
	estado VARCHAR(10) NOT NULL ENABLE,
	CONSTRAINT FACTURA_PK PRIMARY KEY (num_factura),
	CONSTRAINT FACTURA_FK_DOC_CLIENTE FOREIGN KEY doc_id_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT FACTURA_FK_NUM_ORDEN FOREIGN KEY num_orden REFERENCES orden(nro_orden),
	CONSTRAINT FACTURA_CH_TOTAL CHECK (total >= 0),
	CONSTRAINT FACTURA_CH_FP CHECK (forma_pago IN('CREDITO', 'DEBITO', 'EFECTIVO')),
	CONSTRAINT FACTURA_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
	CONSTRAINT FACTURA_CH_ESTADO CHECK (estado IN('PAGADA', 'PENDIENTE', 'DEVUELTA'))
);

CREATE SEQUENCE cvfactura --SECUENCIA PARA EL NUMERO DE FACTURA EN LA FACTURA 
	START WITH 1
	INCREMENT BY 1;


CREATE TABLE orden(
	nro_orden NUMBER NOT NULL ENABLE, -- TRIGGER PARA HACER EL AUTO INCREMENTO
	estado VARCHAR(13) NOT NULL ENABLE,
	concepto VARCHAR(120) NOT NULL ENABLE,
	fecha_entrada DATE NOT NULL ENABLE,
	fecha_salida DATE NOT NULL ENABLE,
	precio NUMBER(10,2) NOT NULL ENABLE,
	tipo_falla VARCHAR(25) NOT NULL ENABLE,
	doc_id_cliente VARCHAR(8) NOT NULL ENABLE,
	CONSTRAINT ORDEN_PK PRIMARY KEY (nro_orden),
	CONSTRAINT ORDEN_FK_CEDULA FOREIGN KEY doc_id_cliente REFERENCES cliente(doc_identidad),
	CONSTRAINT ORDEN_CH_ESTADO CHECK (estado IN('EN ESPERA', ' ES REVISION', 'EN REPARACION', 'DEVUELTO', 'TERMINADO', 'ENTREGADO')) ENABLE,
	CONSTRAINT ORDEN_CH_PRECIO CHECK (precion >= 0) ENABLE,
	CONSTRAINT ORDEN_CH_TIPO_FALLA CHECK (tipo_falla IN('HARDWARE', 'SOFTWARE', 'AMBAS')) ENABLE
);

CREATE SEQUENCE cvorden --SECUENCIA EL CAMPO AUTOINCREMENTAL NUMERO DEL MODELO DE LA TABLA MODELO
	START WITH 1
	INCREMENT BY 1;


CREATE TABLE proveedor(
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	nombre VARCHAR(20) NOT NULL ENABLE, --COLOCAR EL CHECK PARA PERMITIR SOLO LETRAS
	fecha_registro DATE NOT NULL ENABLE,
	tlf_prov NUMBER(11) NOT NULL ENABLE,
	dir_prov VARCHAR(50) NOT NULL ENABLE,
	estado_prov VARCHAR(8) NOT NULL ENABLE DEFAULT 'A',
	email_prov VARCHAR(50),
	CONSTRAINT PROVEDOR_PK PRIMARY KEY (rif_proveedor),
	CONSTRAINT PROV_CH_TELEFONO CHECK (regexp_like (telefono, '^[[:digit:]]+$') and length(telefono)='11') ENABLE
);



CREATE TABLE venta_web(
	nro_venta NUMBER NOT NULL ENABLE, --HACER UN TRIGGER PARA LA INSERCION Y SE AUTOINCREMENTE EL CAMPO
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

CREATE SEQUENCE cvweb --SECUENCIA PARA EL NUMERO DE VENTA EN LA TABLA VENTA WEB 
	START WITH 1
	INCREMENT BY 1;

CREATE TABLE abono(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	fecha DATE NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	nro_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	nro_factura_compra NUMBER NOT NULL ENABLE,
	CONSTRAINT ABONO_PK PRIMARY KEY (referencia,rif_proveedor,nro_factura_compra),
	CONSTRAINT ABONO_FK_NRO_CUENTA FOREIGN KEY nro_cuenta_tienda REFERENCES cuenta(numero),
	CONSTRAINT ABONO_FK_CUENTA_POR_PAGAR FOREIGN KEY (rif_proveedor,nro_factura_compra) REFERENCES cuenta_por_pagar(rif_proveedor,nro_factura_compra),
	CONSTRAINT ABONO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT ABONO_CH_NUMERO_CUENTA_TIENDA CHECK (regexp_like (numero, '^[[:digit:]]+$') and length(numero)='20')	
);

CREATE TABLE actualiza(
	nro_factura_compra NUMBER NOT NULL ENABLE,
	codigo NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT ACTUALIZA_PK PRIMARY KEY (rif_proveedor, codigo, nro_factura_compra),
	CONSTRAINT ACTUALIZA_FK_FACTURA FOREIGN KEY (rif_proveedor,nro_factura_compra) REFERENCES factura_compra(rif_proveedor,nro_factura_compra),
	CONSTRAINT ACTUALIZA_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT ACTUALIZA_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT ACTUALIZA_CH_COSTO CHECK (costo > 0)
);

CREATE TABLE emite(
	nro_factura NUMBER NOT NULL ENABLE,
	nro_venta_web NUMBER NOT NULL ENABLE,
	CONSTRAINT EMITE_PK PRIMARY KEY nro_venta_web,
	CONSTRAINT EMITE_FK_NRO_FACTURA FOREIGN KEY nro_factura REFERENCES factura(num_factura),
	CONSTRAINT EMITE_FK_NRO_VENTA_WEB FOREIGN KEY nro_venta_web REFERENCES venta_web(nro_venta),
);

CREATE TABLE factura_compra(
	fecha DATE NOT NULL ENABLE,
	total NUMBER(10,2) NOT NULL ENABLE DEFAULT 0,
	nro_factura_compra NUMBER NOT NULL ENABLE,
	rif_proveedor VARCHAR(10) NOT NULL ENABLE,
	tipo VARCHAR(7) NOT NULL ENABLE,
	CONSTRAINT FACTURA_COMPRA_PK PRIMARY KEY (nro_factura_compra,rif_proveedor),
	CONSTRAINT FACTURA_COMPRA_FK_RIF_PROVEEDOR FOREIGN KEY rif_proveedor REFERENCES proveedor(rif_proveedor),
	CONSTRAINT FACTURA_COMPRA_CH_TIPO CHECK (tipo IN('CONTADO', 'CREDITO')),
);

CREATE SEQUENCE cvfacturacompra --SECUENCIA PARA EL NUMERO DE VENTA EN LA TABLA VENTA WEB 
	START WITH 1
	INCREMENT BY 1;

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

CREATE TABLE pago(
	tipo VARCHAR(15) NOT NULL ENABLE,
	banco VARCHAR(100) NOT NULL ENABLE,
	monto NUMBER(11,2) NOT NULL ENABLE DEFAULT 0,
	fecha DATE NOT NULL ENABLE,
	referencia NUMBER NOT NULL ENABLE,
	doc_identidad_cliente VARCHAR(10) NOT NULL ENABLE,
	nro_cuenta_tienda CHAR(20) NOT NULL ENABLE,
	nro_factura NUMBER NOT NULL ENABLE,
	CONSTRAINT PAGO_PK PRIMARY KEY (referencia,rif_proveedor,nro_factura),
	CONSTRAINT PAGO_FK_NRO_CUENTA FOREIGN KEY nro_cuenta_tienda REFERENCES cuenta(numero),
	CONSTRAINT PAGO_FK_CUENTA_POR_COBRAR FOREIGN KEY (doc_identidad_cliente,nro_factura) REFERENCES cuenta_por_cobrar(doc_identidad_cliente,nro_factura),
	CONSTRAINT PAGO_CH_TIPO CHECK (tipo IN('DEBITO', 'CREDITO', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT PAGO_CH_NUMERO_CUENTA_TIENDA CHECK (regexp_like (numero, '^[[:digit:]]+$') and length(numero)='20')	
);

CREATE TABLE pertenece_a(
	nro_orden NUMBER NOT NULL ENABLE,
	serial_equipo VARCHAR(60) NOT NULL ENABLE,
	CONSTRAINT PERTENECE_PK PRIMARY KEY (nro_orden,serial_equipo),
	CONSTRAINT PERTENECE_FK_NRO_ORDEN FOREIGN KEY nro_orden REFERENCES orden(nro_orden),
	CONSTRAINT PERTENECE_FK_SERIAL_EQUIPO FOREIGN KEY serial_equipo REFERENCES equipo(eq_serial)
);

CREATE TABLE posee(
	cod_articulo NUMBER NOT NULL ENABLE,
	nro_venta_web NUMBER NOT NULL ENABLE,
	cantidad NUMBER NOT NULL ENABLE,
	subtotal NUMBER(10,2) NOT NULL ENABLE,
	pvp NUMBER(10,2) NOT NULL ENABLE,
	CONSTRAINT PAGO_PK PRIMARY KEY (cod_articulo,nro_venta_web),
	CONSTRAINT PAGO_FK_ARTICULO FOREIGN KEY cod_articulo REFERENCES articulo(codigo),
	CONSTRAINT PAGO_FK_NRO_VENTA_WEB FOREIGN KEY nro_venta_web REFERENCES venta_web(nro_venta),
	CONSTRAINT PAGO_CH_CANTIDAD CHECK (cantidad >= 0),
	CONSTRAINT PAGO_CH_SUBTOTAL CHECK (subtotal > 0),
	CONSTRAINT PAGO_CH_PVP CHECK (pvp > 0)
);

CREATE TABLE reparacion(
	fecha_inicio DATE NOT NULL ENABLE,
	estado VARCHAR(9) NOT NULL ENABLE,
	comision NUMBER(10,2) NOT NULL ENABLE,
	tipo_reparacion VARCHAR(8) NOT NULL ENABLE,
	fecha_hora TIMESTAMP DEFAULT sysdate NOT NULL ENABLE,
	cedula_tecnico NUMBER(8) NOT NULL ENABLE,
	nro_orden NUMBER NOT NULL ENABLE,
	fecha_fin DATE NOT NULL ENABLE,
	descripcion VARCHAR(200),
	CONSTRAINT REPARACION_PK PRIMARY KEY (fecha_hora,cedula_tecnico,nro_orden),
	CONSTRAINT REPARACION_FK_NRO_ORDEN FOREIGN KEY nro_orden REFERENCES orden(nro_orden),
	CONSTRAINT REPARACION_FK_CEDULA_TECNICO FOREIGN KEY cedula_tecnico REFERENCES empleado_tecnico(cedula),
	CONSTRAINT REPARACION_CH_ESTADO CHECK (estado IN('TERMINADO', 'REPARANDO', 'EN_ESPERA')),
	CONSTRAINT REPARACION_CH_TIPO_REPARACION CHECK (tipo_reparacion IN('SOFTWARE', 'HARDWARE', 'AMBAS'))
);

CREATE TABLE usa(
	cod_repuesto NUMBER NOT NULL ENABLE,
	fecha_hora_reparacion TIMESTAMP NOT NULL ENABLE,
	nro_orden NUMBER NOT NULL ENABLE,
	cedula_tecnico NUMBER(8) NOT NULL ENABLE,
	costo NUMBER(10,2) NOT NULL ENABLE,
	observacion VARCHAR(120),
	cant_usada NUMBER NOT NULL ENABLE,
	CONSTRAINT USA_PK PRIMARY KEY (cod_repuesto, fecha_hora, nro_orden,cedula_tecnico),
	CONSTRAINT USA_FK_REPUESTO FOREIGN KEY cod_repuesto REFERENCES repuesto(cod_repuesto),
	CONSTRAINT USA_FK_REPARACION FOREIGN KEY (fecha_hora_reparacion,cedula_tecnico,nro_orden) REFERENCES reparacion(fecha_hora,nro_orden,cedula_tecnico)	
);
--FALTAN TRIGGERS PARA SECUENCIAS DE AUTOINCREMENTO
--FALTAN TRIGGERS PARA ACTUALIZACION DE DETALLES DE COMPRAS Y DE VENTA
--FALTAN TRIGGERS PARA CAMBIO DE ESTADO DE LA ORDEN AL CAMBIAR TODAS LAS REPARACIONES DE LA MISMA A TERMINADO
--FALTAN INDICES ALTERNOS
--FALTAN VISTAS PARA LOS USUARIOS