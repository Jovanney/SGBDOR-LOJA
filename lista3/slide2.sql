-- questão 1 e 2

CREATE OR REPLACE TYPE endereco_tp AS OBJECT (
    cep VARCHAR(8),
    bairro VARCHAR(200),
    cidade VARCHAR(200)
);

/

CREATE OR REPLACE TYPE cliente_tp AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(200),
    endereco_cliente REF endereco_tp
);

/

CREATE TABLE Endereco_tabela OF endereco_tp (
    cep PRIMARY KEY
)

/

CREATE TABLE Cliente_tabela OF cliente_tp (
    cpf PRIMARY KEY,
    endereco_cliente WITH ROWID REFERENCES Endereco_tabela
)

-- q3


-- q3

INSERT INTO endereco_tabela VALUES ('50100250', 'Santo Amaro',
'Recife');

INSERT INTO endereco_tabela VALUES ('52021180', 'Espinheiro',
'Recife');

INSERT INTO cliente_tabela VALUES ('12345678902', 'Ana', (SELECT
REF(E) FROM endereco_tabela E WHERE E.cep = '50100250'));

INSERT INTO cliente_tabela VALUES ('56789012303', 'Carla', (SELECT
REF(E) FROM endereco_tabela E WHERE E.cep = '50100250'));

INSERT INTO cliente_tabela VALUES ('78912345604', 'Maria', (SELECT
REF(E) FROM endereco_tabela E WHERE E.cep = '52021180'));



-- q4

SELECT COUNT(c.cpf), DEREF(c.endereco_cliente).bairro FROM cliente_tabela c
WHERE DEREF(c.endereco_cliente).bairro IN (SELECT bairro from endereco_tabela)
GROUP BY DEREF(c.endereco_cliente).bairro;

--improv

SELECT COUNT(*), DEREF(c.endereco_cliente).bairro as bairro
FROM cliente_tabela c GROUP BY (DEREF(c.endereco_cliente).bairro);

--q5

CREATE OR REPLACE TYPE vendas_tp AS OBJECT(
    valor NUMBER(10,2),
    data_compra DATE,
    cliente REF cliente_tp
);

/

CREATE TABLE Vendas OF vendas_tp (
    data_compra PRIMARY KEY,
    cliente SCOPE IS cliente_tabela
);

/

INSERT INTO Vendas VALUES (100, cast(to_date( '2022-08-01 14:53:20', 'YYYY-MM-DD HH24:MI:SS') AS
TIMESTAMP), (SELECT REF(c) FROM cliente_tabela c WHERE c.cpf like '56789012303'));

--q6

SELECT v.valor, v.data_compra, DEREF(v.cliente).nome, DEREF(DEREF(v.cliente).endereco_cliente).cep
    FROM vendas v;