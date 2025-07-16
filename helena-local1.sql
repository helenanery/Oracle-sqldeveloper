CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nome_cliente VARCHAR2(50)
);

CREATE TABLE pedidos (
    id_pedido NUMBER PRIMARY KEY,
    id_cliente NUMBER,
    produto VARCHAR2(50),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO clientes VALUES (1, 'Ana');
INSERT INTO clientes VALUES (2, 'Bruno');
INSERT INTO clientes VALUES (3, 'Carla');
INSERT INTO clientes VALUES (4, 'Daniela'); 
INSERT INTO clientes VALUES (5, 'Helena'); 

delete from clientes
where id_cliente=5;

INSERT INTO pedidos VALUES (101, 1, 'Notebook');
INSERT INTO pedidos VALUES (102, 2, 'Impressora');
INSERT INTO pedidos VALUES (103, 2, 'Mouse');
INSERT INTO pedidos VALUES (104, 4, 'Teclado');
INSERT INTO pedidos VALUES (105, 5, 'Teclado');

delete from pedidos 
where id_cliente = 5;

commit;

SELECT
    c.id_cliente,
    c.nome_cliente,
    p.id_pedido,
    p.produto
FROM
    clientes c
LEFT JOIN
    pedidos p
ON
    c.id_cliente = p.id_cliente;

SELECT nome_cliente
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL;

SELECT c.nome AS nome_cliente, p.produto
FROM clientes c
RIGHT JOIN pedidos p ON c.cliente_id = p.cliente_id;

commit;
