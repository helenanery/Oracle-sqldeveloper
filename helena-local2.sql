CREATE TABLE departamentos (
    id_departamento NUMBER PRIMARY KEY,
    nome_departamento VARCHAR2(100)
);

drop table departamentos;

drop table funcionarios;

CREATE TABLE funcionarios (
    id_funcionario NUMBER PRIMARY KEY,
    nome_funcionario VARCHAR2(100),
    salario NUMBER(10, 2),
    id_departamento NUMBER,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

INSERT INTO departamentos VALUES (1, 'Recursos Humanos');
INSERT INTO departamentos VALUES (2, 'TI');
INSERT INTO departamentos VALUES (3, 'Financeiro');

INSERT INTO funcionarios VALUES (101, 'Ana', 3500.00, 1);
INSERT INTO funcionarios VALUES (102, 'Carlos', 4500.00, 2);
INSERT INTO funcionarios VALUES (103, 'Bruna', 4700.00, 2);
INSERT INTO funcionarios VALUES (104, 'Daniel', 3900.00, 3);
INSERT INTO funcionarios VALUES (105, 'Fernanda', 3200.00, 1);
INSERT INTO funcionarios VALUES (106, 'Helena', 3200.00, 3);

commit;

SELECT * FROM FUNCIONARIOS;

CREATE or REPLACE VIEW vw_funcionarios_ti AS
SELECT nome_funcionario, salario
FROM funcionarios
WHERE id_departamento = 3

CREATE MATERIALIZED VIEW mt_funcionarios_ti AS
SELECT nome_funcionario, salario
FROM funcionarios
WHERE id_departamento = 3

select * from vw_funcionarios_ti;

EXEC DBMS_MVIEW.REFRESH('MT_FUNCIONARIOS_TI');

select * from mt_funcionarios_ti;

-- Ver todas as views do usuário:
SELECT view_name FROM user_views;

-- Ver o código de uma view:
SELECT text FROM user_views WHERE view_name = 'VW_FUNCIONARIOS_TI';

CREATE VIEW vw_funcionarios_departamentos AS
SELECT f.nome_funcionario, f.salario, d.nome_departamento
FROM funcionarios f
JOIN departamentos d ON f.id_departamento = d.id_departamento;

select * from vw_funcionarios_departamentos; 

CREATE VIEW vw_salario_anual AS
SELECT nome_funcionario, salario * 12 AS salario_anual
FROM funcionarios;

select * from vw_salario_anual;

UPDATE vw_funcionarios_ti
SET salario = salario + 500
WHERE nome_funcionario = 'Daniel';

CREATE OR REPLACE VIEW vw_funcionarios_departamentos AS
SELECT f.id_funcionario,
       f.nome_funcionario,
       f.salario,
       d.id_departamento,
       d.nome_departamento
FROM funcionarios f
JOIN departamentos d ON f.id_departamento = d.id_departamento;

CREATE OR REPLACE TRIGGER trg_update_vw_funcionarios_departamentos
INSTEAD OF UPDATE ON vw_funcionarios_departamentos
FOR EACH ROW
BEGIN
  -- Atualizar a tabela funcionarios
  UPDATE funcionarios
  SET nome_funcionario = :NEW.nome_funcionario,
      salario = :NEW.salario,
      id_departamento = :NEW.id_departamento
  WHERE id_funcionario = :OLD.id_funcionario;

  -- Atualizar a tabela departamentos (se necessário)
  UPDATE departamentos
  SET nome_departamento = :NEW.nome_departamento
  WHERE id_departamento = :OLD.id_departamento;
END;

-- Usar a view para atualizar
UPDATE vw_funcionarios_departamentos
SET salario = 5000,
    nome_departamento = 'TI e Inovação'
WHERE id_funcionario = 102;

COMMIT;


