# Otimização de Consulta: Relatório Mensal de Vendas (Exemplo)

**Banco de Dados:** PostgreSQL 15 (ou Oracle 19c / MySQL 8)  
**Problema:** A geração do relatório mensal estava levando 45 segundos e causando picos de CPU no servidor devido a um `Seq Scan` (Full Table Scan) em uma tabela com 50 milhões de registros.

---

## 🛑 1. Cenário Original (Antes)

**Query Original:**
```sql
SELECT c.nome_cliente, SUM(v.valor_total)
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
WHERE v.data_venda >= '2023-01-01'
GROUP BY c.nome_cliente;
