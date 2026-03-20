-- Obtiene todas las ventas mayores a 500 USD ordenadas por monto
SELECT *
FROM sales
WHERE total > 500
ORDER BY total DESC;

-- Calcula el revenue total por sucursal
SELECT branch, SUM(total) AS total_revenue
FROM sales
GROUP BY branch
ORDER BY total_revenue DESC;

-- Calcula el revenue total por sucursal
SELECT branch, SUM(total) AS total_revenue
FROM sales
GROUP BY branch
ORDER BY total_revenue DESC;

-- Promedio de gasto por cliente según tipo de cliente
SELECT customer_type, AVG(total) AS avg_spending
FROM sales
GROUP BY customer_type;

-- Une ventas con información de sucursales
SELECT s.branch, b.city, SUM(s.total) AS revenue
FROM sales s
JOIN branches b ON s.branch = b.branch_id
GROUP BY s.branch, b.city;

-- Identifica las sucursales con revenue superior al promedio
WITH branch_revenue AS (
    SELECT branch, SUM(total) AS revenue
    FROM sales
    GROUP BY branch
)
SELECT *
FROM branch_revenue
WHERE revenue > (SELECT AVG(revenue) FROM branch_revenue);

-- Ranking de productos más vendidos por sucursal
SELECT 
    branch,
    product_line,
    SUM(total) AS revenue,
    RANK() OVER (PARTITION BY branch ORDER BY SUM(total) DESC) AS rank_in_branch
FROM sales
GROUP BY branch, product_line;

-- Identifica el top 3 de categorías por revenue en cada sucursal
WITH ranked_products AS (
    SELECT 
        branch,
        product_line,
        SUM(total) AS revenue,
        RANK() OVER (PARTITION BY branch ORDER BY SUM(total) DESC) AS rnk
    FROM sales
    GROUP BY branch, product_line
)
SELECT *
FROM ranked_products
WHERE rnk <= 3;