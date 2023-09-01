CREATE OR REPLACE TYPE equipe_tp AS OBJECT (
	id_equipe VARCHAR2(50),
	nome VARCHAR2(50),
	data_criacao TIMESTAMP
);

--NT: equipes_participantes (Campeonatos)
--VARRAY: nacionalidade (Jogador)
/

CREATE OR REPLACE TYPE residencia_tp AS OBJECT(
	cod_residencia_unificado VARCHAR2(50),
	pais_atual VARCHAR2(50),
	estado VARCHAR2(50),
	municipio VARCHAR2(50)
);

CREATE TABLE Residencia OF residencia_tp(
	cod_residencia_unificado NOT NULL,
	pais_atual NOT NULL,
	estado NOT NULL,
	municipio NOT NULL,
);

/

CREATE OR REPLACE TYPE nacionalidade_tp AS OBJECT(
    nacionalidade VARCHAR2(50)
);

/
CREATE OR REPLACE TYPE varray_nacionalidade AS VARRAY(3) OF nacionalidade_tp;

/
CREATE OR REPLACE TYPE jogador_tp AS OBJECT (
	id_jogador VARCHAR2(50),
	nome VARCHAR2(50),
	data_nascimento TIMESTAMP,
    nacionalidade varray_nacionalidade,
    cod_residencia_unificado VARCHAR2(50),
    equipe_atual VARCHAR2(50)
);





/

CREATE OR REPLACE TYPE line_up_data_tp AS OBJECT(
	id_jogador VARCHAR2(50),
	ano TIMESTAMP,
	equipe_na_data VARCHAR2(50)
);

/
CREATE TYPE participacao_equipes_campeonatos_tp AS TABLE OF VARCHAR2(200);

/

CREATE OR REPLACE TYPE campeonato_tp AS OBJECT(
	id_campeonato VARCHAR2(50),
    	nome VARCHAR2(50),
    	ano TIMESTAMP,
    	tipo VARCHAR2(50),
    	equipes_participantes participacao_equipes_campeonatos_tp
)
--NESTED TABLE equipes_paticipantes STORE AS camp_participantes_nt;

/

CREATE OR REPLACE TYPE participacao_equipes_campeonatos_tp AS OBJECT(
	id_equipe VARCHAR2(50),
	id_campeonato VARCHAR2(50),
	ranking NUMBER
);

-------

CREATE TABLE Equipe OF equipe_tp(
	id_equipe NOT NULL,
	nome NOT NULL,
	data_criacao NOT NULL,

	CONSTRAINT equipe_pk PRIMARY KEY (id_equipe)
)

/

CREATE TABLE Campeonato OF campeonato_tp(
	id_campeonato NOT NULL,
	nome NOT NULL,
	ano NOT NULL,
	tipo NOT NULL

	CONSTRAINT campeonato_pk PRIMARY KEY (id_campeonato)

) NESTED TABLE equipes_participantes STORE AS camp_participantes_nt;
