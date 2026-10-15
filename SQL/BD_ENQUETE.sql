CREATE DATABASE IF NOT EXISTS BD_ENQUETE;
USE BD_ENQUETE;

CREATE TABLE IF NOT EXISTS USUARIOS(
	USU_CODIGO        INT AUTO_INCREMENT,
    USU_DATA_CADATRO  DATE NOT NULL,
    USU_LOGIN         VARCHAR(50) NOT NULL UNIQUE, -- LOGIN É ÚNICO
    USU_AREA_ATUACAO  VARCHAR(50),
    USU_PROFISSAO     VARCHAR(50),
    USU_AREA_FORMACAO VARCHAR(50),
    USU_DATANASC      DATE NOT NULL,
    USU_ESTADO_CIVIL  ENUM('Solteiro','Casado','Divorciado','Viúvo') NOT NULL,
    USU_ESTADO        VARCHAR(2) NOT NULL,
    USU_ESCOLARIDADE  ENUM('Fundamental completo', 'Médio completo', 'Superior') NOT NULL,
    USU_EMAIL         VARCHAR(50) NOT NULL UNIQUE,
    USU_SENHA         VARCHAR(255) NOT NULL ,
    USU_NOME          VARCHAR(100) NOT NULL,
    PRIMARY KEY (USU_CODIGO)
    );
    
CREATE TABLE IF NOT EXISTS ENQUETE(
	ENQ_CODIGO       INT AUTO_INCREMENT,
    ENQ_DATA_INICIAL DATE NOT NULL,
    ENQ_DATA_FINAL   DATE,
    ENQ_DESCRICAO    VARCHAR(1440),
    ENQ_NOME         VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY(ENQ_CODIGO)
);

CREATE TABLE IF NOT EXISTS PERGUNTAS(
	PER_CODIGO       INT AUTO_INCREMENT,
    PER_DESCRICAO    VARCHAR(500) NOT NULL,
    FK_ENQ_CODIGO    INT NOT NULL,
    PRIMARY KEY (PER_CODIGO),
    FOREIGN KEY (FK_ENQ_CODIGO) REFERENCES ENQUETE(ENQ_CODIGO) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RESPOSTAS(
	RES_CODIGO      INT AUTO_INCREMENT,
    RES_DESCRICAO   VARCHAR(500) NOT NULL,
    RES_CERTA       VARCHAR(1) NOT NULL,
    FK_PER_CODIGO   INT NOT NULL,
    PRIMARY KEY (RES_CODIGO),
    FOREIGN KEY (FK_PER_CODIGO) REFERENCES PERGUNTAS(PER_CODIGO) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS USUARIO_RESPONDE_ENQUETE(
	URE_CODIGO    INT AUTO_INCREMENT,
    URE_DATA      DATE NOT NULL,
    FK_USU_CODIGO INT NOT NULL,
    FK_ENQ_CODIGO INT NOT NULL,
    PRIMARY KEY (URE_CODIGO),
    FOREIGN KEY (FK_USU_CODIGO) REFERENCES USUARIOS(USU_CODIGO) ON DELETE CASCADE,
    FOREIGN KEY (FK_ENQ_CODIGO) REFERENCES ENQUETE(ENQ_CODIGO) ON DELETE CASCADE
);

-- ÌNDICES DE CONSULTAS (SELECT)
-- Criar índicesem cammpos com altas chances de serem buscados em um select
-- UNIQUE e PRIMARY KEY já tem Ìndices automaticamente
CREATE INDEX IDX_USUARIO_AREA_ATUACAO ON USUARIOS(USU_AREA_ATUACAO);

CREATE INDEX IDX_USUARIO_AREA_FORMACAO ON USUARIOS(USU_AREA_FORMACAO);

CREATE INDEX IDX_USAURIO_ESCOLARIDADE ON USUARIOS(USU_ESCOLARIDADE);

CREATE INDEX IDX_URE_USUARIO_ENQUETE ON USUARIO_RESPONDE_ENQUETE(FK_USU_CODIGO,FK_ENQ_CODIGO);

-- DCL DATA CONTROL LANGUAGE
-- Linguagem de controle de dados

-- 1.Criar usuários
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adimin@123';
CREATE USER 'analara'@'localhost' IDENTIFIED BY 'senhaForte@123';

-- 2.Verificar se foram criados os usuarios
SELECT USER, HOST FROM MYSQL.USER;

-- 3.Conceder permissões para os usuários
-- Dar todos os privilegios em todas as tabelas para o admin
GRANT ALL PRIVILEGES ON BD_ENQUETE.* TO 'admin'@'localhost';
-- Liberar apenas INSERT E SELECT para o seu usuário
GRANT INSERT ON BD_ENQUETE.* TO 'analara'@'localhost';
GRANT SELECT ON BD_ENQUETE.* TO 'analara'@'localhost';
-- Libera o usuario realizar somente UPDATE na tabela respostas
GRANT UPDATE ON BD_ENQUETE.RESPOSTAS TO 'analara'@'localhost';

-- 4.Revogar uma permissão
REVOKE UPDATE ON BD_ENQUETE.RESPOSTAS FROM 'analara'@'localhost';

-- 5 INSERTS EM CADA TABELA
-- USUARIOS
INSERT INTO USUARIOS(USU_DATA_CADATRO ,USU_LOGIN,USU_DATANASC,USU_ESTADO_CIVIL,USU_ESTADO,USU_ESCOLARIDADE,USU_EMAIL,USU_SENHA,USU_NOME)
VALUES			    (NOW(),'anadias','2010-03-31','Solteiro','sp', 'Médio completo', 'ana.aparecido@gmail.com','123','Ana Lara'),
					(NOW(),'pedroBiondo','2009-11-20','Solteiro','sp', 'Médio completo', 'pedro@gmail.com','654','Pedro'),
                    (NOW(),'mariacecilia','2015-06-29','Solteiro','mg', 'Fundamental completo', 'mcdias@gmail.com','898','Maria Cecilia'),
                    (NOW(),'natyprovi','1989-09-20','Divorciado','rj', 'Fundamental completo', 'natyprovidias20@gmail.com','278','Natalia'),
                    (NOW(),'pedrohenrique','2007-12-04','Solteiro','am', 'Médio completo', 'pedrodias@gmail.com','000','Pedro Dias');
SELECT * FROM USUARIOS;

-- ENQUETE
INSERT INTO ENQUETE(ENQ_DATA_INICIAL, ENQ_NOME)
VALUES             ('2026-10-14','Sua Opinião Importa!'),
				   ('2026-10-01','Qual é o Próximo Passo'),
                   ('2026-09-25','Escolha Seu Favorito'),
                   ('2026-07-04','O Que Você Prefere?'),
                   ('2026-05-12','Hora do Feedback');
SELECT *FROM ENQUETE;

-- PERGUNTAS
INSERT INTO PERGUNTAS(PER_DESCRICAO,FK_ENQ_CODIGO )
VALUES               ('Qual formato de conteúdo você mais consome no nosso perfil?',1),
					 ('Em qual projeto nossa equipe deve focar os esforços no próximo trimestre?',2),
                     ('Se você pudesse levar apenas um destes sabores para uma ilha deserta, qual seria?',3),
                     ('Em uma viagem de férias dos seus sonhos, oque você prefere:',4),
                     ('Como você avalia a sua experiência geral com o nosso atendimento hoje?',5);
SELECT * FROM PERGUNTAS;

-- REPOSTAS
INSERT INTO RESPOSTAS(RES_DESCRICAO  ,RES_CERTA ,FK_PER_CODIGO )
VALUE                ('A)Vídeos curtos (Reels/TikTok)','A',1),
                     ('B)Posts em carrossel','A',1),
                     ('C) Textos longos','A',1),
                     ('D) Stories diários','A',1);
SELECT * FROM RESPOSTAS;

-- USUARIO_RESPONDE_ENQUETE
INSERT INTO USUARIO_RESPONDE_ENQUETE (URE_DATA  ,FK_USU_CODIGO ,FK_ENQ_CODIGO  )
VALUE                                ('2025-12-25',1,5),
									 ('2025-10-15',2,4),
                                     ('2025-02-18',3,3),
                                     ('2024-08-30',4,2),
                                     ('2023-11-05',5,1);
SELECT * FROM USUARIO_RESPONDE_ENQUETE;


