CREATE OR REPLACE TYPE telefone_tp AS OBJECT (
    numero VARCHAR2(11)
);

/

CREATE OR REPLACE TYPE lista_telefone AS VARRAY (5) OF telefone_tp;

/

CREATE OR REPLACE TYPE endereco_tp AS OBJECT (
    rua VARCHAR2(200),
    numero NUMBER,
    CEP VARCHAR2(8)
);

/

CREATE OR REPLACE TYPE usuario_tp AS OBJECT(
    cpf VARCHAR2(12),
    nome VARCHAR2(200),
    endereco endereco_tp,
    telefones lista_telefone

) NOT FINAL NOT INSTANTIABLE;

/

CREATE OR REPLACE TYPE funcionario_tp UNDER usuario_tp (
    cargo VARCHAR2(200),
    data_admissao DATE,
    salario NUMBER,
    supervisor REF funcionario_tp
);

/

CREATE OR REPLACE TYPE cliente_tp UNDER usuario_tp (
    tipo_de_assinatura VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE produto_tp AS OBJECT (
    codigo VARCHAR2(200),
    nome VARCHAR2(200),
    preco VARCHAR2(200),
    estoque VARCHAR2(200),
    nota_media VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE nt_produtos AS TABLE OF produto_tp;

/

CREATE OR REPLACE TYPE empresa_tp AS OBJECT (
    cnpj VARCHAR2(200),
    telefones lista_telefone,
    nome_fantasia VARCHAR2(200)
) NOT FINAL NOT INSTANTIABLE;

/

CREATE OR REPLACE TYPE transportadora_tp UNDER empresa_tp (
    frete VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE compra_cliente_tp AS OBJECT (
    cliente REF cliente_tp,
    produto REF produto_tp,
    data_saida VARCHAR2(200),
    data_entrega VARCHAR2(200),
    transpotadora REF transportadora_tp
);

/

CREATE OR REPLACE TYPE reclama_tp AS OBJECT (
    classificacao VARCHAR2(200),
    descricao VARCHAR2(200),
    funcionario REF funcionario_tp,
    cliente REF cliente_tp,
    compra_cliente REF compra_cliente_tp
);

/

CREATE OR REPLACE TYPE avalia_tp AS OBJECT (
    cliente REF cliente_tp,
    produto REF produto_tp,
    nota NUMBER
);

/

CREATE OR REPLACE TYPE categoria_tp AS OBJECT (
    nome VARCHAR2(200)
);

/

CREATE OR REPLACE TYPE lista_categoria AS VARRAY (5) OF categoria_tp;

/

CREATE OR REPLACE TYPE loja_tp AS OBJECT (
    categoria lista_categoria
);
