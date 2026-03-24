-- Total de vendas
SELECT SUM(Quantity) AS total_vendido
FROM transacoes;

-- Produto mais vendido
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(t.Quantity) AS total_vendido
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY total_vendido DESC;

-- Receita por produto
SELECT 
    p.ProductName,
    SUM(t.Quantity * p.UnitPrice) AS receita_total
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY receita_total DESC;

-- Lucro por produto
SELECT 
    p.ProductName,
    SUM(t.Quantity * (p.UnitPrice - p.CostPrice)) AS lucro_total
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY lucro_total DESC;

/*
vender mais ≠ ganhar mais dinheiro
Mais vendido → Road Clothing
Mais receita → Book Television
Mais lucro → And Footwear

o que isso significa para o negócio?

Produtos com maior volume de vendas não são necessariamente os mais lucrativos,
indicando a necessidade de estratégias focadas em margem e não apenas em volume.
*/
 

-- Vendas por loja
SELECT 
    l.StoreName,
    SUM(t.Quantity * p.UnitPrice) AS receita_total
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
JOIN lojas l ON t.StoreID = l.StoreID
GROUP BY l.StoreName
ORDER BY receita_total DESC;

-- Impacto do desconto na receita
SELECT 
    t.Discount,
    SUM(t.Quantity * p.UnitPrice) AS receita
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY t.Discount
ORDER BY t.Discount;

/*
Vale a pena dar desconto?

Desconto alto (0,15) → maior receita
Desconto médio (0,10) → pior resultado
Sem desconto e baixo desconto → praticamente iguais

O impacto do desconto na receita não é linear: descontos mais altos (15%) parecem impulsionar as vendas, 
enquanto descontos moderados (10%) apresentam pior desempenho, 
indicando que a eficácia da estratégia de desconto depende da intensidade aplicada.

não é “dar desconto” — é COMO dar desconto
*/

-- Lucro por nível de desconto
SELECT 
    t.Discount,
    SUM(t.Quantity * (p.UnitPrice - p.CostPrice)) AS lucro
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY t.Discount
ORDER BY t.Discount;

/* 
promoção vale a pena ou estamos perdendo dinheiro?
O desconto aumenta o lucro por venda ou só aumenta o volume?

Embora descontos mais altos aumentem tanto a receita quanto o lucro total, 
é necessário avaliar o impacto na margem por transação,
pois o crescimento pode estar associado ao aumento do volume de vendas 
e não necessariamente à eficiência da estratégia.

Descontos altos aumentam o lucro total devido ao volume de vendas, 
porém descontos moderados (10%) apresentam maior eficiência por transação, 
indicando melhor equilíbrio entre volume e margem.
 */
 
 -- Lucro médio por transação
SELECT 
    t.Discount,
    AVG(t.Quantity * (p.UnitPrice - p.CostPrice)) AS lucro_medio
FROM transacoes t
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY t.Discount
ORDER BY t.Discount;


/*
Devemos dar muito desconto ou otimizar margem?
depende do objetivo.

maximizar lucro total:
usa desconto alto (15%)

Se quer:
eficiência e margem
usa desconto médio (10%)

A análise revelou que maiores descontos impulsionam o volume de vendas e o lucro total, 
porém reduzem a eficiência por transação. 
Descontos moderados demonstraram melhor equilíbrio entre margem e volume,
sendo potencialmente mais sustentáveis a longo prazo.
*/

-- Clientes que mais geram receita
SELECT 
    c.FirstName,
    c.LastName,
    SUM(t.Quantity * p.UnitPrice) AS receita_total
FROM transacoes t
JOIN clientes c ON t.CustomerID = c.CustomerID
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY receita_total DESC;

-- Top 10 clientes por receita
-- quem são nossos melhores clientes?
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(t.Quantity * p.UnitPrice) AS receita_total
FROM transacoes t
JOIN clientes c ON t.CustomerID = c.CustomerID
JOIN produtos p ON t.ProductID = p.ProductID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY receita_total DESC
LIMIT 10;

/*
Objetivo: identificar os clientes mais valiosos para o negócio
Métrica: receita total gerada por cliente
*/