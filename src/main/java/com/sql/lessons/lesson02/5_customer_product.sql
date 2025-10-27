CREATE TABLE customers_5
(
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    email      TEXT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products_5
(
    id             SERIAL PRIMARY KEY,
    name           TEXT           NOT NULL,
    price          NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE orders_5
(
    id           SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE           DEFAULT CURRENT_DATE,
    status       TEXT           DEFAULT 'pending',
    total_amount NUMERIC(10, 2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE TABLE order_items_5
(
    order_id   INT,
    product_id INT,
    quantity   INT            NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id)
);