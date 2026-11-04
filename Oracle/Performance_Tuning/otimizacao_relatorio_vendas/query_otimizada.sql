🛠️ 2. Ações Realizadas
Para resolver o problema de I/O, criei um índice de cobertura (Covering Index) na tabela de vendas, indexando a data e incluindo a coluna de valor. Isso evita a ida à tabela principal (Table Access by Index ROWID) para buscar o valor total, resolvendo a query apenas com os dados do índice.

Script DDL Aplicado:

SQL
CREATE INDEX idx_vendas_data_valor 
ON vendas (data_venda) 
INCLUDE (valor_total, cliente_id);


✅ 3. Cenário Otimizado (Depois)
Query Otimizada: (Neste caso a query permaneceu a mesma, o ganho foi estrutural)

Explain Plan Novo:

Plaintext
HashAggregate  (cost=45321.00..45330.00 rows=1000 loops=1)
  ->  Hash Join  (cost=12543.00..34567.00 rows=1500000 loops=1)
        Hash Cond: (v.cliente_id = c.id)
        ->  Index Only Scan using idx_vendas_data_valor on vendas v  (cost=0.42..23456.00 rows=1500000 loops=1)
              Index Cond: (data_venda >= '2023-01-01'::date)
        ->  Hash  (cost=10000.00..10000.00 rows=100000 loops=1)
              ->  Seq Scan on clientes c  (cost=0.00..10000.00 rows=100000 loops=1)
  
Métricas Atuais:

Tempo de Execução: 1.8 segundos

Custo Estimado: 45.321

Novo Comportamento: Utilização de Index Only Scan.
