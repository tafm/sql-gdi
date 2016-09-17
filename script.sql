/* Script SQL para criação e povoamento de tabelas 
Grupo: 
	Gabriel		(gvmgs)
	Jailson		(jcd2)
	Leonardo	(las3)
	Marcos		(msb5)
	Matheus		(mlrbc)
	Moabe		(mrov)
	Thomas 		(tafm)
	Vinicius	(vrm)
*/

-- 1. Criação de tabelas

-- 1.1 Pessoa

CREATE TABLE Pessoa (
	cpf varchar2(15),
	nome varchar2(50) NOT NULL,
	datanascimento date NOT NULL,
	sexo char(1) NOT NULL,
	cep varchar2(30) NOT NULL,
	cidade varchar2(30) NOT NULL,
	bairro varchar2(50) NOT NULL,
	rua varchar2(50) NOT NULL,
	numero varchar2(20) NOT NULL,
	CONSTRAINT Pessoa_pkey PRIMARY KEY (cpf),
	CONSTRAINT Pessoa_checkSexo CHECK (sexo In ('M', 'F'))
);

-- 1.2 Telefone

CREATE TABLE Telefone (
	cpf varchar2(15),
	numero varchar2(50),
	CONSTRAINT telefone_pkey1 PRIMARY KEY (cpf, numero),
	CONSTRAINT pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);

-- 1.3 Funcionário

CREATE TABLE Funcionario (
	cpf varchar2(15),
	salario number(10,2) NOT NULL,
	dataAdmissao date NOT NULL,
	CONSTRAINT funcionario_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT func_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
	CONSTRAINT Funcionario_checkSal CHECK (salario >= 880.00)
);

-- 1.4 Assinante

CREATE TABLE Assinante (
	cpf varchar2(15),
	planoAssinatura varchar2(50) NOT NULL,
	dataAssinatura date NOT NULL,
	CONSTRAINT assinante_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT assinante_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);

-- 1.5 Fotografo

CREATE TABLE Fotografo (
	cpf varchar2(15),
	certificado blob,
	CONSTRAINT fotografo_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT fotografo_funcionario_fkey1 FOREIGN KEY (cpf) REFERENCES Funcionario (cpf)
);

-- 1.6 Jornalista

CREATE TABLE Jornalista (
	cpf varchar2(15),
	mtb varchar2(20),
	cpf_supervisor varchar2(15),
	CONSTRAINT jornalista_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT jornalista_funcionario_fkey1 FOREIGN KEY (cpf) REFERENCES Funcionario (cpf),
	CONSTRAINT jornalista_fkey1 FOREIGN KEY (cpf_supervisor) REFERENCES Jornalista (cpf)
);

-- 1.7 Titulação

CREATE TABLE Titulacao (
	cpf varchar2(15),
	data date NOT NULL,
	instituicao varchar2(50) NOT NULL,
	grau varchar2(30) NOT NULL,
	CONSTRAINT titulacao_jornalista_fkey1 FOREIGN KEY (cpf) REFERENCES Jornalista (cpf)  
);

-- 1.8 Edição

CREATE TABLE Edicao (
	numero integer,
	cpf_chefe varchar2(15),
	data date NOT NULL,
	CONSTRAINT edicao_pkey PRIMARY KEY (numero),
	CONSTRAINT edicao_jornalista_fkey1 FOREIGN KEY (cpf_chefe) REFERENCES Jornalista (cpf)
);

-- 1.9 Seção

CREATE TABLE Secao (
	nome varchar2(30),
	cpf_coord varchar2(15),
	CONSTRAINT secao_pkey PRIMARY KEY (nome),
	CONSTRAINT secao_jornalista_fkey1 FOREIGN KEY (cpf_coord) REFERENCES Jornalista (cpf)
);

-- 1.10 Matéria

CREATE TABLE Materia (
    id integer,
    secao varchar2(30),
    titulo CLOB NOT NULL,
    data date NOT NULL,
    conteudo CLOB,
    anexos CLOB,
    CONSTRAINT materia_pkey PRIMARY KEY (id),
    CONSTRAINT materia_secao_fkey1 FOREIGN KEY (secao) REFERENCES Secao (nome)
 );

-- 1.11 Jornalista <escreve> Matéria

CREATE TABLE JornTrabMateria (
	cpf varchar2(15),
	id_materia integer,
	CONSTRAINT jorntabmateria_pkey PRIMARY KEY (cpf, id_materia),
	CONSTRAINT jorntabmateria_jornalista_fkey FOREIGN KEY (cpf) REFERENCES Jornalista (cpf),
	CONSTRAINT jorntabmateria_materia_fkey FOREIGN KEY (id_materia) REFERENCES Materia (id)
);