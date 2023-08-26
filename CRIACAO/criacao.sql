--Criação dos TIPOS

-- Endereco

CREATE OR REPLACE TYPE endereco_tp AS OBJECT (
    CEP VARCHAR2(8),
    bairro VARCHAR2(200),
    rua VARCHAR2(200),
    numero VARCHAR2(20),
    complemento VARCHAR2(200)
);

/

-- Telefone

CREATE OR REPLACE TYPE telefone_tp AS OBJECT (
    numero NUMBER
);

/

CREATE OR REPLACE TYPE varray_telefone AS VARRAY(2) OF telefone_tp;

/

-- Cargo

CREATE OR REPLACE TYPE cargo_tp AS OBJECT (
    cargo VARCHAR2(200),
    salario VARCHAR2(200)
);

/

-- Usuario

CREATE OR REPLACE TYPE usuario_tp AS OBJECT (
    email VARCHAR2(200),
    senha VARCHAR2(200),
    nome VARCHAR2(200),
    idade NUMBER,
    endereco REF endereco_tp,
    telefones varray_telefone,
    MEMBER PROCEDURE get_usuario_info (SELF usuario_tp),
    FINAL MEMBER PROCEDURE get_usuario_endereco (SELF usuario_tp)
) NOT FINAL NOT INSTANTIABLE;

/

CREATE OR REPLACE TYPE BODY usuario_tp AS
    MEMBER PROCEDURE get_usuario_info (SELF usuario_tp) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Email: ' || SELF.email);
        DBMS_OUTPUT.PUT_LINE('Idade: ' || SELF.idade);
    END;
    FINAL MEMBER PROCEDURE get_usuario_endereco (SELF usuario_tp) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('O seu nome é ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Ele(a) mora em ' || SELF.endereco.bairro );
        DBMS_OUTPUT.PUT_LINE(SELF.endereco.cep);
    END;
END;

/

-- Cliente
CREATE OR REPLACE TYPE cliente_tp UNDER usuario_tp (
    data_criacao_conta DATE,
    OVERRIDING MEMBER PROCEDURE get_usuario_info (SELF cliente_tp)
);

/

CREATE OR REPLACE TYPE BODY cliente_tp AS
    OVERRIDING MEMBER PROCEDURE get_usuario_info (SELF cliente_tp) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Email: ' || SELF.email);
        DBMS_OUTPUT.PUT_LINE('Idade: ' || SELF.idade);
        DBMS_OUTPUT.PUT_LINE('Data de criação da conta: ' || SELF.data_criacao_conta);
    END;
END;

/

-- Funcionário
CREATE OR REPLACE TYPE funcionario_tp UNDER usuario_tp (
    data_contratacao DATE,
    cargo REF cargo_tp,
    supervisor REF funcionario_tp,
    OVERRIDING MEMBER PROCEDURE get_usuario_info (SELF funcionario_tp)
);

/

CREATE OR REPLACE TYPE BODY funcionario_tp AS
    OVERRIDING MEMBER PROCEDURE get_usuario_info (SELF funcionario_tp) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Email: ' || SELF.email);
        DBMS_OUTPUT.PUT_LINE('Idade: ' || SELF.idade);
        DBMS_OUTPUT.PUT_LINE('cargo: ' || SELF.cargo.cargo);
        DBMS_OUTPUT.PUT_LINE('salario: ' || SELF.cargo.salario);
        DBMS_OUTPUT.PUT_LINE('Data de contratação: ' || SELF.data_contratacao);
    END;
END;

-- Ordem de Serviço

CREATE OR REPLACE TYPE ordem_de_servico_tp AS OBJECT (
    protocolo VARCHAR2(50),
    funcionario REF funcionario_tp,
    descricao VARCHAR2(100),
    produto VARCHAR2(50),
    data_de_emissao DATE
);

/

-- Transportadora

CREATE OR REPLACE TYPE transportadora_tp AS OBJECT (
    cnpj VARCHAR(14),
    nome VARCHAR2(100)
);

/

-- Pedido

CREATE OR REPLACE TYPE pedido_tp AS OBJECT (
    id_pedido NUMBER(10),
	preco NUMBER(8,2),
	data_pedido DATE,
	cliente REF cliente_tp,
	destino VARCHAR2(50),
	local_saida VARCHAR2(50),
	data_saida DATE,
	local_atual VARCHAR2(50),
	data_entrega DATE,
	transportadora REF transportadora_tp,
	frete NUMBER(5,2),
	status VARCHAR2(20),

    ORDER MEMBER FUNCTION comparar (v pedido_tp) RETURN NUMBER
);

/

CREATE OR REPLACE TYPE BODY pedido_tp AS
    ORDER MEMBER FUNCTION comparar (v pedido_tp) RETURN NUMBER IS
    BEGIN
        IF SELF.preco > v.preco THEN
            RETURN 1;
        ELSIF SELF.preco < v.preco THEN
            RETURN 0;
        ELSE
            RETURN -1;
        END IF;
    END;
END;

/

-- Pagamento

CREATE OR REPLACE TYPE pagamento_tp AS OBJECT (
    id_pagamento NUMBER(10),
    data_do_pagamento DATE,
    status VARCHAR2(100),
    metodo_do_pagamento VARCHAR2(50),
    
    pedido REF pedido_tp
);

/

-- Produto 

CREATE OR REPLACE TYPE produto_tp AS OBJECT (
    id_produto NUMBER(10),
	nome VARCHAR2(100),
	preco NUMBER(7,2),
	data_estoque DATE,
	caracteristicas VARCHAR2(200),
	marca VARCHAR2(20),
	categoria VARCHAR2(20),
	pedido REF pedido_tp
);

/

ALTER TYPE produto_tp ADD ATTRIBUTE(quantidade NUMBER(3)) CASCADE;

/

-- Assistencia

CREATE OR REPLACE TYPE assistencia_tp AS OBJECT(
    cnpj VARCHAR2(14),
    data_inicio DATE,
    descricao VARCHAR2(50),
    status VARCHAR2(50),
    equipamento VARCHAR2(50)
    CONSTRUCTOR FUNCTION assistencia_tp(cnpj VARCHAR2(14), data_inicio DATE, descricao VARCHAR2(50),status VARCHAR2(50), equipamento VARCHAR2(50)) RETURN SELF AS RESULT
);

/

CREATE OR REPLACE TYPE BODY tp_usuario AS
    CONSTRUCTOR FUNCTION assistencia_tp(cnpj VARCHAR2(14), data_inicio DATE, descricao VARCHAR2(50), status VARCHAR2(50), equipamento VARCHAR2(50)) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cnpj := cnpj;
        SELF.data_inicio := data_inicio;
        SELF.descricao := descricao;
        SELF.status := status;
        SELF.equipamento := equipamento;
        RETURN;
    END;
END;

-- Aciona

CREATE OR REPLACE TYPE aciona_tp AS OBJECT(
	cliente REF cliente_tp,
  	funcionario REF funcionario_tp,
  	assistencia REF assistencia_tp
);

/

-- TipoAssistencia

CREATE OR REPLACE TYPE tipo_assistencia_tp AS OBJECT (
    tipo_assistencia VARCHAR2(50),
    assistencia REF assistencia_tp
);

/

-- Relatorio aux
CREATE OR REPLACE TYPE relatorio_aux_tp AS OBJECT (
    codigo_relatorio_aux VARCHAR2(50)
);
/

-- Servico Aux
CREATE OR REPLACE TYPE Servico_aux_tp AS OBJECT (
    codigo_servico_aux VARCHAR2(50)
);

/

--Servico a ser realizado MESMO PROBLEMA DO REF COMO PK

CREATE OR REPLACE TYPE servico_a_ser_realizado_tp AS OBJECT (
	funcionario REF funcionario_tp,
  	ordServico REF ordem_de_servico_tp,
  	relatorio REF relatorio_aux_tp,
  	servico REF Servico_aux_tp
);

/

-- Relatorio

CREATE OR REPLACE TYPE relatorio_tp AS OBJECT (
    codigo_relatorio VARCHAR2(50),
    descricao VARCHAR(50),
    funcionario REF funcionario_tp,
    protocolo VARCHAR2(50)
);
/

-- Servico

CREATE OR REPLACE TYPE servico_tp AS OBJECT (
    codigo_servico VARCHAR2(50),
    status VARCHAR(20),
    data_inicio DATE,
    data_conclusao DATE,
    funcionario REF relatorio_tp,
    protocolo REF relatorio_tp
);

/

-- Descricao
CREATE OR REPLACE TYPE descricao_tp AS OBJECT(
    descricao_n NUMBER,
    acoes_tomadas VARCHAR2(50)
);

/

-- Protocolo
CREATE OR REPLACE TYPE protocolo_de_Atendimento_tp AS OBJECT (
    codigo_Protocolo VARCHAR2(50),
    assistencia REF assistencia_tp,
    descricao REF descricao_tp,
    acoes_tomadas VARCHAR2(50),
    data_inicio DATE,
    data_conclusao DATE
);

/

-- Criando Tabelas

-- Endereco

CREATE TABLE Endereco OF endereco_tp (
    cep PRIMARY KEY,
    bairro NOT NULL,
    rua NOT NULL,
    numero NOT NULL,
    complemento NOT NULL
);

/

-- Telefone

CREATE TABLE Telefone OF telefone_tp (
    PRIMARY KEY (numero)
);

/

-- Usuario

CREATE TABLE Usuario OF usuario_tp (
    email PRIMARY KEY,
    senha NOT NULL,
    nome NOT NULL,
    idade NOT NULL,
    endereco WITH ROWID REFERENCES Endereco
);  

/

-- Cliente 
CREATE TABLE Cliente OF cliente_tp ( 
    data_criacao_conta NOT NULL,

    CONSTRAINT cliente_pk PRIMARY KEY (email)
);

/

-- Cargo

CREATE TABLE Cargo OF cargo_tp (
    cargo PRIMARY KEY,
    salario NOT NULL
);

/

-- Funcionário

CREATE TABLE Funcionario OF funcionario_tp (
    data_contratacao NOT NULL,
    cargo NOT NULL,
    supervisor SCOPE IS Funcionario,

    CONSTRAINT funcionario_pk PRIMARY KEY (email)
);

/

-- Ordem de Serviço

CREATE TABLE Ordem_de_servico OF ordem_de_servico_tp (
    descricao NOT NULL,
    produto NOT NULL,
    data_de_emissao NOT NULL,

    funcionario WITH ROWID REFERENCES Funcionario,
    protocolo PRIMARY KEY
);

/

-- Transportadora

CREATE TABLE Transportadora OF transportadora_tp(
    nome NOT NULL,
    cnpj PRIMARY KEY
);

/

-- Pedido 

CREATE TABLE Pedido OF pedido_tp (
	descricao NOT NULL,
	preco NOT NULL,
	data_pedido NOT NULL ,
	destino NOT NULL,
	local_saida NOT NULL,
	data_saida NOT NULL ,
	local_atual NOT NULL,
	data_entrega NOT NULL,
	frete NOT NULL,
	status NOT NULL,

	id_pedido PRIMARY KEY,
    cliente WITH ROWID REFERENCES Cliente,
	transportadora WITH ROWID REFERENCES Transportadora
);

/

-- Pagamento

CREATE TABLE Pagamento OF pagamento_tp (
    data_do_pagamento NOT NULL,
    status NOT NULL,
    metodo_do_pagamento NOT NULL,
    
    id_pagamento PRIMARY KEY,
    pedido WITH ROWID REFERENCES Pedido
);

/

-- Produto

CREATE TABLE Produto OF produto_tp (
	quantidade NOT NULL,
	nome NOT NULL,
	preco NOT NULL,
	data_estoque NOT NULL,
	caracteristicas NOT NULL,
	marca NOT NULL,
	categoria NOT NULL,
	
    id_produto PRIMARY KEY,
    pedido WITH ROWID REFERENCES Pedido
);

/

-- Assistencia

CREATE TABLE Assistencia OF assistencia_tp(
    data_inicio NOT NULL,
    descricao NOT NULL,
    status NOT NULL,
    equipamento NOT NULL,

    cnpj PRIMARY KEY
);

/
-- Aciona

CREATE TABLE Aciona OF aciona_tp(
	cliente WITH ROWID REFERENCES Cliente,
  	funcionario WITH ROWID REFERENCES Funcionario,
  	assistencia WITH ROWID REFERENCES Assistencia
);

/

-- -- TipoAssistencia
-- CREATE TABLE TipoAssistencia OF tipo_assistencia_tp (
    
--     CONSTRAINT tipoassistencia_pkey PRIMARY KEY (tipo_assistencia, assistencia),
--     assistencia WITH ROWID REFERENCES Assistencia
-- );

-- Relatorio aux
CREATE TABLE Relatorio_aux OF relatorio_aux_tp (
    CONSTRAINT relatorio_aux_pk PRIMARY KEY (codigo_relatorio_aux));

/

-- Servico Aux
CREATE TABLE Servico_aux OF servico_aux_tp (
    CONSTRAINT servico_aux_pk PRIMARY KEY (codigo_servico_aux));

/

-- Servico a ser realizado
-- CREATE TABLE Servico_a_ser_realizado OF servico_a_ser_realizado_tp (
-- 	CONSTRAINT funcionario_Aprova_pk PRIMARY KEY (funcionario, ordServico));

/

-- Relatorio

CREATE TABLE Relatorio OF relatorio_tp (
    CONSTRAINT relatorio_pk PRIMARY KEY (codigo_relatorio));

/

--Servico

CREATE TABLE Servico OF servico_tp (
    CONSTRAINT servico_pk PRIMARY KEY (codigo_servico));

/

-- Descricao
CREATE TABLE Descricao OF descricao_tp(
    descricao_n PRIMARY KEY,
    acoes_tomadas NOT NULL
);


/

-- Procolo de atendimento

CREATE TABLE Protocolo_de_Atendimento OF protocolo_de_Atendimento_tp (
    codigo_Protocolo PRIMARY KEY,
    assistencia  WITH ROWID REFERENCES Assistencia,
    descricao  WITH ROWID REFERENCES Descricao,
    acoes_tomadas NOT NULL,
    data_inicio NOT NULL,
    data_conclusao NOT NULL
);