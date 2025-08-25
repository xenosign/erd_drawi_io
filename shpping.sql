-- CREATE DATABASE shopping_test;

USE shopping_test;

CREATE TABLE regions (
  region_id     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  region_name   VARCHAR(100) NOT NULL,
  region_code   VARCHAR(50)  NOT NULL,              -- 지역번호
  CONSTRAINT uq_regions_region_code UNIQUE (region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE users (
  user_id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_code      VARCHAR(50)  NOT NULL,             -- 고객코드 → 사용자코드
  name           VARCHAR(100) NOT NULL,             -- 이름
  phone          VARCHAR(20)  NULL,                 -- 전화번호
  email          VARCHAR(255) NULL,                 -- 이메일
  address_line1  VARCHAR(255) NULL,                 -- 기본주소
  address_line2  VARCHAR(255) NULL,                 -- 상세주소
  join_date      DATE         NULL,                 -- 가입일
  region_id      BIGINT UNSIGNED NULL,              -- 지역 FK (관리 관계)
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
