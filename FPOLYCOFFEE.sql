CREATE DATABASE FPOLYCOFFEE;
GO
USE FPOLYCOFFEE;
GO

CREATE TABLE ROLE
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE [USER]
(
    id INT IDENTITY(1,1) NOT NULL,
    fullname NVARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    status BIT NOT NULL DEFAULT 1,
    -- 1=active, 0=locked
    role_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (role_id) REFERENCES ROLE(id)
);

CREATE TABLE CUSTOMER
(
    id INT IDENTITY(1,1) NOT NULL,
    fullname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    point INT NOT NULL DEFAULT 0,
    status BIT NOT NULL DEFAULT 1,
    created_at DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE DISCOUNTCODE
(
    id INT IDENTITY(1,1) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    discount_value DECIMAL(10,2) NOT NULL,
    discount_type BIT NOT NULL,
    -- 0=fixed amount, 1=percent
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status BIT NOT NULL DEFAULT 1,
    condition_note NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE CATEGORY
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NOT NULL DEFAULT '',
    image NVARCHAR(255) NOT NULL DEFAULT '',
    status BIT NOT NULL DEFAULT 1,
    created_at DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE DRINK
(
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

CREATE TABLE BILL
(
    id INT IDENTITY(1,1) NOT NULL,
    created_at DATE NOT NULL,
    total_price DECIMAL(18,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    payment_method BIT NOT NULL DEFAULT 0,
    -- 0=cash, 1=online
    status TINYINT NOT NULL DEFAULT 0,
    -- 0=waiting, 1=finish, 2=cancel
    code VARCHAR(30) NOT NULL UNIQUE,
    user_id INT NULL,
    customer_id INT NULL,
    discount_id INT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES [USER](id) ON DELETE SET NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id) ON DELETE SET NULL,
    FOREIGN KEY (discount_id) REFERENCES DISCOUNTCODE(id) ON DELETE SET NULL
);

CREATE TABLE BILLDETAIL
(
    bill_id INT NOT NULL,
    drink_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    total_price DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (bill_id, drink_id),
    FOREIGN KEY (bill_id) REFERENCES BILL(id) ON DELETE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES DRINK(id) ON DELETE NO ACTION
);

CREATE TABLE POINT
(
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

INSERT INTO ROLE
    (name)
VALUES
    (N'Quản lý'),
    (N'Nhân viên');

INSERT INTO [USER]
    (fullname, email, phone, password, status, role_id)
VALUES
    (N'Phạm Thuỳ Trinh', 'trinh@gmail.com', '0919123123', '123456', 1, 1),
    (N'Mai Quốc Tam', 'tam@gmail.com', '0907828123', '123456', 1, 2),
    (N'Nguyễn Bá Hải Anh', 'anh@gmail.com', '090947195', '123456', 1, 2),
    (N'Trần Hải An', 'an@gmail.com', '098471502', '123456', 1, 2);

INSERT INTO CATEGORY
    (name, description, image, status, created_at)
VALUES
    (N'Cafe', N'Các loại cà phê', '', 1, GETDATE()),
    (N'Trà', N'Các loại trà', '', 1, GETDATE()),
    (N'Nước ép', N'Nước ép trái cây', '', 1, GETDATE()),
    (N'Sinh tố', N'Sinh tố các loại', '', 1, GETDATE()),
    (N'Đá xay', N'Các loại đồ uống đá xay mát lạnh', '', 1, GETDATE()),
    (N'Matcha', N'Các loại đồ uống matcha Nhật Bản', '', 1, GETDATE()),
    (N'Chocolate', N'Đồ uống chocolate thơm ngon', '', 1, GETDATE());
GO

-- ---- CAFE (category_id = 1) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Cà phê đen', 25000, N'Cà phê đen truyền thống đậm đà', 'cafe_den.jpg', 1, 1),
    (N'Cà phê sữa', 30000, N'Cà phê sữa đặc thơm ngon', 'cafe_sua.jpg', 1, 1),
    (N'Bạc xỉu', 35000, N'Bạc xỉu với phong cách Huế', 'bac_xiu.jpg', 1, 1),
    (N'Americano', 40000, N'Espresso pha loãng với nước nóng', 'americano.jpg', 1, 1),
    (N'Espresso', 35000, N'Espresso nguyên chất đậm đà', 'espresso.jpg', 1, 1),
    (N'Cappuccino', 45000, N'Cappuccino với foam sữa mịn', 'cappuccino.jpg', 1, 1),
    (N'Latte', 45000, N'Cafe latte sữa thơm béo', 'latte.jpg', 1, 1),
    (N'Mocha', 50000, N'Kết hợp espresso, chocolate và sữa', 'mocha.jpg', 1, 1),
    (N'Cà phê muối', 38000, N'Cà phê muối phong cách Huế', 'cafe_muoi.jpg', 1, 1),
    (N'Cold Brew', 55000, N'Cà phê pha lạnh 24 giờ đậm đà', 'cold_brew.jpg', 1, 1);
GO

-- ---- TRÀ (category_id = 2) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Trà đào cam sả', 45000, N'Trà đào kết hợp cam và sả thơm mát', 'tra_dao_cam_sa.jpg', 1, 2),
    (N'Trà sen vàng', 50000, N'Trà xanh hoa sen tinh tế', 'tra_sen_vang.jpg', 1, 2),
    (N'Trà gừng mật ong', 40000, N'Trà gừng ấm áp với mật ong', 'tra_gung.jpg', 1, 2),
    (N'Trà ô long', 45000, N'Trà ô long thơm nhẹ kiểu Đài Loan', 'tra_o_long.jpg', 1, 2),
    (N'Trà chanh', 35000, N'Trà chanh tươi mát', 'tra_chanh.jpg', 1, 2),
    (N'Trà vải', 45000, N'Trà trái vải ngọt thơm', 'tra_vai.jpg', 1, 2),
    (N'Trà hoa cúc', 40000, N'Trà hoa cúc thanh mát, giảm stress', 'tra_hoa_cuc.jpg', 1, 2),
    (N'Trà bạc hà', 38000, N'Trà bạc hà mát lạnh thơm dễ chịu', 'tra_bac_ha.jpg', 1, 2);
GO

-- ---- NƯỚC ÉP (category_id = 3) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Nước ép cam', 45000, N'Cam tươi ép nguyên chất', 'ep_cam.jpg', 1, 3),
    (N'Nước ép dưa hấu', 40000, N'Dưa hấu ép tươi mát', 'ep_dua_hau.jpg', 1, 3),
    (N'Nước ép táo', 50000, N'Táo xanh ép nguyên chất', 'ep_tao.jpg', 1, 3),
    (N'Nước ép cà rốt', 45000, N'Cà rốt ép bổ dưỡng', 'ep_ca_rot.jpg', 1, 3),
    (N'Nước ép dứa', 40000, N'Dứa ép chua ngọt đặc trưng', 'ep_dua.jpg', 1, 3),
    (N'Nước ép xoài', 50000, N'Xoài chín ép ngọt thơm', 'ep_xoai.jpg', 1, 3),
    (N'Nước ép lê', 55000, N'Lê ép thanh mát ngọt nhẹ', 'ep_le.jpg', 1, 3),
    (N'Nước ép nho', 55000, N'Nho đen ép nguyên chất', 'ep_nho.jpg', 1, 3);
GO

-- ---- SINH TỐ (category_id = 4) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Sinh tố bơ', 55000, N'Sinh tố bơ béo ngậy thơm ngon', 'st_bo.jpg', 1, 4),
    (N'Sinh tố xoài', 50000, N'Sinh tố xoài chín ngọt thơm', 'st_xoai.jpg', 1, 4),
    (N'Sinh tố dâu', 55000, N'Sinh tố dâu tây tươi chua ngọt', 'st_dau.jpg', 1, 4),
    (N'Sinh tố chuối', 45000, N'Sinh tố chuối bổ dưỡng', 'st_chuoi.jpg', 1, 4),
    (N'Sinh tố dưa hấu', 45000, N'Sinh tố dưa hấu mát lạnh', 'st_dua_hau.jpg', 1, 4),
    (N'Sinh tố mixed fruits', 60000, N'Hỗn hợp nhiều loại trái cây tươi', 'st_mixed.jpg', 1, 4),
    (N'Sinh tố sapoche', 55000, N'Sinh tố sapoche béo ngậy lạ miệng', 'st_sapoche.jpg', 1, 4),
    (N'Sinh tố mãng cầu', 55000, N'Sinh tố mãng cầu xiêm chua ngọt', 'st_mang_cau.jpg', 1, 4);
GO

-- ---- ĐÁ XAY (category_id = 5) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Đá xay caramel', 65000, N'Đá xay caramel thơm ngọt kiểu Starbucks', 'dx_caramel.jpg', 1, 5),
    (N'Đá xay matcha', 65000, N'Đá xay matcha vị đắng nhẹ béo ngậy', 'dx_matcha.jpg', 1, 5),
    (N'Đá xay chocolate', 65000, N'Đá xay chocolate đậm đà ngọt ngào', 'dx_chocolate.jpg', 1, 5),
    (N'Đá xay dâu tây', 65000, N'Đá xay dâu tây màu hồng xinh xắn', 'dx_dau.jpg', 1, 5),
    (N'Đá xay cafe', 60000, N'Đá xay cafe đậm đà tỉnh táo', 'dx_cafe.jpg', 1, 5),
    (N'Đá xay bạc hà', 65000, N'Đá xay bạc hà mát lạnh sảng khoái', 'dx_bac_ha.jpg', 1, 5),
    (N'Đá xay việt quất', 70000, N'Đá xay việt quất tím đẹp, nhiều vitamin', 'dx_viet_quat.jpg', 1, 5),
    (N'Đá xay xoài', 65000, N'Đá xay xoài chín ngọt thơm nhiệt đới', 'dx_xoai.jpg', 1, 5);
GO

-- ---- MATCHA (category_id = 6) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Matcha latte', 55000, N'Matcha Nhật pha latte sữa thơm', 'matcha_latte.jpg', 1, 6),
    (N'Matcha đá xay', 60000, N'Matcha đá xay mát lạnh', 'matcha_da_xay.jpg', 1, 6),
    (N'Matcha sữa đặc', 50000, N'Matcha thêm sữa đặc ngọt ngào', 'matcha_sua_dac.jpg', 1, 6),
    (N'Matcha trái cây', 65000, N'Matcha kết hợp với trái cây tươi', 'matcha_trai_cay.jpg', 1, 6),
    (N'Matcha yogurt', 65000, N'Matcha pha với yogurt chua ngọt', 'matcha_yogurt.jpg', 1, 6),
    (N'Matcha dừa', 60000, N'Matcha béo ngậy với nước dừa tươi', 'matcha_dua.jpg', 1, 6);
GO

-- ---- CHOCOLATE (category_id = 7) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Hot chocolate', 50000, N'Chocolate nóng ấm áp ngày mưa', 'hot_choco.jpg', 1, 7),
    (N'Chocolate đá', 50000, N'Chocolate lạnh giải nhiệt', 'choco_da.jpg', 1, 7),
    (N'Chocolate sữa', 55000, N'Chocolate pha sữa tươi béo ngậy', 'choco_sua.jpg', 1, 7),
    (N'Chocolate dâu', 60000, N'Chocolate kết hợp dâu tây tươi', 'choco_dau.jpg', 1, 7),
    (N'White chocolate', 60000, N'White chocolate thơm ngọt nhẹ nhàng', 'white_choco.jpg', 1, 7),
    (N'Chocolate hazelnut', 65000, N'Chocolate hạt phỉ kiểu Châu Âu', 'choco_hazelnut.jpg', 1, 7);
GO

