CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clean_profit_by_month`(
	year_input INT
)
BEGIN

	WITH employee_payroll AS(
		SELECT MONTH(spt.date_transaction) AS month_nbr,
			MONTHNAME(spt.date_transaction) AS month_name,
			SUM(et.payroll) AS employee_payroll
		FROM spending_table spt
		JOIN employee_table et ON et.employee_id = spt.employee_id
		WHERE YEAR(spt.date_transaction) = year_input OR year_input IS NULL
		GROUP BY MONTH(spt.date_transaction),MONTHNAME(spt.date_transaction)),
	store_rent AS(
		SELECT MONTH(spt.date_transaction) AS month_nbr,
			MONTHNAME(spt.date_transaction) AS month_name,
			SUM(stt.rent_utility_per_month) AS store_rent
		FROM spending_table spt
		JOIN store_table stt ON stt.store_id = spt.store_id
		GROUP BY MONTH(spt.date_transaction),MONTHNAME(spt.date_transaction)),
	production_cost AS(
		SELECT MONTH(sit.date_transaction) AS month_nbr,
			MONTHNAME(sit.date_transaction) AS month_name,
			SUM(mt.cost * sit.quantity) AS production_cost
		FROM sales_item_table sit
		JOIN menu_table mt ON mt.menu_id = sit.menu_id
		WHERE YEAR(sit.date_transaction) = 2024
		GROUP BY  MONTH(sit.date_transaction),MONTHNAME(sit.date_transaction)),    
	revenue AS(
		SELECT MONTH(sit.date_transaction) AS month_nbr,
			MONTHNAME(sit.date_transaction) AS month_name,
			SUM(mt.sold_price * sit.quantity) AS revenue
		FROM sales_item_table sit
		JOIN menu_table mt ON mt.menu_id = sit.menu_id
		GROUP BY  MONTH(sit.date_transaction),MONTHNAME(sit.date_transaction)),
	profit_per_month AS(
		SELECT rv.month_nbr AS month_nbr1,
			rv.month_name AS month_name1,
			ep.employee_payroll AS employee_payroll1,
			sr.store_rent AS store_rent1,
			pc.production_cost AS production_cost1,
			rv.revenue AS revenue1,
			rv.revenue - (ep.employee_payroll + sr.store_rent + pc.production_cost) AS profit1
		FROM revenue rv
		JOIN employee_payroll ep ON ep.month_nbr = rv.month_nbr
		JOIN store_rent sr ON sr.month_nbr = ep.month_nbr
		JOIN production_cost pc ON pc.month_nbr = sr.month_nbr)
	SELECT month_nbr1 AS month_nbr,
		month_name1 AS month_name,
		employee_payroll1 AS employee_payroll,
		store_rent1 AS store_rent,
		production_cost1 AS production_cost,
		revenue1 AS revenue,
		profit1 AS profit,
		ROUND((profit1 / SUM(profit1) OVER()) * 100,2) AS proft_contr_perc
	FROM profit_per_month;

END
