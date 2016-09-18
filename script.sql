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

-- 1.3 Plano

CREATE TABLE Plano (
    descricao varchar2(50),
    preco number(5,2) NOT NULL,
    CONSTRAINT plano_pkey PRIMARY KEY (descricao)
);

-- 1.4 Assinante

CREATE TABLE Assinante (
	cpf varchar2(15),
	plano varchar2(50) NOT NULL,
	dataAssinatura date NOT NULL,
	CONSTRAINT assinante_pkey PRIMARY KEY (cpf),
	CONSTRAINT assinante_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
	CONSTRAINT assinante_plano_fkey2 FOREIGN KEY (plano) REFERENCES Plano (descricao)
);

-- 1.5 Funcionário

CREATE TABLE Funcionario (
	cpf varchar2(15),
	salario number(10,2) NOT NULL,
	dataAdmissao date NOT NULL,
	CONSTRAINT funcionario_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT func_pessoa_fkey1 FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
	CONSTRAINT Funcionario_checkSal CHECK (salario >= 880.00)
);

-- 1.6 Fotografo

CREATE TABLE Fotografo (
	cpf varchar2(15),
	certificado blob,
	CONSTRAINT fotografo_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT fotografo_funcionario_fkey1 FOREIGN KEY (cpf) REFERENCES Funcionario (cpf)
);

-- 1.7 Jornalista

CREATE TABLE Jornalista (
	cpf varchar2(15),
	mtb varchar2(20),
	cpf_supervisor varchar2(15),
	CONSTRAINT jornalista_pkey1 PRIMARY KEY (cpf),
	CONSTRAINT jornalista_funcionario_fkey1 FOREIGN KEY (cpf) REFERENCES Funcionario (cpf),
	CONSTRAINT jornalista_fkey1 FOREIGN KEY (cpf_supervisor) REFERENCES Jornalista (cpf)
);

-- 1.8 Titulação

CREATE TABLE Titulacao (
	cpf varchar2(15),
	data date NOT NULL,
	instituicao varchar2(50) NOT NULL,
	grau varchar2(30) NOT NULL,
	CONSTRAINT titulacao_jornalista_fkey1 FOREIGN KEY (cpf) REFERENCES Jornalista (cpf)  
);

-- 1.9 Edição

CREATE TABLE Edicao (
	numero integer,
	cpf_chefe varchar2(15),
	data date NOT NULL,
	CONSTRAINT edicao_pkey PRIMARY KEY (numero),
	CONSTRAINT edicao_jornalista_fkey1 FOREIGN KEY (cpf_chefe) REFERENCES Jornalista (cpf)
);

-- 1.10 Seção

CREATE TABLE Secao (
	nome varchar2(30),
	cpf_coord varchar2(15),
	CONSTRAINT secao_pkey PRIMARY KEY (nome),
	CONSTRAINT secao_jornalista_fkey1 FOREIGN KEY (cpf_coord) REFERENCES Jornalista (cpf)
);

-- 1.11 Matéria

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

-- 1.12 Jornalista <escreve> Matéria

CREATE TABLE JornTrabMateria (
	cpf varchar2(15),
	id_materia integer,
	CONSTRAINT jorntab_pkey PRIMARY KEY (cpf, id_materia),
	CONSTRAINT jorntab_jornalista_fkey1 FOREIGN KEY (cpf) REFERENCES Jornalista (cpf),
	CONSTRAINT jorntab_materia_fkey2 FOREIGN KEY (id_materia) REFERENCES Materia (id)
);

-- 1.13 Premiação

CREATE TABLE Premiacao (
	evento varchar2(50),
	data date NOT NULL,
	categoria varchar2(50),
	CONSTRAINT Premiacao_pkey PRIMARY KEY (evento, data)
);

-- 1.14 (Jornalista <escreve> Matéria) <ganha> Premiação

CREATE TABLE Ganha (
	cpf varchar2(15),
	id_materia integer,
	evento varchar2(50),
	data date,
	CONSTRAINT ganha_pkey PRIMARY KEY (cpf, id_materia, evento),
	CONSTRAINT ganha_jortrabmateria_fkey1 FOREIGN KEY (cpf, id_materia) REFERENCES JornTrabMateria (cpf, id_materia),
	CONSTRAINT ganha_premiacao_fkey2 FOREIGN KEY (evento, data) REFERENCES Premiacao (evento, data)
);

-- 1.15 Fotos

CREATE TABLE Foto (
	id integer,
	fotografo varchar2(15),
	materia integer,
	foto BLOB NOT NULL,
	CONSTRAINT foto_pkey PRIMARY KEY (id),
	CONSTRAINT foto_fotografo_fkey1 FOREIGN KEY (fotografo) REFERENCES Fotografo (cpf),
	CONSTRAINT foto_materia_fkey2 FOREIGN KEY (materia) REFERENCES Materia (id)
);

-- 1.16 Evento

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
INTO Pessoa VALUES ('123456789-45', 'Leonardo Alves',       TO_DATE('16/12/1996', 'dd/MM/yyyy'), 'M', '44900000', 'Irecê',          'Bairro',               'Rua Aquela Mesma',     '16'    )
INTO Pessoa VALUES ('888777666-85', 'Marcos Barreto',       TO_DATE('16/08/1996', 'dd/MM/yyyy'), 'M', '99212300', 'Irecê',          'Bairro2',              'Rua do Beco',          '188'   )
INTO Pessoa VALUES ('456228741-99', 'Afonso Gomes',         TO_DATE('09/05/1987', 'dd/MM/yyyy'), 'M', '05465203', 'São Paulo',      'Liberdade',            'Av.Paulista',          '548'   )
INTO Pessoa VALUES ('648752006-56', 'Roberto Andrade',      TO_DATE('30/05/1990', 'dd/MM/yyyy'), 'M', '54862066', 'Rio de Janeiro', 'Leblon',               'Rua 10',               '9'     )
INTO Pessoa VALUES ('160742365-48', 'Alice Ayres',          TO_DATE('01/01/2000', 'dd/MM/yyyy'), 'F', '98212340', 'Irecê',          'Recanto',              'Antonio Cardoso',      '61'    )
INTO Pessoa VALUES ('283492009-11', 'Ana Maria',            TO_DATE('10/05/1997', 'dd/MM/yyyy'), 'F', '54896211', 'Brasília',       'Centro',               'Rua JK',               '7'     )
INTO Pessoa VALUES ('945632778-12', 'Ana Alves',            TO_DATE('02/02/1987', 'dd/MM/yyyy'), 'F', '66975233', 'São Paulo',      'Morumbi',              'Av. Santo Antônio',    '400'   )
INTO Pessoa VALUES ('549316775-00', 'Bob Jones',            TO_DATE('05/06/1988', 'dd/MM/yyyy'), 'M', '75264977', 'Acre',           'Floresta',             'Árvore',               '7'     )
INTO Pessoa VALUES ('654823004-11', 'Amanda Nunes',         TO_DATE('06/04/1944', 'dd/MM/yyyy'), 'F', '65482236', 'Recife',         'CDU',                  'Polidoro',             '344'   )
INTO Pessoa VALUES ('684997235-01', 'João Silva',           TO_DATE('10/07/1980', 'dd/MM/yyyy'), 'M', '95877236', 'Recife',         'CDU',                  'UFPE',                 '455'   )
INTO Pessoa VALUES ('234908724-88', 'Vitor Pereira',        TO_DATE('15/12/1995', 'dd/MM/yyyy'), 'M', '23456000', 'Recife',         'Bairro do Caxanga',    'Avenida Caxangá',      '230'   )
INTO Pessoa VALUES ('171615142-21', 'Amanda Kezia',         TO_DATE('23/10/1994', 'dd/MM/yyyy'), 'F', '77800000', 'Recife',         'Várzea',               'João F. Lisboa',       '120'   )
INTO Pessoa VALUES ('881391402-21', 'Letícia Silva',        TO_DATE('01/11/1980', 'dd/MM/yyyy'), 'F', '99134817', 'Fortaleza',      'Padre Miguel',         'Marechal Deodoro',     '23'    )
INTO Pessoa VALUES ('143234503-91', 'Cláudio Roberto',      TO_DATE('09/10/1977', 'dd/MM/yyyy'), 'M', '88123491', 'Caruaru',        'Centro',               'Agamenon Magalhães',   '23'    )
INTO Pessoa VALUES ('144319847-45', 'Antônio Flávio',       TO_DATE('08/03/1990', 'dd/MM/yyyy'), 'M', '23495302', 'Palmas',         'Floresta',             'Prefeito Miguel',      '621'   )
INTO Pessoa VALUES ('238432464-99', 'Priscila Alcântara',   TO_DATE('25/06/1979', 'dd/MM/yyyy'), 'F', '83475843', 'Florianópolis',  'Mangue',               'Madre Tereza',         '33'    )
INTO Pessoa VALUES ('234353455-44', 'Maria Aparecida',      TO_DATE('20/09/1960', 'dd/MM/yyyy'), 'F', '14124984', 'Porto Alegre',   'Conde Boa Vista',      'Mariano Amaro',        '21'    )
INTO Pessoa VALUES ('893451348-30', 'Renato Arruda',        TO_DATE('30/03/1990', 'dd/MM/yyyy'), 'M', '82886234', 'São Paulo',      'Cracolândia',          'Rua da Neblina',       '66'    )
INTO Pessoa VALUES ('635752445-80', 'Ricardo Junior',       TO_DATE('05/12/1972', 'dd/MM/yyyy'), 'M', '23476784', 'Rio de Janeiro', 'Nova Morada',          'Teófilo Antônio',      '99'    )
INTO Pessoa VALUES ('353234979-23', 'Regina Oliveira',      TO_DATE('10/08/1996', 'dd/MM/yyyy'), 'F', '82346248', 'Santos',         'Litoral',              'Av. Mascarenhas',      '806'   )
INTO Pessoa VALUES ('658775462-03', 'Catarina Abreu',       TO_DATE('30/02/1988', 'dd/MM/yyyy'), 'F', '35741200', 'Fortaleza',      'Meireles',             'Rua Oswaldo Cruz',     '1'     )
INTO Pessoa VALUES ('782662490-13', 'Alberto Maia',         TO_DATE('13/12/1977', 'dd/MM/yyyy'), 'M', '60160230', 'Fortaleza',      'Aldeota',              'Av.Don Luis',          '1200'  )
INTO Pessoa VALUES ('665482660-02', 'Francisco Cunha',      TO_DATE('02/08/1968', 'dd/MM/yyyy'), 'M', '96578266', 'Manaus',         'Adrianópolis',         'Av.Mario Ypiranga',    '1300'  )
INTO Pessoa VALUES ('554826331-22', 'Julia Andrade',        TO_DATE('03/02/1998', 'dd/MM/yyyy'), 'F', '56475300', 'Manaus',         'Japiim',               'Rua Santa Luzia',      '438'   )
INTO Pessoa VALUES ('785663215-00', 'Roberto Santos',       TO_DATE('16/07/1973', 'dd/MM/yyyy'), 'M', '06955712', 'João Pessoa',    'Tambaú',               'Av.Rui Carneiro',      '232'   )
INTO Pessoa VALUES ('153664872-66', 'Robin Wood',           TO_DATE('06/12/1939', 'dd/MM/yyyy'), 'M', '32654788', 'Rondonia',       'Flodoaldo Pinto',      'Av.Rio Madeira',       '3288'  )
INTO Pessoa VALUES ('456987415-44', 'Roberta Gomes',        TO_DATE('01/01/1944', 'dd/MM/yyyy'), 'F', '45987455', 'São Luis',       'Jaracati',             'Av.Prof.Carlos Cunha', '1000'  )
INTO Pessoa VALUES ('785441365-99', 'Marcelo Resende',      TO_DATE('02/03/1955', 'dd/MM/yyyy'), 'M', '45699822', 'Porto Alegre',   'Carvalhada',           'Av.Eduardo Prado',     '425'   )
INTO Pessoa VALUES ('548662300-11', 'Edinanci Gomes',       TO_DATE('06/08/1982', 'dd/MM/yyyy'), 'F', '45698520', 'Porto Alegre',   'Boa Vista',            'Av.Nilo Peçanha',      '2131'  )
INTO Pessoa VALUES ('569552330-32', 'Amanda Freitas',       TO_DATE('22/12/1974', 'dd/MM/yyyy'), 'F', '32145874', 'Porto Alegre',   'Praia de Belas',       'Praia de Belas',       '1181'  )


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

-- 2.3 Plano

INSERT ALL
INTO Plano VALUES ('Básico',    10.00)
INTO Plano VALUES ('Combo',     15.00)
INTO Plano VALUES ('Ultra',     20.00)
SELECT 1 FROM DUAL;

-- 2.4 Assinante

INSERT ALL
INTO Assinante VALUES ('123456789-45', 'Combo',   TO_DATE('05/04/2013', 'dd/MM/yyyy'))
INTO Assinante VALUES ('888777666-85', 'Básico',  TO_DATE('12/09/2015', 'dd/MM/yyyy'))
INTO Assinante VALUES ('456228741-99', 'Básico',  TO_DATE('27/01/2010', 'dd/MM/yyyy'))
INTO Assinante VALUES ('648752006-56', 'Ultra',   TO_DATE('15/06/2012', 'dd/MM/yyyy'))
INTO Assinante VALUES ('160742365-48', 'Básico',  TO_DATE('01/12/2012', 'dd/MM/yyyy'))
INTO Assinante VALUES ('283492009-11', 'Básico',  TO_DATE('21/02/2008', 'dd/MM/yyyy'))
INTO Assinante VALUES ('945632778-12', 'Básico',  TO_DATE('07/10/2016', 'dd/MM/yyyy'))
INTO Assinante VALUES ('549316775-00', 'Combo',   TO_DATE('20/07/2011', 'dd/MM/yyyy'))
INTO Assinante VALUES ('654823004-11', 'Combo',   TO_DATE('16/01/2015', 'dd/MM/yyyy'))
INTO Assinante VALUES ('684997235-01', 'Ultra',   TO_DATE('23/05/2014', 'dd/MM/yyyy'))
SELECT 1 FROM DUAL;

-- 2.5 Funcionário

INSERT ALL
INTO Funcionario VALUES ('234908724-88', 1500.00, TO_DATE('13/10/2014', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('171615142-21', 1450.00, TO_DATE('30/11/2015', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('881391402-21', 1600.00, TO_DATE('20/02/2014', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('143234503-91', 2000.00, TO_DATE('29/08/2012', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('144319847-45', 1400.00, TO_DATE('06/01/2016', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('238432464-99', 1500.00, TO_DATE('25/10/2012', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('234353455-44', 1650.00, TO_DATE('09/03/2012', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('893451348-30', 1800.00, TO_DATE('12/05/2013', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('635752445-80', 1900.00, TO_DATE('18/12/2013', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('353234979-23', 1760.00, TO_DATE('24/07/2014', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('658775462-03', 1600.00, TO_DATE('15/08/2014', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('782662490-13', 1000.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('665482660-02', 1250.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('554826331-22', 2000.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('785663215-00', 1950.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('153664872-66', 1550.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('456987415-44', 1650.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('785441365-99', 1700.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('548662300-11', 1900.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))
INTO Funcionario VALUES ('569552330-32', 1650.00, TO_DATE('05/10/2011', 'dd/MM/yyyy'))

SELECT 1 FROM DUAL;

-- 2.6 Fotógrafo

INSERT ALL
INTO Fotografo VALUES ('234908724-88', NULL)
INTO Fotografo VALUES ('171615142-21', NULL)
INTO Fotografo VALUES ('881391402-21', NULL)
INTO Fotografo VALUES ('143234503-91', NULL)
INTO Fotografo VALUES ('144319847-45', NULL)
INTO Fotografo VALUES ('238432464-99', NULL)
INTO Fotografo VALUES ('234353455-44', NULL)
INTO Fotografo VALUES ('893451348-30', NULL)
INTO Fotografo VALUES ('635752445-80', NULL)
INTO Fotografo VALUES ('353234979-23', NULL)
SELECT 1 FROM DUAL;
