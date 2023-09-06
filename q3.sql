
CREATE OR REPLACE TYPE tp_hora_aula AS OBJECT( dia_semana VARCHAR(3), hora_inicio INT, hora_fim    INT);
/

CREATE OR REPLACE TYPE tp_va_hora_aula AS VARRAY(5) OF tp_hora_aula;
/

CREATE OR REPLACE TYPE tp_disciplina AS OBJECT(cod_disc  VARCHAR(5), nome_disc VARCHAR(50), objetivo  VARCHAR(200), horarios tp_va_hora_aula, MEMBER FUNCTION checa_choque_horario(cod_disc_check VARCHAR) RETURN VARCHAR);
/

CREATE OR REPLACE TYPE tp_nota AS OBJECT(nota NUMBER(4,2));
/

CREATE OR REPLACE TYPE tp_va_notas AS VARRAY(6) OF tp_nota;
/

CREATE OR REPLACE TYPE tp_cursa_disc AS OBJECT (disc_ref REF tp_disciplina, notas tp_va_notas);
/

CREATE OR REPLACE TYPE tp_nt_bruxo_cursa AS TABLE OF tp_cursa_disc;
/

CREATE OR REPLACE TYPE tb_bruxo AS OBJECT(cod_bruxo VARCHAR(5), nome_bruxo VARCHAR(50), idade INTEGER, casa  VARCHAR(15), cursa_disc tp_nt_bruxo_cursa, MEMBER PROCEDURE add_nota(cod_disc_up VARCHAR, nota NUMBER));
/

CREATE TABLE tb_disciplina OF tp_disciplina(cod_disc PRIMARY KEY);
/
CREATE TABLE tb_bruxo OF tp_bruxo(cod_bruxo PRIMARY KEY) NESTED TABLE cursa_disc STORE AS tb_cursa_disc;

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


/

CREATE OR REPLACE TYPE BODY tp_disciplina AS
    MEMBER FUNCTION checa_choque_horario(cod_disc_check VARCHAR) RETURN VARCHAR IS
        horarios_disc tp_va_hora_aula;
    BEGIN
        SELECT d.horarios.
    END;
END;


/

--Gabarito q4

--Após a criação das tabelas
CREATE OR REPLACE TYPE BODY tp_disciplina AS
	MEMBER FUNCTION checa_choque_horario(cod_disc_check VARCHAR) RETURN VARCHAR IS
   	 h1 tp_va_hora_aula;
   	 h2 tp_va_hora_aula;
    
	BEGIN
    	SELECT horarios INTO h1 FROM tb_disciplina WHERE cod_disc = SELF.cod_disc;
    	SELECT horarios INTO h2 FROM tb_disciplina WHERE cod_disc = cod_disc_check;

   	 FOR i IN 1..h1.count LOOP
        	FOR j IN 1..h2.count LOOP
       		 IF h1(i).dia_semana = h2(j).dia_semana THEN
       			 IF (h1(i).hora_inicio < h2(j).hora_fim) AND (h1(i).hora_fim > h2(j).hora_inicio) THEN
   					 RETURN 'S';
   				 END IF;
       		 END IF;
        	END LOOP;
    	END LOOP;

   	 RETURN 'N';
	END;
END;
