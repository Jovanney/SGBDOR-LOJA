CREATE OR REPLACE TYPE tp_endereco AS OBJECT (
    cep VARCHAR2(8),
    complemento VARCHAR2(100),
    numero VARCHAR2(5),
    rua VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE tp_telefone AS OBJECT (
    numero VARCHAR(9)
);
/

CREATE OR REPLACE TYPE tp_fones AS VARRAY(5) OF tp_telefone;
/
CREATE OR REPLACE TYPE tp_jogo AS OBJECT (
    id VARCHAR2(10),
    nome_jogo VARCHAR2(20),
    custo_jogo NUMBER
);
/

CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(255),
    genero VARCHAR2(1),
    idade NUMBER(2),
    endereco tp_endereco,
    telefones tp_fones
) NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE tp_jogador UNDER tp_pessoa (
    carteira NUMBER,
    MEMBER PROCEDURE atualizar_endereco (novo_endereco tp_endereco)
);
/
CREATE OR REPLACE TYPE BODY tp_jogador AS
    MEMBER PROCEDURE atualizar_endereco (novo_endereco tp_endereco) IS 
    BEGIN
        -- Update the player object's address in memory
        self.endereco := novo_endereco;

        UPDATE tb_jogador j
        SET j.endereco = novo_endereco
        WHERE j.cpf like SELF.cpf;
    
    END;
END;
/


/

CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa (
    cargo_funcionario VARCHAR2(30),
    salario NUMBER,
    supervisor REF tp_funcionario
);
/

CREATE OR REPLACE TYPE tp_joga AS OBJECT (
    jogo REF tp_jogo,
    jogador REF tp_jogador,
    funcionario REF tp_funcionario,
    datahora TIMESTAMP
);
/

CREATE TABLE tb_jogador OF tp_jogador (
    cpf PRIMARY KEY
);
/

CREATE TABLE tb_jogo OF tp_jogo (
    id PRIMARY KEY
);
/
    

CREATE TABLE tb_funcionario OF tp_funcionario (
    cpf PRIMARY KEY,
    supervisor SCOPE IS tb_funcionario
);
/

CREATE TABLE tb_joga OF tp_joga (
    jogo WITH ROWID REFERENCES tb_jogo,
    jogador WITH ROWID REFERENCES tb_jogador,
    funcionario WITH ROWID REFERENCES tb_funcionario
);
/
