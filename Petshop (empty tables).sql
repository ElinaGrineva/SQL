-- БД PETSHOP


-- *********************** ИНФОРМАЦИЯ ПОЛЬЗОВАТЕЛЕЙ **************************

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender ENUM('Male','Female') NOT NULL UNIQUE COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  country_id INT UNSIGNED NOT NULL COMMENT "Ссылка на страну пользователя",
  last_login DATETIME COMMENT "Последний вход в систему",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили";


-- *********************** КАТАЛОГ И КАТЕГОРИИ ТОВАРОВ **********************


CREATE TABLE products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  product_category ENUM('Корма','Лакомства','Косметика','Игрушки','Переноски', 'Миски', 'Одежда', 'Аксессуары') NOT NULL UNIQUE COMMENT "Категории товаров",
  pet ENUM('Товары для собак','Товары для кошек','Для грызунов и хорьков','Товары для птиц','Товары для рыб') NOT NULL UNIQUE COMMENT "Животные",
  supplier_id INT UNSIGNED NOT NULL COMMENT "Ссылка на поставщика товара",
  name VARCHAR(100) NOT NULL UNIQUE COMMENT "Наименование товара",
  price INT NOT NULL COMMENT "Цена товара",
  warehouse_quantity INT NOT NULL COMMENT "Количество товаров на складе",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Товары";



-- ************************** ЗАКАЗЫ ******************************


CREATE TABLE orders (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на того, кто заказал",
order_status ENUM('Оформлен','Не оформлен','Доставлен','Отгружен') NOT NULL UNIQUE COMMENT "Статус",
country_id INT UNSIGNED NOT NULL COMMENT "Ссылка на страну доставки",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Заказы";

CREATE TABLE orders_products (
order_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказ",
product_id INT UNSIGNED NOT NULL COMMENT "Ссылка на товар",
quantity INT NOT NULL COMMENT "Количество товаров",
discount BOOLEAN COMMENT "Признак скидки" -- Есть ли смысл создавать таблицу скидки и помещать разные варианты?
) COMMENT "Таблица для отслеживания разных товаров в заказе";


CREATE TABLE return_orders (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  order_id INT UNSIGNED NOT NULL COMMENT "Ссылка на заказ",
  reason_name ENUM('Брак', 'Не подошел товар', 'Ошибка в заказе') NOT NULL UNIQUE COMMENT "Причины возврата",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статус возврата";


-- ***************************** ПОСТАВЩИКИ ****************************************


CREATE TABLE suppliers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
name VARCHAR(255) NOT NULL UNIQUE COMMENT "Имя поставщика",
country_id INT UNSIGNED NOT NULL COMMENT "Ссылка на страну откуда поставщик",
status ENUM('Работаем','Планируем работать','Больше не работаем') NOT NULL UNIQUE COMMENT "Статус работы с поставщиком",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Поставщики";


CREATE TABLE countries (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название страны",
currency_id INT UNSIGNED NOT NULL COMMENT "Ссылка на валюту страны",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"  
) COMMENT "Страны";

CREATE TABLE currencies(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
name ENUM('Euro','US dollar', 'Russian Ruble', 'Chinese yuan') NOT NULL UNIQUE COMMENT "Наименование валюты",
iso_code ENUM('EUR','USD','RUB','CNY') NOT NULL COMMENT "Сокращенное наименование валюты",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Валюты";





 

