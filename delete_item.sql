CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_item`(
	sales_id_input INT
)
BEGIN

START TRANSACTION;

	UPDATE inventory_ingredient_table iit
    JOIN(
		SELECT imt.item_menu_id,
			SUM(sit.quantity * imt.quantity) AS total_item
        FROM sales_item_table sit
        JOIN menu_table mt ON mt.menu_id = sit.menu_id
        JOIN item_menu_table imt ON imt.menu_id = mt.menu_id
        WHERE sit.sales_id = sales_id_input
        GROUP BY imt.item_menu_id
    ) item_summary ON item_summary.item_menu_id = iit.item_menu_id
    SET iit.stock = iit.stock + item_summary.total_item;

	DELETE FROM sales_item_table
		WHERE sales_id = sales_id_input;
	
	DELETE FROM spending_table
		WHERE sales_id = sales_id_input;

	DELETE FROM sales_table
		WHERE sales_id = sales_id_input;
        
COMMIT;

END
