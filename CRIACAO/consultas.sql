
--CONSULTAS

--consultas select ref

-- usando select ref a partir de um update (é alterado a transportadora do pedido 9404040409)
UPDATE pedido p
SET
    p.transportadora = (
        SELECT
            REF(t)
        FROM
            transportadora t
        WHERE
            t.cnpj = '90000000000009'
    )
WHERE
    p.id_pedido = 9404040409;


--usando select ref a partir de uma inserção
INSERT INTO Relatorio VALUES (relatorio_tp('aaaaaaa', 'bbbbbbb', (SELECT REF(F) FROM Funcionario F WHERE F.email = 'funcionarioA@gmail.com'), 'ccccccc'));


-- SELECT DEREF

-- Agrupando os produtos pela marca, e pelo status do pedido que o produto pertence, além de calcular o preço total para cada grupo, retornando apenas os grupos com o preço total maior que 600 dineros

SELECT DEREF(p.pedido).status, p.marca, SUM(p.get_precoTotal_produto()) AS total_preco
FROM produto p
WHERE DEREF(p.pedido).status like 'Entregue'
GROUP BY p.marca, DEREF(p.pedido).status 
HAVING SUM(p.get_precoTotal_produto()) > 600;


-- Seleciona detalhes de ordens de serviço emitidas por gerentes após 01/01/2020.
-- Inclui nome, data de contratação e cargo do funcionário, além de informações da ordem.

SELECT DEREF(s.funcionario).nome AS nome_funcionario, DEREF(s.funcionario).data_contratacao AS data_contratacao_funcionario, s.protocolo, s.descricao, s.produto, s.data_de_emissao, DEREF(s.funcionario.cargo).cargo AS cargo_funcionario
FROM Ordem_de_servico s
WHERE DEREF(s.funcionario.cargo).cargo = 'Gerente' AND s.data_de_emissao > TO_DATE('01/01/2020', 'DD/MM/YYYY');

-- SELECT de ASSISTENCIAS ordenadas de menor tempo decorrido desde a data de início para maior

SELECT a.*
FROM Assistencia a
ORDER BY a.CalcularTempoDesdeInicio();


-- Consulta CONSTRUCTOR FUNCTION

DECLARE
    cargo_atual cargo_tp;
	pessoaX_cargo VARCHAR2(200);
	pessoaX_salario VARCHAR2(200);
BEGIN
    pessoaX_cargo := 'Manager';
	pessoaX_salario := '18000';
    cargo_atual := cargo_tp(pessoaX_cargo, pessoaX_salario);
	DBMS_OUTPUT.PUT_LINE('Cargo: ' || cargo_atual.cargo || ' | Salario: ' || cargo_atual.salario);
    COMMIT;
END;
/


-- Consultas NESTED TABLE
    --Selecionando row de cada Produto(produto_tp) com diferentes Caracteristicas(caracteristicas)
SELECT 
    p.id_produto, 
    p.nome, 
    p.preco, 
    p.data_estoque, 
    c.column_value AS caracteristicas_value, 
    p.marca, 
    p.categoria, 
    p.quantidade
FROM Produto p
CROSS JOIN TABLE(p.caracteristicas) c;

--Selecionando colunos especificas de cada Produto que tenha caracteristicas especificadas como Preto, Headset e HD interno

SELECT 
    p.id_produto, 
    p.nome, 
    c.column_value AS caracteristicas_value, 
    p.marca, 
    p.categoria
FROM Produto p
CROSS JOIN TABLE(p.caracteristicas) c
WHERE c.column_value IN ('Preto', 'Headset', 'HD interno'); --note que nao ha pedidos com o nome headset, apenas HeadSet com fio

--Selecionando todos os tipos de características na tabela produto_caracteristicas_nt (A nested table)
SELECT DISTINCT * FROM produto_caracteristicas_nt;


-- SELECT VARRAY (telefones)


-- Selecionando todos os números de telefone por um e-mail arbitrário
SELECT u.nome, n.numero
FROM Usuario u
CROSS JOIN TABLE(u.telefones) n
WHERE u.email = 'pessoaA@gmail.com';

-- Selecionando os telefones de todos os usuários maiores de 20 anos
SELECT u.nome, n.numero
FROM Usuario u
CROSS JOIN TABLE(u.telefones) n
WHERE u.idade > 20;

-- Selecionando todos os telefones distintos salvos
SELECT DISTINCT * FROM Telefone;

-- Selecionando email, dados do endereco e numeros de telefone de clientes que moram nos bairros pimentao, alho ou cenoura
SELECT c.email, c.endereco.CEP, c.endereco.Rua, c.endereco.Bairro, c.endereco.Numero, c.endereco.Complemento, n.numero
FROM Cliente c
CROSS JOIN TABLE(c.telefones) n
WHERE c.endereco.bairro IN ('bairro pimentao', 'bairro alho', 'bairro cenoura');

-- Selecionando os dados de nome, email, idade, data de criacao da conta e numeros de telefone das contas criadas em agosto de 2023
SELECT c.nome, c.email, c.idade, c.data_criacao_conta, n.numero
FROM Cliente c
CROSS JOIN TABLE(c.telefones) n
WHERE EXTRACT(MONTH FROM c.data_criacao_conta) = 8 AND EXTRACT(YEAR FROM c.data_criacao_conta) = 2023;














--  TESTANDO FUNÇÕES E PROCEDURES
-- testando função de get_usuário_info
declare
    funcionario_obj funcionario_tp;
	
begin
	select value(f) into funcionario_obj from funcionario f where f.email = 'funcionarioA@gmail.com';
	funcionario_obj.get_usuario_info();
end;

-- Consultas ORDER MEMBER FUNCTION --
DECLARE
    assistencia assistencia_tp;
    dias_passados NUMBER;
BEGIN
    assistencia := assistencia_tp('12345678901234', TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Reparo', 'Em pendencia', 'Notebook');
    dias_passados := assistencia.CalcularTempoDesdeInicio();
    DBMS_OUTPUT.PUT_LINE('Dias desde o início: ' || dias_passados);
END;
/
-- testando get_precoTotal_produto
/
DECLARE
    produto_atual produto_tp;
    preco_total NUMBER;
BEGIN
    SELECT VALUE(p)
    INTO produto_atual
    FROM produto p
    WHERE p.id_produto = '404040404';

    preco_total := produto_atual.get_precoTotal_produto();
    DBMS_OUTPUT.PUT_LINE('Nome: ' || produto_atual.nome || ' | Preco Total: ' || preco_total);
END; 

/
-- testando get_msg_assistencia_completa

DECLARE
    assistencia_atual assistencia_tp;
    descricao_completa VARCHAR2(4000);
BEGIN
    SELECT VALUE(a)
    INTO assistencia_atual
    FROM Assistencia a
    WHERE a.cnpj = '12345678901234';

    descricao_completa := assistencia_atual.get_msg_assistencia_completa();
    DBMS_OUTPUT.PUT_LINE('CNPJ: ' || assistencia_atual.cnpj || ' | Descricao Completa: ' || descricao_completa);
END;

/

-- testando get_precoTotal_produto

DECLARE
    renda_produto NUMBER;
BEGIN
    FOR produto IN (SELECT pd.id_produto, pd.quantidade, pd.preco, pd.get_precoTotal_produto() AS renda_produto FROM Produto Pd)
    LOOP
        renda_produto := produto.renda_produto;
        DBMS_OUTPUT.PUT_LINE('ID do Produto: ' || produto.id_produto || ' | Quantidade: ' || produto.quantidade || ' | Preço: ' || produto.preco || ' | Renda do Produto: ' || renda_produto);
    END LOOP;
END;


-- teste get_precoTotal_produto

DECLARE
    id_produto NUMBER;
    quantidade NUMBER;
    preco NUMBER;
BEGIN
    FOR produto IN (SELECT pd.id_produto, pd.quantidade, pd.preco FROM Produto Pd WHERE pd.get_precoTotal_produto() > 500.00)
    LOOP
        id_produto := produto.id_produto;
        quantidade := produto.quantidade;
        preco := produto.preco;
        DBMS_OUTPUT.PUT_LINE('ID do Produto: ' || id_produto || ' | Quantidade: ' || quantidade || ' | Preço: ' || preco);
    END LOOP;
END;




