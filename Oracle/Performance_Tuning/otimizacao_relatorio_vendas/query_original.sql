# Otimização de Consulta: Relatório Mensal de Vendas

**Banco de Dados:** PostgreSQL 15 (ou Oracle 19c / MySQL 8)  
**Problema:** A geração do relatório mensal estava levando 45 segundos e causando picos de CPU no servidor devido a um `Seq Scan` (Full Table Scan) em uma tabela com 50 milhões de registros.

---

## 🛑 1. Cenário Original (Antes)

**Query Original:**

SELECT c.nome_cliente, SUM(v.valor_total)
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
WHERE v.data_venda >= '2023-01-01'
GROUP BY c.nome_cliente;

HashAggregate  (cost=854321.00..854330.00 rows=1000 loops=1)
  ->  Hash Join  (cost=12543.00..734567.00 rows=1500000 loops=1)
        Hash Cond: (v.cliente_id = c.id)
        ->  Seq Scan on vendas v  (cost=0.00..654321.00 rows=50000000 loops=1)
              Filter: (data_venda >= '2023-01-01'::date)
        ->  Hash  (cost=10000.00..10000.00 rows=100000 loops=1)
              ->  Seq Scan on clientes c  (cost=0.00..10000.00 rows=100000 loops=1)
