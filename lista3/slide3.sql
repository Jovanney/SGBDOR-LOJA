--q1

CREATE OR REPLACE TYPE tp_fone AS OBJECT (
	cod_area NUMBER(2),
    numero NUMBER(8)
);
/
CREATE TYPE varray_telefones AS VARRAY (5) OF tp_fone;
/
CREATE OR REPLACE TYPE cliente_tp as object (
    codigo NUMBER,
    nome VARCHAR2(200),
    fones varray_telefones
);

/

CREATE TABLE cliente OF cliente_tp (
    codigo PRIMARY KEY
);

/
INSERT INTO cliente VALUES (

12345, 'Ada Lovelace', varray_telefones (tp_fone (81, 11111111),

tp_fone (81, 22222222))

);

--q2


CREATE OR REPLACE TYPE mercadoria_tp AS OBJECT (
    codigo NUMBER,
    nome VARCHAR2(200),
    preco FLOAT
);

/

CREATE OR REPLACE TYPE item_tp AS OBJECT (
    numero NUMBER,
    quantidade NUMBER,
    mercadoria_item REF mercadoria_tp
);

/

CREATE TYPE tp_lista_item AS TABLE OF item_tp;

/

CREATE OR REPLACE TYPE pedido_tp AS OBJECT (
    numero NUMBER,
    data_pedido DATE,
    data_entrega DATE,
    itens_pedido tp_lista_item
);

/

CREATE TABLE Mercadoria OF mercadoria_tp (
	codigo PRIMARY KEY
);

/

CREATE TABLE Item of item_tp (
	numero PRIMARY KEY,
    mercadoria_item WITH ROWID REFERENCES Mercadoria
);
    
/

CREATE TABLE Pedido OF pedido_tp(
    numero PRIMARY KEY
) NESTED TABLE itens_pedido STORE AS nt_itens;

/

INSERT INTO Mercadoria VALUES (mercadoria_tp (01, 'Mouse',
56.99));

/

INSERT INTO Mercadoria VALUES (02, 'Teclado', 67.99);

/

INSERT INTO Mercadoria VALUES (03, 'Monitor', 395.99);

/

INSERT INTO Pedido VALUES (
    pedido_tp(001, to_date ('07/11/2018', 'dd/mm/yyyy'), to_date('17/11/2018', 'dd/mm/yyyy'), 
    tp_lista_item (item_tp (10, 1, (SELECT REF(M) FROM Mercadoria M where M.nome = 'Mouse')),
    item_tp (11, 2, (SELECT REF(M) FROM Mercadoria M where M.nome = 'Teclado'))))
);

/

INSERT INTO TABLE (SELECT P.itens_pedido FROM Pedido P WHERE
P.numero = 001) T VALUES (
item_tp (12, 1, (SELECT REF(M) FROM Mercadoria M WHERE
M.nome = 'Monitor'))

);

/

SELECT P.itens_pedido FROM Pedido P WHERE P.numero = 001;

/

SELECT * FROM TABLE (SELECT P.itens_pedido FROM Pedido P WHERE P.numero
= 001);

/

SELECT VALUE L FROM TABLE (SELECT P.itens_pedido FROM Pedido P WHERE
P.numero = 001) L;

/
SELECT P.itens_pedido FROM Pedido P WHERE P.numero
= 001;

/

--varray de varray

CREATE OR REPLACE TYPE telefone_tp AS OBJECT (
    cod NUMBER,
    numero NUMBER
)
/
CREATE OR REPLACE TYPE array_telefone AS VARRAY (3) OF telefone_tp;
/

CREATE OR REPLACE TYPE responsavel_tp AS OBJECT (
    nome VARCHAR2(200),
    telefones array_telefone
)

/

CREATE OR REPLACE TYPE array_resposavel AS VARRAY (5) OF responsavel_tp;

/

INSERT INTO tb_alunos VALUES (124, tp_nt_professores(
tp_professor('Snape', 'Poções', array_tp_fone
(tp_telefone('11', '11111111'))),
tp_professor('Minerva','Transfiguração', array_tp_fone
(tp_telefone('22', '22222222'), tp_telefone('33', '33333333')))));
/

SELECT P.nome
FROM tb_alunos A, TABLE (A.conj_professores) P
WHERE P.disciplina LIKE 'Poções'
GROUP BY P.nome;
/
SELECT T.cod_area, T.fone
FROM tb_alunos A, TABLE (A.conj_professores) P, TABLE
(P.telefones) T
WHERE P.nome LIKE 'Minerva'
GROUP BY T.cod_area, T.fone;

INSERT INTO TABLE (SELECT a.conj_professores FROM tb_alunos a WHERE a.matricula = 123) A VALUES (tp_professor('JOAO', 'matemática', telefones(tp_telefone(23, 234342))));

/

