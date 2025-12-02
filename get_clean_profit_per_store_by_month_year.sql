CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clean_profit_per_store_by_month_year`(
	month_input INT,
    year_input INT
)
BEGIN

	WITH employee_salary AS(
	SELECT st.store_id AS store_id,
		st.franchise_name AS store_name,
		SUM(et.payroll) AS employee_salary
	FROM store_table st
	JOIN employee_table et ON st.store_id = et.store_id
	JOIN spending_table spt ON spt.store_id = st.store_id
    WHERE (MONTH(spt.date_transaction) = month_input AND YEAR(spt.date_transaction) = year_input)
		OR (month_input IS NULL AND YEAR(spt.date_transaction) = year_input)
        OR (month_input IS NULL AND year_input IS NULL)
	GROUP BY st.store_id,st.franchise_name),
	rent_utility AS(
		SELECT st.store_id AS store_id,
			st.franchise_name AS store_name,
			SUM(st.rent_utility_per_month) AS rent_utility
		FROM store_table st
		JOIN spending_table spt ON spt.store_id = st.store_id
		GROUP BY st.store_id,st.franchise_name),
	cost_production AS(
		SELECT stt.store_id AS store_id,
			stt.franchise_name AS store_name,
			SUM(mt.cost * sit.quantity) AS cost_production 
		FROM store_table stt
		JOIN employee_table et ON et.store_id = stt.store_id
		JOIN sales_table st ON st.employee_id = et.employee_id
		JOIN sales_item_table sit ON sit.sales_id = st.sales_id
		JOIN menu_table mt ON sit.menu_id = mt.menu_id
		GROUP BY stt.store_id,stt.franchise_name),
	revenue AS(
		SELECT stt.store_id AS store_id,
			stt.franchise_name AS store_name,
			SUM(mt.sold_price * sit.quantity) AS revenue 
		FROM store_table stt
		JOIN employee_table et ON et.store_id = stt.store_id
		JOIN sales_table st ON st.employee_id = et.employee_id
		JOIN sales_item_table sit ON sit.sales_id = st.sales_id
		JOIN menu_table mt ON sit.menu_id = mt.menu_id
		GROUP BY stt.store_id,stt.franchise_name),
	clean_profit AS(
		SELECT rv.store_id AS store_id1,
			rv.store_name AS store_name1,
			er.employee_salary AS employee_salary1,
			ru.rent_utility AS rent_utility1,
			cp.cost_production AS cost_production1,
			rv.revenue AS revenue1,
			rv.revenue - (er.employee_salary + ru.rent_utility + cp.cost_production) AS profit1
		FROM revenue rv
		JOIN cost_production cp ON cp.store_id = rv.store_id
		JOIN rent_utility ru ON ru.store_id = cp.store_id
		JOIN employee_salary er ON er.store_id = ru.store_id)
	SELECT ROW_NUMBER() OVER(ORDER BY profit1 DESC) AS rank_store, 
		store_name1 AS store_name,
		employee_salary1 AS employee_salary,
		rent_utility1 AS rent_utility,
		cost_production1 AS cost_production,
		revenue1 AS revenue,
		profit1 AS profit,
		ROUND((profit1 / SUM(profit1) OVER()) * 100,2) AS profit_contr_perc
	FROM clean_profit;

END
