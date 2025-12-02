CREATE DEFINER=`root`@`localhost` PROCEDURE `get_revenue_per_day`(
	from_date_input DATE,
    into_date_input DATE
)
BEGIN

	WITH revenue_per_day AS(
		SELECT DATE(sit.date_transaction) AS date_revenue,
			SUM(sit.quantity * mt.sold_price) AS revenue
		FROM sales_item_table sit
		JOIN menu_table mt ON mt.menu_id = sit.menu_id
		JOIN sales_table st ON sit.sales_id = st.sales_id
		WHERE DATE(sit.date_transaction) BETWEEN from_date_input AND into_date_input
			OR (DATE(sit.date_transaction) = from_date_input AND into_date_input IS NULL)
            OR (from_date_input  IS NULL AND DATE(sit.date_transaction) = into_date_input)
		GROUP BY DATE(sit.date_transaction),sit.sales_id)
	SELECT date_revenue,
		COUNT(date_revenue) AS summary_transaction,
		SUM(revenue) AS revenue
	FROM revenue_per_day
	GROUP BY date_revenue
    ORDER BY date_revenue;

END
