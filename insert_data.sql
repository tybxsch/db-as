USE delivery_db;

-- Clientes com endereço pela procedure
CALL create_client_with_address(
  'Alice Silva',
  '11999990000',
  'Rua das Flores',
  '01001000',
  '123',
  'Apto 12',
  'São Paulo'
);
CALL create_client_with_address(
  'Bruno Souza',
  '21988881111',
  'Av. Brasil',
  '20040030',
  '456',
  NULL,
  'Rio de Janeiro'
);
CALL create_client_with_address(
  'Carla Pereira',
  '31977772222',
  'Praça Sete',
  '30100000',
  '789',
  'Sala 5',
  'Belo Horizonte'
);
CALL create_client_with_address(
  'Daniel Oliveira',
  '11933334444',
  'Rua Deputado',
  '20132400',
  '432',
  'Apto 110',
  'Curitiba'
);
CALL create_client_with_address(
  'Eva Lima',
  '21922223333',
  'Av. Mauá',
  '04123432',
  '115',
  NULL,
  'Curitiba'
);
CALL create_client_with_address(
  'Felipe Gomes',
  '31911112222',
  'Rua Cruzeiro',
  '3031222',
  '1138',
  'Fundos',
  'Pinhais'
);

CALL create_client_with_address(
  'Fulano de Tal',
  '31911112222',
  'Rua Batata',
  '3031222',
  '3345',
  'Número 0',
  'Laguna'
);

-- Entregadores
INSERT INTO delivery_persons (name, phone) VALUES
  ('Pedro Almeida',   '11955553333'),
  ('Maria Costa',     '21944442222'),
  ('Rodrigo Santos',  '11977778888'),
  ('Ana Paula',       '21966669999'),
  ('Lucas Mendes',    '31955556666');

-- Sanduiches
INSERT INTO sandwiches (name, price) VALUES
  ('X-Burger',            15.50),
  ('X-Salada',            18.00),
  ('Misto Quente',        10.00),
  ('Vegetariano',         20.00),
  ('Frango com Catupiry', 22.50);

-- Pedidos com order_id gerado pelo trigger
INSERT INTO orders (client_id, delivery_person_id, status, order_date) VALUES
  (1, 1, '0', '2025-04-17 20:15:00'),
  (2, 2, '0', '2025-04-17 20:20:00'),
  (4, 3, '0', '2025-04-17 21:00:00'),
  (4, 1, '1', '2025-04-17 21:05:00'),
  (5, 4, '1', '2025-04-17 21:10:00'),
  (6, 5, '2', '2025-04-17 21:15:00'),
  (1, 4, '2', '2025-04-17 21:20:00'),
  (2, 2, '0', '2025-04-17 21:25:00');

-- Itens dos pedidos
INSERT INTO order_sandwiches (order_id, sandwich_id, quantity) VALUES
  -- Alice Silva
  (
    (SELECT order_id FROM orders
     WHERE client_id = 1 AND order_date = '2025-04-17 20:15:00'),
    1, 2
  ),
  (
    (SELECT order_id FROM orders
     WHERE client_id = 1 AND order_date = '2025-04-17 20:15:00'),
    3, 1
  ),

  -- Bruno Souza
  (
    (SELECT order_id FROM orders
     WHERE client_id = 2 AND order_date = '2025-04-17 20:20:00'),
    2, 3
  ),

  -- Daniel Oliveira
  (
    (SELECT order_id FROM orders
     WHERE client_id = 4 AND order_date = '2025-04-17 21:00:00'),
    1, 1
  ),
  (
    (SELECT order_id FROM orders
     WHERE client_id = 4 AND order_date = '2025-04-17 21:00:00'),
    2, 2
  ),

  -- Daniel Oliveira
  (
    (SELECT order_id FROM orders
     WHERE client_id = 4 AND order_date = '2025-04-17 21:05:00'),
    3, 1
  ),

  -- Eva Lima
  (
    (SELECT order_id FROM orders
     WHERE client_id = 5 AND order_date = '2025-04-17 21:10:00'),
    2, 1
  ),
  (
    (SELECT order_id FROM orders
     WHERE client_id = 5 AND order_date = '2025-04-17 21:10:00'),
    3, 2
  ),

  -- Felipe Gomes
  (
    (SELECT order_id FROM orders
     WHERE client_id = 6 AND order_date = '2025-04-17 21:15:00'),
    1, 3
  ),

  -- Alice Silva extra
  (
    (SELECT order_id FROM orders
     WHERE client_id = 1 AND order_date = '2025-04-17 21:20:00'),
    3, 2
  ),

  -- Bruno Souza extra
  (
    (SELECT order_id FROM orders
     WHERE client_id = 2 AND order_date = '2025-04-17 21:25:00'),
    1, 1
  ),
  (
    (SELECT order_id FROM orders
     WHERE client_id = 2 AND order_date = '2025-04-17 21:25:00'),
    2, 1
  );
