O que é uma Procedure no Oracle?
Uma Procedure é um bloco de código PL/SQL armazenado no banco de dados, que pode ser executado sob demanda. Ela pode conter comandos SQL e PL/SQL, aceitar parâmetros, e realizar operações complexas — como inserções, atualizações, validações, cálculos, entre outros.
drop table funcionarios;
CREATE TABLE funcionarios (
    id_funcionario NUMBER PRIMARY KEY,
    nome           VARCHAR2(100),
    salario         NUMBER
);

CREATE OR REPLACE PROCEDURE inserir_funcionario (
    p_id_funcionario IN funcionarios.id_funcionario%TYPE,
    p_nome           IN funcionarios.nome%TYPE,
    p_salario        IN funcionarios.salario%TYPE
)
IS
BEGIN
    INSERT INTO funcionarios (id_funcionario, nome, salario)
    VALUES (p_id_funcionario, p_nome, p_salario);
    
    COMMIT;
END;
/

EXEC inserir_funcionario(1, 'Carlos Silva', 3500);
EXEC inserir_funcionario(2, 'Helena', 4500);
EXEC inserir_funcionario(3, 'Sérgio Oliveira', 3500);
EXEC inserir_funcionario(4, 'Dulce Carvalho', 5500);
EXEC inserir_funcionario(5, 'João Pedro', 3500);
EXEC inserir_funcionario(6, 'Juliana Alves', 4500);
EXEC inserir_funcionario(7, 'Paulo Roberto', 3600);
EXEC inserir_funcionario(8, 'Fernanda Souza', 3700);
EXEC inserir_funcionario(9, 'Ricardo Gomes', 3300);
EXEC inserir_funcionario(10, 'Camila Duarte', 4100);
EXEC inserir_funcionario(11, 'Rafael Lima', 2950);
EXEC inserir_funcionario(12, 'Larissa Menezes', 3850);
EXEC inserir_funcionario(13, 'Eduardo Castro', 2750);
EXEC inserir_funcionario(14, 'Patrícia Oliveira', 3400);
EXEC inserir_funcionario(15, 'Bruno Martins', 3600);
EXEC inserir_funcionario(16, 'João Pedro', 3500);
EXEC inserir_funcionario(17, 'Maria Clara', 4200);
EXEC inserir_funcionario(18, 'Carlos Henrique', 3100);
EXEC inserir_funcionario(19, 'Ana Beatriz', 3900);
EXEC inserir_funcionario(20, 'Lucas Silva', 2800);
EXEC inserir_funcionario(21, 'Tatiane Moreira', 3600);
EXEC inserir_funcionario(22, 'Marcos Paulo', 3050);
EXEC inserir_funcionario(23, 'Débora Santos', 3700);
EXEC inserir_funcionario(24, 'Vinícius Braga', 4500);
EXEC inserir_funcionario(25, 'Renata Lima', 3400);
EXEC inserir_funcionario(26, 'André Luiz', 3850);
EXEC inserir_funcionario(27, 'Carolina Souza', 3100);
EXEC inserir_funcionario(28, 'Fábio Cunha', 3300);
EXEC inserir_funcionario(29, 'Letícia Ribeiro', 2800);
EXEC inserir_funcionario(30, 'Roberto Nunes', 4000);
EXEC inserir_funcionario(31, 'Isabela Martins', 4200);
EXEC inserir_funcionario(32, 'Marcela Barros', 2750);
EXEC inserir_funcionario(33, 'Henrique Oliveira', 3650);
EXEC inserir_funcionario(34, 'Luciana Pires', 3500);
EXEC inserir_funcionario(35, 'Jorge Almeida', 3050);
EXEC inserir_funcionario(36, 'Thiago Mendes', 3200);
EXEC inserir_funcionario(37, 'Aline Ferreira', 3900);
EXEC inserir_funcionario(38, 'Gustavo Rocha', 2800);
EXEC inserir_funcionario(39, 'Vanessa Cardoso', 4100);
EXEC inserir_funcionario(40, 'Felipe Andrade', 2950);

select * from funcionarios;

CREATE OR REPLACE PROCEDURE obter_salario (
    p_id_funcionario IN funcionarios.id_funcionario%TYPE,
    p_salario        OUT funcionarios.salario%TYPE
)
IS
BEGIN
    SELECT salario INTO p_salario
    FROM funcionarios
    WHERE id_funcionario = p_id_funcionario;
END;
/

VARIABLE v_salario NUMBER
EXEC obter_salario(1, :v_salario)
PRINT v_salario

set serveroutput on;
CREATE OR REPLACE PROCEDURE exemplo_erro (
    p_id_funcionario IN funcionarios.id_funcionario%TYPE
)
IS
    v_nome funcionarios.nome%TYPE;
BEGIN
    SELECT nome INTO v_nome
    FROM funcionarios
    WHERE id_funcionario = p_id_funcionario;
    
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/

EXEC exemplo_erro(41);
EXEC exemplo_erro(1);


O que é um Cursor?
Um cursor permite percorrer várias linhas de uma consulta dentro de um bloco PL/SQL. Dentro de uma procedure, 
ele é usado para iterar sobre resultados e aplicar lógica em cada linha.

-- Criar uma procedure que lista todos os funcionários e mostra o nome e salário usando DBMS_OUTPUT.
-- Procedure com cursor explícito
CREATE OR REPLACE PROCEDURE listar_funcionarios
IS
    -- Definição do cursor
    CURSOR c_func IS
        SELECT nome, salario
        FROM funcionarios;

    -- Variáveis para receber os valores do cursor
    v_nome funcionarios.nome%TYPE;
    v_salario funcionarios.salario%TYPE;
BEGIN
    -- Abrindo o cursor
    OPEN c_func;

    LOOP
        -- Buscando linha por linha
        FETCH c_func INTO v_nome, v_salario;

        -- Sai do loop quando não houver mais dados
        EXIT WHEN c_func%NOTFOUND;

        -- Exibe os dados
        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome || ', Salário: R$' || v_salario);
    END LOOP;

-- Fechando o cursor
    CLOSE c_func;
END;
/

SET SERVEROUTPUT ON;
EXEC listar_funcionarios;

-- Versão com FOR e cursor implícito (mais simples)
CREATE OR REPLACE PROCEDURE listar_funcionarios_simples
IS
BEGIN
    FOR r IN (SELECT nome, salario FROM funcionarios) LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome || ', Salário: R$' || r.salario);
    END LOOP;
END;
/

EXEC listar_funcionarios_simples;

Diferença entre cursor explícito e implícito
Tipo	                          Controle	          Código	     Performance	             Simples?
Explícito  (OPEN, FETCH, CLOSE)   Mais controle       Mais longo     Ideal para controle fino    Não
Implícito  (FOR r IN (...))	      Menos controle      Mais curto     Mais fácil de usar	         Sim

Sintaxe geral de cursor com parâmetro:
CURSOR nome_cursor (parametro tipo) IS SELECT ... WHERE coluna = parametro;

CREATE OR REPLACE PROCEDURE listar_funcionarios_por_salario (
    p_min_salario IN NUMBER
)
IS
    -- Cursor com parâmetro
    CURSOR c_func (p_salario NUMBER) IS
        SELECT nome, salario
        FROM funcionarios
        WHERE salario = p_salario;

    -- Variáveis para os dados do cursor
    v_nome funcionarios.nome%TYPE;
    v_salario funcionarios.salario%TYPE;
BEGIN
    OPEN c_func(p_min_salario);  -- Passando o valor do parâmetro

    LOOP
        FETCH c_func INTO v_nome, v_salario;
        EXIT WHEN c_func%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome || ', Salário: R$' || v_salario);
    END LOOP;

    CLOSE c_func;
END;
/

SET SERVEROUTPUT ON;
EXEC listar_funcionarios_por_salario(3500);

select * from funcionarios;

Alternativa com FOR (cursor implícito com parâmetro)

CREATE OR REPLACE PROCEDURE listar_funcionarios_por_salario_simples (
    p_min_salario IN NUMBER
)
IS
BEGIN
    FOR r IN (
        SELECT nome, salario
        FROM funcionarios
        WHERE salario = p_min_salario
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome || ', Salário: R$' || r.salario);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC listar_funcionarios_por_salario_simples(3500);

=== parou aqui

Objetivo:
Criar uma procedure que aumenta o salário de todos os funcionários que ganham abaixo de um valor específico. O aumento será percentual.

CREATE OR REPLACE PROCEDURE aumentar_salario_funcionarios (
    p_limite_salario     IN NUMBER,
    p_percentual_aumento IN NUMBER
)
IS
    -- Cursor com filtro
    CURSOR c_func IS
        SELECT id_funcionario, salario
        FROM funcionarios
        WHERE salario < p_limite_salario;

    -- Variáveis do cursor
    v_id       funcionarios.id_funcionario%TYPE;
    v_salario  funcionarios.salario%TYPE;

    -- Variável para novo salário
    v_novo_salario NUMBER;
BEGIN
    OPEN c_func;

    LOOP
        FETCH c_func INTO v_id, v_salario;
        EXIT WHEN c_func%NOTFOUND;

        -- Cálculo do novo salário
        v_novo_salario := v_salario + (v_salario * p_percentual_aumento / 100);

        -- Atualiza na tabela
        UPDATE funcionarios
        SET salario = v_novo_salario
        WHERE id_funcionario = v_id;

        -- Mostra no console
        DBMS_OUTPUT.PUT_LINE('Funcionário ID: ' || v_id ||
                             ' | Salário antigo: ' || v_salario ||
                             ' | Novo salário: ' || v_novo_salario);
    END LOOP;

    CLOSE c_func;

    -- Confirma as alterações
    COMMIT;
END;
/

SET SERVEROUTPUT ON;
EXEC aumentar_salario_funcionarios(4000, 10);


O que é uma EXCEPTION no Oracle PL/SQL?
Uma EXCEPTION é um erro ou condição inesperada que ocorre durante a execução de um bloco PL/SQL.
Ela serve para interromper o fluxo normal do programa e permitir que você trate erros de forma controlada.
===========================================
DECLARE
    v_num NUMBER := 10;
    v_denom NUMBER := 0;
    v_resultado NUMBER;
BEGIN
    v_resultado := v_num / v_denom;  -- 🔥 Vai gerar erro (divisão por zero)
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_resultado);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: divisão por zero!');
END;

Tipos comuns de EXCEPTION pré-definidas
EXCEPTION	                Quando acontece
NO_DATA_FOUND	    Nenhum registro retornado em SELECT INTO
TOO_MANY_ROWS   SELECT INTO retorna mais de uma linha
ZERO_DIVIDE	    Divisão por zero
INVALID_CURSOR	    Operação inválida com cursor
OTHERS	                Qualquer outro erro não tratado especificamente

DECLARE
    v_nome funcionarios.nome%TYPE;
BEGIN
    SELECT nome INTO v_nome
    FROM funcionarios
    WHERE id_funcionario = 999;  -- ID inexistente

    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;

Criar suas próprias exceções (RAISE) - Você também pode criar suas exceções personalizadas, com mensagens:
DECLARE
    e_salario_baixo EXCEPTION;
    v_salario NUMBER := 500;
BEGIN
    IF v_salario < 1000 THEN
        RAISE e_salario_baixo;
    END IF;
EXCEPTION
    WHEN e_salario_baixo THEN
        DBMS_OUTPUT.PUT_LINE('Salário muito baixo!');
END;

===========================================


Exemplo prático: cursor com tratamento de exceções

CREATE OR REPLACE PROCEDURE aumentar_salario_com_erro (
    p_limite_salario     IN NUMBER,
    p_percentual_aumento IN NUMBER
)
IS
    -- Cursor com filtro
    CURSOR c_func IS
        SELECT id_funcionario, nome, salario
        FROM funcionarios
        WHERE salario < p_limite_salario;

    -- Variáveis do cursor
    v_id       funcionarios.id_funcionario%TYPE;
    v_nome     funcionarios.nome%TYPE;
    v_salario  funcionarios.salario%TYPE;
    v_novo_salario NUMBER;
BEGIN
    OPEN c_func;

    LOOP
        FETCH c_func INTO v_id, v_nome, v_salario;
        EXIT WHEN c_func%NOTFOUND;

        BEGIN
            -- Simulação de erro proposital para teste (ex: salário negativo)
            IF v_salario < 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'Salário inválido para o funcionário ' || v_nome);
            END IF;

            -- Calcula novo salário
            v_novo_salario := v_salario + (v_salario * p_percentual_aumento / 100);

            -- Atualiza
            UPDATE funcionarios
            SET salario = v_novo_salario
            WHERE id_funcionario = v_id;

            -- Mensagem de sucesso
            DBMS_OUTPUT.PUT_LINE('? Funcionário ' || v_nome || 
                                 ' | Salário atualizado: ' || v_novo_salario);

        EXCEPTION
            WHEN OTHERS THEN
                -- Mostra erro, mas não para a procedure
                DBMS_OUTPUT.PUT_LINE('? Erro ao atualizar ' || v_nome || 
                                     ': ' || SQLERRM);
        END;
    END LOOP;

    CLOSE c_func;
    COMMIT;
END;
/


SET SERVEROUTPUT ON;
EXEC aumentar_salario_com_erro(4000, 10);

=================
Objetivo:
Atualizar salários diretamente com cursor amarrado à linha atual, usando FOR UPDATE e WHERE CURRENT OF.
Essa abordagem evita erro de concorrência e garante que o registro atual do cursor será atualizado corretamente.

Explicações importantes:
Comando	                    O que faz
FOR UPDATE	        Trava as linhas selecionadas pelo cursor para update seguro.
WHERE CURRENT OF   Atualiza a linha atual do cursor, sem precisar do ID.

CREATE OR REPLACE PROCEDURE aumentar_salario_current_of (
    p_limite_salario     IN NUMBER,
    p_percentual_aumento IN NUMBER
)
IS
    -- Cursor com trava nas linhas
    CURSOR c_func IS
        SELECT id_funcionario, salario
        FROM funcionarios
        WHERE salario < p_limite_salario
        FOR UPDATE;  -- Trava a linha enquanto percorre

    -- Variáveis do cursor
    v_id      funcionarios.id_funcionario%TYPE;
    v_salario funcionarios.salario%TYPE;
    v_novo_salario NUMBER;
BEGIN
    OPEN c_func;

    LOOP
        FETCH c_func INTO v_id, v_salario;
        EXIT WHEN c_func%NOTFOUND;

        v_novo_salario := v_salario + (v_salario * p_percentual_aumento / 100);

        -- Atualiza a linha atual do cursor
        UPDATE funcionarios
        SET salario = v_novo_salario
        WHERE CURRENT OF c_func;

        DBMS_OUTPUT.PUT_LINE('Funcionário ID ' || v_id || 
                             ' | Novo salário: ' || v_novo_salario);
    END LOOP;

    CLOSE c_func;
    COMMIT;
END;
/
SET SERVEROUTPUT ON;
EXEC aumentar_salario_current_of(4000, 12);

select * from funcionarios;

Quando usar o FOR UPDATE?
Quando precisa garantir que ninguém mais altere os registros enquanto você processa.
Quando quer evitar erros de concorrência em ambientes com múltiplos usuários.
Em operações críticas, como reajuste de salários, movimentação de estoque, etc.

Observação:
FOR UPDATE trava as linhas até o COMMIT.
Se outra sessão tentar atualizar a mesma linha, ela ficará bloqueada até sua transação liberar.

O que são BULK COLLECT e FORALL?
Eles são usados para tratar grandes volumes de dados de forma eficiente em PL/SQL:

BULK COLLECT: carrega múltiplas linhas de uma vez para coleções (arrays).
FORALL:               executa comandos DML em lote, uma vez por item da coleção — sem loop lento.

Resultado: muito mais rápido que loops tradicionais com cursores!

CREATE OR REPLACE PROCEDURE aumentar_salario_bulk (
    p_limite_salario     IN NUMBER,
    p_percentual_aumento IN NUMBER
)
IS
    -- Coleções para dados
    TYPE t_ids      IS TABLE OF funcionarios.id_funcionario%TYPE;
    TYPE t_salarios IS TABLE OF funcionarios.salario%TYPE;
    v_ids      t_ids;
    v_salarios t_salarios;
    v_novos_salarios t_salarios;
BEGIN
    -- Buscar em lote os IDs e salários
    SELECT id_funcionario, salario
    BULK COLLECT INTO v_ids, v_salarios
    FROM funcionarios
    WHERE salario < p_limite_salario;

    -- Calcular os novos salários em memória
    v_novos_salarios := t_salarios();
    v_novos_salarios.EXTEND(v_salarios.COUNT);
    
    FOR i IN 1 .. v_salarios.COUNT LOOP
        v_novos_salarios(i) := v_salarios(i) + (v_salarios(i) * p_percentual_aumento / 100);
    END LOOP;

    -- Atualizar todos de uma vez
    FORALL i IN 1 .. v_ids.COUNT
        UPDATE funcionarios
        SET salario = v_novos_salarios(i)
        WHERE id_funcionario = v_ids(i);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('? ' || v_ids.COUNT || ' salários atualizados com sucesso.');
END;
/
SET SERVEROUTPUT ON;
EXEC aumentar_salario_bulk(4000, 20);

=======================================================
Procedure usando BULK COLLECT + LIMIT

CREATE OR REPLACE PROCEDURE aumentar_salario_em_batch (
    p_percentual_aumento IN NUMBER,
    p_batch_size         IN PLS_INTEGER DEFAULT 100
)
IS
    -- Tipos de coleção
    TYPE t_ids      IS TABLE OF funcionarios.id_funcionario%TYPE;
    TYPE t_salarios IS TABLE OF funcionarios.salario%TYPE;

    v_ids      t_ids;
    v_salarios t_salarios;
    v_novos_salarios t_salarios;

    CURSOR c_func IS
        SELECT id_funcionario, salario
        FROM funcionarios
        WHERE salario < 5000; -- por exemplo, filtro de salário

BEGIN
    OPEN c_func;

    LOOP
        -- Coleta os dados em lotes
        FETCH c_func BULK COLLECT INTO v_ids, v_salarios LIMIT p_batch_size;
        EXIT WHEN v_ids.COUNT = 0;

        -- Prepara novo array com salários atualizados
        v_novos_salarios := t_salarios();
        v_novos_salarios.EXTEND(v_salarios.COUNT);

        FOR i IN 1 .. v_salarios.COUNT LOOP
            v_novos_salarios(i) := v_salarios(i) + (v_salarios(i) * p_percentual_aumento / 100);
        END LOOP;

        -- Atualiza em lote com FORALL
        FORALL i IN 1 .. v_ids.COUNT
            UPDATE funcionarios
            SET salario = v_novos_salarios(i)
            WHERE id_funcionario = v_ids(i);

        -- Commit opcional a cada lote
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('? Lote de ' || v_ids.COUNT || ' funcionários processado.');
    END LOOP;

    CLOSE c_func;

    DBMS_OUTPUT.PUT_LINE('? Processamento completo!');
END;
/

SET SERVEROUTPUT ON;
EXEC aumentar_salario_em_batch(4);  -- Aumenta 4% em batches de 100 (padrão)

-- Ou com batch customizado:
EXEC aumentar_salario_em_batch(4, 50);  -- Aumenta 4% em batches de 50

=== Cursor Explícito + Parâmetro IN OUT

CREATE OR REPLACE PROCEDURE reajustar_salario_exp (
    p_id_funcionario IN OUT funcionarios.id_funcionario%TYPE,
    p_salario_novo   OUT funcionarios.salario%TYPE
)
IS
    -- Cursor explícito com parâmetro
    CURSOR c_func (v_id funcionarios.id_funcionario%TYPE) IS
        SELECT salario
        FROM funcionarios
        WHERE id_funcionario = v_id
        FOR UPDATE;

    v_salario funcionarios.salario%TYPE;
BEGIN
    -- Abrir cursor com o ID passado
    OPEN c_func(p_id_funcionario);

    FETCH c_func INTO v_salario;

    -- Aumentar 10%
    p_salario_novo := v_salario + (v_salario * 0.10);

    -- Atualizar usando WHERE CURRENT OF
    UPDATE funcionarios
    SET salario = p_salario_novo
    WHERE CURRENT OF c_func;

    CLOSE c_func;

    DBMS_OUTPUT.PUT_LINE('Salário reajustado para R$' || p_salario_novo);
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
END;
/

VAR v_id NUMBER
VAR v_salario NUMBER

EXEC :v_id := 11;
EXEC reajustar_salario_exp(:v_id, :v_salario);
PRINT v_id
PRINT v_salario


Imprimir um do lado do outro
set serveroutput on
DECLARE
    v_id        NUMBER := 41;
    v_salario   NUMBER;
BEGIN
    reajustar_salario_exp(v_id, v_salario);
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' | Salário: ' || v_salario);
END;

Recebo 01410. 00000 -  "invalid ROWID" 

UPDATE funcionarios
SET salario = ...
WHERE CURRENT OF c_func;  -- ❌ Aqui ocorre o erro ORA-01410

A Oracle não permite usar WHERE CURRENT OF quando o cursor não tem uma linha atual válida (porque o FETCH não retornou nada).

ORA-01410: invalid ROWID
Causa: Um UPDATE ou DELETE ... WHERE CURRENT OF foi executado, mas o cursor está apontando para linha nenhuma.

Você deve usar a variável embutida c_func%FOUND para confirmar se o cursor retornou algo.


=========
CREATE OR REPLACE PROCEDURE reajustar_salario_exp (
    p_id_funcionario IN OUT funcionarios.id_funcionario%TYPE,
    p_salario_novo   OUT funcionarios.salario%TYPE
)
IS
    CURSOR c_func (v_id funcionarios.id_funcionario%TYPE) IS
        SELECT salario
        FROM funcionarios
        WHERE id_funcionario = v_id
        FOR UPDATE;

    v_salario funcionarios.salario%TYPE;
BEGIN
    OPEN c_func(p_id_funcionario);
    FETCH c_func INTO v_salario;

    -- Verifica se encontrou
    IF c_func%FOUND THEN
        p_salario_novo := v_salario * 1.10;

        UPDATE funcionarios
        SET salario = p_salario_novo
        WHERE CURRENT OF c_func;

        DBMS_OUTPUT.PUT_LINE('Salário reajustado para R$' || p_salario_novo);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado.');
    END IF;

    CLOSE c_func;
    COMMIT;
END;
/

== Com cursor implícito
CREATE OR REPLACE PROCEDURE aumentar_salario_imp (
    p_salario_limite IN OUT NUMBER,
    p_afetados       OUT NUMBER
)
IS
    v_contador NUMBER := 0;
BEGIN
    FOR r IN (
        SELECT id_funcionario, salario
        FROM funcionarios
        WHERE salario < p_salario_limite
        FOR UPDATE
    ) LOOP
        UPDATE funcionarios
        SET salario = r.salario * 1.10
        WHERE CURRENT OF r;

        v_contador := v_contador + 1;
    END LOOP;

    p_afetados := v_contador;

    -- Atualiza o limite recebido (só pra fins de exemplo)
    p_salario_limite := p_salario_limite + 500;

    DBMS_OUTPUT.PUT_LINE('Funcionários atualizados: ' || p_afetados);
    DBMS_OUTPUT.PUT_LINE('Novo limite ajustado para: ' || p_salario_limite);
    COMMIT;
END;
/

16/26     PLS-00413: o identificador da cláusula CURRENT OF não é um nome de cursor
16/26     PL/SQL: ORA-00904: : identificador inválido

WHERE CURRENT OF só pode ser usado com cursores nomeados declarados com CURSOR nome IS ... FOR UPDATE, 
não com cursores implícitos do tipo FOR r IN (...).

Você precisa declarar um cursor nomeado para poder usar WHERE CURRENT OF. Aqui está a versão corrigida da procedure:

CREATE OR REPLACE PROCEDURE aumentar_salario_imp (
    p_salario_limite IN OUT NUMBER,
    p_afetados       OUT NUMBER
)
IS
    CURSOR c_func IS
        SELECT id_funcionario, salario
        FROM funcionarios
        WHERE salario < p_salario_limite
        FOR UPDATE;

    v_contador NUMBER := 0;
BEGIN
    FOR r IN c_func LOOP
        UPDATE funcionarios
        SET salario = r.salario * 1.05
        WHERE CURRENT OF c_func;  -- ✅ Agora está correto

        v_contador := v_contador + 1;
    END LOOP;

    p_afetados := v_contador;
    p_salario_limite := p_salario_limite + 500;

    DBMS_OUTPUT.PUT_LINE('Funcionários atualizados: ' || p_afetados);
    DBMS_OUTPUT.PUT_LINE('Novo limite ajustado para: ' || p_salario_limite);
    COMMIT;
END;
/




