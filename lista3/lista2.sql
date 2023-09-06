SELECT DEREF(jo.jogador).nome FROM tb_joga jo
GROUP BY DEREF(jo.jogador).nome
HAVING COUNT(DEREF(jo.jogo).id) > 2;

/

SELECT DEREF(f.supervisor).nome, DEREF(f.supervisor).cpf, DEREF(f.supervisor).idade
FROM tb_funcionario  f
WHERE f.salario > DEREF(f.supervisor).salario;

/

SELECT DEREF(j.jogador).cpf, DEREF(j.jogador).nome, DEREF(j.jogador).idade, t.numero FROM tb_joga j, TABLE(DEREF(j.jogador).telefones) t
WHERE t.numero LIKE '99%'
AND DEREF(j.jogo).nome_jogo  = 'Poker';

/

SELECT DEREF(j.jogo).nome_jogo FROM tb_joga j 
WHERE DEREF(j.jogador).idade < 25
AND DEREF(j.jogo).nome_jogo NOT IN (SELECT DEREF(j2.jogo).nome_jogo FROM tb_joga j2 WHERE DEREF(j2.jogador).idade > 25);

/

SELECT DEREF(j.jogador).nome FROM tb_joga j
GROUP BY DEREF(j.jogador).nome
HAVING COUNT(DEREF(j.jogo).nome_jogo) = (SELECT COUNT(DISTINCT(DEREF(j2.jogo).nome_jogo)) FROM tb_joga j2);

/

SELECT DEREF(DEREF(j.funcionario).supervisor).nome FROM tb_joga j
WHERE DEREF(j.jogo).id IS NULL;

/

SELECT DEREF(j.jogo).nome

/

SELECT DEREF(j.jogador).nome FROM tb_joga j
WHERE DEREF(j.jogo).id IN (SELECT DEREF(j2.jogo).id FROM tb_joga j2 WHERE DEREF(j2.jogador).cpf = '55566621111')
AND DEREF(j.jogador).cpf != '55566621111';

/

SELECT DEREF(j.jogo).nome_jogo FROM tb_joga j
WHERE COUNT(DEREF(j.jogador).cpf) >= 4;

/


SELECT f.cpf, f.nome
FROM tb_funcionario f
WHERE f.genero = 'M'
AND (SELECT COUNT(*) FROM tb_funcionario fs
     WHERE fs.supervisor = REF(f)) >= 2
AND (SELECT COUNT(DISTINCT j.jogador) FROM tb_joga j
     WHERE j.funcionario = REF(f)) >= 2;


/

SELECT DEREF(j.jogador).cpf, DEREF(j.jogador).nome FROM tb_joga j, TABLE(DEREF(j.jogador).telefones) T
WHERE DEREF(j.jogador).genero = 'F'
AND DEREF(j.jogo).id IN (SELECT DEREF(j2.jogo).id FROM tb_joga j2 WHERE DEREF(j2.funcionario).genero = 'M')
GROUP BY DEREF(j.jogador).cpf, DEREF(j.jogador).nome
HAVING COUNT(T.numero) > 1; 

/


