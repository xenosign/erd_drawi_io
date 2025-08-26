-- CREATE DATABASE shopping_test;

USE shopping_test;

DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS product_colors;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
  region_id     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  region_name   VARCHAR(100) NOT NULL,
  region_code   VARCHAR(50)  NOT NULL,              
  CONSTRAINT uq_regions_region_code UNIQUE (region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
  user_id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_code      VARCHAR(50)  NOT NULL,            
  name           VARCHAR(100) NOT NULL,            
  phone          VARCHAR(20)  NULL,                
  email          VARCHAR(255) NULL,                
  address_line1  VARCHAR(255) NULL,                
  address_line2  VARCHAR(255) NULL,                
  join_date      DATE         NULL,                
  region_id      BIGINT UNSIGNED NULL,             
  CONSTRAINT uq_users_user_code UNIQUE (user_code),
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT fk_users_region
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE products (
  product_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_code  VARCHAR(50)  NOT NULL,
  product_name  VARCHAR(150) NOT NULL,
  product_type  VARCHAR(100) NULL,
  CONSTRAINT uq_products_product_code UNIQUE (product_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE product_colors (
  product_id  BIGINT UNSIGNED NOT NULL,
  color       VARCHAR(50)     NOT NULL,
  PRIMARY KEY (product_id, color),
  CONSTRAINT fk_product_colors_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE purchases (
  purchase_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  purchase_no    VARCHAR(50)  NOT NULL,
  user_id        BIGINT UNSIGNED NOT NULL,
  product_id     BIGINT UNSIGNED NOT NULL,
  quantity       INT UNSIGNED  NOT NULL,
  purchased_at   DATETIME      NOT NULL,
  CONSTRAINT uq_purchases_purchase_no UNIQUE (purchase_no),
  CONSTRAINT chk_purchases_quantity CHECK (quantity > 0),
  CONSTRAINT fk_purchases_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_purchases_product
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 인덱스
CREATE INDEX idx_users_region_id    ON users(region_id);
CREATE INDEX idx_users_name         ON users(name);
CREATE INDEX idx_users_phone        ON users(phone);

CREATE INDEX idx_products_name      ON products(product_name);
CREATE INDEX idx_products_type      ON products(product_type);

CREATE INDEX idx_purchases_user_id  ON purchases(user_id);
CREATE INDEX idx_purchases_product_id ON purchases(product_id);
CREATE INDEX idx_purchases_purchased_at ON purchases(purchased_at);

CREATE INDEX idx_regions_name       ON regions(region_name);

INSERT INTO regions (region_name, region_code) VALUES
('서울', 'SEOUL'),
('부산', 'BUSAN'),
('대구', 'DAEGU'),
('인천', 'INCHEON'),
('광주', 'GWANGJU');

INSERT INTO users (user_code, name, phone, email, address_line1, address_line2, join_date, region_id) VALUES
('U001', '김철수', '010-1111-2222', 'chulsoo@example.com', '서울 강남구 테헤란로 123', '101호', '2024-01-10', 1),
('U002', '이영희', '010-3333-4444', 'younghee@example.com', '부산 해운대구 해운대로 45', NULL, '2024-02-15', 2),
('U003', '박민수', '010-5555-6666', 'minsu@example.com', '대구 달서구 월성동 77', '202호', '2024-03-01', 3),
('U004', '최지우', '010-7777-8888', 'jiwoo@example.com', '인천 남동구 구월동 12', '502호', '2024-04-20', 4),
('U005', '정하나', '010-9999-0000', 'hana@example.com', '광주 북구 문흥동 88', NULL, '2024-05-05', 5);

INSERT INTO products (product_code, product_name, product_type) VALUES
('P001', '아이폰 15', '전자제품'),
('P002', '갤럭시 S24', '전자제품'),
('P003', '에어팟 프로 2', '액세서리'),
('P004', '나이키 운동화', '패션'),
('P005', '아디다스 티셔츠', '패션');

INSERT INTO product_colors (product_id, color) VALUES
(1, '블랙'),
(1, '화이트'),
(2, '블루'),
(3, '화이트'),
(4, '레드'),
(4, '블루'),
(5, '블랙'),
(5, '화이트');

INSERT INTO purchases (purchase_no, user_id, product_id, quantity, purchased_at) VALUES
('PO1001', 1, 1, 1, '2024-06-01 10:30:00'),
('PO1002', 2, 2, 2, '2024-06-02 14:00:00'),
('PO1003', 3, 3, 1, '2024-06-03 16:20:00'),
('PO1004', 4, 4, 1, '2024-06-04 11:15:00'),
('PO1005', 5, 5, 3, '2024-06-05 09:45:00');

