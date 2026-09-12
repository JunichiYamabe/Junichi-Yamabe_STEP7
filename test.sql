--設問１
SELECT *
FROM users;

--設問２
SELECT *
FROM users
WHERE created_at >= '2024-01-01';

--設問３
SELECT *
FROM users
WHERE age < 30 AND gender = 'female';

--設問４
SELECT product_name, price
FROM products;

--設問５
SELECT u.name, o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id;

--設問６
SELECT 
    p.product_name,
    oi.quantity,
    p.price,
    (p.price * oi.quantity) AS total_price 
FROM order_items oi
JOIN products p ON oi.product_id = p.id;

--設問７
SELECT 
    u.name, 
    COUNT(o.id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.name;

--設問８
SELECT 
    u.name,
    SUM(p.price * oi.quantity) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY u.id, u.name;

--設問9
SELECT 
    u.name,
    SUM(p.price * oi.quantity) AS total_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY u.id, u.name
ORDER BY total_amount DESC
LIMIT 1;

--設問10 各商品が何回注文されたか(order_itemsの合計数量)を取得する
SELECT 
    p.id, 
    p.product_name, 
    COUNT(oi.id) AS order_count
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.product_name;


--設問11 1回も注文したことがないユーザー
SELECT u.name 
FROM users u 
LEFT JOIN orders o ON u.id = o.user_id 
WHERE o.user_id IS NULL;

--設問12 一度に２種類以上購入したユーザー
SELECT DISTINCT u.id, u.name, COUNT(oi.product_id) AS '購入種類'
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN users u ON o.user_id = u.id
GROUP BY o.id, u.id, u.name
HAVING COUNT(DISTINCT oi.product_id) >= 2;

--設問13 テレビという商品を購入した全てのユーザー名
SELECT u.name
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN users u ON o.user_id = u.id
JOIN products p ON oi.product_id = p.id
WHERE p.product_name = 'テレビ';

--設問14 明細ごとの注文日・ユーザー名・商品名・数量・合計金額を抽出
SELECT 
    oi.id AS detail_id,
    o.order_date,
    u.name,
    p.product_name,
    oi.quantity,
    (oi.quantity * p.price) AS total_amount
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
JOIN users u ON o.user_id = u.id
JOIN products p ON oi.product_id = p.id;

--設問15 最も多く購入された商品(数量ベース)の商品名を取得する
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.product_name
ORDER BY total_quantity DESC
LIMIT 1;

--設問16 各月の注文件数を取得する(order_dateの年月を使う)
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    COUNT(o.id) AS total_orders
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month;

-- 設問17.注文のない商品を取得するSQLを書いてください。
SELECT p.id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.product_id IS NULL;

-- 設問18.order_items.product_id にインデックスを追加するSQLを書いてください。
CREATE INDEX idx_order_items_product_id ON order_items (product_id);

-- 設問19.ユーザーごとの平均注文金額を取得するSQLを書いてください。
SELECT 
    u.id, 
    u.name, 
    SUM(oi.quantity * p.price) / COUNT(DISTINCT o.id) AS avg_order_amount
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY u.id, u.name;

-- 設問20.各ユーザーの最新注文日のみを取得するSQLを書いてください。
SELECT 
    u.id, 
    u.name,
    MAX(o.order_date) AS '最新注文日'
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- 設問21.新規ユーザー「中村愛（25歳・女性・2025-06-01作成）」をusersテーブルに追加するSQLを書いてください。
INSERT INTO users (id, name, age, gender, created_at)
VALUES(
  6,
  '中村愛',
  25,
  'female',
  '2025-06-01'
);

-- 設問22.商品「エアコン（価格：60000円）」をproductsテーブルに追加するSQLを書いてください。
INSERT INTO products (id, product_name, price)
VALUES(
  6,
  'エアコン',
  60000
);

-- 設問23.ユーザーIDが1の人が2025-06-10に行った新しい注文（orders）を追加するSQLを書いてください。注文IDは10とします。
INSERT INTO orders(id, user_id, order_date)
VALUES(
  10,
  1,
  '2025-06-10'
);

-- 設問24.上記の注文（注文ID：10）に対して、「エアコン（商品ID：6）」を1つ購入したことを表すorder_itemsを追加するSQLを書いてください。
INSERT INTO order_items (id, order_id, product_id, quantity)
VALUES(
    10,
    10,
    6,
    1
);

-- 設問25.ユーザー「田中美咲」の年齢を23歳から24歳に更新するSQLを書いてください。
UPDATE users
SET age = 24
WHERE name = '田中美咲';


-- 設問26.全ての商品価格を10%値上げするSQLを書いてください。
UPDATE products
set price = price * 1.1;

-- 設問27.2024年5月以前（5月1日より前（4月末まで））に行われた注文（orders）のorder_dateをすべて「2024-05-01」に統一する（更新する）SQLを書いてください。
UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date <= '2024-04-30';


-- 設問28.ユーザー名が「高橋健一」のレコードをusersテーブルから削除するSQLを書いてください。
-- ※関連する注文や明細はそのままにします。
DELETE FROM users
WHERE name = '高橋健一';

-- 設問29.注文IDが5の明細（order_items）をすべて削除するSQLを書いてください。
DELETE FROM order_items
WHERE order_id = 5;

-- 設問30.一度も注文されたことのない商品をproductsテーブルから削除するSQLを書いてください。
DELETE FROM products
WHERE id NOT IN (
    SELECT DISTINCT product_id 
    FROM order_items
);
