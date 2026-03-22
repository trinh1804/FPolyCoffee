CREATE DATABASE FPOLYCOFFEE;
GO
USE FPOLYCOFFEE;
GO

CREATE TABLE ROLE (
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE [USER] (
    id INT IDENTITY(1,1) NOT NULL,
    fullname NVARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    status BIT NOT NULL DEFAULT 1,   -- 1=active, 0=locked
    role_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (role_id) REFERENCES ROLE(id)
);

CREATE TABLE CUSTOMER (
    id INT IDENTITY(1,1) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    point INT NOT NULL DEFAULT 0,
    status BIT NOT NULL DEFAULT 1,
    created_at DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE DISCOUNTCODE (
    id INT IDENTITY(1,1) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    discount_value DECIMAL(10,2) NOT NULL,
    discount_type BIT NOT NULL,   -- 0=fixed amount, 1=percent
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status BIT NOT NULL DEFAULT 1,
    condition_note NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE CATEGORY (
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NOT NULL DEFAULT '',
    image NVARCHAR(255) NOT NULL DEFAULT '',
    status BIT NOT NULL DEFAULT 1,
    created_at DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE DRINK (
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    description NVARCHAR(MAX) NOT NULL DEFAULT '',
    image NVARCHAR(255) NOT NULL DEFAULT '',
    status BIT NOT NULL DEFAULT 1,
    category_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(id)
);

CREATE TABLE BILL (
    id INT IDENTITY(1,1) NOT NULL,
    created_at DATE NOT NULL,
    total_price DECIMAL(18,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    payment_method BIT NOT NULL DEFAULT 0,  -- 0=cash, 1=online
    status TINYINT NOT NULL DEFAULT 0,  -- 0=waiting, 1=finish, 2=cancel
    code VARCHAR(30) NOT NULL UNIQUE,
    user_id INT NULL,
    customer_id INT NULL,
    discount_id INT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [USER](id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id) ON DELETE SET NULL,
    FOREIGN KEY (discount_id) REFERENCES DISCOUNTCODE(id) ON DELETE SET NULL
);

CREATE TABLE BILLDETAIL (
    bill_id INT NOT NULL,
    drink_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    total_price DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (bill_id, drink_id),
    FOREIGN KEY (bill_id) REFERENCES BILL(id) ON DELETE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES DRINK(id) ON DELETE NO ACTION
);

CREATE TABLE POINT (
    id INT IDENTITY(1,1) NOT NULL,
    bonus_point INT NOT NULL DEFAULT 0,
    deduct_point INT NOT NULL DEFAULT 0,
    transaction_date DATE NOT NULL,
    note NVARCHAR(255) NOT NULL DEFAULT '',
    customer_id INT NOT NULL,
    bill_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id) ON DELETE CASCADE,
    FOREIGN KEY (bill_id) REFERENCES BILL(id) ON DELETE NO ACTION
);

INSERT INTO ROLE(name) VALUES 
(N'Quản lý'), 
(N'Nhân viên');

INSERT INTO [USER](fullname, email, phone, password, status, role_id) VALUES
(N'Phạm Thuỳ Trinh','trinh@gmail.com', '0919123123', '123456', 1, 1),
(N'Mai Quốc Tam',  'tam@gmail.com', '0907828123', '123456', 1, 2),
(N'Nguyễn Bá HẢi Anh',  'anh@gmail.com', '090947195', '123456', 1, 2),
(N'Trần Hải An',  'an@gmail.com', '098471502', '123456', 1, 2);

INSERT INTO CATEGORY(name, description, image, status, created_at) VALUES
(N'Cafe', N'Các loại cà phê','', 1, GETDATE()),
(N'Trà', N'Các loại trà','', 1, GETDATE()),
(N'Nước ép', N'Nước ép trái cây','', 1, GETDATE()),
(N'Sinh tố', N'Sinh tố các loại','', 1, GETDATE());
