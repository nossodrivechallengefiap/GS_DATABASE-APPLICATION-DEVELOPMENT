-- Dropando Tabelas
DROP TABLE EM_USUARIOS CASCADE CONSTRAINTS;
DROP TABLE EM_PESSOA_FISICA CASCADE CONSTRAINTS;
DROP TABLE EM_PESSOA_JURIDICA CASCADE CONSTRAINTS;
DROP TABLE EM_TIPO_USUARIO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTOS CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_LIQUIDO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_SOLIDO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_USUARIO_INTERVALO CASCADE CONSTRAINTS;

CREATE TABLE EM_USUARIOS (
	CODIGO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	SENHA VARCHAR2(255) NOT NULL,
	EMAIL VARCHAR2(255) NOT NULL,

	constraint PK_USUARIOS PRIMARY KEY (CODIGO_USUARIO)
);


CREATE TABLE EM_PESSOA_FISICA (
	CODIGO_PESSOA_FISICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	CPF VARCHAR2(14) NOT NULL,

	constraint PK_PESSOA_FISICA PRIMARY KEY (CODIGO_PESSOA_FISICA)
);


CREATE TABLE EM_PESSOA_JURIDICA (
	CODIGO_PESSOA_JURIDICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER NOT NULL,
	RAZAO_SOCIAL VARCHAR2(255) NOT NULL,
	CNPJ VARCHAR2(18) NOT NULL,

	constraint PK_PESSOA_JURIDICA PRIMARY KEY (CODIGO_PESSOA_JURIDICA)
);


CREATE TABLE EM_TIPO_USUARIO (
	CODIGO_TIPO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER NOT NULL,
	TIPO_USUARIO VARCHAR2(255) NOT NULL,

	constraint PK_TIPO_USUARIO PRIMARY KEY (CODIGO_TIPO_USUARIO)
);


CREATE TABLE EM_MEDICAMENTOS (
	CODIGO_MEDICAMENTO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	NOME_MEDICAMENTO VARCHAR2(255) NOT NULL,

	constraint PK_MEDICAMENTO PRIMARY KEY (CODIGO_MEDICAMENTO)
);


CREATE TABLE EM_MEDICAMENTO_LIQUIDO (
	CODIGO_MEDICAMENTO_LIQUIDO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_MEDICAMENTO NUMBER NOT NULL,
	VOLUME_ML NUMBER NOT NULL,
	
	constraint PK_MEDICAMENTO_LIQUIDO PRIMARY KEY (CODIGO_MEDICAMENTO_LIQUIDO)
);


CREATE TABLE EM_MEDICAMENTO_SOLIDO (
	CODIGO_MEDICAMENTO_SOLIDO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_MEDICAMENTO NUMBER NOT NULL,
	QUANTIDADE NUMBER NOT NULL,

	constraint PK_MEDICAMENTO_SOLIDO PRIMARY KEY (CODIGO_MEDICAMENTO_SOLIDO)
);


CREATE TABLE EM_MEDICAMENTO_USUARIO_INTERVALO (
	CODIGO_MEDICAMENTO_USUARIO_INTERVALO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY, 
	CODIGO_MEDICAMENTO NUMBER NOT NULL,
	CODIGO_USUARIO NUMBER NOT NULL, 
	DATA_INICIO DATE NOT NULL,
	DATA_FINAL DATE,
	INTERVALO_HORAS NUMBER NOT NULL,
	MEDICAMENTO_ATIVO NUMBER(1) DEFAULT 1 NOT NULL,

	constraint PK_MEDICAMENTO_USUARIO_INTERVALO PRIMARY KEY (CODIGO_MEDICAMENTO_USUARIO_INTERVALO),
	constraint UK_MEDICAMENTO_USUARIO_INTERVALO UNIQUE(CODIGO_MEDICAMENTO, CODIGO_USUARIO)
);


-- Adicionando chaves estrangeiras
ALTER TABLE EM_PESSOA_FISICA ADD CONSTRAINT FK_PESSOA_FISICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_PESSOA_JURIDICA ADD CONSTRAINT FK_PESSOA_JURIDICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_TIPO_USUARIO ADD CONSTRAINT FK_TIPO_USUARIO_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_MEDICAMENTO_USUARIO_INTERVALO ADD CONSTRAINT FK_USUARIO_INTERVALO_MEDICAMENTO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_MEDICAMENTO_USUARIO_INTERVALO ADD CONSTRAINT FK_MEDICAMENTO_USUARIO_INTERVALO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);
ALTER TABLE EM_MEDICAMENTO_LIQUIDO ADD CONSTRAINT FK_MEDICAMENTO_LIQUIDO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);
ALTER TABLE EM_MEDICAMENTO_SOLIDO ADD CONSTRAINT FK_MEDICAMENTO_SOLIDO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);
/

-- Criando blocos para insert
DECLARE
	P_SENHA VARCHAR2(255) := &SENHA;
	P_EMAIL VARCHAR2(255) := &EMAIL;
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_USUARIOS
	WHERE EMAIL = P_EMAIL;
	
	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário já existe.');
	END IF;
	
	INSERT INTO EM_USUARIOS (SENHA, EMAIL)
	VALUES (P_SENHA, P_EMAIL);
    
    COMMIT;
END;
/

DECLARE
	P_CODIGO_USUARIO NUMBER := '&CODIGO_USUARIO';
	P_NOME VARCHAR2(255) := '&NOME';
	P_CPF VARCHAR2(255) := '&CPF';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_PESSOA_FISICA
	WHERE P_CODIGO_USUARIO = CODIGO_USUARIO OR P_CPF = CPF;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário pessoa física já existe.');
	END IF;
	
	INSERT INTO EM_PESSOA_FISICA (CODIGO_USUARIO, NOME, CPF)
	VALUES (P_CODIGO_USUARIO, P_NOME, P_CPF);

	COMMIT;
END;
/

DECLARE 
	P_CODIGO_USUARIO NUMBER := '&CODIGO_USUARIO';
	P_RAZAO_SOCIAL VARCHAR2(255) := '&RAZAO_SOCIAL';
	P_CNPJ VARCHAR2(255) := '&CNPJ';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_PESSOA_JURIDICA
	WHERE P_CODIGO_USUARIO = CODIGO_USUARIO OR P_CNPJ = CNPJ OR P_RAZAO_SOCIAL = RAZAO_SOCIAL;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário pessoa jurídica já existe.');
	END IF;
	
	INSERT INTO EM_PESSOA_JURIDICA (CODIGO_USUARIO, RAZAO_SOCIAL, CNPJ)
	VALUES (P_CODIGO_USUARIO, P_RAZAO_SOCIAL, P_CNPJ);

	COMMIT;
END;
/

DECLARE 
	P_CODIGO_USUARIO NUMBER := '&CODIGO_USUARIO';
	P_TIPO_USUARIO VARCHAR2(255) := '&TIPO_USUARIO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_TIPO_USUARIO
	WHERE P_TIPO_USUARIO = TIPO_USUARIO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O tipo de usuário já existe.');
	END IF;

	INSERT INTO EM_TIPO_USUARIO (CODIGO_USUARIO, TIPO_USUARIO)
	VALUES (P_CODIGO_USUARIO, P_TIPO_USUARIO);

	COMMIT;
END INSERT_EM_TIPO_USUARIO;
/

DECLARE
	P_NOME_MEDICAMENTO VARCHAR2(255) := '&NOME_MEDICAMENTO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_MEDICAMENTOS
	WHERE P_NOME_MEDICAMENTO = NOME_MEDICAMENTO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O medicamento já existe.');
	END IF;

	INSERT INTO EM_MEDICAMENTOS (NOME_MEDICAMENTO)
	VALUES (P_NOME_MEDICAMENTO);

	COMMIT;
END INSERT_EM_MEDICAMENTOS;
/

BEGIN
	P_CODIGO_MEDICAMENTO NUMBER := '&CODIGO_MEDICAMENTO';
	P_VOLUME_ML NUMBER := '&VOLUME_ML';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_MEDICAMENTO_LIQUIDO
	WHERE P_CODIGO_MEDICAMENTO = CODIGO_MEDICAMENTO AND P_VOLUME_ML = VOLUME_ML;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O medicamento líquido já existe.');
	END IF;
	
	INSERT INTO EM_MEDICAMENTO_LIQUIDO (CODIGO_MEDICAMENTO, VOLUME_ML)
	VALUES (P_CODIGO_MEDICAMENTO, P_VOLUME_ML);

	COMMIT;
END;
/

DECLARE
	P_CODIGO_MEDICAMENTO NUMBER := '&CODIGO_MEDICAMENTO';
	P_QUANTIDADE NUMBER := '&QUANTIDADE';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_MEDICAMENTO_SOLIDO
	WHERE P_CODIGO_MEDICAMENTO = CODIGO_MEDICAMENTO AND P_QUANTIDADE = QUANTIDADE;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O medicamento sólido já existe.');
	END IF;
	
	INSERT INTO EM_MEDICAMENTO_SOLIDO (CODIGO_MEDICAMENTO, QUANTIDADE)
	VALUES (P_CODIGO_MEDICAMENTO, P_QUANTIDADE);

	COMMIT;
END;
/

DECLARE
	P_CODIGO_MEDICAMENTO NUMBER := '&CODIGO_MEDICAMENTO';
	P_CODIGO_USUARIO NUMBER := '&CODIGO_USUARIO';
	P_DATA_INICIO DATE := '&DATA_INICIO';
	P_DATA_FINAL DATE := '&DATA_FINAL';
	P_INTERVALO_HORAS NUMBER := '&INTERVALO_HORAS';
	P_MEDICAMENTO_ATIVO NUMBER := '&MEDICAMENTO_ATIVO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EM_MEDICAMENTO_USUARIO_INTERVALO
	WHERE P_CODIGO_MEDICAMENTO = CODIGO_MEDICAMENTO AND P_CODIGO_USUARIO = CODIGO_USUARIO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O intervalo de medicamento para o usuário já existe.');
	END IF;
	
	INSERT INTO EM_MEDICAMENTO_USUARIO_INTERVALO (CODIGO_MEDICAMENTO, CODIGO_USUARIO, DATA_INICIO, DATA_FINAL, INTERVALO_HORAS, MEDICAMENTO_ATIVO)
	VALUES (P_CODIGO_MEDICAMENTO, P_CODIGO_USUARIO, P_DATA_INICIO, P_DATA_FINAL, P_INTERVALO_HORAS, P_MEDICAMENTO_ATIVO);

	COMMIT;
END INSERT_EM_MEDICAMENTO_USUARIO_INTERVALO;
/
