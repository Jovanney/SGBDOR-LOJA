CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(255),
    genero VARCHAR2(1),
    idade NUMBER(2),
    endereco tp_endereco,
    telefones tp_fones,
    
    MEMBER PROCEDURE atualizar_endereco (novo_endereco endereco_tp)
    
) NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY tp_pessoa AS
    MEMBER PROCEDURE atualizar_endereco (novo_endereco IN endereco_tp) IS 
    BEGIN
        UPDATE TABLE pessoa_tb p
        SET p.endereco = novo_endereco
        WHERE p.cpf = SELF.cpf;
    END;
END;