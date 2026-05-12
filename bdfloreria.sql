-- ============================================================
--  Base de datos: bdfloreria
--  Proyecto: Floeria
--  Descripción: Sistema de gestión para florería
-- ============================================================

CREATE DATABASE IF NOT EXISTS bdfloreria
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bdfloreria;

-- ------------------------------------------------------------
-- 1. CATEGORIA
-- ------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria   INT             NOT NULL AUTO_INCREMENT,
    nombre         VARCHAR(80)     NOT NULL,
    descripcion    TEXT,
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
);

-- ------------------------------------------------------------
-- 2. PROVEEDOR
-- ------------------------------------------------------------
CREATE TABLE proveedor (
    id_proveedor   INT             NOT NULL AUTO_INCREMENT,
    nombre         VARCHAR(120)    NOT NULL,
    contacto       VARCHAR(100),
    telefono       VARCHAR(20),
    email          VARCHAR(120),
    direccion      TEXT,
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor)
);

-- ------------------------------------------------------------
-- 3. EMPLEADO
-- ------------------------------------------------------------
CREATE TABLE empleado (
    id_empleado        INT             NOT NULL AUTO_INCREMENT,
    nombre             VARCHAR(80)     NOT NULL,
    apellido           VARCHAR(80)     NOT NULL,
    cargo              VARCHAR(60),
    email              VARCHAR(120)    NOT NULL,
    fecha_contratacion DATE,
    CONSTRAINT pk_empleado     PRIMARY KEY (id_empleado),
    CONSTRAINT uq_empleado_email UNIQUE (email)
);

-- ------------------------------------------------------------
-- 4. CLIENTE
-- ------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente      INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(80)     NOT NULL,
    apellido        VARCHAR(80)     NOT NULL,
    email           VARCHAR(120)    NOT NULL,
    telefono        VARCHAR(20),
    direccion       TEXT,
    fecha_registro  DATE            NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT pk_cliente       PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_email UNIQUE (email)
);

-- ------------------------------------------------------------
-- 5. PRODUCTO
-- ------------------------------------------------------------
CREATE TABLE producto (
    id_producto      INT              NOT NULL AUTO_INCREMENT,
    id_categoria     INT              NOT NULL,
    id_proveedor     INT              NOT NULL,
    nombre           VARCHAR(120)     NOT NULL,
    descripcion      TEXT,
    precio_unitario  DECIMAL(10,2)    NOT NULL CHECK (precio_unitario >= 0),
    stock_disponible INT              NOT NULL DEFAULT 0 CHECK (stock_disponible >= 0),
    unidad_medida    VARCHAR(20),
    temporada        VARCHAR(40),
    CONSTRAINT pk_producto       PRIMARY KEY (id_producto),
    CONSTRAINT fk_producto_cat   FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_producto_prov  FOREIGN KEY (id_proveedor)
        REFERENCES proveedor (id_proveedor)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 6. PEDIDO
-- ------------------------------------------------------------
CREATE TABLE pedido (
    id_pedido      INT              NOT NULL AUTO_INCREMENT,
    id_cliente     INT              NOT NULL,
    id_empleado    INT              NOT NULL,
    fecha_pedido   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega  DATE,
    estado         ENUM('pendiente','en_proceso','listo','entregado','cancelado')
                                    NOT NULL DEFAULT 'pendiente',
    total          DECIMAL(10,2)    DEFAULT 0.00,
    notas          TEXT,
    CONSTRAINT pk_pedido          PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_cliente  FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 7. DETALLE_PEDIDO
-- ------------------------------------------------------------
CREATE TABLE detalle_pedido (
    id_detalle      INT              NOT NULL AUTO_INCREMENT,
    id_pedido       INT              NOT NULL,
    id_producto     INT              NOT NULL,
    cantidad        INT              NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2)    NOT NULL CHECK (precio_unitario >= 0),
    subtotal        DECIMAL(10,2)    GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    CONSTRAINT pk_detalle          PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_pedido   FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 8. PAGO
-- ------------------------------------------------------------
CREATE TABLE pago (
    id_pago       INT              NOT NULL AUTO_INCREMENT,
    id_pedido     INT              NOT NULL,
    fecha_pago    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto         DECIMAL(10,2)    NOT NULL CHECK (monto > 0),
    metodo_pago   ENUM('efectivo','tarjeta_debito','tarjeta_credito','transferencia','otro')
                                   NOT NULL,
    estado        ENUM('completado','pendiente','reembolsado')
                                   NOT NULL DEFAULT 'completado',
    CONSTRAINT pk_pago        PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 9. ENVIO  (entidad adicional para entregas a domicilio)
-- ------------------------------------------------------------
CREATE TABLE envio (
    id_envio            INT              NOT NULL AUTO_INCREMENT,
    id_pedido           INT              NOT NULL,
    id_empleado         INT,
    direccion_entrega   TEXT             NOT NULL,
    fecha_programada    DATETIME         NOT NULL,
    fecha_entregado     DATETIME,
    estado              ENUM('programado','en_camino','entregado','fallido')
                                         NOT NULL DEFAULT 'programado',
    costo_envio         DECIMAL(10,2)    DEFAULT 0.00,
    notas               TEXT,
    CONSTRAINT pk_envio           PRIMARY KEY (id_envio),
    CONSTRAINT fk_envio_pedido    FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_envio_empleado  FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- ------------------------------------------------------------
-- 10. PROMOCION  (descuentos y ofertas por temporada)
-- ------------------------------------------------------------
CREATE TABLE promocion (
    id_promocion    INT              NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(100)     NOT NULL,
    descripcion     TEXT,
    descuento_pct   DECIMAL(5,2)     NOT NULL CHECK (descuento_pct BETWEEN 0 AND 100),
    fecha_inicio    DATE             NOT NULL,
    fecha_fin       DATE             NOT NULL,
    activa          TINYINT(1)       NOT NULL DEFAULT 1,
    CONSTRAINT pk_promocion PRIMARY KEY (id_promocion),
    CONSTRAINT chk_fechas_promo CHECK (fecha_fin >= fecha_inicio)
);

-- ------------------------------------------------------------
-- 10a. PRODUCTO_PROMOCION  (relación N:M entre producto y promoción)
-- ------------------------------------------------------------
CREATE TABLE producto_promocion (
    id_producto  INT NOT NULL,
    id_promocion INT NOT NULL,
    CONSTRAINT pk_prod_promo      PRIMARY KEY (id_producto, id_promocion),
    CONSTRAINT fk_pp_producto     FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pp_promocion    FOREIGN KEY (id_promocion)
        REFERENCES promocion (id_promocion)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ============================================================
--  TRIGGERS
-- ============================================================

DELIMITER $$

-- Recalcular total del pedido al insertar detalle
CREATE TRIGGER trg_recalcular_total_insert
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM detalle_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

-- Recalcular total del pedido al eliminar detalle
CREATE TRIGGER trg_recalcular_total_delete
AFTER DELETE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM detalle_pedido
        WHERE id_pedido = OLD.id_pedido
    )
    WHERE id_pedido = OLD.id_pedido;
END$$

-- Reducir stock al confirmar detalle
CREATE TRIGGER trg_reducir_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock_disponible = stock_disponible - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END$$

DELIMITER ;

-- ============================================================
--  ÍNDICES adicionales para consultas frecuentes
-- ============================================================

CREATE INDEX idx_pedido_cliente   ON pedido (id_cliente);
CREATE INDEX idx_pedido_estado    ON pedido (estado);
CREATE INDEX idx_pedido_fecha     ON pedido (fecha_pedido);
CREATE INDEX idx_producto_cat     ON producto (id_categoria);
CREATE INDEX idx_envio_estado     ON envio (estado);
CREATE INDEX idx_pago_metodo      ON pago (metodo_pago);

-- ============================================================
--  DATOS DE EJEMPLO
-- ============================================================

INSERT INTO categoria (nombre, descripcion) VALUES
  ('Rosas',              'Todas las variedades de rosas'),
  ('Arreglos fúnebres',  'Coronas, bases y arreglos para servicios fúnebres'),
  ('Plantas de interior','Plantas decorativas para interiores'),
  ('Bouquets de novia',  'Ramos y arreglos para bodas'),
  ('Flores tropicales',  'Heliconias, aves del paraíso, anturios');

INSERT INTO proveedor (nombre, contacto, telefono, email) VALUES
  ('Flores del Valle S.A.',  'Martín López',   '614-100-1111', 'ventas@floresdelvalle.mx'),
  ('Jardines Chihuahua',     'Ana Ríos',        '614-200-2222', 'pedidos@jardineschi.mx'),
  ('Viveros Norteños',       'Carlos Mendoza',  '614-300-3333', 'info@viverosn.mx');

INSERT INTO empleado (nombre, apellido, cargo, email, fecha_contratacion) VALUES
  ('Sofía',   'Ramírez',  'Florista',    'sofia@floreria.mx',   '2022-03-15'),
  ('Diego',   'Torres',   'Vendedor',    'diego@floreria.mx',   '2021-07-01'),
  ('Valeria', 'Núñez',    'Repartidora', 'valeria@floreria.mx', '2023-01-10');

INSERT INTO cliente (nombre, apellido, email, telefono, fecha_registro) VALUES
  ('Laura',   'Sánchez',  'laura.s@email.com',  '614-555-0001', '2024-01-20'),
  ('Roberto', 'Pérez',    'roberto.p@email.com','614-555-0002', '2024-02-14'),
  ('Gabriela','Morales',  'gabi.m@email.com',   '614-555-0003', '2024-03-05');

INSERT INTO producto (id_categoria, id_proveedor, nombre, precio_unitario, stock_disponible, unidad_medida, temporada) VALUES
  (1, 1, 'Rosa roja premium',       25.00, 200, 'pieza',   'Todo el año'),
  (1, 1, 'Rosa blanca',             20.00, 150, 'pieza',   'Todo el año'),
  (4, 2, 'Bouquet novia clásico',  850.00,  10, 'arreglo', 'Todo el año'),
  (3, 3, 'Pothos colgante',        120.00,  30, 'maceta',  'Todo el año'),
  (5, 2, 'Ave del paraíso',        180.00,  25, 'vara',    'Primavera');

INSERT INTO promocion (nombre, descuento_pct, fecha_inicio, fecha_fin) VALUES
  ('San Valentín 2025', 15.00, '2025-02-10', '2025-02-14'),
  ('Día de las Madres', 10.00, '2025-05-05', '2025-05-10');

INSERT INTO producto_promocion VALUES (1, 1),(2, 1),(3, 2),(4, 2);
