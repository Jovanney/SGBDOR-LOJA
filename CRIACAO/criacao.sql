--Criação dos TIPOS

-- Endereco

CREATE OR REPLACE TYPE endereco_tp AS OBJECT (
    CEP VARCHAR2(8),
    Bairro VARCHAR2(200),
    Rua VARCHAR2(200),
    Numero VARCHAR2(20),
    Complemento VARCHAR2(200)
);


-- Telefone

CREATE OR REPLACE TYPE telefone_tp AS OBJECT (
    numero NUMBER
);

CREATE OR REPLACE TYPE varray_telefone AS VARRAY(2) OF telefone_tp;

-- Cargo

CREATE OR REPLACE TYPE cargo_tp AS OBJECT (
    cargo VARCHAR2(200),
    salario VARCHAR2(200)
);

-- Usuario

CREATE OR REPLACE TYPE usuario_tp AS OBJECT (
    email VARCHAR2(200),
    senha VARCHAR2(200),
    nome VARCHAR2(200),
    idade NUMBER,
    endereco REF endereco_tp,
    telefones varray_telefone
    
) NOT FINAL;

-- Cliente
CREATE OR REPLACE TYPE cliente_tp UNDER usuario_tp (
    data_criacao_conta DATE
);

-- Funcionário
CREATE OR REPLACE TYPE funcionario_tp UNDER usuario_tp (
    data_contratacao DATE,
    cargo REF cargo_tp,
    supervisor REF funcionario_tp
);    

-- Ordem de Serviço

CREATE OR REPLACE TYPE ordem_de_servico_tp AS OBJECT (
    protocolo VARCHAR2(50),
    funcionario REF funcionario_tp,
    descricao VARCHAR2(100),
    produto VARCHAR2(50),
    data_de_emissao DATE,
);        

-- Criando Tabelas

-- Endereco

CREATE TABLE Endereco OF endereco_tp (
    cep PRIMARY KEY,
    bairro NOT NULL,
    rua NOT NULL,
    numero NOT NULL,
    complemento NOT NULL
);

-- Telefone

CREATE TABLE Telefone OF telefone_tp (
    PRIMARY KEY (numero)
);

-- Usuario

CREATE TABLE Usuario OF usuario_tp (
    email PRIMARY KEY,
    senha NOT NULL,
    nome NOT NULL,
    idade NOT NULL,
    endereco WITH ROWID REFERENCES Endereco
);  

-- Cliente 
CREATE TABLE Cliente OF cliente_tp ( 
    data_criacao_conta NOT NULL,

    CONSTRAINT cliente_pk PRIMARY KEY (email)
);

-- Cargo

CREATE TABLE Cargo OF cargo_tp (
    cargo PRIMARY KEY;
    salario NOT NULL
);

-- Funcionário

CREATE TABLE Funcionario OF funcionario_tp (
    data_contratacao NOT NULL,
    cargo NOT NULL,
    supervisor SCOPE IS Funcionario,

    CONSTRAINT funcionario_pk PRIMARY KEY (email)
);

-- Ordem de Serviço

CREATE TABLE Ordem_de_servico (
    descricao NOT NULL,
    produto NOT NULL,
    data_de_emissao NOT NULL,

    funcionario WITH ROWID REFERENCES Funcionario,
    protocolo PRIMARY KEY
);

