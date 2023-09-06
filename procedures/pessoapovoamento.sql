INSERT INTO tb_jogador VALUES(tp_jogador('55566621111', 'Agatha Ottoni', 'F', 40,
                              tp_endereco('85304390', NULL, '1023', 'Rua das Canafístulas'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 300));

INSERT INTO tb_jogador VALUES(tp_jogador('19321816283', 'Victor Matheus de Azevedo P.', 'M', 52,
                              tp_endereco('58420430', 'Ap 602', '224', 'Rua Alaíde Leandro Sobreira'),
                              tp_fones(tp_telefone('997415326'), tp_telefone('91234567')), 3000));

INSERT INTO tb_jogador VALUES(tp_jogador('94044687544', 'Lucas Gabriel R. de Melo', 'M', 25,
                              tp_endereco('19067100', 'Ap 2002', '471', 'Rua Santa Pavezi Rubim'),
                              tp_fones(tp_telefone('993547816'), tp_telefone('981357891')), 600));

INSERT INTO tb_jogador VALUES(tp_jogador('34864572097', 'Ana Carla Albuquerque', 'F', 28,
                              tp_endereco('65632660', 'Ap 904', '63', 'Rua Três'),
                              tp_fones(tp_telefone('991348915'), tp_telefone('935478915')), 5000));
 
INSERT INTO tb_jogador VALUES(tp_jogador('42824439602', 'Gabriel Barbosa Almeida', 'M', 26,
                              tp_endereco('89218055', 'Ap 3001', '1226', 'Rua Blumenau'),
                              tp_fones(tp_telefone('947589268'), tp_telefone('915745987')), 10000)); 



INSERT INTO tb_funcionario VALUES(tp_funcionario('95068505005', 'Sara Maria da Carvalheira', 'F', 38,
                              tp_endereco('13274350', NULL, '26', 'Avenida Doutor Altino Gouveia'),
                              tp_fones(tp_telefone('991635284'), tp_telefone('921571282'), tp_telefone('988195234')),
                              'Supervisor', 8000, NULL));

INSERT INTO tb_funcionario VALUES(tp_funcionario('51871590035', 'João Pedro Barreto Panda', 'M', 20,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 
                              'Dealer', 5000, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('99942745033', 'Lucas Oliveira Cavalcanti', 'M', 30,
                              tp_endereco('54505390', NULL, '322', 'Rua Conde da Boa Vista'),
                              tp_fones(tp_telefone('992005132')), 'Caixa', 3500, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('61888835044', 'João Lucas Alves', 'M', 34,
                              tp_endereco('69908650', NULL, '89', 'Avenida Getúlio Vargas'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Caixa', 2850, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '16790533028')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('16790533028', 'Patricia Ismael de Carvalho', 'F', 54,
                              tp_endereco('69908650', NULL, '87', 'Avenida Getúlio Vargas'),
                              tp_fones(tp_telefone('982865122'), tp_telefone('921001282')), 'Supervisor', 4050, NULL));

INSERT INTO tb_funcionario VALUES(tp_funcionario('99518963088', 'Bruna Alves W. Siqueira', 'F', 35,
                              tp_endereco('23092490', 'Ap 1202', '90', 'Rua São Bento do Sul'),
                              tp_fones(tp_telefone('912245118'), tp_telefone('995481078')), 'Dealer', 6400, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '16790533028')));
        
INSERT INTO tb_funcionario VALUES(tp_funcionario('49869393004', 'Andreia Duboc', 'F', 46,
                              tp_endereco('60831160', NULL, '777', 'Rua Lourdes Vidal Alves'),
                              tp_fones(tp_telefone('994887659')), 'Supervisor', 6550, NULL));

INSERT INTO tb_funcionario VALUES(tp_funcionario('66559107060', 'Matheus Frej Lemos C.', 'M', 62,
                              tp_endereco('74971460', 'Ap 101', '800', 'Travessa 1'),
                              tp_fones(tp_telefone('992342832'), tp_telefone('995481378'),tp_telefone('991222418')), 'Dealer', 4900, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '49869393004')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('78366263002', 'Alexandre Ottoni', 'M', 45,
                              tp_endereco('69901255', NULL, '192', 'Estrada Particular'),
                              tp_fones(tp_telefone('991223344'), tp_telefone('993022418')), 'Caixa', 2300, (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '49869393004')));


INSERT INTO tb_jogo VALUES(tp_jogo('1','Blackjack',150));
INSERT INTO tb_jogo VALUES(tp_jogo('2','Roleta',100));
INSERT INTO tb_jogo VALUES(tp_jogo('3','Poker',200));
INSERT INTO tb_jogo VALUES(tp_jogo('4','Roda da Fortuna',50));
INSERT INTO tb_jogo VALUES(tp_jogo('5','Caça-Níquel',10));


INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '55566621111'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '51871590035'),
    to_date('2022-08-31 19:10:01','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '94044687544'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '51871590035'),
    to_date('2022-08-31 19:10:01','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '5'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '19321816283'),
    NULL,
    to_date('2022-02-27 19:45:56','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '4'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '34864572097'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99518963088'),
    to_date('2022-05-27 13:42:34','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '1'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '42824439602'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99518963088'),
    to_date('2022-05-28 14:50:12','yyyy-mm-dd hh24:mi:ss')
));