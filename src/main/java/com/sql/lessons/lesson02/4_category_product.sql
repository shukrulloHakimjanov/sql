CREATE TABLE categories
(
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE products_1
(
    id          SERIAL PRIMARY KEY,
    name        TEXT           NOT NULL,
    price       NUMERIC NOT NULL CHECK (price >= 0),
    category_id INT            NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories (id)
);

INSERT INTO categories(name)
VALUES ('computers');
INSERT INTO products_1(name, price, category_id)
values ('Laptop Dell XPS 13',1,1)