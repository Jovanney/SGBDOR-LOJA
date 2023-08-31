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
    
	-- SELECT de ASSISTENCIAS ordenadas de menor tempo decorrido desde a data de início para maior
SELECT a.*
FROM Assistencia a
ORDER BY a.CalcularTempoDesdeInicio();
	--
--

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
