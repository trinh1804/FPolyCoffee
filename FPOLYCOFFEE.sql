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
(N'Phạm Thuỳ Trinh', 'trinh@gmail.com', '0919123123', '123456', 1, 1),
(N'Mai Quốc Tam', 'tam@gmail.com', '0907828123', '123456', 1, 2),
(N'Nguyễn Bá HẢi Anh', 'anh@gmail.com', '090947195', '123456', 1, 2),
(N'Trần Hải An', 'an@gmail.com', '098471502', '123456', 1, 2);

INSERT INTO CATEGORY(name, description, image, status, created_at) VALUES
(N'Cà Phê',      N'Các loại cà phê truyền thống và hiện đại', '', 1, GETDATE()),
(N'Trà',         N'Các loại trà thơm ngon',                   '', 1, GETDATE()),
(N'Nước Ép',     N'Nước ép trái cây tươi ngon',               '', 1, GETDATE()),
(N'Sinh Tố',     N'Sinh tố bổ dưỡng các loại',               '', 1, GETDATE()),
(N'Soda',        N'Soda mát lạnh nhiều vị',                   '', 1, GETDATE()),
(N'Bánh & Snack', N'Bánh ngọt và đồ ăn nhẹ',                  '', 1, GETDATE());

-- Category 1: Cà Phê (id=1)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Cà Phê Đen',           25000, N'Cà phê đen truyền thống đậm đà',      '', 1, 1),
(N'Cà Phê Sữa',           30000, N'Cà phê sữa thơm béo',                 '', 1, 1),
(N'Cà Phê Bạc Xỉu',       32000, N'Cà phê sữa ít đậm kiểu Sài Gòn',     '', 1, 1),
(N'Cappuccino',            45000, N'Cappuccino Italy chuẩn vị',           '', 1, 1),
(N'Latte',                 45000, N'Latte mềm mịn hương sữa',             '', 1, 1),
(N'Americano',             40000, N'Americano thanh mát',                  '', 1, 1),
(N'Espresso',              35000, N'Espresso đặc biệt',                   '', 1, 1),
(N'Mocha',                 48000, N'Mocha kết hợp chocolate',             '', 1, 1),
(N'Cold Brew',             45000, N'Cold brew ủ lạnh 12 tiếng',           '', 1, 1),
(N'Cà Phê Cốt Dừa',       42000, N'Cà phê với cốt dừa béo ngậy',        '', 1, 1),
(N'Bạch Tuộc Sữa',        38000, N'Cà phê đá xay thơm ngon',             '', 1, 1);

-- Category 2: Trà (id=2)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Trà Sữa Truyền Thống', 35000, N'Trà sữa thơm ngon đúng vị',           '', 1, 2),
(N'Trà Sữa Matcha',       38000, N'Trà sữa matcha Nhật Bản',              '', 1, 2),
(N'Trà Sữa Oolong',       38000, N'Trà oolong đậm vị',                   '', 1, 2),
(N'Trà Đào Cam Sả',       35000, N'Trà đào thơm mát',                    '', 1, 2),
(N'Trà Vải',              32000, N'Trà vải thanh mát',                    '', 1, 2),
(N'Trà Xanh Lài',         28000, N'Trà xanh hoa lài nhẹ nhàng',          '', 1, 2),
(N'Hồng Trà Sữa Nóng',   32000, N'Hồng trà sữa nóng ấm áp',             '', 1, 2),
(N'Trà Chanh',            25000, N'Trà chanh chua ngọt',                  '', 1, 2),
(N'Trà Gừng Mật Ong',     30000, N'Trà gừng mật ong tốt cho sức khoẻ',  '', 1, 2);

-- Category 3: Nước Ép (id=3)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Nước Ép Cam',          35000, N'Nước ép cam tươi nguyên chất',         '', 1, 3),
(N'Nước Ép Dưa Hấu',     30000, N'Nước ép dưa hấu mát lạnh',             '', 1, 3),
(N'Nước Ép Cà Rốt',      32000, N'Nước ép cà rốt bổ dưỡng',             '', 1, 3),
(N'Nước Ép Táo',          35000, N'Nước ép táo xanh tươi ngon',           '', 1, 3),
(N'Nước Ép Dứa',          32000, N'Nước ép dứa thơm chua ngọt',           '', 1, 3),
(N'Nước Ép Xoài',         35000, N'Nước ép xoài chín thơm ngọt',          '', 1, 3),
(N'Nước Ép Lê',           38000, N'Nước ép lê thanh mát',                 '', 1, 3),
(N'Nước Ép Mix Rau Củ',   40000, N'Hỗn hợp rau củ tốt cho sức khoẻ',    '', 1, 3);

-- Category 4: Sinh Tố (id=4)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Sinh Tố Bơ',           45000, N'Sinh tố bơ béo ngậy bổ dưỡng',        '', 1, 4),
(N'Sinh Tố Dâu',          40000, N'Sinh tố dâu đỏ tươi ngon',            '', 1, 4),
(N'Sinh Tố Xoài',         40000, N'Sinh tố xoài chín vàng',               '', 1, 4),
(N'Sinh Tố Chuối',        35000, N'Sinh tố chuối mịn thơm',               '', 1, 4),
(N'Sinh Tố Mãng Cầu',    42000, N'Sinh tố mãng cầu ngọt dịu',            '', 1, 4),
(N'Sinh Tố Ổi',           38000, N'Sinh tố ổi thơm ngon',                 '', 1, 4),
(N'Sinh Tố Dứa Dừa',     42000, N'Sinh tố dứa kết hợp cốt dừa',         '', 1, 4),
(N'Sinh Tố Mix 3 Loại',   48000, N'Hỗn hợp 3 loại trái cây theo mùa',   '', 1, 4);

-- Category 5: Soda (id=5)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Soda Chanh Dây',       32000, N'Soda chanh dây chua ngọt mát lạnh',   '', 1, 5),
(N'Soda Việt Quất',       35000, N'Soda việt quất màu tím đẹp mắt',      '', 1, 5),
(N'Soda Dưa Lưới',        32000, N'Soda dưa lưới thơm mát',              '', 1, 5),
(N'Soda Cam',             30000, N'Soda cam sảng khoái',                  '', 1, 5),
(N'Soda Dâu',             32000, N'Soda dâu đỏ hấp dẫn',                 '', 1, 5),
(N'Soda Bạc Hà',          28000, N'Soda bạc hà mát lạnh',                '', 1, 5),
(N'Soda Blue Ocean',      35000, N'Soda xanh biển đặc trưng của quán',   '', 1, 5);

-- Category 6: Bánh & Snack (id=6)
INSERT INTO DRINK(name, price, description, image, status, category_id) VALUES
(N'Bánh Croissant',       35000, N'Bánh sừng bò bơ thơm giòn',           '', 1, 6),
(N'Bánh Tiramisu',        45000, N'Bánh tiramisu Italy thơm ngon',        '', 1, 6),
(N'Cheesecake',           48000, N'Cheesecake mềm mịn thơm ngậy',        '', 1, 6),
(N'Bánh Mì Bơ Tỏi',      25000, N'Bánh mì bơ tỏi giòn thơm',            '', 1, 6),
(N'Bánh Flan',            25000, N'Bánh flan mềm mịn truyền thống',       '', 1, 6),
(N'Cookie Chocolate',     20000, N'Cookie socola giòn tan',               '', 1, 6),
(N'Brownie',              30000, N'Brownie chocolate đậm vị',             '', 1, 6);

GO