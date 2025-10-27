-- 1
CREATE TABLE customers
(
    id    SERIAL PRIMARY KEY,
    name  TEXT        NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE products
(
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    price NUMERIC CHECK (price >= 0)
);

CREATE TABLE orders
(
    id           SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE    DEFAULT CURRENT_DATE,
    total_amount NUMERIC DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE order_items
(
    order_id       INT,
    product_id     INT,
    quantity       INT     NOT NULL CHECK (quantity > 0),
    price_at_order NUMERIC NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

INSERT INTO customers (name, email)
VALUES ('John Smith', 'john.smith@email.com');
INSERT INTO products (name, price)
VALUES ('c', 1299.99);
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2024-03-15', 1299.99);
INSERT INTO order_items (order_id, product_id, quantity, price_at_order)
VALUES(1, 1, 1, 1299.99)
