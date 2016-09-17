/* Script SQL para criação e população de tabelas 
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