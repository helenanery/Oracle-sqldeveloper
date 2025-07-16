-- Criação de tabela mãe/pai

CREATE TABLE clientes (
    cliente_id NUMBER PRIMARY KEY,
    nome VARCHAR2(50)
);
drop table pedidos;
drop table clientes;
-- Criação de tabela filha/filho

CREATE TABLE pedidos (
    pedido_id NUMBER PRIMARY KEY,
    cliente_id NUMBER,
    produto VARCHAR2(50),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Insert tabela clientes

INSERT INTO clientes VALUES (1, 'Ana');
INSERT INTO clientes VALUES (2, 'Bruno');
INSERT INTO clientes VALUES (3, 'Carlos');

-- Insert tabela pedidos

INSERT INTO pedidos VALUES (101, 1, 'Notebook');
INSERT INTO pedidos VALUES (102, 1, 'Mouse');
INSERT INTO pedidos VALUES (103, NULL, 'Monitor');
INSERT INTO pedidos VALUES (104, 4, 'Teclado'); -- cliente_id 4 não existe, por isso aparece violação


select * from clientes;

select * from pedidos;

commit;

SELECT c.nome AS nome_cliente, 
p.produto
FROM clientes c
RIGHT JOIN pedidos p 
ON c.cliente_id = p.cliente_id;
