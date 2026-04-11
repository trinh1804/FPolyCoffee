CREATE DATABASE FPOLYCOFFEE;
GO
USE FPOLYCOFFEE;
GO

select *
from Drink;

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

INSERT INTO [USER]
    (fullname, email, phone, password, status, role_id)
VALUES
    (N'Test', 'trinhpham180408@gmail.com', '038290482', '123456', 1, 2);

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
    (N'Cà phê đen', 25000, N'Cà phê đen truyền thống đậm đà', 'ca_phe_den.jpg', 1, 1),
    (N'Cà phê sữa', 30000, N'Cà phê sữa đặc thơm ngon', 'ca_phe_sua.jpg', 1, 1),
    (N'Bạc xỉu', 35000, N'Bạc xỉu với phong cách Huế', 'bac_xiu.jpg', 1, 1),
    (N'Americano', 40000, N'Espresso pha loãng với nước nóng', 'americano.jpg', 1, 1),
    (N'Espresso', 35000, N'Espresso nguyên chất đậm đà', 'espresso.jpg', 1, 1),
    (N'Cappuccino', 45000, N'Cappuccino với foam sữa mịn', 'cappuccino.jpg', 1, 1),
    (N'Latte', 45000, N'Cafe latte sữa thơm béo', 'latte.webp', 1, 1),
    (N'Mocha', 50000, N'Kết hợp espresso, chocolate và sữa', 'mocha.jpg', 1, 1),
    (N'Cà phê muối', 38000, N'Cà phê muối phong cách Huế', 'cafe_muoi.jpg', 1, 1),
    (N'Cold Brew', 55000, N'Cà phê pha lạnh 24 giờ đậm đà', 'cold_brew.jpg', 1, 1);
GO

-- ---- TRÀ (category_id = 2) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Trà đào cam sả', 45000, N'Trà đào kết hợp cam và sả thơm mát', 'tra_dao_cam_sa.jpg', 1, 2),
    (N'Trà sen vàng', 50000, N'Trà xanh hoa sen tinh tế', 'tra_sen_vang.webp', 1, 2),
    (N'Trà gừng mật ong', 40000, N'Trà gừng ấm áp với mật ong', 'tra_gung_mat_ong.jpg', 1, 2),
    (N'Trà ô long', 45000, N'Trà ô long thơm nhẹ kiểu Đài Loan', 'tra_o_long.jpg', 1, 2),
    (N'Trà chanh', 35000, N'Trà chanh tươi mát', 'tra_chanh.jpg', 1, 2),
    (N'Trà vải', 45000, N'Trà trái vải ngọt thơm', 'tra_vai.avif', 1, 2),
    (N'Trà hoa cúc', 40000, N'Trà hoa cúc thanh mát, giảm stress', 'tra_hoa_cuc.webp', 1, 2),
    (N'Trà bạc hà', 38000, N'Trà bạc hà mát lạnh thơm dễ chịu', 'tra_bac_ha.webp', 1, 2);
GO

-- ---- NƯỚC ÉP (category_id = 3) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Nước ép cam', 45000, N'Cam tươi ép nguyên chất', 'nuoc_ep_cam.jpg', 1, 3),
    (N'Nước ép dưa hấu', 40000, N'Dưa hấu ép tươi mát', 'nuoc_ep_dua_hau.webp', 1, 3),
    (N'Nước ép táo', 50000, N'Táo xanh ép nguyên chất', 'nuoc_ep_tao.webp', 1, 3),
    (N'Nước ép cà rốt', 45000, N'Cà rốt ép bổ dưỡng', 'nuoc_ep_ca_rot.jpg', 1, 3),
    (N'Nước ép dứa', 40000, N'Dứa ép chua ngọt đặc trưng', 'nuoc_ep_dua.jpg', 1, 3),
    (N'Nước ép xoài', 50000, N'Xoài chín ép ngọt thơm', 'nuoc_ep_xoai.webp', 1, 3),
    (N'Nước ép lê', 55000, N'Lê ép thanh mát ngọt nhẹ', 'nuoc_ep_le.jpg', 1, 3),
    (N'Nước ép nho', 55000, N'Nho đen ép nguyên chất', 'nuoc_ep_nho.webp', 1, 3);
GO

-- ---- SINH TỐ (category_id = 4) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Sinh tố bơ', 55000, N'Sinh tố bơ béo ngậy thơm ngon', 'sto_bo.jpg', 1, 4),
    (N'Sinh tố xoài', 50000, N'Sinh tố xoài chín ngọt thơm', 'sto_xoai.webp', 1, 4),
    (N'Sinh tố dâu', 55000, N'Sinh tố dâu tây tươi chua ngọt', 'sto_dau.png', 1, 4),
    (N'Sinh tố chuối', 45000, N'Sinh tố chuối bổ dưỡng', 'sto_chuoi.jpg', 1, 4),
    (N'Sinh tố dưa hấu', 45000, N'Sinh tố dưa hấu mát lạnh', 'sto_dua_hau.webp', 1, 4),
    (N'Sinh tố mixed fruits', 60000, N'Hỗn hợp nhiều loại trái cây tươi', 'st_mixed.jpg', 1, 4),
    (N'Sinh tố sapoche', 55000, N'Sinh tố sapoche béo ngậy lạ miệng', 'sto sapoche.jpg', 1, 4),
    (N'Sinh tố mãng cầu', 55000, N'Sinh tố mãng cầu xiêm chua ngọt', 'sto_mang_cau.png', 1, 4);
GO

-- ---- ĐÁ XAY (category_id = 5) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Đá xay caramel', 65000, N'Đá xay caramel thơm ngọt kiểu Starbucks', 'caramel_da_xay.jpg', 1, 5),
    (N'Đá xay matcha', 65000, N'Đá xay matcha vị đắng nhẹ béo ngậy', 'matcha_da_xay.jpg', 1, 5),
    (N'Đá xay chocolate', 65000, N'Đá xay chocolate đậm đà ngọt ngào', 'chocolate_da_xay.jpg', 1, 5),
    (N'Đá xay dâu tây', 65000, N'Đá xay dâu tây màu hồng xinh xắn', 'dau_tay_da_xay.jpg', 1, 5),
    (N'Đá xay cafe', 60000, N'Đá xay cafe đậm đà tỉnh táo', 'cafe_da_xay.jpg', 1, 5),
    (N'Đá xay bạc hà', 65000, N'Đá xay bạc hà mát lạnh sảng khoái', 'bac_ha_da_xay.jpg', 1, 5),
    (N'Đá xay việt quất', 70000, N'Đá xay việt quất tím đẹp, nhiều vitamin', 'viet_quat_da_xay.png', 1, 5),
    (N'Đá xay xoài', 65000, N'Đá xay xoài chín ngọt thơm nhiệt đới', 'xoai_da_xay.jpg', 1, 5);
GO

-- ---- MATCHA (category_id = 6) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Matcha latte', 55000, N'Matcha Nhật pha latte sữa thơm', 'matche_latta.jpg', 1, 6),
    (N'Matcha đá xay', 60000, N'Matcha đá xay mát lạnh', 'matcha_da_xay.jpg', 1, 6),
    (N'Matcha sữa đặc', 50000, N'Matcha thêm sữa đặc ngọt ngào', 'matcha_sua_dac.jpg', 1, 6),
    (N'Matcha trái cây', 65000, N'Matcha kết hợp với trái cây tươi', 'matcha_trai_cay.png', 1, 6),
    (N'Matcha yogurt', 65000, N'Matcha pha với yogurt chua ngọt', 'matcha_yogurt.jpg', 1, 6),
    (N'Matcha dừa', 60000, N'Matcha béo ngậy với nước dừa tươi', 'matcha_dua.jpg', 1, 6);
GO

-- ---- CHOCOLATE (category_id = 7) ----
INSERT INTO DRINK
    (name, price, description, image, status, category_id)
VALUES
    (N'Hot chocolate', 50000, N'Chocolate nóng ấm áp ngày mưa', 'hot_chocolate.jpg', 1, 7),
    (N'Chocolate đá', 50000, N'Chocolate lạnh giải nhiệt', 'chocolate_da.jpg', 1, 7),
    (N'Chocolate sữa', 55000, N'Chocolate pha sữa tươi béo ngậy', 'chocolate_sua.jpg', 1, 7),
    (N'Chocolate dâu', 60000, N'Chocolate kết hợp dâu tây tươi', 'chocolate_dau.jpg', 1, 7),
    (N'White chocolate', 60000, N'White chocolate thơm ngọt nhẹ nhàng', 'white_chocolate.jpg', 1, 7),
    (N'Chocolate hazelnut', 65000, N'Chocolate hạt phỉ kiểu Châu Âu', 'chocolate_hazelnut.jpg', 1, 7);
GO

-- Thêm khách hàng
INSERT INTO CUSTOMER
    (fullname, phone, email, point, status, created_at)
VALUES
    (N'Nguyễn Văn An', '0987654321', 'an.nguyen@email.com', 150, 1, '2026-03-01'),
    (N'Trần Thị Bình', '0976543210', 'binh.tran@email.com', 85, 1, '2026-03-05'),
    (N'Lê Văn Cường', '0965432109', 'cuong.le@email.com', 200, 1, '2026-03-10'),
    (N'Phạm Thị Dung', '0954321098', 'dung.pham@email.com', 45, 1, '2026-03-15'),
    (N'Hoàng Văn Em', '0943210987', 'em.hoang@email.com', 320, 1, '2026-03-20'),
    (N'Ngô Thị Phương', '0932109876', 'phuong.ngo@email.com', 0, 1, '2026-04-01'),
    (N'Đỗ Văn Giang', '0921098765', 'giang.do@email.com', 12, 1, '2026-04-02'),
    (N'Vũ Thị Hà', '0910987654', 'ha.vu@email.com', 78, 1, '2026-04-03');
GO

-- Thêm mã giảm giá
INSERT INTO DISCOUNTCODE
    (code, discount_value, discount_type, start_date, end_date, status, condition_note)
VALUES
    ('WELCOME10', 10, 1, '2026-03-01', '2026-12-31', 1, N'Giảm 10% cho đơn hàng đầu tiên'),
    ('GIAM20K', 20000, 0, '2026-03-01', '2026-12-31', 1, N'Giảm 20.000đ cho đơn từ 100.000đ'),
    ('SALE50', 50, 1, '2026-04-01', '2026-04-10', 1, N'Giảm 50% nhân dịp khai trương'),
    ('FREESHIP', 15000, 0, '2026-04-01', '2026-04-30', 1, N'Giảm 15.000đ phí ship'),
    ('MEMBERS', 15, 1, '2026-03-15', '2026-12-31', 1, N'Giảm 15% cho thành viên VIP'),
    ('DACBIET30', 30, 1, '2026-04-05', '2026-04-15', 1, N'Giảm 30% đặc biệt'),
    ('CUOITUAN', 10, 1, '2026-04-01', '2026-04-30', 1, N'Giảm 10% cuối tuần');
GO

-- Hóa đơn tháng 3 (đã hoàn thành)
INSERT INTO BILL
    (created_at, total_price, discount_amount, payment_method, status, code, user_id, customer_id, discount_id)
VALUES
    ('2026-03-01', 125000, 0, 0, 1, 'HD001', 2, 1, NULL),
    ('2026-03-02', 89000, 0, 1, 1, 'HD002', 3, 2, NULL),
    ('2026-03-03', 210000, 21000, 0, 1, 'HD003', 4, 3, 1),
    ('2026-03-05', 45000, 0, 0, 1, 'HD004', 2, 1, NULL),
    ('2026-03-07', 175000, 0, 1, 1, 'HD005', 3, 4, NULL),
    ('2026-03-10', 320000, 48000, 0, 1, 'HD006', 4, 5, 2),
    ('2026-03-12', 95000, 0, 0, 1, 'HD007', 2, 2, NULL),
    ('2026-03-15', 280000, 28000, 1, 1, 'HD008', 3, 3, 1),
    ('2026-03-18', 67000, 0, 0, 1, 'HD009', 4, 6, NULL),
    ('2026-03-20', 450000, 67500, 0, 1, 'HD010', 2, 5, 3),
    ('2026-03-22', 150000, 0, 1, 1, 'HD011', 3, 1, NULL),
    ('2026-03-25', 89000, 0, 0, 1, 'HD012', 4, 7, NULL),
    ('2026-03-27', 235000, 23500, 1, 1, 'HD013', 2, 4, 5),
    ('2026-03-28', 120000, 0, 0, 1, 'HD014', 3, 2, NULL),
    ('2026-03-29', 345000, 0, 1, 1, 'HD015', 4, 8, NULL),
    ('2026-03-30', 98000, 0, 0, 1, 'HD016', 2, 3, NULL),
    ('2026-03-31', 560000, 84000, 0, 1, 'HD017', 3, 5, 3);

-- Hóa đơn tháng 4 (đã hoàn thành, đang chờ, đã hủy)
INSERT INTO BILL
    (created_at, total_price, discount_amount, payment_method, status, code, user_id, customer_id, discount_id)
VALUES
    ('2026-04-01', 185000, 18500, 0, 1, 'HD018', 4, 1, 1),
    ('2026-04-01', 75000, 0, 1, 1, 'HD019', 2, 2, NULL),
    ('2026-04-02', 420000, 63000, 0, 1, 'HD020', 3, 5, 3),
    ('2026-04-02', 95000, 0, 0, 1, 'HD021', 4, 3, NULL),
    ('2026-04-03', 150000, 0, 1, 1, 'HD022', 2, 4, NULL),
    ('2026-04-03', 280000, 42000, 0, 1, 'HD023', 3, 6, 5),
    ('2026-04-04', 67000, 0, 0, 1, 'HD024', 4, 1, NULL),
    ('2026-04-04', 340000, 0, 1, 1, 'HD025', 2, 7, NULL),
    ('2026-04-05', 195000, 0, 0, 1, 'HD026', 3, 2, NULL),
    ('2026-04-05', 110000, 0, 1, 0, 'HD027', 4, 8, NULL),
    -- Đang chờ xử lý
    ('2026-04-05', 250000, 0, 0, 0, 'HD028', 2, 3, NULL),
    -- Đang chờ xử lý
    ('2026-04-05', 89000, 0, 1, 2, 'HD029', 3, 4, NULL),
    -- Đã hủy
    ('2026-04-05', 450000, 0, 0, 2, 'HD030', 4, 5, NULL);  -- Đã hủy
GO

-- Chi tiết hóa đơn HD001 (id=1)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (1, 2, 2, 30000, 60000),
    -- Cà phê sữa x 2
    (1, 11, 1, 45000, 45000),
    -- Trà đào cam sả
    (1, 29, 1, 20000, 20000);
-- Nước ép dưa hấu

-- Chi tiết hóa đơn HD002 (id=2)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (2, 1, 1, 25000, 25000),
    -- Cà phê đen
    (2, 16, 1, 35000, 35000),
    -- Trà chanh
    (2, 19, 1, 29000, 29000);
-- Nước ép cam

-- Chi tiết hóa đơn HD003 (id=3)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (3, 6, 3, 45000, 135000),
    -- Cappuccino x 3
    (3, 31, 2, 55000, 110000);
-- Sinh tố bơ x 2

-- Chi tiết hóa đơn HD004 (id=4)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (4, 4, 1, 40000, 40000),
    -- Americano
    (4, 13, 1, 5000, 5000);
-- Trà gừng mật ong

-- Chi tiết hóa đơn HD005 (id=5)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (5, 8, 2, 50000, 100000),
    -- Mocha x 2
    (5, 24, 1, 45000, 45000),
    -- Sinh tố dâu
    (5, 36, 1, 30000, 30000);
-- Sinh tố chuối

-- Chi tiết hóa đơn HD006 (id=6)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (6, 39, 2, 65000, 130000),
    -- Đá xay matcha x 2
    (6, 42, 2, 60000, 120000),
    -- Đá xay cafe x 2
    (6, 48, 1, 70000, 70000);
-- Matcha latte

-- Chi tiết hóa đơn HD007 (id=7)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (7, 3, 1, 35000, 35000),
    -- Bạc xỉu
    (7, 17, 1, 45000, 45000),
    -- Trà vải
    (7, 33, 1, 15000, 15000);
-- Sinh tố dưa hấu

-- Chi tiết hóa đơn HD008 (id=8)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (8, 9, 2, 38000, 76000),
    -- Cà phê muối x 2
    (8, 27, 2, 55000, 110000),
    -- Sinh tố bơ x 2
    (8, 44, 2, 65000, 130000);
-- Đá xay dâu tây x 2

-- Chi tiết hóa đơn HD009 (id=9)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (9, 5, 1, 35000, 35000),
    -- Espresso
    (9, 12, 1, 50000, 50000),
    -- Trà sen vàng
    (9, 38, 1, -18000, -18000);
-- (Lỗi test)

-- Chi tiết hóa đơn HD010 (id=10)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (10, 40, 3, 65000, 195000),
    -- Đá xay chocolate x 3
    (10, 46, 2, 55000, 110000),
    -- Matcha sữa đặc x 2
    (10, 51, 1, 60000, 60000),
    -- Hot chocolate
    (10, 53, 1, 55000, 55000);
-- Chocolate sữa

-- Chi tiết hóa đơn HD011 (id=11)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (11, 7, 2, 45000, 90000),
    -- Latte x 2
    (11, 18, 2, 35000, 70000);
-- Trà hoa cúc x 2

-- Chi tiết hóa đơn HD012 (id=12)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (12, 14, 1, 40000, 40000),
    -- Trà ô long
    (12, 22, 1, 45000, 45000),
    -- Nước ép dứa
    (12, 35, 1, 4000, 4000);
-- Sinh tố mixed fruits

-- Chi tiết hóa đơn HD013 (id=13)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (13, 41, 2, 65000, 130000),
    -- Đá xay dâu tây x 2
    (13, 49, 2, 60000, 120000);
-- Matcha đá xay x 2


-- Chi tiết hóa đơn HD014 (id=14)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (14, 10, 2, 55000, 110000),
    -- Cold Brew x 2
    (14, 15, 1, 10000, 10000);
-- Trà bạc hà

-- Chi tiết hóa đơn HD015 (id=15)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (15, 25, 2, 55000, 110000),
    -- Sinh tố xoài x 2
    (15, 32, 2, 55000, 110000),
    -- Sinh tố dâu x 2
    (15, 47, 2, 65000, 130000);
-- Matcha trái cây x 2

-- Chi tiết hóa đơn HD016 (id=16)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (16, 20, 2, 50000, 100000),
    -- Nước ép táo x 2
    (16, 23, 1, -2000, -2000);
-- (Lỗi test)

-- Chi tiết hóa đơn HD017 (id=17)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (17, 43, 3, 65000, 195000),
    -- Đá xay bạc hà x 3
    (17, 50, 3, 65000, 195000),
    -- Matcha yogurt x 3
    (17, 53, 2, 60000, 120000);
-- White chocolate x 2

-- Chi tiết hóa đơn HD018 (id=18)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (18, 1, 2, 25000, 50000),
    -- Cà phê đen x 2
    (18, 2, 2, 30000, 60000),
    -- Cà phê sữa x 2
    (18, 4, 1, 40000, 40000),
    -- Americano
    (18, 5, 1, 35000, 35000);
-- Espresso

-- Chi tiết hóa đơn HD019 (id=19)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (19, 11, 1, 45000, 45000),
    -- Trà đào cam sả
    (19, 16, 1, 35000, 35000);
-- Trà chanh

-- Chi tiết hóa đơn HD020 (id=20)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (20, 29, 3, 40000, 120000),
    -- Nước ép dưa hấu x 3
    (20, 31, 3, 55000, 165000),
    -- Sinh tố bơ x 3
    (20, 39, 2, 65000, 130000);
-- Đá xay matcha x 2

-- Chi tiết hóa đơn HD021 (id=21)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (21, 7, 1, 45000, 45000),
    -- Latte
    (21, 8, 1, 50000, 50000);
-- Mocha

-- Chi tiết hóa đơn HD022 (id=22)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (22, 17, 2, 45000, 90000),
    -- Trà vải x 2
    (22, 18, 1, 40000, 40000),
    -- Trà hoa cúc
    (22, 19, 1, 45000, 45000);
-- Nước ép cam

-- Chi tiết hóa đơn HD023 (id=23)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (23, 27, 2, 55000, 110000),
    -- Sinh tố bơ x 2
    (23, 34, 2, 45000, 90000),
    -- Sinh tố dưa hấu x 2
    (23, 37, 1, 55000, 55000);
-- Sinh tố sapoche

-- Chi tiết hóa đơn HD024 (id=24)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (24, 12, 1, 50000, 50000),
    -- Trà sen vàng
    (24, 14, 1, 45000, 45000);
-- Trà ô long

-- Chi tiết hóa đơn HD025 (id=25)
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (25, 44, 3, 65000, 195000),
    -- Đá xay dâu tây x 3
    (25, 45, 2, 60000, 120000);
-- Đá xay cafe x 2

-- Chi tiết hóa đơn HD026 (id=26) - Hóa đơn hoàn thành ngày 05/04
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (26, 3, 2, 35000, 70000),
    -- Bạc xỉu x 2
    (26, 6, 1, 45000, 45000),
    -- Cappuccino
    (26, 10, 1, 55000, 55000);
-- Cold Brew

-- Chi tiết hóa đơn HD027 (id=27) - Đang chờ xử lý
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (27, 2, 2, 30000, 60000),
    -- Cà phê sữa x 2
    (27, 11, 1, 45000, 45000);
-- Trà đào cam sả

-- Chi tiết hóa đơn HD028 (id=28) - Đang chờ xử lý
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (28, 31, 2, 55000, 110000),
    -- Sinh tố bơ x 2
    (28, 39, 2, 65000, 130000);
-- Đá xay matcha x 2

-- Chi tiết hóa đơn HD029 (id=29) - Đã hủy
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (29, 4, 1, 40000, 40000),
    -- Americano
    (29, 16, 1, 35000, 35000),
    -- Trà chanh
    (29, 21, 1, 45000, 45000);
-- Nước ép cam

-- Chi tiết hóa đơn HD030 (id=30) - Đã hủy
INSERT INTO BILLDETAIL
    (bill_id, drink_id, quantity, unit_price, total_price)
VALUES
    (30, 41, 3, 65000, 195000),
    -- Đá xay dâu tây x 3
    (30, 46, 2, 55000, 110000),
    -- Matcha sữa đặc x 2
    (30, 52, 1, 50000, 50000);
-- Chocolate đá

-- Thêm lịch sử tích điểm cho khách hàng
INSERT INTO POINT
    (bonus_point, deduct_point, transaction_date, note, customer_id, bill_id)
VALUES
    (12, 0, '2026-03-01', N'Tích điểm hóa đơn #HD001', 1, 1),
    (8, 0, '2026-03-02', N'Tích điểm hóa đơn #HD002', 2, 2),
    (21, 0, '2026-03-03', N'Tích điểm hóa đơn #HD003', 3, 3),
    (4, 0, '2026-03-05', N'Tích điểm hóa đơn #HD004', 1, 4),
    (17, 0, '2026-03-07', N'Tích điểm hóa đơn #HD005', 4, 5),
    (32, 0, '2026-03-10', N'Tích điểm hóa đơn #HD006', 5, 6),
    (9, 0, '2026-03-12', N'Tích điểm hóa đơn #HD007', 2, 7),
    (28, 0, '2026-03-15', N'Tích điểm hóa đơn #HD008', 3, 8),
    (6, 0, '2026-03-18', N'Tích điểm hóa đơn #HD009', 6, 9),
    (45, 0, '2026-03-20', N'Tích điểm hóa đơn #HD010', 5, 10),
    (15, 0, '2026-03-22', N'Tích điểm hóa đơn #HD011', 1, 11),
    (8, 0, '2026-03-25', N'Tích điểm hóa đơn #HD012', 7, 12),
    (23, 0, '2026-03-27', N'Tích điểm hóa đơn #HD013', 4, 13),
    (12, 0, '2026-03-28', N'Tích điểm hóa đơn #HD014', 2, 14),
    (34, 0, '2026-03-29', N'Tích điểm hóa đơn #HD015', 8, 15),
    (9, 0, '2026-03-30', N'Tích điểm hóa đơn #HD016', 3, 16),
    (56, 0, '2026-03-31', N'Tích điểm hóa đơn #HD017', 5, 17),
    (18, 0, '2026-04-01', N'Tích điểm hóa đơn #HD018', 1, 18),
    (7, 0, '2026-04-01', N'Tích điểm hóa đơn #HD019', 2, 19),
    (42, 0, '2026-04-02', N'Tích điểm hóa đơn #HD020', 5, 20),
    (9, 0, '2026-04-02', N'Tích điểm hóa đơn #HD021', 3, 21),
    (15, 0, '2026-04-03', N'Tích điểm hóa đơn #HD022', 4, 22),
    (28, 0, '2026-04-03', N'Tích điểm hóa đơn #HD023', 6, 23),
    (6, 0, '2026-04-04', N'Tích điểm hóa đơn #HD024', 1, 24),
    (34, 0, '2026-04-04', N'Tích điểm hóa đơn #HD025', 7, 25),
    (19, 0, '2026-04-05', N'Tích điểm hóa đơn #HD026', 2, 26);