-- Dropando Tabelas
DROP TABLE EASYMED_USUARIOS CASCADE CONSTRAINTS;
DROP TABLE EASYMED_PESSOA_FISICA CASCADE CONSTRAINTS;
DROP TABLE EASYMED_PESSOA_JURIDICA CASCADE CONSTRAINTS;
DROP TABLE EASYMED_TIPO_USUARIO CASCADE CONSTRAINTS;
DROP TABLE EASYMED_MEDICAMENTOS CASCADE CONSTRAINTS;
DROP TABLE EASYMED_TRATAMENTOS CASCADE CONSTRAINTS;


-- Criando Tabelas
CREATE TABLE EASYMED_USUARIOS (
	CODIGO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_TIPO_USUARIO NUMBER NOT NULL,
	SENHA VARCHAR2(255) NOT NULL,
	EMAIL VARCHAR2(255) NOT NULL,

	constraint PK_USUARIOS PRIMARY KEY (CODIGO_USUARIO)
);

CREATE TABLE EASYMED_TIPO_USUARIO (
	CODIGO_TIPO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	TIPO_USUARIO VARCHAR2(255) NOT NULL,

	constraint PK_TIPO_USUARIO PRIMARY KEY (CODIGO_TIPO_USUARIO)
);

CREATE TABLE EASYMED_PESSOA_FISICA (
	CODIGO_PESSOA_FISICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER NOT NULL,
	NOME VARCHAR2(255) NOT NULL,
	CPF VARCHAR2(14) NOT NULL,

	constraint PK_PESSOA_FISICA PRIMARY KEY (CODIGO_PESSOA_FISICA)
);

CREATE TABLE EASYMED_PESSOA_JURIDICA (
	CODIGO_PESSOA_JURIDICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER NOT NULL,
	RAZAO_SOCIAL VARCHAR2(255) NOT NULL,
	CNPJ VARCHAR2(18) NOT NULL,

	constraint PK_PESSOA_JURIDICA PRIMARY KEY (CODIGO_PESSOA_JURIDICA)
);

CREATE TABLE EASYMED_MEDICAMENTOS (
	CODIGO_MEDICAMENTO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	NOME_MEDICAMENTO VARCHAR2(255) NOT NULL,

	constraint PK_MEDICAMENTO PRIMARY KEY (CODIGO_MEDICAMENTO)
);

CREATE TABLE EASYMED_TRATAMENTOS (
	CODIGO_TRATAMENTO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY, 
	CODIGO_MEDICAMENTO NUMBER NOT NULL,
	CODIGO_USUARIO NUMBER NOT NULL, 
	DATA_INICIO DATE NOT NULL,
	DATA_FINAL DATE,
	INTERVALO_HORAS NUMBER NOT NULL,
	MEDICAMENTO_ATIVO NUMBER(1) DEFAULT 1 NOT NULL,

	constraint PK_TRATAMENTO PRIMARY KEY (CODIGO_TRATAMENTO),
	constraint UK_TRATAMENTO UNIQUE(CODIGO_MEDICAMENTO, CODIGO_USUARIO)
);


-- Adicionando chaves estrangeiras
ALTER TABLE EASYMED_USUARIOS ADD CONSTRAINT FK_USUARIO_TIPO_USUARIO FOREIGN KEY (CODIGO_TIPO_USUARIO) REFERENCES EASYMED_TIPO_USUARIO(CODIGO_TIPO_USUARIO);
ALTER TABLE EASYMED_PESSOA_FISICA ADD CONSTRAINT FK_PESSOA_FISICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EASYMED_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EASYMED_PESSOA_JURIDICA ADD CONSTRAINT FK_PESSOA_JURIDICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EASYMED_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EASYMED_TRATAMENTOS ADD CONSTRAINT FK_TRATAMENTO_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EASYMED_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EASYMED_TRATAMENTOS ADD CONSTRAINT FK_TRATAMENTO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EASYMED_MEDICAMENTOS(CODIGO_MEDICAMENTO);
/


-- Criando blocos para insert
SET SERVEROUTPUT ON;

DECLARE 
	P_TIPO_USUARIO VARCHAR2(255) := '&TIPO_USUARIO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EASYMED_TIPO_USUARIO
	WHERE P_TIPO_USUARIO = TIPO_USUARIO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O tipo de usuário já existe.');
	END IF;

	INSERT INTO EASYMED_TIPO_USUARIO (TIPO_USUARIO)
	VALUES (P_TIPO_USUARIO);

	COMMIT;
END;
/

DECLARE
	P_EMAIL VARCHAR2(255) := '&EMAIL';
	P_SENHA VARCHAR2(255) := '&SENHA';
	P_CODIGO_TIPO_USUARIO NUMBER := '&CODIGO_TIPO_USUARIO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EASYMED_USUARIOS
	WHERE EMAIL = P_EMAIL;
	
	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário já existe.');
	END IF;
	
	INSERT INTO EASYMED_USUARIOS (SENHA, EMAIL, CODIGO_TIPO_USUARIO)
	VALUES (P_SENHA, P_EMAIL, P_CODIGO_TIPO_USUARIO);
    
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
	FROM EASYMED_PESSOA_FISICA
	WHERE P_CODIGO_USUARIO = CODIGO_USUARIO OR P_CPF = CPF;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário pessoa física já existe.');
	END IF;
	
	INSERT INTO EASYMED_PESSOA_FISICA (CODIGO_USUARIO, NOME, CPF)
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
	FROM EASYMED_PESSOA_JURIDICA
	WHERE P_CODIGO_USUARIO = CODIGO_USUARIO OR P_CNPJ = CNPJ OR P_RAZAO_SOCIAL = RAZAO_SOCIAL;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O usuário pessoa jurídica já existe.');
	END IF;
	
	INSERT INTO EASYMED_PESSOA_JURIDICA (CODIGO_USUARIO, RAZAO_SOCIAL, CNPJ)
	VALUES (P_CODIGO_USUARIO, P_RAZAO_SOCIAL, P_CNPJ);

	COMMIT;
END;
/

DECLARE
	P_NOME_MEDICAMENTO VARCHAR2(255) := '&NOME_MEDICAMENTO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EASYMED_MEDICAMENTOS
	WHERE P_NOME_MEDICAMENTO = NOME_MEDICAMENTO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O medicamento já existe.');
	END IF;

	INSERT INTO EASYMED_MEDICAMENTOS (NOME_MEDICAMENTO)
	VALUES (P_NOME_MEDICAMENTO);

	COMMIT;
END;
/

DECLARE
	P_CODIGO_MEDICAMENTO NUMBER := '&CODIGO_MEDICAMENTO';
	P_CODIGO_USUARIO NUMBER := '&CODIGO_USUARIO';
	P_DATA_INICIO VARCHAR2(10) := '&DATA_INICIO_YYYY_MM_DD';
	P_DATA_FINAL VARCHAR2(10) := '&DATA_FINAL_YYYY_MM_DD';
	P_INTERVALO_HORAS NUMBER := '&INTERVALO_HORAS';
	P_MEDICAMENTO_ATIVO NUMBER := '&MEDICAMENTO_ATIVO';
	COUNT_LINES NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO COUNT_LINES
	FROM EASYMED_TRATAMENTOS
	WHERE P_CODIGO_MEDICAMENTO = CODIGO_MEDICAMENTO AND P_CODIGO_USUARIO = CODIGO_USUARIO;

	IF COUNT_LINES > 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'O tratamento já existe.');
	END IF;
	
	INSERT INTO EASYMED_TRATAMENTOS (
		CODIGO_MEDICAMENTO, 
		CODIGO_USUARIO, 
		DATA_INICIO, 
		DATA_FINAL, 
		INTERVALO_HORAS, 
		MEDICAMENTO_ATIVO
	) VALUES (
		P_CODIGO_MEDICAMENTO, 
		P_CODIGO_USUARIO, 
		TO_DATE(P_DATA_INICIO, 'YYYY-MM-DD'),
		TO_DATE(P_DATA_FINAL, 'YYYY-MM-DD'),
		P_INTERVALO_HORAS, 
		P_MEDICAMENTO_ATIVO
	);

	COMMIT;
END;
/


-- Procedures com cursor e join
CREATE OR REPLACE PROCEDURE selectPessoaFisica
IS
  CURSOR pessoa_fisica_cursor IS
    SELECT 
        NOME,
        EMAIL,
        CPF
    FROM 
        easymed_usuarios eu
    INNER JOIN 
        easymed_pessoa_fisica epf ON
        eu.codigo_usuario = epf.codigo_usuario;

  v_nome VARCHAR(255);
  v_email VARCHAR(255);
  v_cpf VARCHAR(255);

BEGIN
  OPEN pessoa_fisica_cursor;
  LOOP
    FETCH pessoa_fisica_cursor INTO v_nome, v_email, v_cpf; 
    EXIT WHEN pessoa_fisica_cursor%NOTFOUND;

    dbms_output.put_line('Nome: ' || v_nome);
    dbms_output.put_line('EMail: ' || v_email);
    dbms_output.put_line('CPF: ' || v_cpf);
    dbms_output.put_line('---');
    
  END LOOP;
  CLOSE pessoa_fisica_cursor;

END selectPessoaFisica;
/

BEGIN
  selectPessoaFisica;
END;
/


CREATE OR REPLACE PROCEDURE selectTratamentos
IS
  CURSOR tratamento_cursor IS
    SELECT 
	    NOME,
	    NOME_MEDICAMENTO AS MEDICAMENTO,
	    INTERVALO_HORAS
	FROM 
	    EASYMED_TRATAMENTOS et
	INNER JOIN 
	    easymed_usuarios eu ON
	    eu.codigo_usuario = et.codigo_usuario
	INNER JOIN 
	    easymed_pessoa_fisica epf ON
	    eu.codigo_usuario = epf.codigo_usuario
	INNER JOIN 
	    easymed_medicamentos em ON
	    em.codigo_medicamento = et.codigo_medicamento;

  v_nome VARCHAR(255);
  v_medicamento VARCHAR(255);
  v_intervalo_horas NUMBER;

BEGIN
  OPEN tratamento_cursor;
  LOOP
    FETCH tratamento_cursor INTO v_nome, v_medicamento, v_intervalo_horas; 
    EXIT WHEN tratamento_cursor%NOTFOUND;

    dbms_output.put_line('Nome: ' || v_nome);
    dbms_output.put_line('Medicamento: ' || v_medicamento);
    dbms_output.put_line('Intervalo em horas: ' || v_intervalo_horas);
    dbms_output.put_line('---');
    
  END LOOP;
  CLOSE tratamento_cursor;

END selectTratamentos;
/

BEGIN
  selectTratamentos;
END;
/

