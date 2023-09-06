-- Criar tipo endereço e CONSTRUCTOR

CREATE OR REPLACE TYPE endereco_tp AS OBJECT (
    Rua VARCHAR2(200),
    Cidade VARCHAR2(200),
    Estado VARCHAR2(200),
    CEP VARCHAR2(200),

    CONSTRUCTOR FUNCTION endereco_tp (rua VARCHAR2, cidade VARCHAR2, estado VARCHAR2, cep VARCHAR2) RETURN SELF AS RESULT
);
/
CREATE OR REPLACE TYPE BODY endereco_tp AS
    CONSTRUCTOR FUNCTION endereco_tp(
    rua VARCHAR2,
    cidade VARCHAR2,
    estado VARCHAR2,
    cep VARCHAR2)
    RETURN SELF AS RESULT IS
    	BEGIN
    		SELF.Rua := rua;
			SELF.Cidade := cidade;
			SELF.Estado := estado;
			SELF.CEP := cep;
			RETURN;
    	END;
END;

/

DECLARE

endereco endereco_tp;

BEGIN
    endereco := endereco_tp('qwe', 'qwe', 'qwe', 'qwe');
END;

/

-- Criar tipo pessoa, tabela e inserir 3 valores

CREATE OR REPLACE TYPE pessoa_tp as OBJECT (
    ID VARCHAR2(200),
    Nome VARCHAR2(200),
    Endereco VARCHAR2(200)
);

/

CREATE TABLE Pessoa_tb OF pessoa_tp (
    ID PRIMARY KEY,
    Nome NOT NULL,
    Endereco NOT NULL
)

/

INSERT INTO Pessoa_tb VALUES (pessoa_tp('1', 'João', 'Casa da febe do rato'));
INSERT INTO Pessoa_tb VALUES (pessoa_tp('2', 'Maria', 'Casa da febe tife'));
INSERT INTO Pessoa_tb VALUES (pessoa_tp('3', 'João Maria', 'Casa da febe do rato preta'));

/

CREATE OR REPLACE TYPE profissional_tp AS OBJECT (
    nome VARCHAR2(200),
    datanascimento VARCHAR2(200)
) NOT FINAL NOT INSTANTIABLE;

/

CREATE OR REPLACE TYPE medico_tp UNDER profissional_tp (
    especialidade VARCHAR2(200),
    CRM VARCHAR2(200)
); 

/

CREATE OR REPLACE TYPE engenheiro_tp UNDER profissional_tp (
    CREA VARCHAR2(200)
)
/
INSERT INTO tb_medico VALUES ('Jose', to_date('05/04/1997', 'dd/mm/yyyy'), 12345, 'Cardiologista');
INSERT INTO tb_medico VALUES ('Ana', to_date('13/08/1993', 'dd/mm/yyyy'), 54321, 'Neurologista');
INSERT INTO tb_engenheiro VALUES ('Luiz', to_date ('26/11/1999', 'dd/mm/yyyy'), 34567);

/


-- exercício 4

CREATE OR REPLACE TYPE tp_retangulo AS OBJECT (
    id NUMBER,
    altura NUMBER,
    largura NUMBER,

    MEMBER FUNCTION exibir_area RETURN NUMBER,
    MEMBER PROCEDURE set_altura (new_altura NUMBER)
);
/

CREATE OR REPLACE TYPE BODY tp_retangulo AS
	MEMBER FUNCTION exibir_area RETURN NUMBER IS
		BEGIN
    		RETURN altura * largura;
		END;
	MEMBER PROCEDURE set_altura(new_altura NUMBER) IS
        BEGIN
        	altura := new_altura;
        END;
END;

/

-- 5 e 6

CREATE OR REPLACE TYPE endereco AS OBJECT (
    cep VARCHAR2(200),
    bairro VARCHAR2(200),
    cidade VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE cliente AS OBJECT (
    endereco_cliente REF endereco,
    cpf VARCHAR2(200),
    nome VARCHAR2(200)
);
/

CREATE TABLE endereco_tb OF endereco (
    PRIMARY KEY (cep,bairro)
    
);

/ 

CREATE TABLE cliente_tb OF cliente (
    PRIMARY KEY (cpf),
    endereco_cliente WITH ROWID REFERENCES endereco_tb
);

/

INSERT INTO endereco_tb VALUES (endereco('56600-00', 'mario melo nova', 'sertânia'));
INSERT INTO endereco_tb VALUES (endereco('56600-000', 'mario melo nova', 'Sertânia'));

INSERT INTO cliente_tb VALUES (cliente((SELECT REF(e) FROM endereco_tb e WHERE e.cep like '56600-00' AND e.bairro like 'mario melo nova'), '11209921413', 'Jovanney'));
INSERT INTO cliente_tb VALUES (cliente((SELECT REF(e) FROM endereco_tb e WHERE e.cep like '56600-000' AND e.bairro like 'mario melo nova'), '13209921413', 'aney'));
INSERT INTO cliente_tb VALUES (cliente((SELECT REF(e) FROM endereco_tb e WHERE e.cep like '56600-00' AND e.bairro like 'mario melo nova'), '11129921413', 'Jovay'));

