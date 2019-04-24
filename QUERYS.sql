/*1 - tabela com todas as flores ordenadas pelo valor*/
select * from flor order by valor;

/*2 - tabela de funcionarios que tambem sao clientes*/
select p.primeiro_nome,p.sobrenome, f.cargo, f.salario from funcionario f
  left join pessoa p on(cpf_pessoa=cpf_funcionario)
  join cliente on (cpf_cliente = cpf_funcionario)
  order by primeiro_nome;

/*3 - funcionarios que ganham salario acima da media*/
select p.primeiro_nome,p.sobrenome, f.cargo, f.salario from (funcionario f
  inner join pessoa p on (f.cpf_funcionario = p.cpf_pessoa))
  where (f.salario > (select avg(salario) from funcionario))
  order by f.salario desc;

/*4 - pedidos que contem produtos que custa mais de $100 cada unidade*/
select id_pedido, pro.id_produto, valor_produto
from pedido p natural join produto pro
group by pro.id_produto,id_pedido, valor_produto
having valor_produto > 100 order by pro.id_produto desc;

/*5 - tabela com os clientes que compraram flores que sao rosas*/
select p.primeiro_nome,p.sobrenome,f.nome,f.especie from pessoa p
  join cliente c on p.cpf_pessoa = c.cpf_cliente
  join pedido_cliente pc on c.id_cliente = pc.id_cliente
  natural join pedido pe
  join produto pro USING (id_produto)
  join flor f on pro.id_flor = f.id_flor
  where f.nome like '%Rosa%';

/*6 - tabela com pedidos para entrega tendo data compra, data entrega e id endereco*/
select id_pedido,data_compra, data_entrega,e.id_mora from cliente c
  join pedido_cliente c2 on c.id_cliente = c2.id_cliente
  join venda v on c.id_cliente = v.id_cliente
  join entrega e on v.id_venda = e.id_venda
  order by c.id_cliente;

/*7 - media em dias das entregas dos pedidos*/
with tabela_dias as(
    select data_compra,data_entrega, data_entrega - data_compra as dias from venda v
    join entrega e on v.id_venda = e.id_venda)
    select avg(dias) from tabela_dias;

/*8 - tabela com quantidade de venda por mes*/
with meses as (
    select to_char(data_compra, 'TMMONTH') AS mes,id_pedido, data_compra,EXTRACT(Month from data_compra) mesN
        from venda v join cliente c2 on v.id_cliente = c2.id_cliente
        join pedido_cliente c3 on c2.id_cliente = c3.id_cliente order by mesN)
select mes,count(mesN) vendas
    from meses group by mesN,mes order by mesN;

/*9 - quantidade total de flores vendidas da floricultura*/
with total as (select pe.id_pedido, (pe.quant_produto*pro.quant_flor) total_flor from pedido pe
  join produto pro on pe.id_produto = pro.id_produto
  order by pe.id_pedido)
  select sum(total_flor)total_flores_vendidas from total;

/*10 - tabela dos funcionarios que venderam acima de 3000 mil*/
select f.id_funcionario,primeiro_nome,sobrenome, sum(valor_pedido) tot
  from funcionario f
  join pessoa p on f.cpf_funcionario = p.cpf_pessoa
  join venda v on f.id_funcionario = v.id_funcionario
  join cliente c on v.id_cliente = c.id_cliente
  join pedido_cliente pc on c.id_cliente = pc.id_cliente
  join pedido pe on pc.id_pedido = pe.id_pedido
  group by f.id_funcionario,primeiro_nome,sobrenome
  having sum(valor_pedido) > 3000 order by tot desc;
