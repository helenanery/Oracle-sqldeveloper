A criação de Materialized View Logs é obrigatória quando usamos REFRESH FAST em MATERIALIZED VIEWs no Oracle por razões de desempenho e rastreabilidade.

✅ Resumo rápido
👉 Materialized View Logs armazenam mudanças incrementais feitas nas tabelas base (inserts, updates e deletes), permitindo que o Oracle atualize apenas os dados que mudaram, e não a view inteira.

🧠 Por que o Oracle precisa disso?
Quando você usa REFRESH FAST, o Oracle:
1.	Evita recalcular toda a view.
2.	Verifica o que mudou nas tabelas de origem (usando os logs).
3.	Aplica apenas as mudanças necessárias à view materializada.
🔎 Sem os logs, o Oracle não tem como saber o que mudou — então ele obriga o uso do REFRESH COMPLETE (reconstruir toda a view).

📦 O que contém um Materialized View Log?
É uma tabela oculta que armazena:
•	ROWID da linha alterada.
•	Sequência de tempo (para saber a ordem das mudanças).
•	Colunas que mudaram (se você especificar).
•	Se definido: INCLUDING NEW VALUES, ele grava os valores novos das colunas (usado para FAST REFRESH com JOIN, WHERE, GROUP BY, etc.)

CREATE TABLE produtos (
    id_produto NUMBER PRIMARY KEY,
    nome_produto VARCHAR2(100),
    preco NUMBER(10,2)
);
CREATE TABLE vendas (
    id_venda NUMBER PRIMARY KEY,
    id_produto NUMBER,
    quantidade NUMBER,
    data_venda DATE,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Produtos
INSERT INTO produtos VALUES (1, 'Notebook', 3500.00);
INSERT INTO produtos VALUES (2, 'Mouse', 80.00);
INSERT INTO produtos VALUES (3, 'Teclado', 150.00);
INSERT INTO produtos VALUES (4, 'Placa de Vídeo', 50.00);
INSERT INTO produtos VALUES (5, 'Placa Mãe', 50.00);
-- Vendas
INSERT INTO vendas VALUES (101, 1, 2, TO_DATE('2025-07-01','YYYY-MM-DD'));
INSERT INTO vendas VALUES (102, 2, 10, TO_DATE('2025-07-02','YYYY-MM-DD'));
INSERT INTO vendas VALUES (103, 3, 5, TO_DATE('2025-07-03','YYYY-MM-DD'));
INSERT INTO vendas VALUES (104, 1, 1, TO_DATE('2025-07-05','YYYY-MM-DD'));
INSERT INTO vendas VALUES (105, 1, 4, TO_DATE('2025-07-05','YYYY-MM-DD'));
INSERT INTO vendas VALUES (106, 3, 1, TO_DATE('2025-07-05','YYYY-MM-DD'));
INSERT INTO vendas VALUES (107, 2, 1, TO_DATE('2025-07-05','YYYY-MM-DD'));
INSERT INTO vendas VALUES (108, 4, 1, TO_DATE('2025-07-05','YYYY-MM-DD'));
INSERT INTO vendas VALUES (109, 5, 3, TO_DATE('2025-07-05','YYYY-MM-DD'));

commit;

select * from vendas;
select * from produtos;

DROP MATERIALIZED VIEW LOG ON vendas;
DROP MATERIALIZED VIEW LOG ON produtos;
DROP MATERIALIZED VIEW mv_total_vendas_auto;


CREATE MATERIALIZED VIEW LOG ON produtos 
WITH ROWID, SEQUENCE (id_produto, nome_produto, preco) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON vendas 
WITH ROWID, SEQUENCE (id_produto, quantidade) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW mv_total_vendas_auto
BUILD IMMEDIATE
REFRESH FAST
START WITH SYSDATE
NEXT SYSDATE + 1/1440
AS
SELECT p.nome_produto,
       SUM(v.quantidade) AS total_vendido,
       SUM(v.quantidade * p.preco) AS valor_total
FROM produtos p
JOIN vendas v ON p.id_produto = v.id_produto
GROUP BY p.nome_produto;

select * from mv_total_vendas_auto;

GROUP BY e HAVING 

drop table funcionarios;
CREATE TABLE funcionarios (
    id            NUMBER PRIMARY KEY,
    nome          VARCHAR2(100),
    salario       NUMBER(10, 2),
    departamento  VARCHAR2(50),
    data_admissao DATE
);

INSERT INTO funcionarios VALUES (1, 'Ana Silva',       3000.00, 'RH',         TO_DATE('2018-01-15', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (2, 'Carlos Souza',    4500.00, 'TI',         TO_DATE('2019-03-10', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (3, 'Bruno Lima',      4000.00, 'TI',         TO_DATE('2020-06-05', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (4, 'Marina Castro',   2800.00, 'RH',         TO_DATE('2021-09-12', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (5, 'João Pedro',      3200.00, 'Financeiro', TO_DATE('2017-11-30', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (6, 'Laura Mendes',    5100.00, 'TI',         TO_DATE('2016-07-01', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (7, 'Pedro Gonçalves', 2900.00, 'Financeiro', TO_DATE('2022-02-18', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (8, 'Juliana Lopes',   3300.00, 'RH',         TO_DATE('2023-05-20', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (9, 'Fernanda Dias',   3700.00, 'Marketing',  TO_DATE('2019-12-01', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (10,'Rafael Martins',  4600.00, 'Marketing',  TO_DATE('2020-01-25', 'YYYY-MM-DD'));
INSERT INTO funcionarios VALUES (11, 'Manoel Pedro',    2500.00, 'Financeiro', TO_DATE('2022-02-18', 'YYYY-MM-DD'));


COMMIT;

=== CLAÚSULA GROUP BY
--- Agrupa os resultados por uma ou mais colunas (usado com funções agregadas).

=== CLAÚSULA HAVING
--- Filtra resultados agrupados (usado após GROUP BY).

-- Total de funcionários por departamento
SELECT departamento, COUNT(*) AS total_funcionarios
FROM funcionarios
GROUP BY departamento;

-- Salário médio por departamento
SELECT departamento, AVG(salario) AS media_salarial
FROM funcionarios
GROUP BY departamento;

-- Departamentos com mais de 2 funcionários
SELECT departamento, COUNT(*) AS total
FROM funcionarios
GROUP BY departamento
HAVING COUNT(*) > 2;

-- Maior e menor salário por departamento
SELECT departamento, MAX(salario) AS maior, MIN(salario) AS menor
FROM funcionarios
GROUP BY departamento;

-- total de funcionários por departamento e data de admissão
SELECT departamento, data_admissao, COUNT(*) AS total
FROM funcionarios
GROUP BY departamento, data_admissao
ORDER BY departamento, data_admissao;

select * from funcionarios;

-- SELECT departamento, COUNT(*) FROM funcionarios GROUP BY departamento;
SELECT departamento, COUNT(*) FROM funcionarios GROUP BY departamento;

SELECT departamento, nome FROM funcionarios GROUP BY departamento;

-- Toda coluna que não está dentro de uma função agregada (ex: SUM, AVG, COUNT) deve obrigatoriamente estar no GROUP BY.
-- Isso agrupa os funcionários por ano de admissão, usando uma função no GROUP BY.
SELECT TO_CHAR(data_admissao, 'YYYY') AS ano, COUNT(*)
FROM funcionarios
GROUP BY TO_CHAR(data_admissao, 'YYYY');

-- "Para cada departamento, conte quantos funcionários há."
SELECT departamento, COUNT(*) 
FROM funcionarios
GROUP BY departamento;

-- xemplo sem função agregada (incomum, mas possível):
-- Isso funciona e retorna uma lista dos departamentos distintos.
SELECT departamento
FROM funcionarios
GROUP BY departamento;

SELECT DISTINCT departamento
FROM funcionarios;

-- Todas as colunas que aparecem no SELECT e não estão em uma função agregada, devem obrigatoriamente estar no GROUP BY.
-- Exemplo inválido (vai dar erro ORA-00979):
SELECT nome, departamento
FROM funcionarios
GROUP BY departamento;

É obrigatório usar função agregada com GROUP BY? Não.
Você não é obrigado a usar funções agregadas com GROUP BY, mas na prática o GROUP BY só faz sentido quando você quer agregar alguma informação.

=== O que o GROUP BY faz?
--- O GROUP BY agrupa registros iguais com base nas colunas especificadas. A utilidade principal é aplicar funções de agregação sobre esses grupos, como:

COUNT()
SUM()
AVG()
MAX()
MIN()

== WHERE - Antes da agregação (filtra linhas) - (filtra antes do agrupamento)
== HAVING - Depois da agregação (filtra grupos) - (filtra após o agrupamento)

-- Aqui ele primeiro elimina quem ganha até 3000, depois calcula a média por departamento.
SELECT departamento, AVG(salario)
FROM funcionarios
WHERE salario > 3000
GROUP BY departamento;

-- Aqui ele calcula a média primeiro, depois filtra os departamentos cuja média é maior que 3500.
SELECT departamento, AVG(salario) AS media
FROM funcionarios
GROUP BY departamento
HAVING AVG(salario) > 3500;

== Posso usar HAVING sem GROUP BY?
-- Tecnicamente, sim, mas só se a consulta tiver uma função agregada.
-- Funciona. Aqui, é como se o Oracle agrupasse tudo em um único grupo implícito.
SELECT COUNT(*) AS total_funcionarios
FROM funcionarios
HAVING COUNT(*) > 5;


-- Agrupa os valores de uma coluna em uma string separada por delimitador.          
SELECT departamento, LISTAGG(nome, ', ') WITHIN GROUP (ORDER BY nome) AS nomes
FROM funcionarios
GROUP BY departamento;

