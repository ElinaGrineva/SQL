USE petshop;

-- Поправляем загруженный дамп

UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;

UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at;

UPDATE profiles SET last_login = NOW() WHERE last_login < created_at;

UPDATE profiles SET country_id = FLOOR(1+ RAND() * 100);

UPDATE countries SET currency_id = FLOOR(1+ RAND() * 4);

UPDATE currencies SET updated_at = NOW() WHERE updated_at < created_at;


UPDATE return_orders SET 
order_id = FLOOR(1+ RAND() * 100);


UPDATE orders SET 
user_id = FLOOR(1+ RAND() * 100),
country_id = FLOOR(1+ RAND() * 100);


UPDATE suppliers SET 
country_id = FLOOR(1+ RAND() * 100);


UPDATE products SET 
supplier_id = FLOOR(1+ RAND() * 20);


UPDATE orders_products SET 
order_id = FLOOR(1+ RAND() * 100),
product_id = FLOOR(1+ RAND() * 100);


-- Создаем внешние ключи

ALTER TABLE profiles
  	ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;
     
ALTER TABLE countries 
	ADD CONSTRAINT countries_currency_id_fk
	FOREIGN KEY (currency_id) REFERENCES currencies(id)
	  ON DELETE CASCADE;
	 
ALTER TABLE profiles 
	ADD CONSTRAINT profiles_country_id_fk
	FOREIGN KEY (country_id) REFERENCES countries(id)
	  ON DELETE CASCADE;
	 
ALTER TABLE suppliers
	ADD CONSTRAINT suppliers_country_id_fk
	FOREIGN KEY (country_id) REFERENCES countries(id)
	  ON DELETE CASCADE; 
	 
ALTER TABLE orders 
  	ADD CONSTRAINT orders_user_id_fk
	FOREIGN KEY (user_id) REFERENCES users(id),
  	ADD CONSTRAINT orders_country_id_fk
	FOREIGN KEY (country_id) REFERENCES countries(id)
	  ON DELETE CASCADE;

ALTER TABLE return_orders 
	ADD CONSTRAINT return_orders_order_id_fk
	FOREIGN KEY (order_id) REFERENCES orders(id)
	  ON DELETE CASCADE;
	 
ALTER TABLE products
	ADD CONSTRAINT products_supplier_id_fk
	FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
	  ON DELETE CASCADE;
	 
ALTER TABLE orders_products ADD CONSTRAINT orders_products_order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id),
ADD CONSTRAINT orders_products_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id) ON
DELETE
	CASCADE;
	
	
-- Определить кто больше делал заказов - Мужчины или Женщины


SELECT profiles.gender, 
  COUNT(orders.id) AS total_orders
  FROM orders
    JOIN profiles
      ON orders.user_id = profiles.user_id
    GROUP BY profiles.gender
    ORDER BY total_orders DESC
    LIMIT 1;
   
-- Подсчет заказов пользователей по их именам
   
SELECT users.id, COUNT(orders.user_id) AS total_orders
  FROM users JOIN orders
    ON users.id = orders.user_id
  GROUP BY users.id
  ORDER BY total_orders;
 
 
 -- Вычислить по названию товара среднюю стоимость, минимальную, максимальную, общую и в процентном соотношении с помощью оконных функций.
 

SELECT DISTINCT products.name,
  AVG(products.price) OVER w AS average,
  MIN(products.price) OVER w AS min,
  MAX(products.price) OVER w AS max,
  SUM(products.price) OVER() AS total,
  SUM(products.price) OVER w / (SUM(products.price) OVER() * 100) AS "%%"
    FROM (products
      JOIN orders_products
        ON orders_products.product_id = products.id)
        WINDOW w AS (PARTITION BY orders_products.order_id);

       
       
       
***** Триггеры *******************
       
       
DELIMITER //

CREATE TRIGGER validate_price_insert BEFORE INSERT ON products
FOR EACH ROW BEGIN
  IF NEW.price IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Product price is NULL';
  END IF;
END//



CREATE TRIGGER validate_price_update BEFORE UPDATE ON products
FOR EACH ROW BEGIN
  IF NEW.price IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Product price is NULL';
  END IF;
END//



******** Индексы **********


CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

CREATE INDEX products_name_price_warehouse_quantity_idx ON products(name, price, warehouse_quantity);

CREATE INDEX orders_order_status_user_id_idx ON orders(order_status, user_id);



****** Представления ************


CREATE OR REPLACE VIEW food AS 
    SELECT id, name, price, product_category, warehouse_quantity 
    FROM products 
    WHERE product_category = 'Корма';


CREATE OR REPLACE VIEW order_delivery AS 
    SELECT id, order_status, user_id, country_id, created_at 
    FROM orders
    WHERE order_status = 'Оформлен'
    ORDER BY created_at;



















