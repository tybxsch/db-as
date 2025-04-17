USE delivery_db;

-- Consulta genérica em cada tabela
SELECT * FROM clients;
SELECT * FROM delivery_persons;
SELECT * FROM sandwiches;
SELECT * FROM addresses;
SELECT * FROM orders;
SELECT * FROM order_sandwiches;

-- Pedidos com dados do cliente e do entregador
SELECT
  o.order_id,
  o.order_date,
  o.status,
  c.name        AS client_name,
  dp.name       AS delivery_person_name
FROM orders o
JOIN clients c       ON o.client_id          = c.client_id
JOIN delivery_persons dp ON o.delivery_person_id = dp.delivery_person_id;

-- Itens de cada pedido com nome do sanduiche
SELECT
  os.order_id,
  s.name     AS sandwich_name,
  os.quantity
FROM order_sandwiches os
JOIN sandwiches s ON os.sandwich_id = s.sandwich_id
ORDER BY os.order_id;

-- Valor total de cada pedido
SELECT
  os.order_id,
  ROUND(SUM(s.price * os.quantity), 2) AS total_value
FROM order_sandwiches os
JOIN sandwiches s ON os.sandwich_id = s.sandwich_id
GROUP BY os.order_id;

-- Quantidade de pedidos por status
SELECT
  o.status,
  COUNT(*) AS count_by_status
FROM orders o
GROUP BY o.status;

-- Endereços completos de cada cliente
SELECT
  c.client_id,
  c.name,
  a.street,
  a.number,
  a.complement,
  a.zip_code,
  a.city
FROM clients c
JOIN addresses a ON c.client_id = a.client_id;

-- Total de sanduíches vendidos por tipo
SELECT
  s.name             AS sandwich_name,
  SUM(os.quantity)   AS total_sold
FROM order_sandwiches os
JOIN sandwiches s ON os.sandwich_id = s.sandwich_id
GROUP BY s.name
ORDER BY total_sold DESC;

-- Número de pedidos entregues por cada entregador
SELECT
  dp.delivery_person_id,
  dp.name            AS delivery_person_name,
  COUNT(o.order_id)  AS orders_assigned
FROM delivery_persons dp
LEFT JOIN orders o ON dp.delivery_person_id = o.delivery_person_id
GROUP BY dp.delivery_person_id, dp.name;

-- Pedidos EM PREPARAÇÃO nas últimas 24 horas
SELECT
  o.order_id,
  o.order_date,
  c.name            AS client_name
FROM orders o
JOIN clients c ON o.client_id = c.client_id
WHERE o.status = '0'
  AND o.order_date >= NOW() - INTERVAL 1 DAY
ORDER BY o.order_date DESC;
