-- Dropando Tabelas
DROP TABLE EM_USUARIOS CASCADE CONSTRAINTS;
DROP TABLE EM_PESSOA_FISICA CASCADE CONSTRAINTS;
DROP TABLE EM_PESSOA_JURIDICA CASCADE CONSTRAINTS;
DROP TABLE EM_TIPO_USUARIO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTOS CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_LIQUIDO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_SOLIDO CASCADE CONSTRAINTS;
DROP TABLE EM_MEDICAMENTO_HORARIO CASCADE CONSTRAINTS;


-- Criando tabelas
CREATE TABLE EM_USUARIOS (
	CODIGO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	SENHA VARCHAR2(255) NOT NULL,
	EMAIL VARCHAR2(255) NOT NULL,

	constraint PK_USUARIOS PRIMARY KEY (CODIGO_USUARIO)
);


CREATE TABLE EM_PESSOA_FISICA (
	CODIGO_PESSOA_FISICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER,
	NOME VARCHAR2(255) NOT NULL,
	CPF VARCHAR2(14) NOT NULL,

	constraint PK_PESSOA_FISICA PRIMARY KEY (CODIGO_PESSOA_FISICA)
);


CREATE TABLE EM_PESSOA_JURIDICA (
	CODIGO_PESSOA_JURIDICA NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER,
	RAZAO_SOCIAL VARCHAR2(255) NOT NULL,
	CNPJ VARCHAR2(18) NOT NULL,

	constraint PK_PESSOA_JURIDICA PRIMARY KEY (CODIGO_PESSOA_JURIDICA)
);


CREATE TABLE EM_TIPO_USUARIO (
	CODIGO_TIPO_USUARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER,
	TIPO_USUARIO VARCHAR2(255) NOT NULL,

	constraint PK_TIPO_USUARIO PRIMARY KEY (CODIGO_TIPO_USUARIO)
);


CREATE TABLE EM_MEDICAMENTOS (
	CODIGO_MEDICAMENTO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_USUARIO NUMBER,
	NOME_MEDICAMENTO VARCHAR2(255) NOT NULL,
	MEDICAMENTO_ATIVO NUMBER(1) DEFAULT 1 NOT NULL,
	DATA_INICIO DATE NOT NULL,
	DATA_FINAL DATE,

	constraint PK_MEDICAMENTO PRIMARY KEY (CODIGO_MEDICAMENTO)
);


CREATE TABLE EM_MEDICAMENTO_LIQUIDO (
	CODIGO_MEDICAMENTO_LIQUIDO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_MEDICAMENTO NUMBER,
	VOLUME NUMBER,
	
	constraint PK_MEDICAMENTO_LIQUIDO PRIMARY KEY (CODIGO_MEDICAMENTO_LIQUIDO)
);


CREATE TABLE EM_MEDICAMENTO_SOLIDO (
	CODIGO_MEDICAMENTO_SOLIDO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_MEDICAMENTO NUMBER,
	QUANTIDADE NUMBER,

	constraint PK_MEDICAMENTO_SOLIDO PRIMARY KEY (CODIGO_MEDICAMENTO_SOLIDO)
);


CREATE TABLE EM_MEDICAMENTO_HORARIO (
	CODIGO_MEDICAMENTO_HORARIO NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	CODIGO_MEDICAMENTO NUMBER,
	HORARIO DATE,

	constraint PK_MEDICAMENTO_HORARIO PRIMARY KEY (CODIGO_MEDICAMENTO_HORARIO)
);


-- Adicionando chaves estrangeiras
ALTER TABLE EM_PESSOA_FISICA ADD CONSTRAINT FK_PESSOA_FISICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_PESSOA_JURIDICA ADD CONSTRAINT FK_PESSOA_JURIDICA_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_TIPO_USUARIO ADD CONSTRAINT FK_TIPO_USUARIO_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_MEDICAMENTOS ADD CONSTRAINT FK_MEDICAMENTO_USUARIO FOREIGN KEY (CODIGO_USUARIO) REFERENCES EM_USUARIOS(CODIGO_USUARIO);
ALTER TABLE EM_MEDICAMENTO_LIQUIDO ADD CONSTRAINT FK_MEDICAMENTO_LIQUIDO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);
ALTER TABLE EM_MEDICAMENTO_SOLIDO ADD CONSTRAINT FK_MEDICAMENTO_SOLIDO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);
ALTER TABLE EM_MEDICAMENTO_HORARIO ADD CONSTRAINT FK_MEDICAMENTO_HORARIO_MEDICAMENTO FOREIGN KEY (CODIGO_MEDICAMENTO) REFERENCES EM_MEDICAMENTOS(CODIGO_MEDICAMENTO);

