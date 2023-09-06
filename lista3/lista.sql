CREATE OR REPLACE TYPE endeco_tp AS OBJECT (
    CEP VARCHAR2(11),
    rua VARCHAR2(200),
    complemento VARCHAR2(200),
    numero NUMBER
);

/

CREATE OR REPLACE TYPE telefone_tp AS OBJECT (
    codigo VARCHAR2(3),
    numero VARCHAR2(9)
);

/

CREATE OR REPLACE TYPE array_telefone AS VARRAY (5) OF telefone_tp;

/

CREATE OR REPLACE TYPE pessoa_tp AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(200),
    idade NUMBER,
    genero VARCHAR2(200),
    lista_telefone array_telefone,
    endereco_pessoa endeco_tp
) NOT FINAL NOT INSTANTIABLE;

/

CREATE OR REPLACE TYPE jogador_tp UNDER pessoa_tp(
    carteira VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE funcionario_tp UNDER pessoa_tp(
    cargo VARCHAR2(200),
    salario FLOAT,
    supervisor REF funcionario_tp
);

/

CREATE OR REPLACE TYPE jogo_tp AS OBJECT (
    id NUMBER,
    custo_para_jogar VARCHAR2(200),
    nome_do_jogo VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE joga_tp AS OBJECT (
    data_e_hora DATE,
    jogador REF jogador_tp,
    jogo REF jogo_tp,
    funcionario REF funcionario_tp
);

/

SELECT j.nome, j.carteira FROM jogador j
WHERE j.carteira = (SELECT MIN(j2.carteira) FROM jogador j2);

/

SELECT f.nome, f.salario FROM funcionario f
WHERE j.salario = (SELECT MAX(f2.salario) FROM funcionario f2);

/

SELECT j.nome, T.numero FROM jogador j, TABLE(j.telefones) T
WHERE t.ddd like ('99');

/

SELECT DEREF(jo.jogo).id, DEREF(jo.jogo).nome FROM joga jo
WHERE funcionario IS NULL; 

/

SELECT DEREF(jo.jogador).nome FROM joga jo
WHERE DEREF(jo.jogo).nomedojogo like "poker";
/

SELECT COUNT(DISTINCT(DEREF(f.supervisor).cpf)) FROM funcionario f

/

SELECT COUNT (*) AS QTD_MULHERES_SUPERVISORAS
FROM tb_funcionario C WHERE DEREF(C.supervisor).genero = 'F';

/

SELECT b.cod_bruxo, b.nome_bruxo, b.idade, b.casa, b.cursa_disc_tp_nt_bruxo_cursa FROM tb_bruxo b;

/

SELECT AVG(n.nota)
FROM tb_bruxo b, TABLE(b.cursa_disc) cd, TABLE(cd.notas) n, tb_disciplina d
WHERE b.casa = 'Sonserina'
AND cd.disc_ref.cod_disc = '11111';

/

CREATE OR REPLACE TYPE tp_bruxo AS OBJECT(cod_bruxo VARCHAR(5), nome_bruxo     VARCHAR(50), idade INTEGER, casa  VARCHAR(15), cursa_disc tp_nt_bruxo_cursa, MEMBER PROCEDURE add_nota(cod_disc_up VARCHAR, nota NUMBER));

/

CREATE OR REPLACE TYPE BODY tp_bruxo AS 
    MEMBER PROCEDURE  add_nota(cod_disc_up VARCHAR, nota NUMBER) 
    IS
        notas_atuais tp_va_notas;
        tamanho INT;
    BEGIN
        SELECT cd.notas INTO notas_atuais FROM tb_bruxo b, TABLE(b.cursa_disc) cd
        WHERE DEREF(cd.disc_ref).cod_disc = cod_disc_up
        AND b.cod_bruxo = SELF.cod_bruxo;

        notas_atuais.extend;
        tamanho := notas_atuais.count;
        notas_atuais(tamanho) := tp_nota(nota);

        UPDATE TABLE (SELECT b.cursa_disc FROM tb_bruxo b WHERE b.cod_bruxo = SELF.cod_bruxo) cd 
            SET cd.notas = notas_atuais 
            WHERE DEREF(cd.disc_ref).cod_disc = cod_disc_up;
	END;
 END;