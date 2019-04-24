create schema genflor;

set search_path to genflor;

CREATE DOMAIN cpf AS varchar(11);

create table pessoa(
  primeiro_nome varchar(20) not null,
  sobrenome varchar(30) not null,
  cpf_pessoa cpf not null,
  data_nascimento date,
  email varchar(30)[],
  constraint pk_pessoa primary key(cpf_pessoa)
);

create table endereco(
  id_endereco int not null,
  rua varchar(40) not null,
  bairro varchar(30) not null,
  cep varchar(8) not null,
  cidade varchar(30) not null,
  estado varchar(30) not null,
  pais varchar(40) default 'Brasil',
  constraint pk_endereco primary key(id_endereco),
  UNIQUE (cep,bairro,cidade,rua,estado,pais)
);

create table mora(
  id_mora int not null,
  numero_casa int not null ,
  id_endereco int not null ,
  cpf cpf not null ,
  complemento varchar(50),
  constraint pk_mora primary key (id_mora),
  constraint fk_mora_id foreign key (id_endereco) references endereco(id_endereco)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint fk_mora_cpf foreign key (cpf) references pessoa(cpf_pessoa)
  ON DELETE SET NULL ON UPDATE CASCADE
);

create table cliente(
  id_cliente int not null ,
  cpf_cliente cpf not null,
  constraint pk_cliente primary key(id_cliente),
  constraint fk_cliente foreign key(cpf_cliente) references pessoa(cpf_pessoa)
  ON DELETE SET NULL ON UPDATE CASCADE
);

create table funcionario(
  id_funcionario int not null ,
  cargo varchar(30) not null,
  salario float not null check (salario>0),
  cpf_funcionario cpf not null,
  constraint pk_funcionario primary key (id_funcionario),
  constraint fk_funcionario foreign key (cpf_funcionario) references pessoa(cpf_pessoa)
  ON DELETE SET NULL ON UPDATE CASCADE
);

create table flor(
  id_flor int not null ,
  especie varchar(50) not null,
  nome varchar (50) not null,
  cor varchar(30) not null,
  valor float not null check (valor>0),
  constraint pk_flor primary key(id_flor),
  UNIQUE (especie,nome,cor,id_flor)
);

create table embalagem (
  id_embalagem int not null ,
  descricao varchar(150) not null,
  valor float not null ,
  constraint pk_embalagem primary key(id_embalagem)
);

create table produto(
  id_produto int not null,
  id_flor int not null ,
  id_embalagem int default 1,
  quant_flor int not null check (quant_flor>0),
  valor_produto float not null,
  constraint pk_produto primary key (id_produto),
  constraint fk_produto_flor foreign key(id_flor) references flor(id_flor)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint fk_produto_desc foreign key(id_embalagem) references embalagem(id_embalagem)
  ON DELETE SET NULL ON UPDATE CASCADE
);

create table pedido(
  id_pedido int not null,
  quant_produto int default 1 check (quant_produto > 0),
  id_produto int not null,
  valor_pedido float not null check (valor_pedido>0),
  constraint pk_pedido primary key(id_pedido),
  constraint fk_pedido foreign key(id_produto) references produto(id_produto)
  ON DELETE SET NULL ON UPDATE CASCADE
);

create table pedido_cliente(
  id_cliente int not null,
  id_pedido int not null,
  constraint fk_pedido__cliente_p foreign key(id_pedido) references pedido(id_pedido)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint fk_pedido_cliente_c foreign key(id_cliente) references cliente(id_cliente)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint pk_pedido_cliente primary key (id_cliente,id_pedido)
);

create table venda(
  id_venda int not null,
  id_cliente int not null ,
  id_funcionario int not null ,
  data_compra date not null ,
  id_mora int default null,
  constraint pk_venda primary key(id_venda),
  constraint fk_venda_cliente foreign key(id_cliente) references cliente(id_cliente)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint fk_venda_func foreign key(id_funcionario) references funcionario(id_funcionario)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint pk_venda_endereco foreign key (id_mora) references mora(id_mora)
);

create table entrega(
  id_entrega int not null,
  id_mora int not null,
  id_venda int not null,
  data_entrega date not null,
  constraint fk_entrega_id_venda foreign key(id_venda) references venda(id_venda)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint fk_entrega_id_endereco foreign key(id_mora) references mora(id_mora)
  ON DELETE SET NULL ON UPDATE CASCADE,
  constraint pk_entrega primary key(id_entrega)
);