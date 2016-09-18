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
	CONSTRAINT pessoa_pkey PRIMARY KEY (cpf),
	CONSTRAINT pessoa_checkSexo CHECK (sexo In ('M', 'F'))
);

-- 1.2 Telefone

CREATE TABLE Telefone (
	cpf varchar2(15),
	numero varchar2(50),
	CONSTRAINT telefone_pkey1 PRIMARY KEY (cpf, numero),
	CONSTRAINT pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);

-- 1.3 Assinante

CREATE TABLE Assinante (
	cpf varchar2(15),
	planoAssinatura varchar2(50) NOT NULL,
	dataAssinatura date NOT NULL,
	CONSTRAINT assinante_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT assinante_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);

-- 1.4 Funcionário

CREATE TABLE Funcionario (
	cpf varchar2(15),
	salario number(10,2) NOT NULL,
	dataAdmissao date NOT NULL,
	CONSTRAINT funcionario_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT func_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
	CONSTRAINT Funcionario_checkSal CHECK (salario >= 880.00)
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
	edicao integer,
	titulo varchar2(255) NOT NULL,
	data date NOT NULL,
	conteudo CLOB,
	anexos CLOB,
	CONSTRAINT materia_pkey PRIMARY KEY (id),
	CONSTRAINT materia_edicao_fkey1 FOREIGN KEY (edicao) REFERENCES Edicao (numero),
	CONSTRAINT materia_secao_fkey2 FOREIGN KEY (secao) REFERENCES Secao (nome)
 );

-- 1.11 Jornalista <escreve> Matéria

CREATE TABLE JornTrabMateria (
	cpf varchar2(15),
	id_materia integer,
	CONSTRAINT jorntab_pkey PRIMARY KEY (cpf, id_materia),
	CONSTRAINT jorntab_jornalista_fkey1 FOREIGN KEY (cpf) REFERENCES Jornalista (cpf),
	CONSTRAINT jorntab_materia_fkey2 FOREIGN KEY (id_materia) REFERENCES Materia (id)
);

-- 1.12 Premiação

CREATE TABLE Premiacao (
	evento varchar2(50),
	data date NOT NULL,
	categoria varchar2(50),
	CONSTRAINT Premiacao_pkey PRIMARY KEY (evento, data)
);

-- 1.13 (Jornalista <escreve> Matéria) <ganha> Premiação

CREATE TABLE Ganha (
	cpf varchar2(15),
	id_materia integer,
	evento varchar2(50),
	data date,
	CONSTRAINT ganha_pkey PRIMARY KEY (cpf, id_materia, evento),
	CONSTRAINT ganha_jortrabmateria_fkey1 FOREIGN KEY (cpf, id_materia) REFERENCES JornTrabMateria (cpf, id_materia),
	CONSTRAINT ganha_premiacao_fkey2 FOREIGN KEY (evento, data) REFERENCES Premiacao (evento, data)
);

-- 1.14 Fotos

CREATE TABLE Foto (
	id integer,
	fotografo varchar2(15),
	materia integer,
	foto BLOB NOT NULL,
	CONSTRAINT foto_pkey PRIMARY KEY (id),
	CONSTRAINT foto_fotografo_fkey1 FOREIGN KEY (fotografo) REFERENCES Fotografo (cpf),
	CONSTRAINT foto_materia_fkey2 FOREIGN KEY (materia) REFERENCES Materia (id)
);

-- 1.15 Evento

CREATE TABLE Evento (
	nome varchar2(50),
	fotografo varchar2(15),
	data date,
	CONSTRAINT evento_pkey PRIMARY KEY (nome, fotografo, data),
	CONSTRAINT evento_fotografo_fkey1 FOREIGN KEY (fotografo) REFERENCES Fotografo (cpf)
);

-- 2. Povoamento de tabelas

-- 2.1 Pessoa

INSERT ALL
INTO Pessoa VALUES ('123456789-45', 'Leonardo Alves',   TO_DATE('16/12/1996', 'dd/MM/yyyy'), 'M', '44900000', 'Irecê',          'Bairro',				'Rua Aquela Mesma',		'16')
INTO Pessoa VALUES ('888777666-85', 'Marcos Barreto',   TO_DATE('16/08/1996', 'dd/MM/yyyy'), 'M', '99212300', 'Irecê',          'Bairro2',				'Rua do Beco',			'188')
INTO Pessoa VALUES ('456228741-99', 'Afonso Gomes',     TO_DATE('09/05/1987', 'dd/MM/yyyy'), 'M', '05465203', 'São Paulo',      'Liberdade',			'Av.Paulista',			'548')
INTO Pessoa VALUES ('648752006-56', 'Roberto Andrade',  TO_DATE('30/05/1990', 'dd/MM/yyyy'), 'M', '54862066', 'Rio de Janeiro', 'Leblon',				'Rua 10',				'9')
INTO Pessoa VALUES ('160742365-48', 'Alice Ayres',      TO_DATE('01/01/2000', 'dd/MM/yyyy'), 'F', '98212340', 'Irecê',          'Recanto',				'Antonio Cardoso',		'61')
INTO Pessoa VALUES ('283492009-11', 'Ana Maria',        TO_DATE('10/05/1997', 'dd/MM/yyyy'), 'F', '54896211', 'Brasília',       'Centro',				'Rua JK',				'7')
INTO Pessoa VALUES ('945632778-12', 'Ana Alves',        TO_DATE('02/02/1987', 'dd/MM/yyyy'), 'F', '66975233', 'São Paulo',      'Morumbi',				'Av. Santo Antônio',	'400')
INTO Pessoa VALUES ('549316775-00', 'Bob Jones',        TO_DATE('05/06/1988', 'dd/MM/yyyy'), 'M', '75264977', 'Acre',           'Floresta',				'Árvore',				'7')
INTO Pessoa VALUES ('654823004-11', 'Amanda Nunes',     TO_DATE('06/04/1944', 'dd/MM/yyyy'), 'F', '65482236', 'Recife',         'CDU',					'Polidoro',				'344')
INTO Pessoa VALUES ('684997235-01', 'João Silva',       TO_DATE('10/07/1980', 'dd/MM/yyyy'), 'M', '95877236', 'Recife',         'CDU',					'UFPE',					'455')
INTO Pessoa VALUES ('234908724-88', 'Vitor Pereira',    TO_DATE('15/12/1995', 'dd/MM/yyyy'), 'M', '23456000', 'Recife',         'Bairro do Caxanga',	'Avenida Caxangá',		'230')
INTO Pessoa VALUES ('171615142-21', 'Amanda Kezia',     TO_DATE('23/10/1994', 'dd/MM/yyyy'), 'F', '77800000', 'Recife',         'Várzea',				'João F. Lisboa',		'120')
SELECT 1 FROM DUAL;

-- 2.2 Telefone

INSERT ALL
INTO Telefone VALUES ('123456789-45', '081-982661311')
INTO Telefone VALUES ('123456789-45', '074-9818-9022')
INTO Telefone VALUES ('123456789-45', '074-999473373')
INTO Telefone VALUES ('888777666-85', '055-946223584')
INTO Telefone VALUES ('888777666-85', '081-994687752')
INTO Telefone VALUES ('684997235-01', '021-994627756')
INTO Telefone VALUES ('684997235-01', '021-956317785')
INTO Telefone VALUES ('684997235-01', '055-976331520')
INTO Telefone VALUES ('283492009-11', '091-936547785')
INTO Telefone VALUES ('283492009-11', '081-912003600')
SELECT 1 FROM DUAL;