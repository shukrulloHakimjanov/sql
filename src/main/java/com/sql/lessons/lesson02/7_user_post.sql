CREATE TABLE users
(
    id    SERIAL PRIMARY KEY,
    name  TEXT        NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE posts
(
    id      SERIAL PRIMARY KEY,
    user_id INT  NOT NULL,
    text    TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE comments
(
    id      SERIAL PRIMARY KEY,
    post_id INT  NOT NULL,
    user_id INT  NOT NULL,
    text    TEXT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE likes
(
    user_id    INT,
    post_id    INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE
);

INSERT INTO users (name, email)
VALUES ('Alice Johnson', 'alice.johnson@email.com');
INSERT INTO posts (user_id, text)
VALUES (1, 'potgresql is the most powerful tool in database ');
INSERT INTO comments (post_id, user_id, text)
VALUES (1, 1, 'I knew it');
INSERT INTO likes (user_id, post_id) VALUES
(1, 1);