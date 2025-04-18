-- Cria o banco de dados e seleciona
CREATE DATABASE IF NOT EXISTS delivery_db;
USE delivery_db;

-- Tabela de clientes
CREATE TABLE clients (
  client_id INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(100)  NOT NULL,
  phone     VARCHAR(20)   NOT NULL
);

-- Tabela de entregadores
CREATE TABLE delivery_persons (
  delivery_person_id INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name               VARCHAR(100)  NOT NULL,
  phone              VARCHAR(20)   NOT NULL
);

-- Tabela de sanduíches
CREATE TABLE sandwiches (
  sandwich_id INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)  NOT NULL,
  price       DECIMAL(10,2) NOT NULL
);

-- Tabela de endereços
CREATE TABLE addresses (
  address_id  INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  client_id   INT           NOT NULL,
  street      VARCHAR(150)  NOT NULL,
  zip_code    VARCHAR(20)   NOT NULL,
  number      VARCHAR(10)   NOT NULL,
  complement  VARCHAR(100),
  city        VARCHAR(100)  NOT NULL,
  FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Tabela de pedidos, com UUID em order_id
CREATE TABLE orders (
  order_id            CHAR(36)      NOT NULL PRIMARY KEY,
  client_id           INT           NOT NULL,
  delivery_person_id  INT           NOT NULL,
  status              ENUM('0','1','2') NOT NULL DEFAULT '0',
  order_date          DATETIME      NOT NULL,
  FOREIGN KEY (client_id)          REFERENCES clients(client_id),
  FOREIGN KEY (delivery_person_id) REFERENCES delivery_persons(delivery_person_id)
);

-- Trigger para preencher order_id automaticamente
DELIMITER $$
CREATE TRIGGER before_orders_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  IF NEW.order_id IS NULL OR NEW.order_id = '' THEN
    SET NEW.order_id = UUID();
  END IF;
END$$
DELIMITER ;

-- Procedure para criar um cliente com endereço
DELIMITER $$
CREATE PROCEDURE create_client_with_address(
  IN p_name       VARCHAR(100),
  IN p_phone      VARCHAR(20),
  IN p_street     VARCHAR(150),
  IN p_zip_code   VARCHAR(20),
  IN p_number     VARCHAR(10),
  IN p_complement VARCHAR(100),
  IN p_city       VARCHAR(100)
)
BEGIN
  DECLARE new_id INT;
  START TRANSACTION;
    INSERT INTO clients (name, phone)
    VALUES (p_name, p_phone);
    SET new_id = LAST_INSERT_ID();

    INSERT INTO addresses (
      client_id, street, zip_code, number, complement, city
    ) VALUES (
      new_id, p_street, p_zip_code, p_number, p_complement, p_city
    );
  COMMIT;
END$$
DELIMITER ;

-- Tabela entre pedidos e sanduiches
CREATE TABLE order_sandwiches (
  order_id    CHAR(36) NOT NULL,
  sandwich_id INT      NOT NULL,
  quantity    INT      NOT NULL,
  PRIMARY KEY (order_id, sandwich_id),
  FOREIGN KEY (order_id)    REFERENCES orders(order_id),
  FOREIGN KEY (sandwich_id) REFERENCES sandwiches(sandwich_id)
);
