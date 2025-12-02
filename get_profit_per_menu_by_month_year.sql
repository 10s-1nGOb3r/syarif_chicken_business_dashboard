CREATE DEFINER=`root`@`localhost` PROCEDURE `get_profit_per_menu_by_month_year`(
	month_input INT,
    year_input INT
)
BEGIN

	WITH menu_profit1 AS(
	SELECT mt.menu_name AS menu1,
		SUM(sit.quantity * mt.sold_price) AS revenue1,
		SUM(sit.quantity * mt.cost) AS cost1,
		SUM(sit.quantity * mt.sold_price) - SUM(sit.quantity * mt.cost) AS profit1
	FROM sales_item_table sit
	JOIN menu_table mt ON mt.menu_id = sit.menu_id
	WHERE (MONTH(sit.date_transaction) = month_input AND YEAR(sit.date_transaction) = year_input)
		OR (month_input IS NULL AND YEAR(sit.date_transaction) = year_input)
        OR (month_input IS NULL AND year_input IS NULL)
	GROUP BY mt.menu_name)
	SELECT ROW_NUMBER() OVER(ORDER BY profit1 DESC) AS ranking, 
		menu1 AS menu,
		revenue1 AS revenue,
		cost1 AS cost,
		profit1 AS profit,
		ROUND((profit1 / SUM(profit1) OVER()) * 100,2) AS profit_contr_perc
	FROM menu_profit1;

END
