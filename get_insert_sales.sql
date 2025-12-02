CREATE DEFINER=`root`@`localhost` PROCEDURE `get_insert_sales`(
	menu_input_1 INT,
    quantity_input_1 INT,
    menu_input_2 INT,
    quantity_input_2 INT,
    menu_input_3 INT,
    quantity_input_3 INT,
	employee_id_input INT
)
BEGIN
	DECLARE v_sales_id INT;
    
    -- first insert to sales_table
    INSERT INTO sales_table(employee_id)
		VALUES(employee_id_input);
        
	SET v_sales_id = LAST_INSERT_ID();
    
    -- then continue to the sales_item_table where the sales_id is taken from v_sales_id
    IF menu_input_1 IS NOT NULL THEN
		INSERT INTO sales_item_table(sales_id,menu_id,quantity,date_transaction)
			VALUES(v_sales_id,menu_input_1,quantity_input_1,NOW());
	END IF;
    
    IF menu_input_2 IS NOT NULL THEN
		INSERT INTO sales_item_table(sales_id,menu_id,quantity,date_transaction)
			VALUES(v_sales_id,menu_input_2,quantity_input_2,NOW());
	END IF;
    
    IF menu_input_3 IS NOT NULL THEN
		INSERT INTO sales_item_table(sales_id,menu_id,quantity,date_transaction)
			VALUES(v_sales_id,menu_input_3,quantity_input_3,NOW());
	END IF;
    
    -- this one is used for updating inventory when the sales happening
    -- we use the aggregate per item_menu_id to avoid over deduct in some cases
    UPDATE inventory_ingredient_table iit
    JOIN(
		SELECT imt.item_menu_id,
			SUM(sit.quantity * imt.quantity) AS total_item
        FROM sales_item_table sit
        JOIN menu_table mt ON mt.menu_id = sit.menu_id
        JOIN item_menu_table imt ON imt.menu_id = mt.menu_id
        WHERE sit.sales_id = v_sales_id
        GROUP BY imt.item_menu_id
    ) item_summary ON item_summary.item_menu_id = iit.item_menu_id
    SET iit.stock = iit.stock - item_summary.total_item;
    
    -- when the sales happening the spending_table will also be updated
    INSERT INTO spending_table(sales_id,employee_id,date_transaction)
		VALUES(v_sales_id,employee_id_input,NOW());
    
END
