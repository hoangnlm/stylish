USE master
GO

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = db_id('F21508T1_stylish_store_2017')

EXEC(@kill);
GO


IF db_id ('F21508T1_stylish_store_2017') is not null
	drop database F21508T1_stylish_store_2017

GO

CREATE DATABASE F21508T1_stylish_store_2017

GO

USE F21508T1_stylish_store_2017

GO

-- TABLE "User" -- 
CREATE TABLE roles (
	roleID		INT				PRIMARY KEY		IDENTITY(1,1),
	roleName	NVARCHAR(30)	NOT NULL,
)

GO

CREATE TABLE users (
	userID					INT				PRIMARY KEY		IDENTITY(1,1),
	roleID					INT				FOREIGN KEY		REFERENCES roles(roleID),
	email					NVARCHAR(50)	UNIQUE			NOT NULL,
	[password]				NVARCHAR(500)	NOT NULL,
	firstName				NVARCHAR(50)	NOT NULL,
	lastName				NVARCHAR(50)	NOT NULL,	
	avatar					NVARCHAR(50)	DEFAULT 'default_user.jpg',
	gender					TINYINT,		--1: MALE; 0: FEMALE
	birthday				DATE,
	registrationDate		DATE			DEFAULT getDate(),
	[status]				TINYINT			DEFAULT 1			--1: WORKING, 0: BANNED 
)

GO

CREATE TABLE userAddresses (
	addressID		INT					PRIMARY KEY		IDENTITY(1,1),
	userID			INT					FOREIGN KEY		REFERENCES users(userID),
	[address]		NVARCHAR(255)		NOT NULL,
	phoneNumber		NVARCHAR(20)		NOT NULL
)

GO

CREATE TABLE functions(
    functionID INT PRIMARY KEY IDENTITY(1,1),
    functionName NVARCHAR(50) NOT NULL
)

GO

CREATE TABLE permissions(
    roleID INT FOREIGN KEY (roleID) REFERENCES roles(roleID) NOT NULL,
    functionID INT FOREIGN KEY (functionID) REFERENCES functions(functionID) NOT NULL
);

GO

-- TABLE RELATE TO "PRODUCT" --
CREATE TABLE categories (
	cateID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateName		NVARCHAR(255)	NOT NULL		UNIQUE,
	cateNameNA		NVARCHAR(255)	NOT NULL
)

GO

CREATE TABLE subCategories (
	subCateID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateID				INT				FOREIGN KEY		REFERENCES categories(cateID),
	subCateName			NVARCHAR(255)	NOT NULL,
	subCateNameNA		NVARCHAR(500)	NOT NULL		--NA: Non-Accent
)

--test chức năng utf-8
GO

CREATE TABLE products (
	productID			INT				PRIMARY KEY		IDENTITY(1,1),
	cateID				INT				FOREIGN KEY		REFERENCES categories(cateID),
	subCateID			INT				FOREIGN KEY		REFERENCES subCategories(subCateID),
	productName			NVARCHAR(255)	NOT NULL,
	productNameNA		NVARCHAR(255)	NOT NULL,		--NA: Non-Accent
	price				FLOAT			NOT NULL,
	urlImg				NVARCHAR(255)	NOT NULL,
	productDescription	TEXT,
	productDiscount		TINYINT			DEFAULT 0,
	postedDate			DATE			DEFAULT getDate(),	
	productViews		INT				DEFAULT 0,
	[status]			TINYINT			DEFAULT 1		
)

GO

CREATE TABLE productColors (
	colorID				INT				PRIMARY KEY		IDENTITY(1,1),
	productID			INT				FOREIGN KEY		REFERENCES products(productID),
	color				NVARCHAR(255)	NOT NULL,
	colorNA				NVARCHAR(255)	NOT NULL,
	urlColorImg			NVARCHAR(255)	NOT NULL,
	colorOrder			INT				NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO
CREATE TABLE sizesByColor (
	sizeID				INT				PRIMARY KEY		IDENTITY(1,1),
	colorID				INT				FOREIGN KEY		REFERENCES productColors(colorID),
	size				NVARCHAR(255)	NOT NULL,
	quantity			INT				NOT NULL,
	sizeOrder			INT				NOT NULL,
	[status]			TINYINT			DEFAULT 1
)

GO

CREATE TABLE productSubImgs (
	subImgID		INT				PRIMARY KEY		IDENTITY(1,1),
	colorID			INT				FOREIGN KEY		REFERENCES productColors(colorID),
	urlImg			NVARCHAR(255)	NOT NULL,
	subImgOrder		INT				NOT NULL
)

GO

CREATE TABLE productRating (
	ratingID	INT				PRIMARY KEY		IDENTITY(1,1),
	productID	INT				FOREIGN KEY		REFERENCES products(productID),
	userID		INT				FOREIGN KEY		REFERENCES users(userID),
	rating		INT				NOT NULL,
	ratingDate	DATE			DEFAULT getDate(),
	review		TEXT,
	[status]	TINYINT			DEFAULT 0 -- 0: NOT VERIFIED, 1: VERIFIED 
)

GO

-- Table "ORDERS" -- 

CREATE TABLE discountVoucher(
	voucherID			NVARCHAR(50)		PRIMARY KEY,
	discount			TINYINT				NOT NULL,
	quantity			INT					NOT NULL,
	beginDate			DATE,
	endDate				DATE,
	[description]		TEXT
)

GO

CREATE TABLE orders (
	ordersID			INT				PRIMARY KEY		IDENTITY(1,1),
	userID				INT				FOREIGN KEY		REFERENCES users(userID),
	ordersDate			DATETIME		DEFAULT getDate(),
	receiverFirstName	NVARCHAR(100)	NOT NULL,
	receiverLastName	NVARCHAR(50)	NOT NULL,
	phoneNumber			NVARCHAR(20)	NOT NULL,
	deliveryAddress		NVARCHAR(100)	NOT NULL,
	voucherID			NVARCHAR(50)	FOREIGN KEY		REFERENCES discountVoucher(voucherID)	NULL,
	note				TEXT,
	[status]			TINYINT			-- 1: completed; 2: Pending; 3: Confirmed; 0: Cancelled
)

GO

CREATE TABLE ordersDetail (
	ordersDetailID		INT		PRIMARY KEY		IDENTITY(1,1),
	ordersID			INT		FOREIGN KEY		REFERENCES orders(ordersID),
	productID			INT		FOREIGN KEY		REFERENCES products(productID),
	sizeID				INT		FOREIGN KEY		REFERENCES sizesByColor(sizeID),
	productDiscount		TINYINT	NOT NULL,
	quantity			INT		NOT NULL,
	price				FLOAT	NOT NULL,
	[status]			TINYINT					--0: not change; 1: old; 2: new
)

GO

-- TABLE "WISHLIST"--
CREATE TABLE wishList(
	wishID		INT		PRIMARY KEY		IDENTITY(1,1),
	userID		INT		FOREIGN KEY		REFERENCES users(userID),
	productID	INT		FOREIGN KEY		REFERENCES products(productID),
	createDate	DATE					DEFAULT getDate()
)

GO

-- TABLE "BLOG" --
CREATE TABLE blogCategories (
	blogCateID		INT				PRIMARY KEY		IDENTITY(1,1),
	blogCateName	NVARCHAR(255)	NOT NULL,
	blogCateNameNA	NVARCHAR(255)	NOT NULL
)

GO

CREATE TABLE blogs( 
	blogID			INT				PRIMARY KEY		IDENTITY(1,1),
	blogCateID		INT				FOREIGN KEY		REFERENCES blogCategories(blogCateID),
	userID			INT				FOREIGN KEY		REFERENCES users(userID),
	blogTitle		NVARCHAR(255)	NOT NULL,
	blogTitleNA		NVARCHAR(255)	NOT NULL,
	blogSummary		NVARCHAR(500)	NOT NULL,
	blogImg			NVARCHAR(255)	NOT NULL,
	postedDate		DATE			DEFAULT getDate(),	
	content			TEXT,
	blogViews		INT				DEFAULT 0,
	[status]		TINYINT			DEFAULT 1
)

GO
SET IDENTITY_INSERT [dbo].[roles] ON 

GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (1, N'Admin')
GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (2, N'Moderator')
GO
INSERT [dbo].[roles] ([roleID], [roleName]) VALUES (3, N'User')
GO
SET IDENTITY_INSERT [dbo].[roles] OFF
GO

INSERT functions(functionName) VALUES 
('Users'), 
('User Roles'),
('Products'),
('Product Categories'),
('Product Subcategories'),
('Orders'),
('Discounts'),
('Comments'),
('Blog Categories'),
('Blogs')
GO

INSERT permissions VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),
(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10)
GO

SET IDENTITY_INSERT [dbo].[users] ON 

GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (1, 1, N'admin@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Hoang', N'Nguyen', N'default_user.jpg', 1, CAST(N'1984-04-13' AS Date), CAST(N'2017-04-27' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (2, 2, N'product@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Duy', N'Le', N'default_user.jpg', 0, CAST(N'1998-01-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (3, 2, N'orders@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Mai', N'Pham', N'default_user.jpg', 1, CAST(N'1995-04-07' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (4, 2, N'blogs@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Thanh', N'Nhan', N'default_user.jpg', 1, CAST(N'1996-05-08' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (5, 3, N'laurel@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Laurel', N'Lance', N'default_user.jpg', 0, CAST(N'1982-09-13' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (6, 3, N'queen@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Oliver', N'Queen', N'default_user.jpg', 1, CAST(N'1980-12-08' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (7, 3, N'ba@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Barry', N'Allen', N'default_user.jpg', 1, CAST(N'1984-01-05' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (8, 3, N'bruce@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Bruce', N'Wayne', N'default_user.jpg', 1, CAST(N'1980-02-03' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (9, 3, N'luke@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Luke', N'Cage', N'default_user.jpg', 1, CAST(N'1970-04-09' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (10, 3, N'clark@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Clark', N'Kent', N'default_user.jpg', 1, CAST(N'1978-03-04' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (11, 3, N'thea@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Thea', N'Queen', N'default_user.jpg', 0, CAST(N'1990-05-17' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (12, 3, N'hal@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Hal', N'Jordan', N'default_user.jpg', 1, CAST(N'1976-05-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (13, 3, N'tim@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Tim', N'Drake', N'default_user.jpg', 1, CAST(N'1985-03-27' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (14, 3, N'lex@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Lex', N'Luthor', N'default_user.jpg', 1, CAST(N'1972-06-12' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (15, 3, N'peter@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Peter', N'Parker', N'default_user.jpg', 1, CAST(N'1989-07-14' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (16, 3, N'steve@mail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Steve', N'Roger', N'default_user.jpg', 1, CAST(N'1980-08-28' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
INSERT [dbo].[users] ([userID], [roleID], [email], [password], [firstName], [lastName], [avatar], [gender], [birthday], [registrationDate], [status]) VALUES (17, 3, N'tony@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Tony', N'Stark', N'default_user.jpg', 1, CAST(N'1980-03-04' AS Date), CAST(N'2017-04-29' AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET IDENTITY_INSERT [dbo].[userAddresses] ON 

GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (1, 5, N'District 1, Ho Chi Minh City', N'0168726543')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (2, 6, N'Thu Duc District, Ho Chi Minh City', N'0918727328')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (3, 7, N'District 8, Ho Chi Minh City', N'0967827631')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (4, 9, N'District 5, Ho Chi Minh City', N'0987264813')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (5, 10, N'Tan Binh District, Ho Chi Minh City', N'0128736817')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (6, 8, N'District 3, Ho Chi Minh City', N'0188726813')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (7, 13, N'District 4, Ho Chi Minh City', N'0935124897')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (8, 16, N'District 3, Ho Chi Minh City', N'0951235487')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (9, 17, N'District 2, Ho Chi Minh City', N'0963548425')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (10, 14, N'District 7, Ho Chi Minh City', N'0122458725')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (11, 14, N'179/12 Su Van Hanh , P.13 , District 10 , Ho Chi Minh City', N'0988766567')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (12, 14, N'200/12 Au Co , P.Hoa Thanh , District Tan Phu , Ho Chi Minh City', N'01220888789')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (13, 14, N'201 De Tham , P.Cau Ong Lanh , District 1 , Ho Chi Minh City', N'0906723423')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (14, 14, N'787 Luy Ban Bich , P.Tan Thanh , District Tan Phu , Ho Chi Minh City', N'01234480888')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (15, 10, N'35 Truong Dinh , P.6, District 3 , Ho Chi Minh City', N'0903758002')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (16, 10, N'101/1 Nguyen Phi Khanh, P.Tan Dinh , District 1 , Ho Chi Minh City', N'0903650432')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (17, 10, N'21/15/8 Truong Son, P.4 ,  District Tan Binh, Ho Chi Minh City', N'0983807880')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (18, 10, N'72 Nguyen Minh Hoang, P.12 , District Tan Binh, Ho Chi Minh City', N'0983080818')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (19, 17, N'202 Pasteur , District 3 , Ho Chi Minh City', N'0914770545')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (20, 17, N'172C Nguyen Dinh Chieu, P.6 , District 3 , Ho Chi Minh City', N'0944545232')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (21, 17, N'11 Tu Xuong, District 3 , Ho Chi Minh City', N'01668890843')
GO
INSERT [dbo].[userAddresses] ([addressID], [userID], [address], [phoneNumber]) VALUES (22, 17, N'44 Ngo Duc Ke, District 1 , Ho Chi Minh City', N'0962089926')
GO
SET IDENTITY_INSERT [dbo].[userAddresses] OFF
GO


--INSERT CATEGORIES
SET IDENTITY_INSERT [dbo].[categories] ON 
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (1, N'Tops', N'tops')
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (2, N'Pants', N'pants')
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (3, N'Dresses', N'dresses')
INSERT [dbo].[categories] ([cateID], [cateName], [cateNameNA]) VALUES (4, N'Shoes', N'shoes')
SET IDENTITY_INSERT [dbo].[categories] OFF
GO

--INSERT SUBCATEGORIES
SET IDENTITY_INSERT [dbo].[subCategories] ON 
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (1, 1, N'Shirts', N'shirts')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (2, 1, N'T-Shirts', N't-shirts')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (3, 1, N'Coats', N'coats')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (4, 1, N'Sweaters', N'sweaters')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (5, 3, N'Dresses', N'dresses')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (6, 1, N'Jackets', N'jackets')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (7, 1, N'Knitwears', N'knitwears')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (8, 3, N'Jumpsuits', N'jumpsuits')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (9, 4, N'Mules', N'mules')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (10, 4, N'Boots', N'boots')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (12, 4, N'Heels', N'heels')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (13, 2, N'Skirts', N'skirts')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (14, 2, N'Shorts', N'shorts')
INSERT [dbo].[subCategories] ([subCateID], [cateID], [subCateName], [subCateNameNA]) VALUES (15, 2, N'Trousers ', N'trousers')
SET IDENTITY_INSERT [dbo].[subCategories] OFF
GO

--INSERT PRODUCTS
SET IDENTITY_INSERT [dbo].[products] ON 
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (1, 1, 3, N'Denim Jacket', N'denim-jacket', 34.9900016784668, N'20170704_00_34_22white-denim-(3).jpg', N'<p>Jacket in washed denim with metal buttons. Collar, buttons at front, chest pockets with flap and button, and welt side pockets. Buttons at cuffs and adjustable tab with button at sides.</p>
', 0, CAST(N'2017-06-17' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (2, 1, 3, N'Denim Jacket with Lacing', N'denim-jacket-with-lacing', 69.989997863769531, N'20170617_17_06_57denim-jacket-with-lacing.jpg', N'<p>Short, wide-cut denim jacket with a collar and buttons at front. Chest pockets with flap and button, welt side pockets, and adjustable tabs with button at back of hem and at cuffs. Seam with lacing at back and along sleeves.</p>
', 0, CAST(N'2017-06-17' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (3, 3, 5, N'Off-the-shoulder Dress', N'off-the-shoulder-dress', 29.989999771118164, N'20170617_17_44_44hmprod.jpg', N'<p>CONSCIOUS. Short, off-the-shoulder dress in airy, woven fabric with narrow, adjustable shoulder straps. Elastication at top with silicone trim inside upper edge. Long sleeves with drawstring at elbows and narrow elastication at cuffs. Smocking at waist and flared skirt. Lined. Made partly from recycled polyester.</p>
', 0, CAST(N'2017-06-17' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (4, 3, 5, N'Dress with Smocking', N'dress-with-smocking', 24.989999771118164, N'20170617_17_55_02hmprod-(1).jpg', N'<p>Short, off-the-shoulder dress in crinkled, woven viscose with smocking at top. Short sleeves, seam at waist, and gently flared, lined skirt.</p>
', 0, CAST(N'2017-06-17' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (5, 1, 3, N'Trashed Denim Jacket', N'trashed-denim-jacket', 49.9900016784668, N'20170617_18_07_29hmprod-(11).jpg', N'<p>Jacket in washed denim with heavily distressed details. Side pockets, chest pockets with flap and button, and cut-off hem with raw edges.</p>
', 0, CAST(N'2017-06-17' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (6, 1, 2, N'Short T-Shirt', N'short-t-shirt', 6.9899997711181641, N'20170618_01_09_02hmprod-(1).jpg', N'<p>Short T-shirt in cotton jersey with a printed design and cut-off, raw-edge hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (7, 1, 1, N'Short Top', N'short-top', 14.989999771118164, N'20170618_01_55_1801.jpg', N'<p>Short top in cr&ecirc;ped jersey with a V-neck and attached wrapover at front. Short butterfly sleeves, cut-out section at back, and wide ties at hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (8, 1, 1, N'Wrap Camisole Top', N'wrap-camisole-top', 4.9899997711181641, N'20170618_02_03_09hmprod-(3).jpg', N'<p>Short top in soft jersey with narrow shoulder straps and attached wrapover. Lined at front.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (9, 3, 5, N'Cotton poplin dress', N'cotton-poplin-dress', 55.9900016784668, N'20170618_02_10_31hmprod-(3).jpg', N'<p>Calf-length dress in cotton poplin with shoulder straps and a seam at the waist. Flared skirt with pleats and tiers to the hem. Pockets in the side seams and a concealed zip in one side. Lined at the top.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (10, 3, 5, N'Pleated tiered dress', N'pleated-tiered-dress', 75.989997863769531, N'20170618_02_26_22hmprod-(12).jpg', N'<p>Calf-length dress in woven fabric. Deep V-neck with a pleated frill front and back and a tie and concealed zip at the back. Seam at the waist and a flared skirt in several tiers of pleated flounces. Unlined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (11, 3, 5, N'Satin dress', N'satin-dress', 49.9900016784668, N'20170618_02_34_53g-(2).jpg', N'<p>Knee-length satin dress with flounce details, a V-neck, narrow shoulder straps, short sleeves and a zip in the side. Unlined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (12, 3, 5, N'Sleeveless satin dress', N'sleeveless-satin-dress', 49.9900016784668, N'20170618_02_42_281.jpg', N'<p>Sleeveless satin dress with a hook-and-eye fastener at the back of the neck, opening at the back and a seam at the hips with a gently flared skirt. Lined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (13, 3, 5, N'Off-the-shoulder dress ', N'off-the-shoulder-dress-', 29.989999771118164, N'20170618_02_49_57hmprod.jpg', N'<p>Short, straight-cut off-the-shoulder dress in sturdy jersey with elastication and a wide flounce at the top and pockets in the side seams. Unlined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (14, 3, 5, N'Lyocell-blend dress', N'lyocell-blend-dress', 49.9900016784668, N'20170618_02_54_091.jpg', N'<p>Calf-length dress in a Tencel&reg; lyocell and cotton weave that is fitted at the top with wide, tie-top shoulder straps. Concealed zip in the side, seam at the waist and flared skirt. Unlined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (15, 1, 1, N'Flounced top', N'flounced-top', 34.9900016784668, N'20170618_02_57_55hmprod-(2).jpg', N'<p>Top in woven fabric with wide straps that tie at the shoulders, a concealed zip in the side and a wide flounce at the hem. Lined.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (16, 1, 1, N'Shirt with ties', N'shirt-with-ties', 44.9900016784668, N'20170618_03_00_36hmprod-(6).jpg', N'<p>Straight-cut shirt in woven fabric with long sleeves that are open on top and held together by ties. Collar, buttons down the front, yoke with a pleat at the back and cuffs with concealed buttons. Rounded hem, longer at the back.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (17, 1, 1, N'Off-the-shoulder Blouse', N'off-the-shoulder-blouse', 29.989999771118164, N'20170618_03_06_28hmprod-(4).jpg', N'<p>Off-the-shoulder blouse in woven cotton fabric with wide elastication at back. Buttons at front, opening at top with wide tie, and long, cuffed sleeves.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (18, 1, 1, N'Wide-cut Blouse', N'wide-cut-blouse', 24.989999771118164, N'20170618_03_10_38hmprod-(1).jpg', N'<p>Short, wide-cut blouse in soft woven fabric. Collar, buttons at front, gathers on shoulders, and cap sleeves. Round-cut hem with trim.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (19, 1, 1, N'Drawstring Top', N'drawstring-top', 34.9900016784668, N'20170618_03_14_39hmprod-(6).jpg', N'<p>Top in airy woven fabric with embroidery. Narrow elastication at upper edge, ruffles on shoulder straps and at sides, and drawstring hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (20, 1, 1, N'Oversize Shirt', N'oversize-shirt', 27.989999771118164, N'20170618_03_18_49hmprod-(2).jpg', N'<h1>Oversized shirt in a cotton weave with embroidery, low dropped shoulders and long sleeves with buttoned cuffs.</h1>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (21, 1, 4, N' Printed sweatshirt', N'-printed-sweatshirt', 16.989999771118164, N'20170618_03_26_40hmprod-(9).jpg', N'<p>Printed top in light cotton sweatshirt fabric with ribbing around the neckline, cuffs and hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (22, 1, 4, N'Knitted jumper', N'knitted-jumper', 18.989999771118164, N'20170618_03_32_24hmprod-(13).jpg', N'<p>Knitted V-neck jumper in soft yarn with long sleeves and gently rolled edges.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (23, 1, 4, N'Ribbed Cardigan', N'ribbed-cardigan', 29.989999771118164, N'20170618_14_21_18hmprod-(12).jpg', N'<p>Longer cardigan in a soft rib knit with dropped shoulders, no buttons, and front pockets, Slits at sides.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (24, 1, 4, N'Ribbed Cardigan ', N'ribbed-cardigan-', 34.9900016784668, N'20170618_14_26_16hmprod-(2).jpg', N'<p>Ribbed cardigan in a soft cotton blend. Zip at front, side pockets, and ribbing at neckline, cuffs, and hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (25, 1, 4, N'Hooded SweatshirtCardigan', N'hooded-sweatshirtcardigan', 49.9900016784668, N'20170618_14_37_07hmprod-(2).jpg', N'<p>Cardigan in sweatshirt fabric with a lined hood, diagonal front zip, and side pockets. Ribbing at cuffs and raw edges at hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (26, 1, 4, N'Sweatshirt Cardigan', N'sweatshirt-cardigan', 39.9900016784668, N'20170618_14_43_00hmprod.jpg', N'<p>Cardigan in sweatshirt fabric with a hood, side pockets, and raw edges. No fasteners.</p>
', 0, CAST(N'2017-06-18' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (27, 1, 6, N'Hooded Jacket', N'hooded-jacket', 24.989999771118164, N'20170618_14_54_42hmprod-(3).jpg', N'<p>Sweatshirt jacket with a lined drawstring hood. Zip at front, side pockets, and ribbing at cuffs and hem.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (28, 1, 6, N'Hooded Jacket ', N'hooded-jacket-', 19.989999771118164, N'20170618_15_14_14hmprod-(2).jpg', N'<p>Sweatshirt jacket with a lined drawstring hood, zip at front, side pockets, and ribbing at cuffs and hem. Soft, brushed inside.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (29, 1, 6, N'Hooded Sweatshirt Jacket', N'hooded-sweatshirt-jacket', 19.989999771118164, N'20170618_15_17_37hmprod.jpg', N'<p>Sweatshirt jacket with a lined drawstring hood. Zip at front, side pockets, and ribbing at cuffs and hem. Soft, brushed inside.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (30, 1, 6, N'Sweatshirt Jacket', N'sweatshirt-jacket', 12.989999771118164, N'20170618_15_22_34hmprod-(3).jpg', N'<p>Jacket in soft sweatshirt fabric with a zip and diagonal pockets at front and ribbing at neckline, cuffs, and hem. Soft, brushed inside.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (31, 1, 2, N'Top  ', N'top--', 49.9900016784668, N'20170618_15_27_25hmprod-(1).jpg', N'<p>Slightly shorter, wide-cut top in sweatshirt fabric with a ribbed stand-up collar and extra-long sleeves with a ribbed seam and flared cuffs.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (32, 1, 7, N'Knit Sweater', N'knit-sweater', 24.989999771118164, N'20170618_15_38_29hmprod-(3).jpg', N'<p>CONSCIOUS. Wide-cut sweater in a soft, fine knit with wool content. Dropped shoulders and wide ribbing at neckline, cuffs, and hem. Polyester content is recycled.</p>
', 10, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (33, 1, 7, N'Sweater with Shirt Collar', N'sweater-with-shirt-collar', 34.9900016784668, N'20170618_15_48_41hmprod-(9).jpg', N'<p>CONSCIOUS. Soft, fine-knit sweater with wool content. Attached shirt collar at top and shirt tail extending below hem, both in woven fabric. Long sleeves, ribbing at neckline, cuffs, and hem and slits at sides. Polyester content of sweater is recycled.</p>
', 0, CAST(N'2017-06-18' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (34, 1, 2, N'Tie Tank Top', N'tie-tank-top', 12.989999771118164, N'20170623_15_32_09hmprod-(1).jpg', N'<p>Short tank top in cotton jersey with a tie at hem and raw-edge armholes.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (35, 1, 2, N'Tank Top withPrintedMotif', N'tank-top-withprintedmotif', 9.9899997711181641, N'20170623_15_36_37hmprod-(5).jpg', N'<p>Wide-cut tank top in soft viscose slub jersey with a printed motif. Deep armholes, racer back, and rounded hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (36, 1, 2, N'T-shirt with Printed Text', N't-shirt-with-printed-text', 9.9899997711181641, N'20170623_15_39_50hmprod-(1).jpg', N'<p>T-shirt in soft, stretch viscose jersey with a printed text design at front.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (37, 1, 2, N'T-shirt withPrintedDesign', N't-shirt-withprinteddesign', 14.989999771118164, N'20170623_15_41_56hmprod-(3).jpg', N'<p>T-shirt in cotton jersey with a printed design.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (38, 1, 2, N'T-shirt with Motif', N't-shirt-with-motif', 17.989999771118164, N'20170623_15_45_19hmprod-(2).jpg', N'<p>&nbsp;</p>

<p>Short-sleeved T-shirt in soft, washed cotton jersey with a motif at front.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (39, 1, 2, N'T-Shirt W Printed Design2', N't-shirt-w-printed-design2', 17.989999771118164, N'20170623_15_52_12hmprod-(6).jpg', N'<p>&nbsp;</p>

<p>T-shirt in soft jersey with a printed design at front.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (40, 1, 2, N'Jersey Camisole Top', N'jersey-camisole-top', 9.9899997711181641, N'20170623_15_59_05hmprod-(3).jpg', N'<p>Camisole top in soft viscose jersey with a V-neck and narrow shoulder straps.</p>
', 30, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (41, 1, 3, N'Trenchcoat', N'trenchcoat', 59.9900016784668, N'20170704_00_26_52hmprod.jpg', N'<h1>Trenchcoat in soft, lightweight woven fabric. Wide collar, draped lapels, semi-attached yoke at back, and belt at waist with metal fastener. Long sleeves, side-seam pockets, and back vent. Unlined.</h1>
', 30, CAST(N'2017-06-23' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (42, 1, 3, N'Long Jacket', N'long-jacket', 49.9900016784668, N'20170623_16_34_36a.jpg', N'<p>Longer, straight-cut jacket in soft, woven fabric with narrow lapels and no buttons. Unlined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (43, 1, 3, N'Long Jacket ', N'long-jacket-', 49.9900016784668, N'20170623_16_39_33a.jpg', N'<p>Longer style jacket in woven fabric. Button at front, front pockets with flap, and long sleeves with gathers at cuffs. Vent at back. Lined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (44, 1, 1, N'Double-layerChiffonBlouse', N'double-layerchiffonblouse', 34.9900016784668, N'20170623_16_51_42a.jpg', N'<h1>Straight-cut blouse in double-layer crinkled chiffon with a small ruffled collar and decorative ruffles at top, cuffs, and hem. Opening at back of neck with button. 3/4-length sleeves.</h1>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (45, 1, 1, N'Embroidered Cotton Blouse', N'embroidered-cotton-blouse', 49.9900016784668, N'20170623_16_54_37a.jpg', N'<p>&nbsp;</p>

<p>Straight-cut blouse in airy, woven cotton fabric with eyelet embroidery. Small stand-up collar and concealed buttons at front, ruffles at front and back, and long sleeves with wide, flared cuffs with scalloped edges</p>
', 30, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (46, 1, 1, N'Embroidered HalterneckTop', N'embroidered-halternecktop', 39.9900016784668, N'20170623_16_57_34a.jpg', N'<p>Short halterneck top in woven cotton fabric with eyelet embroidery. Ruffles at top and wide ties at back and at back of neck. Lined</p>
', 30, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (47, 1, 1, N'Off-the-shoulder Blouse ', N'off-the-shoulder-blouse-', 49.9900016784668, N'20170623_17_02_08aaa.jpg', N'<p>Off-the-shoulder blouse in woven cotton fabric with buttons at front. Narrow shoulder straps, ruffle at top, and long sleeves with buttons at cuffs.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (48, 1, 1, N'Short Ruffled Top', N'short-ruffled-top', 39.9900016784668, N'20170623_17_04_07a.jpg', N'<p>Short top in woven viscose fabric with a sheen. V-neck at front, narrow shoulder straps, seam below bust with two ruffles, and fastening at back. Lined at top.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (49, 3, 5, N'Knee-length Dress', N'knee-length-dress', 69.989997863769531, N'20170623_17_06_59a.jpg', N'<p>Knee-length dress in dotted chiffon. V-neck at front, narrow, adjustable shoulder straps, and smocked seam at waist. Flared skirt with ruffle and decorative smocking. Jersey lining.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (50, 1, 2, N'Top with Lacing', N'top-with-lacing', 17.989999771118164, N'20170623_17_12_20a.jpg', N'<p>Short-sleeved top in cotton jersey with dropped shoulders and lacing at sides.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (51, 1, 1, N'Tie-front Viscose Blouse', N'tie-front-viscose-blouse', 17.989999771118164, N'20170623_17_14_43a.jpg', N'<p>Short blouse in airy, woven viscose fabric. Notch lapels, buttons at front, short sleeves, and yoke at back. Ties at hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (52, 3, 5, N'Glittery Dress', N'glittery-dress', 49.9900016784668, N'20170623_17_17_34a.jpg', N'<p>Fine-knit, calf-length dress with glittery threads. Narrow shoulder straps, V-neck at front and back, and flared skirt with a heavy drape. Jersey lining to knees</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (53, 3, 5, N'Ruffled Dress', N'ruffled-dress', 59.9900016784668, N'20170623_17_20_37a.jpg', N'<p>Knee-length dress in woven fabric with a printed pattern. Gently shaped V-neck at front and ruffle at top and on shoulder straps. Seam at waist with cut-out section and tie at back. Gently flared skirt and concealed side zip. Lined at top.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (54, 3, 5, N'Dress', N'dress', 34.9900016784668, N'20170623_17_23_20hmprod-(2).jpg', N'<p>Short, flared dress in woven fabric with hemstitching. Narrow, adjustable shoulder straps, V-neck at front, and low-cut V-neck at back with lacing. Unlined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 0)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (55, 3, 5, N'Dress ', N'dress-', 34.9900016784668, N'20170623_17_25_02a.jpg', N'<p>Short, flared dress in woven fabric with hemstitching. Narrow, adjustable shoulder straps, V-neck at front, and low-cut V-neck at back with lacing. Unlined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (56, 1, 6, N'Hooded Mesh Top', N'hooded-mesh-top', 24.989999771118164, N'20170623_17_27_42a.jpg', N'<p>Oversized top in thick mesh with a drawstring hood. Heavily dropped shoulders, long sleeves, and ribbing at cuffs and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (57, 1, 3, N'Oversized Denim Jacket', N'oversized-denim-jacket', 34.9900016784668, N'20170623_17_29_57a.jpg', N'<p>Oversized jacket in washed denim with a collar. Dropped shoulders, metal buttons at front and at cuffs, and adjustable tab and button at sides. Chest pockets with flap and metal button and welt side pockets.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (58, 1, 3, N'Shimmering Metallic Parka', N'shimmering-metallic-parka', 34.9900016784668, N'20170623_17_32_54a.jpg', N'<p>Parka in woven fabric with a shimmering metallic finish. Lined drawstring hood, zip at front, and patch pockets. Lined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (59, 1, 2, N'Short Wrapover Sweater', N'short-wrapover-sweater', 36, N'20170623_17_37_15a.jpg', N'<p>Short sweater in a thick, viscose-blend rib knit with a V-neck, wrapover front, and long sleeves.</p>
', 30, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (60, 1, 7, N'Knit Sweater w Embroidery', N'knit-sweater-w-embroidery', 49.9900016784668, N'20170623_17_39_17a.jpg', N'<p>Slightly shorter sweater knit in a viscose blend with wool content. Embroidered appliqu&eacute;s and beads. Ribbing at neckline, cuffs, and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (61, 1, 7, N'Knit Wrapover Sweater', N'knit-wrapover-sweater', 49.9900016784668, N'20170623_17_40_45a.jpg', N'<p>Loose-knit sweater in a soft viscose blend with glittery threads. Attached wrapover front section, tie at side, and wide ribbing at cuffs and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (62, 1, 7, N'Ribbed Top', N'ribbed-top', 17.989999771118164, N'20170623_17_42_25a.jpg', N'<p>Top in a soft, fine rib knit with long sleeves and a low-cut back with a twisted detail.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (63, 1, 7, N'Rib-knit Sweater', N'rib-knit-sweater', 17.989999771118164, N'20170623_17_47_47a.jpg', N'<p>Sweater in a soft rib knit with a slight sheen. Open back, long dolman sleeves, and ribbing at cuffs and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (64, 1, 6, N'Bomber Jacket', N'bomber-jacket', 34.9900016784668, N'20170623_17_54_05a.jpg', N'<p>Bomber jacket in airy satin fabric. Zip at front, side pockets, and drawstring at hem. Ribbing at collar, cuffs, and hem. Unlined.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (65, 1, 7, N'Glittery Camisole Top', N'glittery-camisole-top', 24.989999771118164, N'20170623_17_56_50a.jpg', N'<p>V-neck camisole top in stretch jersey with glittery threads. Narrow shoulder straps.</p>
', 10, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (66, 1, 7, N'Fine-knit Ruffled Top', N'fine-knit-ruffled-top', 24.989999771118164, N'20170623_18_02_08a.jpg', N'<p>Ribbed fine-knit top in a soft viscose blend with a small, ribbed stand-up collar. Narrow-cut at top with ruffles around armholes.</p>
', 30, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (67, 1, 7, N'Fine-knit Top', N'fine-knit-top', 24.989999771118164, N'20170623_18_04_21a.jpg', N'<p>Fine-knit top in a soft viscose blend. Short sleeves, open section at front of hem, and ribbing at neckline, cuffs, and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (68, 1, 7, N'Ribbed Cardigan  ', N'ribbed-cardigan--', 34.9900016784668, N'20170623_18_06_32a.jpg', N'<p>Ribbed cardigan in a soft cotton blend. Zip at front, side pockets, and ribbing at neckline, cuffs, and hem.</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (69, 3, 5, N'BLUE STRIPE DRESS', N'blue-stripe-dress', 49.9900016784668, N'20170623_18_17_31a.jpg', N'<p>BLUE STRIPE DRESS&nbsp;<br />
:: Printed fabric dress with ruffled straps and square neck.&nbsp;<br />
:: Lace embroidered on the rim dress.&nbsp;<br />
:: Zipper fastening in the back.&nbsp;<br />
100%COTTON&nbsp;<br />
Hand wash cold&nbsp;<br />
Model is wearing size S</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (70, 3, 5, N'STRIPED WITH RUFFLES ', N'striped-with-ruffles-', 49.9900016784668, N'20170623_18_20_47gj17sdr113-2.jpg', N'<p>&nbsp;Classic stripes and sweet ruffles.&nbsp;<br />
:: Off-the-shoulder neckline.&nbsp;<br />
:: 100% Polyester&nbsp;<br />
:: Hand wash&nbsp;<br />
HEIGHT OF MODEL: 177 cm. / Size S</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (71, 3, 5, N'MULTI-GREEN DRESS', N'multi-green-dress', 49.9900016784668, N'20170623_18_23_41gj17sdr214-1.jpg', N'<p>MULTI-GREEN DRESS&nbsp;<br />
:: Off-shoulder mini dress with multi-green detail and oversized short sleeves.&nbsp;<br />
:: Zipper fastening in the back.&nbsp;<br />
100 % POLYESTER&nbsp;<br />
Hand wash cold&nbsp;<br />
Model is wearing size S</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (72, 3, 5, N'FLORAL PRINTED MIDI DRESS', N'floral-printed-midi-dress', 39.9900016784668, N'20170623_18_29_10gj17sdr034_3_.jpg', N'<p>:: Midi dress with floral print.&nbsp;<br />
:: Printed woven chiffon.&nbsp;<br />
:: V- neck and long sleeves with stretch cuffs.&nbsp;<br />
:: 100% Polyester&nbsp;<br />
:: Machine washable.&nbsp;<br />
HEIGHT OF MODEL: 178 cm. / Size S</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (73, 1, 1, N'WnB FLORAL PULLOVER', N'wnb-floral-pullover', 29.989999771118164, N'20170623_18_33_47gj17spu067-1_1.jpeg', N'<p>WHITE-BLACK FLORAL PULLOVER&nbsp;<br />
:: Printed fabric in pullover design with round neck and 3/4 length sleeves.&nbsp;<br />
90%POLYESTER 10%SPANDEX&nbsp;<br />
Hand wash cold&nbsp;<br />
Model is wearing size S</p>
', 0, CAST(N'2017-06-23' AS Date), 0, 0)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (74, 1, 2, N'Top    ', N'top----', 39.9900016784668, N'20170627_15_44_11a.jpg', N'<p>Short top in a soft, fine knit with glittery threads. Shoulder straps and double flounce at upper edge.</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (75, 1, 7, N'Light beige', N'light-beige', 29.989999771118164, N'20170627_15_48_49a.jpg', N'<h4>DESCRIPTION</h4>

<p>Fitted top in thick rib-knit fabric with a slight sheen. V-neck and loose-knit sections at front and back.</p>

<h4>DETAILS</h4>

<p>65% rayon, 35% nylon.&nbsp;Machine wash cold</p>

<p>Imported</p>

<p>Art.No.&nbsp;77-6265</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (76, 3, 5, N'Dress with Ruffled Sleeves', N'dress-with-ruffled-sleeves', 29.989999771118164, N'20170627_15_55_03a.jpg', N'<h4>DESCRIPTION</h4>

<p>Knee-length dress in soft woven fabric. Opening at back of neck with button. Short, ruffled sleeves, seam at waist, and flared skirt. Lined.</p>

<h4>DETAILS</h4>

<p>100% polyester.</p>

<p>Imported</p>

<p>&nbsp;</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (77, 3, 5, N'ONE SHOULDER CROP TOP', N'one-shoulder-crop-top', 61, N'20170627_15_59_05c17wfta069__3_.jpg', N'<p>Bow detail See-through fabric with lining One shoulder strap Matching item available</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (78, 3, 5, N'LACE DRESS', N'lace-dress', 70, N'20170627_22_07_40c16wfdd054_3_.jpg', N'<h2>100%COTTON<br />
SLEEVELESS&nbsp;<br />
RUFFLE FRONT &amp; NECK &amp; SLEEVE TRIMMED<br />
BACK ZIP OPENING</h2>
', 30, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (79, 3, 5, N'POLKA DOT DRESS', N'polka-dot-dress', 39.9900016784668, N'20170627_22_41_55c17sfde045_1__1.jpg', N'<h2>Description</h2>

<h2>&nbsp;</h2>

<p>Round neckline<br />
Over knee length<br />
Double flounce sleeves</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (80, 3, 5, N'TWO-TONE DRESS', N'two-tone-dress', 42.9900016784668, N'20170627_22_43_50c17sfde061_1_.jpg', N'<p>&nbsp;</p>

<p>V-neckline<br />
Camisole strap<br />
Short sleeves<br />
Under layer<br />
Asymmetrical trail<br />
Front &amp; back slits</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (81, 3, 5, N'PUFF SLEEVES DRESS', N'puff-sleeves-dress', 45.9900016784668, N'20170627_22_47_09c17sfde039_1__1.jpg', N'<p>Round neckline<br />
Over knee length</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (82, 1, 1, N'LONG SLEEVE RUFFLE BLOUSE', N'long-sleeve-ruffle-blouse', 60.9900016784668, N'20170627_22_51_06c17wfba072__2_.jpg', N'<p>Metallic mateiral Ruffle detail Long sleeve Button detail on back</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (83, 1, 1, N'BELL SLEEVES BLOUSE', N'bell-sleeves-blouse', 18.989999771118164, N'20170627_22_53_53c17sfte026_1_.jpg', N'<p>Round neckline blouse<br />
Long bell sleeves</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (84, 1, 1, N'TWO-TONE BOW-TIE ', N'two-tone-bow-tie-', 49.9900016784668, N'20170627_23_15_56c17sfte021_4_.jpg', N'<p>Round neckline blouse<br />
Short sleeves<br />
Bow-tie waist</p>
', 30, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (85, 1, 4, N'Sweater with Lace Details', N'sweater-with-lace-details', 29.989999771118164, N'20170627_23_45_59a.jpg', N'<p>Fine-knit sweater in a soft viscose blend with wide lace trim at cuffs and hem.</p>

<h4>DETAILS</h4>

<p>50% rayon, 50% acrylic.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-27' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (86, 1, 6, N'Embroidered Bomber Jacket', N'embroidered-bomber-jacket', 49.9900016784668, N'20170628_00_15_26a.jpg', N'<p>Bomber jacket in soft, woven fabric with a silk matte finish and embroidered motif. Ribbed stand-up collar, concealed snap fasteners at front, and welt side pockets. Elasticized cuffs and hem. Lined.</p>

<h4>DETAILS</h4>

<p>69% modal, 31% polyester.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (87, 1, 4, N'Knit Wrapover Sweater ', N'knit-wrapover-sweater-', 49.9900016784668, N'20170628_00_20_06a.jpg', N'<p>Loose-knit sweater in a soft viscose blend with glittery threads. Attached wrapover front section, tie at side, and wide ribbing at cuffs and hem.</p>

<h4>DETAILS</h4>

<p>64% rayon, 30% metallic fiber, 6% polyester.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (88, 1, 4, N'Trashed Top', N'trashed-top', 29.989999771118164, N'20170628_00_21_47a.jpg', N'<p>Top in double-layer cotton-blend jersey with heavily distressed details. Slits at sides and raw edges at cuffs and hem.</p>

<h4>DETAILS</h4>

<p>70% cotton, 27% polyester, 3% spandex.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (89, 1, 4, N'Gray melange', N'gray-melange', 14.989999771118164, N'20170628_00_28_01a.jpg', N'<p>Sleeveless, lightweight sweatshirt with a drawstring hood and sewn cuffs at armholes.</p>

<h4>DETAILS</h4>

<p>60% cotton, 40% polyester.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (90, 1, 4, N'Dusky pink', N'dusky-pink', 24.989999771118164, N'20170628_00_32_34a.jpg', N'<p>Lace cardigan with long dolman sleeves, rounded front hem, and no buttons.</p>

<h4>DETAILS</h4>

<p>100% polyester.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (91, 1, 2, N'Tank Top wScalloped Edges', N'tank-top-wscalloped-edges', 12.989999771118164, N'20170628_00_37_07a.jpg', N'<p>Tank top in cr&ecirc;ped jersey with raw, scalloped edges.</p>

<h4>DETAILS</h4>

<p>95% polyester, 5% spandex.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (92, 1, 1, N'Top with Lace Details', N'top-with-lace-details', 29.989999771118164, N'20170628_00_39_52a.jpg', N'<p>Top in airy, crinkled woven fabric with a printed pattern. Narrow-cut at top, narrow shoulder straps, and opening at back of neck with covered button. Wide lace trim at hem.</p>

<h4>DETAILS</h4>

<p>100% rayon.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (93, 1, 1, N'Blouse wEyelet Embroidery', N'blouse-weyelet-embroidery', 17.989999771118164, N'20170628_00_42_45a.jpg', N'<p>Short blouse in woven cotton fabric with eyelet embroidery. Short raglan sleeves and smocking at neckline, cuffs, and hem.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (94, 1, 1, N'Off-the-shoulder Top', N'off-the-shoulder-top', 14.989999771118164, N'20170628_00_45_57a.jpg', N'<p>Short, off-the-shoulder top in soft jersey with smocking at top and at hem. Long sleeves with narrow elastication at cuffs.</p>

<h4>DETAILS</h4>

<p>82% polyester, 17% linen, 1% spandex.</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (95, 3, 5, N'Sweatshirt Dress', N'sweatshirt-dress', 24.989999771118164, N'20170628_00_47_39a.jpg', N'<p>Straight-cut dress in cotton sweatshirt fabric with dropped shoulders, 3/4-length sleeves with sewn-in turn-ups at the cuffs, and slits in the sides. Slightly longer at the back.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (96, 3, 5, N'Hooded Dress', N'hooded-dress', 24.989999771118164, N'20170628_00_49_22a.jpg', N'<h4>DESCRIPTION</h4>

<p>Short, straight-cut dress in soft sweatshirt fabric with a drawstring hood and short raw-edge sleeves. Ribbing at hem.</p>

<h4>DETAILS</h4>

<p>98% cotton, 2% spandex.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (97, 3, 5, N'T-Shirt Drees', N't-shirt-drees', 14.989999771118164, N'20170628_00_54_11a.jpg', N'<p>Short, straight-cut jersey dress in a cotton blend with short sleeves.</p>

<h4>DETAILS</h4>

<p>50% cotton, 50% rayon.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (98, 3, 5, N'Knee-length Jersey Dress', N'knee-length-jersey-dress', 17.989999771118164, N'20170628_00_56_56a.jpg', N'<p>Knee-length dress in soft viscose jersey with a V-neck and narrow shoulder straps.</p>

<h4>DETAILS</h4>

<p>100% rayon.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (99, 1, 1, N'Smocked off-the-shoulder', N'smocked-off-the-shoulder', 14.989999771118164, N'20170628_01_29_26a.jpg', N'<p>Short, off-the-shoulder top in smocked cotton jersey with short sleeves and overlocked edges.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
GO
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (100, 1, 2, N'Off-the-shoulder Top ', N'off-the-shoulder-top-', 17.989999771118164, N'20170628_01_31_24a.jpg', N'<p>Short, off-the-shoulder top in a viscose-blend rib knit with short sleeves.</p>

<h4>DETAILS</h4>

<p>39% rayon, 38% acrylic, 20% nylon, 3% polyester.</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (101, 1, 1, N'Checked Top', N'checked-top', 24.989999771118164, N'20170628_01_39_50a.jpg', N'<p>Top in woven cotton fabric with wide shoulder straps, a knot detail at front, and smocking at back.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash cold</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (102, 3, 5, N'Off-the-shoulder Dress  ', N'off-the-shoulder-dress--', 29.989999771118164, N'20170628_01_42_13a.jpg', N'<p>Short, off-the-shoulder dress in woven cotton fabric. Elastication around upper edge, elasticized seam at waist, and 3/4-length sleeves with elasticized cuffs. Unlined.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash cold</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (103, 3, 5, N'Lace-trimmed Dress', N'lace-trimmed-dress', 49.9900016784668, N'20170628_01_44_20a.jpg', N'<p>Dress in cr&ecirc;ped woven fabric with lace trim. V-neck with lacing at back, long sleeves with tie at cuffs, and a concealed side zip. Gathered seam at waist. Jersey lining.</p>

<h4>DETAILS</h4>

<p>100% polyester.&nbsp;Machine wash cold</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (104, 3, 5, N'Off-the-shoulder Dress   ', N'off-the-shoulder-dress---', 39.9900016784668, N'20170628_01_46_10a.jpg', N'<p>Off-the-shoulder dress in crinkled woven fabric with a printed pattern. Elastication and flounce at top, elasticized waist, and flounce at hem. Longer at back. Unlined.</p>

<h4>DETAILS</h4>

<p>100% polyester.</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (105, 1, 1, N'Flounced strappy top ', N'flounced-strappy-top-', 30.989999771118164, N'20170628_01_59_17a.jpg', N'<p>Top in woven fabric with narrow shoulder straps, a V-neck and concealed zip in the side. Seam with flounces down to the hem. Lined at the top.</p>

<ul>
</ul>
', 0, CAST(N'2017-06-28' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (106, 1, 1, N'Off-the-shoulder blouse  ', N'off-the-shoulder-blouse--', 24.989999771118164, N'20170628_02_01_50a.jpg', N'<p>Short off-the-shoulder blouse in an airy weave with a V-neck and narrow, adjustable shoulder straps. Frill around the top, long sleeves with elasticated cuffs and a seam at the hem with narrow elastic and a frill trim.</p>
', 0, CAST(N'2017-06-28' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (107, 3, 8, N'Beatiful Party Dress', N'beatiful-party-dress', 1000, N'20170703_20_57_53a.jpg', N'<p>Beatiful Party Dress</p>
', 0, CAST(N'2017-07-03' AS Date), 2, 0)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (108, 2, 13, N'Pleated Skirt', N'pleated-skirt', 29.989999771118164, N'20170704_01_21_36a.jpg', N'<p>Short, pleated skirt in woven fabric. Elastication and a small ruffle at waist. Lined.</p>

<h4>DETAILS</h4>

<p>100% polyester.&nbsp;Machine wash cold</p>

<p>Imported</p>
', 0, CAST(N'2017-07-04' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (109, 2, 13, N'Circle Skirt', N'circle-skirt', 17.989999771118164, N'20170704_01_56_56a.jpg', N'<p>Short circle skirt in soft fabric. Unlined.</p>

<h4>DETAILS</h4>

<p>97% polyester, 3% spandex.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-07-04' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (110, 2, 13, N'A-line Skirt', N'a-line-skirt', 28.989999771118164, N'20170704_01_58_30a.jpg', N'<p>Short A-line skirt.</p>

<h4>DETAILS</h4>

<p>100% cotton.</p>

<p>Imported</p>
', 0, CAST(N'2017-07-04' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (111, 2, 13, N'Denim Skirt', N'denim-skirt', 24.989999771118164, N'20170704_02_00_29a.jpg', N'<p>Short, 5-pocket skirt in washed denim with distressed details. Button fly and raw-edge hem.</p>

<h4>DETAILS</h4>

<p>100% cotton.&nbsp;Machine wash warm</p>

<p>Imported</p>
', 0, CAST(N'2017-07-04' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (112, 2, 13, N'Long Wrap-front Skirt', N'long-wrap-front-skirt', 24.989999771118164, N'20170704_02_05_12a.jpg', N'<h4>DESCRIPTION</h4>

<p>Long wrap-front skirt in woven viscose fabric with a tie at one side and concealed fastener at the other. Longer at back. Unlined.</p>

<h4>DETAILS</h4>

<p>100% rayon.&nbsp;Machine wash cold</p>
', 0, CAST(N'2017-07-04' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (113, 2, 14, N'MOTO Embroidered', N'moto-embroidered', 40.9900016784668, N'20170707_14_40_22ts05a43mwht_zoom_m_1.jpg', N'<p>These high-rise MOTO Mom shorts come in non-stretch white denim with rip detailing, frayed hems and stylish floral embroidery. We&#39;re wearing ours with crop tops and bardot blouses this season. 100% Cotton. Machine wash.<br />
&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (114, 2, 15, N'Gingham Mensy', N'gingham-mensy', 46, N'20170707_14_44_23ts16k03mmon_zoom_m_1.jpg', N'<p>These high-waisted mensy trousers get a girly update with a flattering ruffle hem. Patterned in on-trend gingham, this covetable style is finished with turn up hems. They&#39;re perfect for workdays or weekends alike. 100% Polyester. Machine wash.&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (115, 2, 15, N'Gingham Frill Trousers', N'gingham-frill-trousers', 55, N'20170707_14_47_40ts16k01lmon_zoom_m_1.jpg', N'<p>These high waisted mensy fit trousers are given a girly twist with a feminine frill hem and waist detailing. In all over gingham print, they can be styled for the workday or the weekend. 57% Cotton, 41% Polyester, 2% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (116, 2, 15, N'Frill Hem Gingham', N'frill-hem-gingham', 35, N'20170707_14_51_40ts16t02mmon_zoom_m_1.jpg', N'<p>These fancy gingham trousers feature a cropped, high-waisted fit and a fun frill hem. Team with pared-down separates and a laid-back attitude. 86% Viscose, 12% Polyamide, 2% Elastane. Machine wash.<br />
&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (117, 2, 15, N'Ruffle Waist Gingham', N'ruffle-waist-gingham', 55, N'20170707_14_57_44ts16k14lppk_zoom_m_1.jpg', N'<p>Opt for a new silhouette with these gingham peg trousers in pale pink . Featuring a high waist and turn up hems, they get a girly finish with the frill waist detailing. With hook and bar fastening. 57% Viscose, 39% Polyester, 4% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (118, 2, 15, N'Stripe Ruffle Peg ', N'stripe-ruffle-peg-', 49, N'20170707_14_59_43ts16m21lble_zoom_m_1.jpg', N'<p>Stripes are always in style, so embrace the trend with these chic peg leg trousers in a summery blue and white colourway. We love the ruffle waist for extra detail. Finished with hook and bar fastenings with turned-up hems for a fuss-free approach. 79% Viscose,21% Cotton. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (119, 2, 15, N'Summer Stripe Peg ', N'summer-stripe-peg-', 49, N'20170707_15_02_39ts36d02mivr_zoom_m_1.jpg', N'<p>Lightweight trousers are a must as the weather gets warmer. We&rsquo;re going to be wearing these chic striped peg trousers all summer long, and we&rsquo;re loving the cute button detail to the waist. Cropped at the ankle bone for a leg-lengthening look, we&rsquo;re finishing with trainers for casual-cool. 78% Viscose,20% Polyester,2% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (120, 2, 14, N'MOTO Floral Painted ', N'moto-floral-painted-', 44, N'20170707_18_06_05ts05b99mmdt_zoom_m_1.jpg', N'<p>Borrow from the boys in shape and up-the-ante on denim cut-offs with these edgy ripped Ashley shorts. Cut with a mid-rise waist, they&#39;re detailed with a raw hem and rips for an edgy feel, and colourful floral paintwork for a pretty contrast. 100% Cotton. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (121, 2, 14, N'PETITE Frill Hem Shorts', N'petite-frill-hem-shorts', 40, N'20170707_18_09_22ts26s04llil_zoom_m_1.jpg', N'<p>Opt for a girlie finish whether dressing for a party or casually in these frill hem shorts. In a pretty lilac hue, they come in a high waisted fit. We&rsquo;ve teamed with a pink knitwear for a pastel perfect look. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (122, 2, 14, N'Velvet Frill Shorts', N'velvet-frill-shorts', 45, N'20170707_18_11_23ts36h01lmnt_zoom_m_1.jpg', N'<p>Tap into the velvet trend with these sumptuous shorts. Featuring two pockets and a charming frill trim, wear them styled over tights, or as they are with block heels depending on the season. 76% Viscose, 24% Polyamide. Machine wash.<br />
&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (123, 2, 14, N'Stripe Shorts by Love', N'stripe-shorts-by-love', 40, N'20170707_18_13_03ts62z12lmul_zoom_m_1.jpg', N'<p>Classic nautical colours combine in these navy and white stripe shorts. Wear with white trainers and the matching crop top for a classic look. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (124, 2, 14, N'Rivet Shorts', N'rivet-shorts', 40, N'20170707_18_15_33ts36h01lnav_zoom_m_1.jpg', N'<p>A chic day-to-night piece, these shorts in navy blue sit high on the waist and come with rivet detail to the waistband. Team with a long sleeve knit for a trans-seasonal feel. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (125, 2, 14, N'Tiger Print Shorts', N'tiger-print-shorts', 44, N'20170707_18_17_57ts14c03lble_zoom_m_1.jpg', N'<p>Add fun to your new season look in these blue shorts featuring all-over tiger print and practical pockets. Style with Tiger Print Shirt for an all-in-one feel. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (126, 2, 14, N'Watermelon Print ', N'watermelon-print-', 20, N'20170707_18_20_37ts62f22lblk_zoom_m_1.jpg', N'<p>These black high-waisted shorts by Nobody&#39;s Child come in a super-fun watermelon print. Team with crop tops and bardot tops for a stylish summer look. 100% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (127, 2, 14, N'PETITE Mix Floral Print', N'petite-mix-floral-print', 39, N'20170707_18_23_19ts26s20lblk_zoom_m_1.jpg', N'<p>For a fresh twist to your new season wardrobe opt for our mixed floral print shorts. Team with your favourite camisole tops and t-shirts for a weekend look. 100% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (128, 2, 14, N'MOTO Sequin Detail Denim', N'moto-sequin-detail-denim', 46, N'20170707_18_25_02ts05a38mwbk_zoom_m_1.jpg', N'<p>In a flattering high-waisted fit, these sparkly MOTO Mom shorts boast authentic trims and two-tone sequin detail on the front panels. Great for festival and parties, team with a bardot crop top to complete the look. 100% Cotton. Machine wash.<br />
&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (129, 2, 15, N'Mermaid Frill Flare ', N'mermaid-frill-flare-', 32, N'20170707_18_29_26ts16k15lblk_zoom_m_1.jpg', N'<p>It&rsquo;s all about the volume with these flared trousers with a &lsquo;mermaid&rsquo; frill hem. In a streamlined fit, they come in a black jersey and sit high on the waist. 90% Polyester, 10% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (130, 2, 15, N'Extreme Flare Trousers', N'extreme-flare-trousers', 32, N'20170707_18_31_40ts36f01mred_zoom_m_1.jpg', N'<p>Make a fashion statement in these extreme flare trousers. With a high waist and striking red hue, complete the look with a crop top and mules. 77% Polyester, 18% Viscose, 5% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (131, 2, 15, N'Extreme Frill Flared', N'extreme-frill-flared', 45, N'20170707_18_33_22ts16k05mblk_zoom_m_1.jpg', N'<p>Make a fashion statement in these extreme frill flared trousers. With a high waist and ribbed jersey fabric, these quirky black trousers are a new season must-have. 90% Polyester, 10% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (132, 2, 15, N'Ruffle Stripe Trousers', N'ruffle-stripe-trousers', 49, N'20170707_18_36_07ts16m06mcrm_zoom_m_1.jpg', N'<p>These awkward-length, wide leg trousers feature a fabulous ruffled waist and a hook-bar fastening. Pair with a simple top and let the trousers do the talking. 88% Cotton, 12% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (133, 3, 8, N'Floral Crisscross Waist ', N'floral-crisscross-waist-', 46, N'20170707_18_39_13ts14p19lble_zoom_m_1.jpg', N'<p>Fall in love with this bright and colourful floral print playsuit, Boasting crisscross detail on the waistband and nifty tie straps, this tropical style is great for balmy days. 100% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (134, 3, 8, N'Drama Sleeve Poplin', N'drama-sleeve-poplin', 52, N'20170707_18_41_12ts36p01mcor_zoom_m_2.jpg', N'<p>Get your closet equipped for summer events with this wrap front playsuit in bright coral. The drama puff sleeves add a so-now statement. Pair with a strappy wedge sandal for daytime or evening. 67% Polyester, 33% Cotton. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (135, 3, 8, N'Dot Print Bardot Playsuit', N'dot-print-bardot-playsuit', 52, N'20170707_18_42_41ts14p01mmon_zoom_m_1.jpg', N'<p>In a sprinkle of polka dots, this black crinkle georgette playsuit is perfect for sunny days. Featuring a trendy bardot neckline and frill detail, it&#39;s finished with a stretch waist for a flattering fit. Team yours with heeled sandals and a tote bag for weekend escapades. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (136, 3, 8, N'Ruffle Bandeau Jumpsuit', N'ruffle-bandeau-jumpsuit', 69, N'20170707_18_52_00ts36j01mtom_zoom_m_2.jpg', N'<p>A bright tomato-red bandeau jumpsuit with a fun ruffled bodice. In a wide leg cropped style, this stylish one-piece is great for parties and making an entrance. 85% Polyester, 15% Elastane. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (137, 3, 8, N'Flute Sleeve Bardot', N'flute-sleeve-bardot', 46, N'20170707_18_53_43ts14p02mkha_zoom_m_1.jpg', N'<p>This trendy khaki playsuit boasts fluted sleeves and a flattering bardot neckline. It&#39;s complete with a drawstring tie to the neckline, a cinched waist and flowing crepe fabric. Complete the look with platform sandals and boho accessories. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (138, 3, 8, N'Sunset Floral Tie ', N'sunset-floral-tie-', 52, N'20170707_18_55_52ts16w07mcrm_zoom_m_1.jpg', N'<p>A relaxed jumpsuit in a pretty floral print with thin straps and back strap details. We love the sunset floral pattern all over and the tie back details. Team with a pair of wedges for summer chic styling. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (139, 3, 8, N'Frill Floral Wrap', N'frill-floral-wrap', 52, N'20170707_18_57_31ts16w01mpbl_zoom_m_1.jpg', N'<p>Patterned all-over with a cheerful floral print, this graceful jumpsuit is inspired by the summer climes. From its wide leg to its flattering wrap front, the stylish details continue with a cold shoulder design and frilly trims. Team yours with nude sandals and floral accessories for that wedding invitation. 100% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (140, 3, 8, N'Playsuit by adidas Originals', N'playsuit-by-adidas-originals', 58, N'20170707_18_59_47ts12x39lmul_zoom_m_1.jpg', N'<p>Take your sportswear to pastel realms with this striking butterfly print playsuit courtesy of adidas Originals. In a flattering bandeau style, this contemporary one-piece comes with the trefoil logo on the front, mint green accenting and a drawstring tie to the chest. 100% Polyester. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (141, 3, 8, N'Crochet Wrap Front Playsuit', N'crochet-wrap-front-playsuit', 45, N'20170707_19_04_08ts62r20lcrm_zoom_m_1.jpg', N'<p>Crochet playsuit with wrap front detail by Glamorous. 95% Polyester, 5% Elastane. Hand wash only.<br />
&nbsp;</p>
', 0, CAST(N'2017-07-07' AS Date), 1, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (142, 3, 8, N'Emily Jumpsuit ', N'emily-jumpsuit-', 52, N'20170707_19_12_37ts12o38lnav_zoom_m_1.jpg', N'<p>Master off-duty cool in this stripe navy jumpsuit from Flynn Skye, with cute knot and cut-out detail to the front and wide leg styling. Team with sliders to keep the look casual. 100% Viscose. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (143, 3, 8, N'Stripe Tie Front', N'stripe-tie-front', 30, N'20170707_19_17_44ts62f25lcrm_zoom_m_1.jpg', N'<p>A stripe tie front playsuit by Nobody&#39;s Child. 65% Viscose, 26% Polyester, 9% Linen. Machine wash.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (144, 3, 8, N'A stripe tie front ', N'a-stripe-tie-front-', 56, N'20170707_19_18_54ts36p02mivr_zoom_m_1.jpg', N'<p>Classic white merges with contemporary design in this wrap playsuit with eyelet belt detail. Wear with metallic heels or sandals for a modern look. 100% Polyester. Machine wash.Model&#39;s height is 5&#39;10&quot; and she wears a UK size 8.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (145, 4, 12, N'JOLENE Toe Cap Block', N'jolene-toe-cap-block', 49, N'20170707_19_23_33ts32j11mslv_zoom_f_1.jpg', N'<p>Say hello to the chicest shoes of the season. The Jolene low heel sandals comes in sleek silver with cool contrast toe-cap detail and a rounded toe. It&#39;s finished with an adjustable ankle strap. Heel height is approximately 2&quot;. Upper: 80% Polyurethane, 20% Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (146, 4, 12, N'NEEVE Metal Detail Block', N'neeve-metal-detail-block', 56, N'20170707_19_27_23ts32n53lblk_zoom_f_1.jpg', N'<p>We&#39;re loving these stylish black sandals with a block heels and metal detailing. Great for adding a catwalk edge to outfits, this distinctive two-part shoe features a wide toe band and an elegant leather ankle strap. Heel height approximately 2.5&quot;. 100% Leather Sheep.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (147, 4, 12, N'NEEVE Metal Caged', N'neeve-metal-caged', 46, N'20170707_19_29_38ts32n47lwht_zoom_f_1.jpg', N'<p>We&#39;re loving these stylish white sandals with a block heels and metal detailing. Great for adding a catwalk edge to outfits, this distinctive two-part shoe features a wide toe band and an elegant leather ankle strap. Heel height approximately 2.5&quot;. Upper: Leather Sheep.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (148, 4, 12, N'LEONARDO Ankle Tie', N'leonardo-ankle-tie', 59, N'20170707_19_31_01ts32l18lblk_zoom_f_1.jpg', N'<p>We&#39;re in love with these black suede leather platforms. Perched on a dramatic skyscraper heel, this elegant style boasts an open toe and tangle of straps forming the ankle tie. Wear at your next summer soiree. Heel height approximately 4.5&quot;. Upper: Leather goat.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (149, 4, 12, N'MAURITIUS Embroidered ', N'mauritius-embroidered-', 44, N'20170707_19_32_59ts42m51lmul_zoom_f_1.jpg', N'<p>In a towering platform heels, these elegant black sandals are brimming with pretty details. Designed with an open toe and adjustable ankle strap, this feminine style is finished with red, green and pink floral embroidery along the heel and platform. Heel height approximately 4&quot;. Upper: Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (150, 4, 12, N'LANEY Embellished ', N'laney-embellished-', 66, N'20170707_19_35_03ts32l14lnud_zoom_m_1.jpg', N'<p>Add height and character to your outfit with these embellished platform sandals. Featuring a tall block heel and adjustable ankle strap, these striking nude sandals are dotted with inspiring flora and fauna appliques. Heel height is approximately 4&quot;. Upper: Textile. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (151, 4, 12, N'MARRAKECH Block ', N'marrakech-block-', 39, N'20170707_19_38_33ts42m44lnud_zoom_f_1.jpg', N'<p>Embroidery lace up block heel sandals with ankle tie. Heel height approximately 4&quot;. Upper: Textile. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (152, 4, 12, N'MOROCCO Studded', N'morocco-studded', 42, N'20170707_19_40_14ts42m39lgry_zoom_m_1.jpg', N'<p>Add edge to your outfit with these grey mid heel sandals. Adorned with striking metal studs across all straps and heels, an adjustable ankle strap and fabric exterior complete the design. Heel height approximately 3.5&rdquo;. Upper: Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (153, 4, 10, N'BEE Heart Stud Ankle ', N'bee-heart-stud-ankle-', 55, N'20170707_19_46_26ts42b15ltpe_zoom_m_1.jpg', N'<p>In a pretty shade of Taupe, these elegant ankle boots have been speckled with charming heart studs. Featuring a mid heel and side zip fastening, they&#39;ll put a spring into your step. Heel height approximately 2.5&quot;. Upper: Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (154, 4, 10, N'MIA Patent Leather Ring', N'mia-patent-leather-ring', 92, N'20170707_19_49_55ts32m20mred_zoom_f_1-(1).jpg', N'<p>These slick red leather boots boast a dramatic flared heel and stylish metal ring detail on the shaft. This stand-out style is finished with a zip at the back. Heel height is approximately 2.5&quot;. Upper: Leather cow.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (155, 4, 10, N'MANUEL Elastic Ankle', N'manuel-elastic-ankle', 85, N'20170707_19_53_04ts32m10mslv_zoom_m_1.jpg', N'<p>In a sleek silver finish, these fashion-forward ankle boots can&#39;t help but twinkle. Boasting an angular mid heel and black elastic in the side, it&#39;s finished with a stylish square toe. Heel height is approximately 2.5&rdquo;. Upper: Synthetic.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (156, 4, 10, N'HUBBA Pointed Socks Boots', N'hubba-pointed-socks-boots', 62, N'20170707_19_55_46ts32h15mblk_zoom_f_1.jpg', N'<p>Perched on a needle-thin heel, these sophisticated sock boots enhance any outfit. Boasting a flattering pointed toe and plush scuba exterior, partner with culottes and a bardot blouse for a powerful office look. Heel height approximately 4&quot;. Upper: Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (157, 4, 10, N'MAY Sock Boots', N'may-sock-boots', 89, N'20170707_19_59_04ts32m16mylw_zoom_f_1.jpg', N'<p>Perched on a three inch angled contrast heel, these eye-catching yellow sock boots demand attention. Styled with a side zip fastening and pointed toe, we&#39;re wearing them with awkward length trousers. Heel height is approximately 3&quot;. Upper: Leather cow.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (158, 4, 10, N'MARILO Knotch Ankle Boots', N'marilo-knotch-ankle-boots', 85, N'20170707_20_03_15ts32m22mpnk_zoom_f_1.jpg', N'<p>In a vibrant pop of fuchsia pink, these suede leather ankle boots can&#39;t help but make an impact. Featuring a cut out detail on the shaft and a mid block heel, they&#39;re finished with a side zip and directional square toe. Heel height is approximately 2.5&quot;. Upper: Leather cow.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (159, 4, 10, N'MARILO Knotch Ankle Boot', N'marilo-knotch-ankle-boot', 85, N'20170707_20_04_18ts32m22mwht_zoom_f_1.jpg', N'<p>In a vibrant pop of fuchsia pink, these suede leather ankle boots can&#39;t help but make an impact. Featuring a cut out detail on the shaft and a mid block heel, they&#39;re finished with a side zip and directional square toe. Heel height is approximately 2.5&quot;. Upper: Leather cow.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (160, 4, 10, N'BUBBA High Leg Stretch', N'bubba-high-leg-stretch', 69, N'20170707_20_07_24ts32b03mkha_zoom_m_1.jpg', N'<p>We&#39;re loving these stretchy over-the-knee boots. Perched on a dramatic stiletto heel, this elegant style is further enhanced with a pointed toe and subtle side zip fastening. Heel height approximately 4&quot;. Upper: Textile.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (161, 4, 10, N'BAY Ankle Boots', N'bay-ankle-boots', 59, N'20170707_20_09_46ts42b29kblk_zoom_m_1-(1).jpg', N'<p>These chunky black heeled boots are a must-have this season, finished in a black suede-style finish. We love with with skinny jeans rolled up at the hem. Heel height approxamitely 3&quot;. Upper: Textile. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (162, 4, 10, N'KAISER Chelsea Boots', N'kaiser-chelsea-boots', 52, N'20170707_20_11_52ts42k04kblk_zoom_f_1.jpg', N'<p>Every girl needs a pair of Chelsea boots in her wardrobe. We&#39;re loving this real leather blended pair with classic rounded toes. Upper: Leather/Elastane. Specialist leather clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (163, 4, 9, N'FERN Studded Heel Sliders', N'fern-studded-heel-sliders', 52, N'20170707_20_15_51ts32f49lred_zoom_f_1.jpg', N'<p>Upscale your shoe collection this SS17 with the FERN slip on sliders. In a red finish, they come complete with stud detail to the heel. Upper: Leather Sheep. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (164, 4, 9, N'ANGELINA Suede Leather ', N'angelina-suede-leather-', 39, N'20170707_20_17_29ts42a08mred_zoom_f_1.jpg', N'<p>In butter-soft suede leather, these supremely elegant red mules are great for teaming ankle-grazing jeans for a sleek finish. In a barely-there contrast heel and elegant point, they&#39;re a new-season essential. Upper: Leather Sheep.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (165, 4, 9, N'KARA Pointy Flats', N'kara-pointy-flats', 35, N'20170707_20_19_58ts32k24lwht_zoom_f_1.jpg', N'<p>Slip into these flat white mules for style sophistication. Crafted in butter-soft leather, these dainty pointed shoes have a slim heel and tonal bow accents. 100% Leather sheep. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (166, 4, 9, N'ANGELINA Suede Leather', N'angelina-suede-leather', 39, N'20170707_20_21_42ts42a08mwht_zoom_f_1.jpg', N'<p>In butter-soft suede leather, these supremely elegant white mules are great for teaming ankle-grazing jeans for a sleek finish. In a barely-there contrast heel and elegant point, they&#39;re a new-season essential. Upper: Leather sheep.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (167, 4, 9, N'JACKSON Kitten Mules', N'jackson-kitten-mules', 62, N'20170707_20_23_15ts32j27lsge_zoom_f_1.jpg', N'<p>Keep things classy in these leather kitten heel mules in a sage colourway. Featuring a pointed toe for a chic finish, they&rsquo;re perfect to style with peg trousers for a pencil skirt. Heel height approximately 2&quot;. Upper: Leather Cow. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (168, 4, 9, N'JOANNE Leather Heeled ', N'joanne-leather-heeled-', 66, N'20170707_20_26_08ts32j36mpnk_zoom_f_1.jpg', N'<p>In shocking pink leather these vibrant mules are set on a slender mid heel for just the right amount of height. Boasting an elongated toe point and square shaped opening, this slip on style is ideal for party events. Heel height approximately 2.5&rdquo;. Upper: Leather Goat.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
INSERT [dbo].[products] ([productID], [cateID], [subCateID], [productName], [productNameNA], [price], [urlImg], [productDescription], [productDiscount], [postedDate], [productViews], [status]) VALUES (169, 4, 9, N'ROME Fabric Knot Mules', N'rome-fabric-knot-mules', 40, N'20170707_20_30_17ts32r57lmul_zoom_f_1.jpg', N'<p>Wear your mules a different way with these textured fabric knot mules with a mid-heel. Heel height approximately 3.5&quot;. GO 100% Textile. Specialist clean only.</p>
', 0, CAST(N'2017-07-07' AS Date), 0, 1)
SET IDENTITY_INSERT [dbo].[products] OFF
GO

--INSERT PRODUCT COLORS
SET IDENTITY_INSERT [dbo].[productColors] ON 
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (1, 1, N'Light denim blue', N'light-denim-blue', N'20170617_17_00_54light-denim-blue-(3).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (2, 1, N'blue', N'blue', N'20170617_17_00_54denim-blue-(2).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (3, 1, N'white ', N'white-', N'20170617_17_00_54white-denim.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (4, 2, N'white ', N'white-', N'20170617_17_06_57hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (5, 3, N'red', N'red', N'20170617_17_44_4429.99.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (6, 4, N'pink', N'pink', N'20170617_17_55_02hmprod-(8).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (7, 4, N'flower', N'flower', N'20170617_17_55_02hmprod-(10).jpg', 3, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (8, 4, N'white ', N'white-', N'20170617_17_55_02hmprod-(7).jpg', 4, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (9, 4, N'black', N'black', N'20170617_17_55_02hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (10, 4, N'red', N'red', N'20170617_17_55_02dress-with-smocking.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (11, 5, N'Light denim blue', N'light-denim-blue', N'20170617_18_07_29hmprod-(4).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (12, 6, N'Black', N'black', N'20170618_01_09_02hmprod.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (13, 6, N'white', N'white', N'20170618_01_09_02699.jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (14, 6, N'Yellow', N'yellow', N'20170618_01_09_02hmprod-(6).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (15, 7, N'Black', N'black', N'20170618_01_55_18hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (16, 7, N'Black floral', N'black-floral', N'20170618_01_55_182.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (17, 8, N'Red/floral', N'red/floral', N'20170618_02_03_09hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (18, 8, N'Leopard print', N'leopard-print', N'20170618_02_03_09hmprod-(8).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (19, 8, N'Black', N'black', N'20170618_02_03_09hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (20, 9, N' Light blue', N'-light-blue', N'20170618_02_10_31hmprod-(8).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (21, 9, N'Black', N'black', N'20170618_02_10_31hmprod-(11).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (22, 9, N'White/Yellow patterned', N'white/yellow-patterned', N'20170618_02_10_31hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (23, 10, N'Neon Pink', N'neon-pink', N'20170618_02_26_22hmprod-(22).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (24, 11, N'Powder pink', N'powder-pink', N'20170618_02_34_53hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (25, 11, N'Dark blue', N'dark-blue', N'20170618_02_34_53g-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (26, 12, N'Light pink', N'light-pink', N'20170618_02_42_28hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (27, 12, N'Pigeon blue', N'pigeon-blue', N'20170618_02_42_28hmprod-(5).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (28, 13, N'Light blue', N'light-blue', N'20170618_02_49_57light-blue.jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (29, 13, N'white ', N'white-', N'20170618_02_49_57hmprod-(7).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (30, 13, N'Light pink', N'light-pink', N'20170618_02_49_57hmprod-(2).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (31, 14, N'Orange', N'orange', N'20170618_02_54_09hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (32, 15, N'Blue/White/Striped', N'blue/white/striped', N'20170618_02_57_55hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (33, 15, N'white ', N'white-', N'20170618_02_57_55hmprod-(5).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (34, 16, N'Blue/White/Striped', N'blue/white/striped', N'20170618_03_00_36hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (35, 17, N'White/striped', N'white/striped', N'20170618_03_06_28hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (36, 17, N'white ', N'white-', N'20170618_03_06_28hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (37, 17, N'Light pink', N'light-pink', N'20170618_03_06_28hmprod-(6).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (38, 18, N'white', N'white', N'20170618_03_10_38hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (39, 18, N'Blue/white striped', N'blue/white-striped', N'20170618_03_10_38hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (40, 19, N'Blue/white striped', N'blue/white-striped', N'20170618_03_14_39hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (41, 20, N'Powder pink/Checked', N'powder-pink/checked', N'20170618_03_18_49hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (42, 20, N'Black/Checked', N'black/checked', N'20170618_03_18_49hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (43, 21, N' Grey marl', N'-grey-marl', N'20170618_03_26_40hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (44, 21, N'Light blue', N'light-blue', N'20170618_03_26_40hmprod-(12).jpg', 3, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (45, 21, N'Beige', N'beige', N'20170618_03_26_40hmprod-(8).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (46, 21, N'Black', N'black', N'20170618_03_26_40hmprod-(4).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (47, 22, N'Mole', N'mole', N'20170618_03_32_24hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (48, 22, N'white ', N'white-', N'20170618_03_32_24hmprod-(8).jpg', 3, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (49, 22, N'Apricot', N'apricot', N'20170618_03_32_24hmprod-(5).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (50, 22, N'Black', N'black', N'20170618_03_32_24hmprod-(11).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (51, 23, N'Black', N'black', N'20170618_14_21_18hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (52, 23, N'Light beige melange', N'light-beige-melange', N'20170618_14_21_18hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (53, 24, N'Black', N'black', N'20170618_14_26_16hmprod-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (54, 25, N'black', N'black', N'20170618_14_37_07hmprod-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (55, 26, N'Gray melange', N'gray-melange', N'20170618_14_43_00hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (56, 27, N'Mint green melange', N'mint-green-melange', N'20170618_14_54_42hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (57, 27, N'Black', N'black', N'20170618_14_54_42hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (58, 28, N'Black', N'black', N'20170618_15_14_14hmprod-(8).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (59, 28, N'Gray', N'gray', N'20170618_15_14_14hmprod-(5).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (60, 28, N'Beige melange', N'beige-melange', N'20170618_15_14_14hmprod-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (61, 29, N'Black', N'black', N'20170618_15_17_37hmprod-(10).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (62, 29, N'Gray melange', N'gray-melange', N'20170618_15_17_37gray-melange.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (63, 30, N'Black', N'black', N'20170618_15_22_34hmprod-(7).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (64, 30, N'Powder Pink', N'powder-pink', N'20170618_15_22_34hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (65, 30, N'Gray melange', N'gray-melange', N'20170618_15_22_34hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (66, 31, N'Light gray melange', N'light-gray-melange', N'20170618_15_27_25hmprod-(9).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (67, 32, N'Light green melange', N'light-green-melange', N'20170618_15_38_29hmprod-(5).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (68, 32, N'Beige melange', N'beige-melange', N'20170618_15_38_29hmprod-(6).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (69, 32, N'Gray', N'gray', N'20170618_15_38_29hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (70, 33, N'Black/white', N'black/white', N'20170618_15_48_41hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (71, 33, N'Gray melange/white', N'gray-melange/white', N'20170618_15_48_41hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (72, 34, N'White/pink striped', N'white/pink-striped', N'20170623_15_32_09hmprod-(6).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (73, 34, N'Gray melange', N'gray-melange', N'20170623_15_32_09hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (74, 35, N'white ', N'white-', N'20170623_15_36_37hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (75, 35, N'Light gray melange', N'light-gray-melange', N'20170623_15_36_37hmprod-(6).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (76, 36, N'white ', N'white-', N'20170623_15_39_50hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (77, 37, N'White/New York', N'white/new-york', N'20170623_15_41_56hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (78, 38, N'Gray/lemon', N'gray/lemon', N'20170623_15_45_19hmprod-(4).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (79, 38, N'white ', N'white-', N'20170623_15_45_19hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (80, 39, N'Nearly Black', N'nearly-black', N'20170623_15_52_12hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (81, 39, N'white ', N'white-', N'20170623_15_52_12hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (82, 40, N'Light Gray', N'light-gray', N'20170623_15_59_05hmprod-(1).jpg', 3, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (83, 40, N'Black', N'black', N'20170623_15_59_05hmprod-(5).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (84, 40, N'Yellow', N'yellow', N'20170623_15_59_05hmprod-(8).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (85, 40, N'Powder Pink', N'powder-pink', N'20170623_15_59_05powder-pink.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (86, 41, N'Khaki Green', N'khaki-green', N'20170623_16_06_51hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (87, 42, N'Black', N'black', N'20170623_16_34_36hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (88, 42, N'Powder Pink', N'powder-pink', N'20170623_16_34_36hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (89, 43, N'Powder Pink', N'powder-pink', N'20170623_16_39_33hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (90, 43, N'Black', N'black', N'20170623_16_39_33hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (91, 44, N'Dusky Green', N'dusky-green', N'20170623_16_51_42hmprod-(5).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (92, 44, N'Powder Pink', N'powder-pink', N'20170623_16_51_42aa.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (93, 45, N'White', N'white', N'20170623_16_54_37hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (94, 46, N'Blue/white striped', N'blue/white-striped', N'20170623_16_57_34hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (95, 47, N'Blue/white striped', N'blue/white-striped', N'20170623_17_02_08hmprod-(6).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (96, 47, N'white ', N'white-', N'20170623_17_02_08hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (97, 47, N'Powder Pink', N'powder-pink', N'20170623_17_02_08hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (98, 48, N'Powder Pink', N'powder-pink', N'20170623_17_04_07hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (99, 49, N'Black/dotted', N'black/dotted', N'20170623_17_06_59hmprod-(1).jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (100, 50, N'black', N'black', N'20170623_17_12_20hmprod-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (101, 50, N'White', N'white', N'20170623_17_12_20hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (102, 51, N'White/palms', N'white/palms', N'20170623_17_14_43hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (103, 52, N'Powder Pink', N'powder-pink', N'20170623_17_17_34hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (104, 53, N'Black/dotted', N'black/dotted', N'20170623_17_20_37hmprod-(2).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (105, 53, N'fLight yellow/Floral', N'flight-yellow/floral', N'20170623_17_20_37hmprod-(4).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (106, 54, N'Powder Pink', N'powder-pink', N'20170623_17_23_20hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (107, 55, N'Powder Pink', N'powder-pink', N'20170623_17_25_02hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (108, 56, N'black', N'black', N'20170623_17_27_42hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (109, 57, N'Powder Pink', N'powder-pink', N'20170623_17_29_57hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (110, 58, N'Silver-colored', N'silver-colored', N'20170623_17_32_54hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (111, 59, N'Black', N'black', N'20170623_17_37_15hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (112, 60, N'Dark blue/floral', N'dark-blue/floral', N'20170623_17_39_17hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (113, 61, N'Mintgreen/glittery', N'mintgreen/glittery', N'20170623_17_40_45hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (114, 62, N'Black', N'black', N'20170623_17_42_25hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (115, 63, N'white ', N'white-', N'20170623_17_47_47hmprod-(5).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (116, 63, N'Pink', N'pink', N'20170623_17_47_47hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (117, 64, N'Powder Pink', N'powder-pink', N'20170623_17_54_05hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (118, 64, N'Black/gold-colored', N'black/gold-colored', N'20170623_17_54_05hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (119, 64, N'Khaki Green', N'khaki-green', N'20170623_17_54_05hmprod-(4).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (120, 65, N'Light beige/glittery', N'light-beige/glittery', N'20170623_17_56_50hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (121, 66, N'Heather purple', N'heather-purple', N'20170623_18_02_08hmprod-(5).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (122, 66, N'yellow', N'yellow', N'20170623_18_02_08hmprod-(8).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (123, 66, N'white ', N'white-', N'20170623_18_02_08hmprod-(2).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (124, 67, N'black', N'black', N'20170623_18_04_21hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (125, 68, N'black', N'black', N'20170623_18_06_32hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (126, 69, N'Blue Stripe', N'blue-stripe', N'20170623_18_17_31gj17sdr262-7-(1).jpeg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (127, 70, N'White Strip Black', N'white-strip-black', N'20170623_18_20_47gj17sdr113-3.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (128, 71, N'MULTI GREEN', N'multi-green', N'20170623_18_23_41gj17sdr214-6.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (129, 72, N'Off white Floral', N'off-white-floral', N'20170623_18_29_10gj17sdr034_2_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (130, 73, N'WHITE-BLACK FLORAL PULLOVER ', N'white-black-floral-pullover-', N'20170623_18_33_47gj17spu067-6_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (131, 74, N'Light pink/glitter', N'light-pink/glitter', N'20170707_14_28_12g.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (132, 75, N'Light beige', N'light-beige', N'20170707_14_01_54hmprod-(3).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (133, 75, N'Black ', N'black-', N'20170707_14_02_01hmprod-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (134, 76, N'Black', N'black', N'20170707_13_59_34hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (135, 77, N'GREY', N'grey', N'20170707_13_58_02c17wfta069__1_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (136, 78, N'GREEN', N'green', N'20170707_13_54_11c16wfdd054_1_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (137, 79, N'white ', N'white-', N'20170707_13_53_09c17sfde045_2__1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (138, 80, N'navy', N'navy', N'20170707_13_52_12c17sfde061_2_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (139, 81, N'Black', N'black', N'20170707_13_51_15c17sfde039_3_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (140, 82, N'silver', N'silver', N'20170704_01_41_540217000406217_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (141, 83, N'white ', N'white-', N'20170707_13_47_55c17sfte026_3_-(1).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (142, 83, N'Black', N'black', N'20170707_13_48_07c17sfte026_5_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (143, 84, N'White', N'white', N'20170707_13_46_23c17sfte021_3_.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (144, 84, N'Navy', N'navy', N'20170707_13_46_32c17sfte021_1_.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (145, 85, N'Natural white', N'natural-white', N'20170704_01_39_38hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (146, 85, N'Black', N'black', N'20170704_01_39_30hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (147, 86, N'Powder Pink', N'powder-pink', N'20170707_14_27_07hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (148, 87, N'Mintgreen/glittery', N'mintgreen/glittery', N'20170707_14_24_52hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (149, 88, N'Black', N'black', N'20170707_14_23_59hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (150, 89, N'Powder pink', N'powder-pink', N'20170707_14_21_41hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (151, 89, N'Black', N'black', N'20170707_14_21_51hmprod-(2).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (152, 89, N'Gray melange', N'gray-melange', N'20170707_14_21_57gray-melange.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (153, 90, N'Natural White', N'natural-white', N'20170707_14_17_37natural-white.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (154, 90, N'Black', N'black', N'20170707_14_17_42hmprod-(2).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (155, 90, N'Dusky Pink', N'dusky-pink', N'20170707_14_17_49dusky-pink.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (156, 91, N'Dusky Green', N'dusky-green', N'20170707_14_11_59dusky-green.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (157, 91, N'Powder Pink', N'powder-pink', N'20170707_14_12_11hmprod-(1).jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (158, 91, N'Natural White', N'natural-white', N'20170707_14_12_17natural-white.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (159, 92, N'Natural white/floral', N'natural-white/floral', N'20170707_14_35_07natural-white.floral.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (160, 93, N'white', N'white', N'20170707_14_09_18hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (161, 94, N'Black', N'black', N'20170704_01_35_00hmprod-(4).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (162, 94, N'white ', N'white-', N'20170704_01_35_08hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (163, 95, N'Black', N'black', N'20170707_14_16_02hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (164, 96, N'Gray', N'gray', N'20170707_14_15_11hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (165, 97, N'Vintage Pink', N'vintage-pink', N'20170704_01_50_33vintage-pink.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (166, 97, N'Black', N'black', N'20170704_01_50_49black.jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (167, 97, N'Light terracotta', N'light-terracotta', N'20170704_01_50_59light-terracotta.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (168, 98, N'yellow', N'yellow', N'20170704_01_47_14hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (169, 99, N'white', N'white', N'20170704_01_32_46hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (170, 99, N'blue', N'blue', N'20170704_01_32_53hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (171, 100, N'white ', N'white-', N'20170704_01_31_20hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (172, 101, N'Black/white', N'black/white', N'20170704_01_46_10hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (173, 102, N'Black/white/checked', N'black/white/checked', N'20170704_01_45_28hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (174, 103, N'Natural White', N'natural-white', N'20170704_01_44_30hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (175, 104, N'Natural white/floral', N'natural-white/floral', N'20170704_01_43_21hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (176, 105, N'white', N'white', N'20170704_01_26_13hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (177, 105, N'Black', N'black', N'20170704_01_26_20hmprod-(3).jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (178, 106, N'white ', N'white-', N'20170707_14_04_41hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (179, 107, N'White', N'white', N'20170703_20_57_53hmprod.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (180, 108, N'Orange', N'orange', N'20170704_01_21_36hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (181, 109, N'Black', N'black', N'20170704_01_56_56hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (182, 110, N'white', N'white', N'20170704_01_58_30hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (183, 111, N'Denim Blue', N'denim-blue', N'20170704_02_00_29hmprod-(2).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (184, 112, N'black', N'black', N'20170704_02_05_12hmprod-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (185, 113, N'white ', N'white-', N'20170707_14_40_22ts05a43mwht_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (186, 114, N'Monochrome', N'monochrome', N'20170707_14_44_23ts16k03mmon_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (187, 115, N'Monochrome', N'monochrome', N'20170707_14_47_40ts16k01lmon_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (188, 116, N' BLACK', N'-black', N'20170707_14_51_39ts16t02mmon_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (189, 117, N'Pale Pink', N'pale-pink', N'20170707_14_57_44ts16k14lppk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (190, 118, N'BLUE', N'blue', N'20170707_14_59_43ts16m21lble_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (191, 119, N'IVORY', N'ivory', N'20170707_15_02_39ts36d02mivr_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (192, 120, N'MID STONE', N'mid-stone', N'20170708_13_56_04ts05b99mmdt_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (193, 121, N'LILAC', N'lilac', N'20170708_13_55_13ts26s04llil_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (194, 122, N'MINT', N'mint', N'20170708_13_53_33ts36h01lmnt_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (195, 123, N'MULTI', N'multi', N'20170708_13_51_46ts62z12lmul_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (196, 124, N'NAVY BLUE', N'navy-blue', N'20170708_13_50_57ts36h01lnav_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (197, 125, N'BLUE', N'blue', N'20170708_13_50_06ts14c03lble_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (198, 126, N'Black', N'black', N'20170708_13_48_29ts62f22lblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (199, 127, N'Black', N'black', N'20170708_13_47_18ts26s20lblk_zoom_f_1.jpg', 0, 1)
GO
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (200, 128, N' Washed Black', N'-washed-black', N'20170708_13_46_21ts05a38mwbk_zoom_f_1-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (201, 129, N'Black', N'black', N'20170708_13_45_22ts16k15lblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (202, 130, N'red', N'red', N'20170708_13_44_19ts36f01mred_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (203, 131, N'Black', N'black', N'20170708_13_43_15ts16k05mblk_zoom_m_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (204, 132, N'CREAM', N'cream', N'20170708_13_42_12ts16m06mcrm_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (205, 133, N'blue', N'blue', N'20170708_13_40_28ts14p19lble_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (206, 134, N'CORAL', N'coral', N'20170708_13_39_53ts36p01mcor_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (207, 135, N' Monochrome', N'-monochrome', N'20170708_13_39_13ts14p01mmon_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (208, 136, N' TOMATO', N'-tomato', N'20170708_13_38_01ts36j01mtom_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (209, 137, N'Khaki', N'khaki', N'20170708_13_37_15ts14p02mkha_zoom_m_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (210, 138, N'CREAM', N'cream', N'20170708_13_36_17ts16w07mcrm_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (211, 139, N'PALE BLUE', N'pale-blue', N'20170708_13_35_08ts16w01mpbl_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (212, 140, N'multi', N'multi', N'20170708_13_33_57ts12x39lmul_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (213, 141, N'Natural White', N'natural-white', N'20170708_13_33_22ts62r20lcrm_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (214, 142, N'navy blue', N'navy-blue', N'20170708_13_32_43ts12o38lnav_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (215, 143, N'White', N'white', N'20170708_13_31_50ts62f25lcrm_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (216, 144, N'white', N'white', N'20170708_13_22_05ts36p02mivr_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (217, 145, N'SILVER', N'silver', N'20170708_13_20_21ts32j11mslv_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (218, 146, N'Black', N'black', N'20170708_13_19_43ts32l18lblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (219, 147, N'white ', N'white-', N'20170708_13_18_57ts32n47lwht_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (220, 148, N'Black', N'black', N'20170708_13_18_21ts32l18lblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (221, 149, N'Multi', N'multi', N'20170708_13_17_39ts42m51lmul_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (222, 150, N'nude', N'nude', N'20170707_19_35_03ts32l14lnud_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (223, 151, N'Red', N'red', N'20170708_13_16_14ts42m46lred_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (224, 151, N'nude', N'nude', N'20170708_13_16_20ts42m44lnud_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (225, 151, N'Black', N'black', N'20170708_13_16_25ts42m45lblk_zoom_f_1.jpg', 2, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (226, 152, N'Grey', N'grey', N'20170708_13_15_33ts42m39lgry_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (227, 153, N'taupe', N'taupe', N'20170708_13_14_05ts42b15ltpe_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (228, 154, N'red', N'red', N'20170708_13_13_18ts32m20mred_zoom_f_1-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (229, 155, N'silver', N'silver', N'20170708_13_12_27ts32m10mslv_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (230, 155, N'PURPLE', N'purple', N'20170708_13_12_33ts32m10mple_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (231, 156, N'Black', N'black', N'20170708_13_11_19ts32h15mblk_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (232, 156, N'Khaki', N'khaki', N'20170708_13_11_25ts32h15mkha_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (233, 157, N'Yellow', N'yellow', N'20170708_13_10_10ts32m16mylw_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (234, 158, N'Pink', N'pink', N'20170708_13_09_01ts32m22mpnk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (235, 158, N'Black', N'black', N'20170708_13_09_07ts32m22mblk_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (236, 159, N'White', N'white', N'20170708_13_08_09ts32m22mwht_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (237, 160, N'Khaki', N'khaki', N'20170708_13_06_55ts32b03mkha_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (238, 160, N'Black', N'black', N'20170708_13_07_00ts32b03mblk_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (239, 161, N'Black', N'black', N'20170708_13_06_16ts42b29kblk_zoom_m_1-(1).jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (240, 162, N'Black', N'black', N'20170708_13_04_41ts42k04kblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (241, 163, N'red', N'red', N'20170708_13_03_28ts32f49lred_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (242, 164, N'red', N'red', N'20170708_13_02_39ts42a08mred_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (243, 165, N'Black', N'black', N'20170708_13_00_57ts32k24lwht_zoom_f_1.jpg', 1, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (244, 165, N'white ', N'white-', N'20170708_13_01_04ts32k24lblk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (245, 166, N'white ', N'white-', N'20170707_21_58_22ts42a08mwht_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (246, 167, N'Sage', N'sage', N'20170707_21_51_11ts32j27lsge_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (247, 168, N'pink', N'pink', N'20170707_21_49_45ts32j36mpnk_zoom_f_1.jpg', 0, 1)
INSERT [dbo].[productColors] ([colorID], [productID], [color], [colorNA], [urlColorImg], [colorOrder], [status]) VALUES (248, 169, N' MULTI', N'-multi', N'20170707_21_49_01ts32r57lmul_zoom_f_1.jpg', 0, 1)
SET IDENTITY_INSERT [dbo].[productColors] OFF
GO

--INSERT PRODUCT SUBIMAGE
SET IDENTITY_INSERT [dbo].[productSubImgs] ON 
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (1, 2, N'20170617_17_00_54denim-blue.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (2, 1, N'20170617_17_00_54light-denim-blue-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (3, 3, N'20170617_17_00_54white-denim-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (4, 4, N'20170617_17_06_57hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (5, 5, N'20170617_17_44_44off-the-shoulder-dress.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (6, 8, N'20170617_17_55_02hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (7, 6, N'20170617_17_55_02hmprod-(9).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (8, 10, N'20170617_17_55_0224.99.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (9, 7, N'20170617_17_55_02hmprod-(5).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (10, 9, N'20170617_17_55_02hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (11, 11, N'20170617_18_07_29hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (12, 12, N'20170618_01_09_02hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (13, 13, N'20170618_01_09_02699.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (14, 12, N'20170618_01_09_02hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (15, 13, N'20170618_01_09_02hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (16, 14, N'20170618_01_09_02hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (17, 13, N'20170618_01_09_02hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (18, 14, N'20170618_01_09_02hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (19, 14, N'20170618_01_09_02hmprod-(6).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (20, 12, N'20170618_01_09_026.99.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (21, 16, N'20170618_01_55_181.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (22, 15, N'20170618_01_55_18hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (23, 16, N'20170618_01_55_182.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (24, 15, N'20170618_01_55_18hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (25, 16, N'20170618_01_55_1801.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (26, 15, N'20170618_01_55_18hmprod-(4).jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (27, 15, N'20170618_01_55_18hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (28, 19, N'20170618_02_03_09hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (29, 17, N'20170618_02_03_09hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (30, 17, N'20170618_02_03_09hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (31, 18, N'20170618_02_03_09hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (32, 18, N'20170618_02_03_09hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (33, 19, N'20170618_02_03_09hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (34, 18, N'20170618_02_03_09hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (35, 19, N'20170618_02_03_09hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (36, 17, N'20170618_02_03_09hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (37, 21, N'20170618_02_10_31hmprod-(11).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (38, 21, N'20170618_02_10_31hmprod-(9).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (39, 22, N'20170618_02_10_31hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (40, 20, N'20170618_02_10_31hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (41, 20, N'20170618_02_10_31hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (42, 22, N'20170618_02_10_31hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (43, 21, N'20170618_02_10_31hmprod-(10).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (44, 22, N'20170618_02_10_31hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (45, 20, N'20170618_02_10_31hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (46, 23, N'20170618_02_26_22hmprod-(12).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (47, 23, N'20170618_02_26_22hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (48, 23, N'20170618_02_26_22hmprod-(22).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (49, 24, N'20170618_02_34_53hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (50, 25, N'20170618_02_34_53g-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (51, 25, N'20170618_02_34_53g-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (52, 24, N'20170618_02_34_53hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (53, 24, N'20170618_02_34_53hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (54, 25, N'20170618_02_34_53g-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (55, 27, N'20170618_02_42_28hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (56, 27, N'20170618_02_42_28hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (57, 26, N'20170618_02_42_28hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (58, 27, N'20170618_02_42_28hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (59, 26, N'20170618_02_42_28hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (60, 26, N'20170618_02_42_281.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (61, 30, N'20170618_02_49_57hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (62, 29, N'20170618_02_49_57hmprod-(7).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (63, 28, N'20170618_02_49_57hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (64, 30, N'20170618_02_49_57hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (65, 28, N'20170618_02_49_57hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (66, 28, N'20170618_02_49_57light-blue.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (67, 29, N'20170618_02_49_57hmprod-(5).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (68, 29, N'20170618_02_49_57hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (69, 30, N'20170618_02_49_57hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (70, 31, N'20170618_02_54_09hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (71, 31, N'20170618_02_54_09hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (72, 31, N'20170618_02_54_091.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (73, 33, N'20170618_02_57_55hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (74, 32, N'20170618_02_57_55hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (75, 33, N'20170618_02_57_55hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (76, 32, N'20170618_02_57_55hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (77, 32, N'20170618_02_57_55hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (78, 33, N'20170618_02_57_55hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (79, 34, N'20170618_03_00_36hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (80, 34, N'20170618_03_00_36hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (81, 34, N'20170618_03_00_36hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (82, 35, N'20170618_03_06_28hmprod-(9).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (83, 36, N'20170618_03_06_28hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (84, 37, N'20170618_03_06_28hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (85, 35, N'20170618_03_06_28hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (86, 37, N'20170618_03_06_28hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (87, 36, N'20170618_03_06_28hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (88, 37, N'20170618_03_06_28hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (89, 36, N'20170618_03_06_28hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (90, 35, N'20170618_03_06_28hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (91, 38, N'20170618_03_10_38hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (92, 38, N'20170618_03_10_38hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (93, 39, N'20170618_03_10_38hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (94, 39, N'20170618_03_10_38hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (95, 38, N'20170618_03_10_38hmprod-(10).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (96, 39, N'20170618_03_10_38hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (97, 38, N'20170618_03_10_38hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (98, 40, N'20170618_03_14_39hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (99, 40, N'20170618_03_14_39hmprod-(1).jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (100, 40, N'20170618_03_14_39hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (101, 41, N'20170618_03_18_49hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (102, 41, N'20170618_03_18_49hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (103, 42, N'20170618_03_18_49hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (104, 42, N'20170618_03_18_49hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (105, 42, N'20170618_03_18_49hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (106, 41, N'20170618_03_18_49hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (107, 44, N'20170618_03_26_40hmprod-(12).jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (108, 46, N'20170618_03_26_40hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (109, 43, N'20170618_03_26_40hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (110, 44, N'20170618_03_26_40hmprod-(9).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (111, 44, N'20170618_03_26_40hmprod-(11).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (112, 45, N'20170618_03_26_40hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (113, 45, N'20170618_03_26_40hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (114, 43, N'20170618_03_26_40hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (115, 43, N'20170618_03_26_40hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (116, 44, N'20170618_03_26_40hmprod-(10).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (117, 46, N'20170618_03_26_40hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (118, 46, N'20170618_03_26_40hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (119, 45, N'20170618_03_26_40hmprod-(5).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (120, 47, N'20170618_03_32_24hmprod-(13).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (121, 49, N'20170618_03_32_24hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (122, 48, N'20170618_03_32_24hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (123, 48, N'20170618_03_32_24hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (124, 47, N'20170618_03_32_24hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (125, 48, N'20170618_03_32_24hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (126, 47, N'20170618_03_32_24hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (127, 49, N'20170618_03_32_24hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (128, 50, N'20170618_03_32_24hmprod-(11).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (129, 49, N'20170618_03_32_24hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (130, 50, N'20170618_03_32_24hmprod-(9).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (131, 50, N'20170618_03_32_24hmprod-(10).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (132, 47, N'20170618_03_32_24hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (133, 52, N'20170618_14_21_18hmprod-(12).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (134, 52, N'20170618_14_21_18hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (135, 52, N'20170618_14_21_18hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (136, 51, N'20170618_14_21_18hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (137, 51, N'20170618_14_21_18hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (138, 51, N'20170618_14_21_18hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (139, 53, N'20170618_14_26_16hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (140, 53, N'20170618_14_26_16hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (141, 53, N'20170618_14_26_16hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (142, 54, N'20170618_14_37_07hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (143, 54, N'20170618_14_37_07hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (144, 54, N'20170618_14_37_07hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (145, 55, N'20170618_14_43_00hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (146, 55, N'20170618_14_43_00hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (147, 55, N'20170618_14_43_00hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (148, 57, N'20170618_14_54_42hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (149, 56, N'20170618_14_54_42hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (150, 57, N'20170618_14_54_42hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (151, 56, N'20170618_14_54_42hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (152, 57, N'20170618_14_54_42hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (153, 56, N'20170618_14_54_42hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (154, 59, N'20170618_15_14_14hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (155, 60, N'20170618_15_14_14hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (156, 60, N'20170618_15_14_14hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (157, 60, N'20170618_15_14_14hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (158, 59, N'20170618_15_14_14hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (159, 59, N'20170618_15_14_14hmprod-(9).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (160, 58, N'20170618_15_14_14hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (161, 58, N'20170618_15_14_14hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (162, 58, N'20170618_15_14_14hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (163, 62, N'20170618_15_17_37gray-melange.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (164, 61, N'20170618_15_17_37hmprod-(10).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (165, 62, N'20170618_15_17_37hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (166, 62, N'20170618_15_17_37hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (167, 61, N'20170618_15_17_37hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (168, 61, N'20170618_15_17_37hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (169, 65, N'20170618_15_22_34hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (170, 63, N'20170618_15_22_34hmprod-(7).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (171, 65, N'20170618_15_22_34hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (172, 64, N'20170618_15_22_34hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (173, 63, N'20170618_15_22_34hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (174, 64, N'20170618_15_22_34hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (175, 63, N'20170618_15_22_34hmprod-(5).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (176, 65, N'20170618_15_22_34hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (177, 64, N'20170618_15_22_34hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (178, 66, N'20170618_15_27_25hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (179, 66, N'20170618_15_27_25hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (180, 66, N'20170618_15_27_25hmprod-(9).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (181, 68, N'20170618_15_38_29hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (182, 68, N'20170618_15_38_29hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (183, 69, N'20170618_15_38_29hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (184, 67, N'20170618_15_38_29hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (185, 68, N'20170618_15_38_29hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (186, 67, N'20170618_15_38_29hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (187, 69, N'20170618_15_38_29hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (188, 67, N'20170618_15_38_29hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (189, 69, N'20170618_15_38_29hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (190, 70, N'20170618_15_48_41hmprod-(9).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (191, 70, N'20170618_15_48_41hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (192, 71, N'20170618_15_48_41hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (193, 71, N'20170618_15_48_41hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (194, 71, N'20170618_15_48_41hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (195, 70, N'20170618_15_48_41hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (196, 72, N'20170623_15_32_09hmprod-(6).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (197, 73, N'20170623_15_32_09hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (198, 73, N'20170623_15_32_09hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (199, 72, N'20170623_15_32_09hmprod-(5).jpg', 1)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (200, 72, N'20170623_15_32_09hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (201, 73, N'20170623_15_32_09hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (202, 75, N'20170623_15_36_37hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (203, 75, N'20170623_15_36_37hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (204, 74, N'20170623_15_36_37hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (205, 74, N'20170623_15_36_37hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (206, 74, N'20170623_15_36_37hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (207, 75, N'20170623_15_36_37hmprod-(6).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (208, 76, N'20170623_15_39_50hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (209, 76, N'20170623_15_39_50hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (210, 76, N'20170623_15_39_50hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (211, 77, N'20170623_15_41_56hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (212, 77, N'20170623_15_41_56hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (213, 77, N'20170623_15_41_56hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (214, 78, N'20170623_15_45_19hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (215, 79, N'20170623_15_45_19hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (216, 79, N'20170623_15_45_19hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (217, 78, N'20170623_15_45_19hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (218, 78, N'20170623_15_45_19hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (219, 79, N'20170623_15_45_19hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (220, 81, N'20170623_15_52_12hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (221, 80, N'20170623_15_52_12hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (222, 80, N'20170623_15_52_12hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (223, 80, N'20170623_15_52_12hmprod-(6).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (224, 81, N'20170623_15_52_12hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (225, 81, N'20170623_15_52_12hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (226, 82, N'20170623_15_59_05hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (227, 85, N'20170623_15_59_05powder-pink.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (228, 82, N'20170623_15_59_05hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (229, 83, N'20170623_15_59_05hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (230, 85, N'20170623_15_59_05hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (231, 84, N'20170623_15_59_05hmprod-(8).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (232, 82, N'20170623_15_59_05hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (233, 85, N'20170623_15_59_05hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (234, 84, N'20170623_15_59_05yellow.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (235, 83, N'20170623_15_59_05hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (236, 83, N'20170623_15_59_05hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (237, 84, N'20170623_15_59_05yellow-1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (238, 86, N'20170623_16_06_51a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (239, 86, N'20170623_16_06_51hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (240, 86, N'20170623_16_06_51hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (241, 88, N'20170623_16_34_36a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (242, 88, N'20170623_16_34_36hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (243, 87, N'20170623_16_34_36aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (244, 88, N'20170623_16_34_36hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (245, 87, N'20170623_16_34_36hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (246, 87, N'20170623_16_34_36hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (247, 89, N'20170623_16_39_33hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (248, 89, N'20170623_16_39_33a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (249, 90, N'20170623_16_39_33hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (250, 90, N'20170623_16_39_33hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (251, 90, N'20170623_16_39_33hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (252, 89, N'20170623_16_39_33hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (253, 92, N'20170623_16_51_42hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (254, 92, N'20170623_16_51_42hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (255, 91, N'20170623_16_51_42a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (256, 91, N'20170623_16_51_42hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (257, 91, N'20170623_16_51_42hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (258, 92, N'20170623_16_51_42aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (259, 93, N'20170623_16_54_37hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (260, 93, N'20170623_16_54_37hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (261, 93, N'20170623_16_54_37a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (262, 93, N'20170623_16_54_37hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (263, 94, N'20170623_16_57_34hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (264, 94, N'20170623_16_57_34hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (265, 94, N'20170623_16_57_34hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (266, 94, N'20170623_16_57_34a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (267, 97, N'20170623_17_02_08hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (268, 97, N'20170623_17_02_08aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (269, 96, N'20170623_17_02_08a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (270, 95, N'20170623_17_02_08hmprod-(6).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (271, 95, N'20170623_17_02_08aaa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (272, 97, N'20170623_17_02_08hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (273, 96, N'20170623_17_02_08hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (274, 96, N'20170623_17_02_08hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (275, 95, N'20170623_17_02_08hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (276, 98, N'20170623_17_04_07hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (277, 98, N'20170623_17_04_07hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (278, 98, N'20170623_17_04_07a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (279, 99, N'20170623_17_06_59hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (280, 99, N'20170623_17_06_59hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (281, 99, N'20170623_17_06_59a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (282, 100, N'20170623_17_12_20hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (283, 101, N'20170623_17_12_20a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (284, 100, N'20170623_17_12_20hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (285, 100, N'20170623_17_12_20aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (286, 101, N'20170623_17_12_20hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (287, 101, N'20170623_17_12_20hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (288, 102, N'20170623_17_14_43hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (289, 102, N'20170623_17_14_43hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (290, 102, N'20170623_17_14_43a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (291, 103, N'20170623_17_17_34a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (292, 103, N'20170623_17_17_34hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (293, 103, N'20170623_17_17_34hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (294, 104, N'20170623_17_20_37a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (295, 105, N'20170623_17_20_37aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (296, 104, N'20170623_17_20_37hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (297, 105, N'20170623_17_20_37hmprod-(4).jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (298, 105, N'20170623_17_20_37hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (299, 104, N'20170623_17_20_37hmprod.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (300, 105, N'20170623_17_20_37hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (301, 106, N'20170623_17_23_20a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (302, 106, N'20170623_17_23_20hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (303, 106, N'20170623_17_23_20hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (304, 106, N'20170623_17_23_20hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (305, 107, N'20170623_17_25_02a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (306, 107, N'20170623_17_25_02hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (307, 107, N'20170623_17_25_02hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (308, 107, N'20170623_17_25_02hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (309, 108, N'20170623_17_27_42hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (310, 108, N'20170623_17_27_42hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (311, 108, N'20170623_17_27_42a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (312, 109, N'20170623_17_29_57hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (313, 109, N'20170623_17_29_57a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (314, 109, N'20170623_17_29_57hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (315, 110, N'20170623_17_32_54a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (316, 110, N'20170623_17_32_54hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (317, 110, N'20170623_17_32_54hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (318, 111, N'20170623_17_37_15a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (319, 111, N'20170623_17_37_15hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (320, 111, N'20170623_17_37_15hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (321, 112, N'20170623_17_39_17hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (322, 112, N'20170623_17_39_17hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (323, 112, N'20170623_17_39_17hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (324, 112, N'20170623_17_39_17a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (325, 113, N'20170623_17_40_45hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (326, 113, N'20170623_17_40_45a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (327, 113, N'20170623_17_40_45hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (328, 114, N'20170623_17_42_25a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (329, 114, N'20170623_17_42_25hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (330, 114, N'20170623_17_42_25hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (331, 116, N'20170623_17_47_47hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (332, 115, N'20170623_17_47_47hmprod-(5).jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (333, 115, N'20170623_17_47_47hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (334, 115, N'20170623_17_47_47hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (335, 116, N'20170623_17_47_47hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (336, 116, N'20170623_17_47_47hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (337, 116, N'20170623_17_47_47a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (338, 115, N'20170623_17_47_47aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (339, 117, N'20170623_17_54_05hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (340, 119, N'20170623_17_54_05hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (341, 118, N'20170623_17_54_05hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (342, 117, N'20170623_17_54_05a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (343, 117, N'20170623_17_54_05hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (344, 119, N'20170623_17_54_05hmprod-(5).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (345, 118, N'20170623_17_54_05hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (346, 120, N'20170623_17_56_50a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (347, 120, N'20170623_17_56_50hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (348, 120, N'20170623_17_56_50hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (349, 123, N'20170623_18_02_08a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (350, 122, N'20170623_18_02_08hmprod-(6).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (351, 123, N'20170623_18_02_08hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (352, 121, N'20170623_18_02_08hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (353, 121, N'20170623_18_02_08hmprod-(4).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (354, 123, N'20170623_18_02_08hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (355, 122, N'20170623_18_02_08hmprod-(7).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (356, 122, N'20170623_18_02_08hmprod-(8).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (357, 121, N'20170623_18_02_08hmprod-(5).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (358, 123, N'20170623_18_02_08hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (359, 124, N'20170623_18_04_21hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (360, 124, N'20170623_18_04_21a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (361, 124, N'20170623_18_04_21hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (362, 125, N'20170623_18_06_32a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (363, 125, N'20170623_18_06_32hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (364, 125, N'20170623_18_06_32hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (365, 126, N'20170623_18_17_31gj17sdr262-7-(1).jpeg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (366, 126, N'20170623_18_17_31gj17sdr262-4.jpeg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (367, 126, N'20170623_18_17_31gj17sdr262-6.jpeg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (368, 126, N'20170623_18_17_31a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (369, 127, N'20170623_18_20_47gj17sdr113-2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (370, 127, N'20170623_18_20_47gj17sdr113-4.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (371, 127, N'20170623_18_20_47gj17sdr113-3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (372, 128, N'20170623_18_23_41gj17sdr214-8.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (373, 128, N'20170623_18_23_41gj17sdr214-1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (374, 128, N'20170623_18_23_41gj17sdr214-3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (375, 128, N'20170623_18_23_41gj17sdr214-7.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (376, 129, N'20170623_18_29_10gj17sdr034_2_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (377, 129, N'20170623_18_29_10gj17sdr034_5_.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (378, 129, N'20170623_18_29_10gj17sdr034_1_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (379, 129, N'20170623_18_29_10gj17sdr034_3_.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (380, 130, N'20170623_18_33_47gj17spu067-4_1.jpeg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (381, 130, N'20170623_18_33_47gj17spu067-2_2.jpeg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (382, 130, N'20170623_18_33_47gj17spu067-3_1.jpeg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (383, 130, N'20170623_18_33_47gj17spu067-1_1.jpeg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (384, 131, N'20170707_14_28_22a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (385, 131, N'20170707_14_28_26g.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (386, 131, N'20170707_14_28_29light-pink.glitter.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (387, 132, N'20170707_14_02_10aa.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (388, 132, N'20170707_14_02_14hmprod-(2).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (389, 133, N'20170707_14_02_24a.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (390, 132, N'20170707_14_02_18hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (391, 133, N'20170707_14_02_30hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (392, 133, N'20170707_14_02_39hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (393, 134, N'20170707_13_59_44a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (394, 134, N'20170707_13_59_47hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (395, 134, N'20170707_13_59_51hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (396, 135, N'20170707_13_58_17c17wfta069__1_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (397, 135, N'20170707_13_58_22c17wfta069__2_.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (398, 135, N'20170707_13_58_27c17wfta069__3_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (399, 136, N'20170707_13_54_31c16wfdd054_1_.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (400, 136, N'20170707_13_54_36c16wfdd054_2_.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (401, 136, N'20170707_13_54_42c16wfdd054_3_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (402, 137, N'20170707_13_53_21c17sfde045_1__1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (403, 137, N'20170707_13_53_25c17sfde045_2__1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (404, 137, N'20170707_13_53_31c17sfde045_3__1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (405, 138, N'20170707_13_52_24c17sfde061_1_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (406, 138, N'20170707_13_52_29c17sfde061_2_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (407, 139, N'20170707_13_51_24c17sfde039_1__1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (408, 139, N'20170707_13_51_29c17sfde039_2_.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (409, 139, N'20170707_13_51_33c17sfde039_3_.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (410, 139, N'20170707_13_51_37c17sfde039_4_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (411, 140, N'20170704_01_41_31c17wfba072__1_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (412, 140, N'20170704_01_41_39c17wfba072__2_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (413, 140, N'20170704_01_41_450217000406217_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (414, 141, N'20170707_13_49_27c17sfte026_2_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (415, 142, N'20170707_13_49_44c17sfte026_1_.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (416, 141, N'20170707_13_49_35c17sfte026_3_-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (417, 142, N'20170707_13_49_50c17sfte026_4_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (418, 142, N'20170707_13_49_55c17sfte026_5_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (419, 143, N'20170707_13_46_44c17sfte021_2_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (420, 144, N'20170707_13_46_57c17sfte021_1_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (421, 143, N'20170707_13_46_49c17sfte021_3_.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (422, 144, N'20170707_13_47_03c17sfte021_4_.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (423, 146, N'20170704_01_40_13a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (424, 145, N'20170704_01_39_48aa.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (425, 145, N'20170704_01_39_54hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (426, 146, N'20170704_01_40_19hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (427, 145, N'20170704_01_39_59hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (428, 146, N'20170704_01_40_25hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (429, 147, N'20170707_14_27_17a.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (430, 147, N'20170707_14_27_20hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (431, 147, N'20170707_14_27_24hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (432, 148, N'20170707_14_25_02a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (433, 148, N'20170707_14_25_06hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (434, 148, N'20170707_14_25_13hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (435, 149, N'20170707_14_24_08a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (436, 149, N'20170707_14_24_13hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (437, 149, N'20170707_14_24_17hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (438, 150, N'20170707_14_22_07a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (439, 152, N'20170707_14_22_56aaa.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (440, 150, N'20170707_14_22_11hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (441, 151, N'20170707_14_22_39aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (442, 152, N'20170707_14_23_00gray-melange.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (443, 151, N'20170707_14_22_43hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (444, 150, N'20170707_14_22_32hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (445, 152, N'20170707_14_23_05hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (446, 151, N'20170707_14_22_47hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (447, 155, N'20170707_14_19_01aaa.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (448, 154, N'20170707_14_18_31aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (449, 154, N'20170707_14_18_39hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (450, 155, N'20170707_14_19_11hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (451, 154, N'20170707_14_18_43hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (452, 155, N'20170707_14_19_15dusky-pink.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (453, 153, N'20170707_14_18_05a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (454, 153, N'20170707_14_18_10hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (455, 156, N'20170707_14_12_31aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (456, 158, N'20170707_14_13_12natural-white.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (457, 157, N'20170707_14_12_48a.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (458, 158, N'20170707_14_13_16hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (459, 156, N'20170707_14_12_35dusky-green.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (460, 158, N'20170707_14_13_20aaa.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (461, 157, N'20170707_14_12_56hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (462, 156, N'20170707_14_12_41hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (463, 157, N'20170707_14_13_00hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (464, 159, N'20170707_14_35_17a.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (465, 159, N'20170707_14_35_21aa.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (466, 159, N'20170707_14_35_24natural-white.floral.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (467, 160, N'20170707_14_09_28a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (468, 160, N'20170707_14_09_32hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (469, 160, N'20170707_14_09_36hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (470, 162, N'20170704_01_36_08a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (471, 161, N'20170704_01_35_36hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (472, 161, N'20170704_01_35_41hmprod-(4).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (473, 161, N'20170704_01_35_56hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (474, 162, N'20170704_01_36_13hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (475, 162, N'20170704_01_36_17hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (476, 163, N'20170707_14_16_15a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (477, 163, N'20170707_14_16_20hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (478, 163, N'20170707_14_16_27hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (479, 164, N'20170707_14_15_20a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (480, 164, N'20170707_14_15_25hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (481, 164, N'20170707_14_15_30hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (482, 166, N'20170704_01_51_32aaa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (483, 167, N'20170704_01_51_46aa.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (484, 166, N'20170704_01_51_35black.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (485, 165, N'20170704_01_51_13a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (486, 167, N'20170704_01_51_51hmprod-(4).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (487, 165, N'20170704_01_51_19hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (488, 165, N'20170704_01_51_25vintage-pink.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (489, 166, N'20170704_01_51_39hmprod-(3).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (490, 167, N'20170704_01_51_57light-terracotta.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (491, 168, N'20170704_01_47_25a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (492, 168, N'20170704_01_47_30hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (493, 168, N'20170704_01_47_34hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (494, 169, N'20170704_01_33_06a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (495, 170, N'20170704_01_33_29aa.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (496, 170, N'20170704_01_33_38hmprod-(3).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (497, 169, N'20170704_01_33_13hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (498, 170, N'20170704_01_33_43hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (499, 169, N'20170704_01_33_20hmprod.jpg', 2)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (500, 171, N'20170704_01_31_37hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (501, 171, N'20170704_01_31_42hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (502, 171, N'20170704_01_31_55hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (503, 172, N'20170704_01_46_22a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (504, 172, N'20170704_01_46_26hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (505, 172, N'20170704_01_46_30hmprod.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (506, 173, N'20170704_01_45_42a.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (507, 173, N'20170704_01_45_45hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (508, 173, N'20170704_01_45_50hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (509, 174, N'20170704_01_44_41hmprod-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (510, 174, N'20170704_01_44_47a.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (511, 174, N'20170704_01_44_52hmprod-(2).jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (512, 174, N'20170704_01_44_58hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (513, 175, N'20170704_01_43_33a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (514, 175, N'20170704_01_43_38hmprod-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (515, 175, N'20170704_01_43_43hmprod.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (516, 176, N'20170704_01_25_24a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (517, 176, N'20170704_01_25_09hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (518, 177, N'20170704_01_25_38aa.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (519, 177, N'20170704_01_25_57hmprod-(3).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (520, 177, N'20170704_01_25_51hmprod-(2).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (521, 176, N'20170704_01_25_16hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (522, 178, N'20170707_14_04_52a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (523, 178, N'20170707_14_04_55hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (524, 178, N'20170707_14_05_00hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (525, 179, N'20170703_20_57_53hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (526, 179, N'20170703_20_57_53hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (527, 179, N'20170703_20_57_53a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (528, 180, N'20170704_01_21_36hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (529, 180, N'20170704_01_21_36a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (530, 180, N'20170704_01_21_36hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (531, 181, N'20170704_01_56_56hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (532, 181, N'20170704_01_56_56hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (533, 181, N'20170704_01_56_56a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (534, 182, N'20170704_01_58_30hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (535, 182, N'20170704_01_58_30hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (536, 182, N'20170704_01_58_30a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (537, 183, N'20170704_02_00_29a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (538, 183, N'20170704_02_00_29hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (539, 183, N'20170704_02_00_29hmprod-(2).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (540, 183, N'20170704_02_00_29hmprod.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (541, 184, N'20170704_02_05_12a.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (542, 184, N'20170704_02_05_12hmprod-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (543, 184, N'20170704_02_05_12hmprod.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (544, 153, N'20170707_14_18_20natural-white.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (545, 185, N'20170707_14_40_22ts05a43mwht_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (546, 185, N'20170707_14_40_22ts05a43mwht_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (547, 185, N'20170707_14_40_22ts05a43mwht_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (548, 186, N'20170707_14_44_23ts16k03mmon_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (549, 186, N'20170707_14_44_23ts16k03mmon_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (550, 186, N'20170707_14_44_23ts16k03mmon_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (551, 186, N'20170707_14_44_23ts16k03mmon_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (552, 187, N'20170707_14_47_40ts16k01lmon_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (553, 187, N'20170707_14_47_40ts16k01lmon_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (554, 187, N'20170707_14_47_40ts16k01lmon_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (555, 187, N'20170707_14_47_40ts16k01lmon_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (556, 188, N'20170707_14_51_39ts16t02mmon_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (557, 188, N'20170707_14_51_40ts16t02mmon_zoom_m_3.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (558, 188, N'20170707_14_51_39ts16t02mmon_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (559, 188, N'20170707_14_51_40ts16t02mmon_zoom_m_4.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (560, 189, N'20170707_14_57_44ts16k14lppk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (561, 189, N'20170707_14_57_44ts16k14lppk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (562, 189, N'20170707_14_57_44ts16k14lppk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (563, 189, N'20170707_14_57_44ts16k14lppk_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (564, 190, N'20170707_14_59_43ts16m21lble_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (565, 190, N'20170707_14_59_43ts16m21lble_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (566, 190, N'20170707_14_59_43ts16m21lble_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (567, 190, N'20170707_14_59_43ts16m21lble_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (568, 191, N'20170707_15_02_39ts36d02mivr_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (569, 191, N'20170707_15_02_39ts36d02mivr_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (570, 191, N'20170707_15_02_39ts36d02mivr_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (571, 191, N'20170707_15_02_39ts36d02mivr_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (572, 192, N'20170708_13_56_12ts05b99mmdt_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (573, 192, N'20170708_13_56_16ts05b99mmdt_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (574, 192, N'20170708_13_56_21ts05b99mmdt_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (575, 193, N'20170708_13_55_21ts26s04llil_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (576, 193, N'20170708_13_55_25ts26s04llil_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (577, 193, N'20170708_13_55_30ts26s04llil_zoom_m_4.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (578, 193, N'20170708_13_55_36ts26s04llil_zoom_f_1.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (579, 194, N'20170708_13_53_44ts36h01lmnt_zoom_m_1.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (580, 194, N'20170708_13_53_48ts36h01lmnt_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (581, 194, N'20170708_13_53_54ts36h01lmnt_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (582, 194, N'20170708_13_53_58ts36h01lmnt_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (583, 195, N'20170708_13_51_59ts62z12lmul_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (584, 195, N'20170708_13_52_03ts62z12lmul_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (585, 195, N'20170708_13_52_06ts62z12lmul_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (586, 196, N'20170708_13_51_09ts36h01lnav_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (587, 196, N'20170708_13_51_16ts36h01lnav_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (588, 196, N'20170708_13_51_21ts36h01lnav_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (589, 196, N'20170708_13_51_26ts36h01lnav_zoom_m_4.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (590, 197, N'20170708_13_50_20ts14c03lble_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (591, 197, N'20170708_13_50_23ts14c03lble_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (592, 197, N'20170708_13_50_27ts14c03lble_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (593, 197, N'20170708_13_50_31ts14c03lble_zoom_m_4.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (594, 198, N'20170708_13_48_37ts62f22lblk_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (595, 198, N'20170708_13_48_41ts62f22lblk_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (596, 198, N'20170708_13_48_45ts62f22lblk_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (597, 199, N'20170708_13_47_27ts26s20lblk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (598, 199, N'20170708_13_47_30ts26s20lblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (599, 199, N'20170708_13_47_35ts26s20lblk_zoom_m_2.jpg', 3)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (600, 199, N'20170708_13_47_39ts26s20lblk_zoom_m_3.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (601, 200, N'20170708_13_46_29ts05a38mwbk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (602, 200, N'20170708_13_46_33ts05a38mwbk_zoom_m_3.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (603, 200, N'20170708_13_46_38ts05a38mwbk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (604, 201, N'20170708_13_45_30ts16k15lblk_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (605, 201, N'20170708_13_45_34ts16k15lblk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (606, 201, N'20170708_13_45_38ts16k15lblk_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (607, 201, N'20170708_13_45_43ts16k15lblk_zoom_m_3.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (608, 202, N'20170708_13_44_29ts36f01mred_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (609, 202, N'20170708_13_44_33ts36f01mred_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (610, 202, N'20170708_13_44_37ts36f01mred_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (611, 203, N'20170708_13_43_25ts16k05mblk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (612, 203, N'20170708_13_43_28ts16k05mblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (613, 203, N'20170708_13_43_37ts16k05mblk_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (614, 204, N'20170708_13_42_21ts16m06mcrm_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (615, 204, N'20170708_13_42_25ts16m06mcrm_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (616, 204, N'20170708_13_42_29ts16m06mcrm_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (617, 205, N'20170708_13_40_36ts14p19lble_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (618, 205, N'20170708_13_40_43ts14p19lble_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (619, 205, N'20170708_13_40_46ts14p19lble_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (620, 205, N'20170708_13_40_52ts14p19lble_zoom_m_3.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (621, 206, N'20170708_13_40_00ts36p01mcor_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (622, 206, N'20170708_13_40_03ts36p01mcor_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (623, 206, N'20170708_13_40_07ts36p01mcor_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (624, 206, N'20170708_13_40_12ts36p01mcor_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (625, 207, N'20170708_13_39_24ts14p01mmon_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (626, 207, N'20170708_13_39_27ts14p01mmon_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (627, 207, N'20170708_13_39_31ts14p01mmon_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (628, 207, N'20170708_13_39_35ts14p01mmon_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (629, 208, N'20170708_13_38_18ts36j01mtom_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (630, 208, N'20170708_13_38_21ts36j01mtom_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (631, 208, N'20170708_13_38_25ts36j01mtom_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (632, 208, N'20170708_13_38_30ts36j01mtom_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (633, 209, N'20170708_13_37_23ts14p02mkha_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (634, 209, N'20170708_13_37_29ts14p02mkha_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (635, 209, N'20170708_13_37_35ts14p02mkha_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (636, 209, N'20170708_13_37_39ts14p02mkha_zoom_m_3.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (637, 210, N'20170708_13_36_24ts16w07mcrm_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (638, 210, N'20170708_13_36_28ts16w07mcrm_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (639, 210, N'20170708_13_36_33ts16w07mcrm_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (640, 210, N'20170708_13_36_38ts16w07mcrm_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (641, 211, N'20170708_13_35_16ts16w01mpbl_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (642, 211, N'20170708_13_35_20ts16w01mpbl_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (643, 211, N'20170708_13_35_26ts16w01mpbl_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (644, 211, N'20170708_13_35_30ts16w01mpbl_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (645, 212, N'20170708_13_34_10ts12x39lmul_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (646, 212, N'20170708_13_34_13ts12x39lmul_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (647, 212, N'20170708_13_34_22ts12x39lmul_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (648, 212, N'20170708_13_34_26ts12x39lmul_zoom_m_3.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (649, 213, N'20170708_13_33_33ts62r20lcrm_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (650, 213, N'20170708_13_33_36ts62r20lcrm_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (651, 213, N'20170708_13_33_42ts62r20lcrm_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (652, 214, N'20170708_13_32_51ts12o38lnav_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (653, 214, N'20170708_13_32_55ts12o38lnav_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (654, 214, N'20170708_13_33_02ts12o38lnav_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (655, 215, N'20170708_13_32_01ts62f25lcrm_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (656, 215, N'20170708_13_32_04ts62f25lcrm_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (657, 215, N'20170708_13_32_08ts62f25lcrm_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (658, 216, N'20170708_13_22_12ts36p02mivr_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (659, 216, N'20170708_13_22_15ts36p02mivr_zoom_m_1.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (660, 216, N'20170708_13_22_19ts36p02mivr_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (661, 216, N'20170708_13_22_23ts36p02mivr_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (662, 217, N'20170708_13_20_30ts32j11mslv_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (663, 217, N'20170708_13_20_34ts32j11mslv_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (664, 217, N'20170708_13_20_38ts32j11mslv_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (665, 218, N'20170708_13_19_55ts32l18lblk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (666, 218, N'20170708_13_19_59ts32l18lblk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (667, 218, N'20170708_13_20_04ts32l18lblk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (668, 219, N'20170708_13_19_04ts32n47lwht_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (669, 219, N'20170708_13_19_07ts32n47lwht_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (670, 219, N'20170708_13_19_10ts32n47lwht_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (671, 220, N'20170708_13_18_29ts32l18lblk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (672, 220, N'20170708_13_18_34ts32l18lblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (673, 220, N'20170708_13_18_38ts32l18lblk_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (674, 221, N'20170708_13_17_46ts42m51lmul_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (675, 221, N'20170708_13_17_49ts42m51lmul_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (676, 221, N'20170708_13_17_54ts42m51lmul_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (677, 222, N'20170707_19_35_03ts32l14lnud_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (678, 222, N'20170707_19_35_03ts32l14lnud_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (679, 222, N'20170707_19_35_03ts32l14lnud_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (680, 224, N'20170708_13_16_48ts42m44lnud_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (681, 225, N'20170708_13_17_03ts42m45lblk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (682, 224, N'20170708_13_16_51ts42m44lnud_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (683, 223, N'20170708_13_16_35ts42m46lred_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (684, 225, N'20170708_13_17_06ts42m45lblk_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (685, 225, N'20170708_13_17_10ts42m45lblk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (686, 223, N'20170708_13_16_38ts42m46lred_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (687, 223, N'20170708_13_16_42ts42m46lred_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (688, 224, N'20170708_13_16_55ts42m44lnud_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (689, 226, N'20170708_13_15_42ts42m39lgry_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (690, 226, N'20170708_13_15_45ts42m39lgry_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (691, 226, N'20170708_13_15_50ts42m39lgry_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (692, 227, N'20170708_13_14_14ts42b15ltpe_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (693, 227, N'20170708_13_14_19ts42b15ltpe_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (694, 227, N'20170708_13_14_25ts42b15ltpe_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (695, 228, N'20170708_13_13_25ts32m20mred_zoom_f_1-(1).jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (696, 228, N'20170708_13_13_29ts32m20mred_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (697, 228, N'20170708_13_13_33ts32m20mred_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (698, 230, N'20170707_19_53_04ts32m10mple_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (699, 229, N'20170708_13_12_49ts32m10mslv_zoom_f_1.jpg', 0)
GO
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (700, 229, N'20170708_13_12_52ts32m10mslv_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (701, 230, N'20170707_19_53_04ts32m10mple_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (702, 230, N'20170707_19_53_04ts32m10mple_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (703, 229, N'20170708_13_12_57ts32m10mslv_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (704, 232, N'20170708_13_11_49ts32h15mkha_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (705, 232, N'20170708_13_11_53ts32h15mkha_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (706, 231, N'20170708_13_11_34ts32h15mblk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (707, 231, N'20170708_13_11_37ts32h15mblk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (708, 232, N'20170708_13_11_58ts32h15mkha_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (709, 231, N'20170708_13_11_42ts32h15mblk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (710, 233, N'20170708_13_10_19ts32m16mylw_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (711, 233, N'20170708_13_10_23ts32m16mylw_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (712, 233, N'20170708_13_10_26ts32m16mylw_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (713, 234, N'20170708_13_09_16ts32m22mpnk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (714, 235, N'20170707_20_03_15ts32m22mblk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (715, 234, N'20170708_13_09_20ts32m22mpnk_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (716, 234, N'20170708_13_09_24ts32m22mpnk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (717, 235, N'20170707_20_03_15ts32m22mblk_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (718, 235, N'20170707_20_03_15ts32m22mblk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (719, 236, N'20170708_13_08_19ts32m22mwht_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (720, 236, N'20170708_13_08_23ts32m22mwht_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (721, 236, N'20170708_13_08_29ts32m22mwht_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (722, 237, N'20170708_13_07_10ts32b03mblk_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (723, 238, N'20170708_13_07_25ts32b03mkha_zoom_f_1-(1).jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (724, 237, N'20170708_13_07_14ts32b03mblk_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (725, 238, N'20170708_13_07_28ts32b03mkha_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (726, 237, N'20170708_13_07_18ts32b03mblk_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (727, 238, N'20170708_13_07_35ts32b03mkha_zoom_m_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (728, 239, N'20170708_13_06_25ts42b29kblk_zoom_m_1-(1).jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (729, 239, N'20170708_13_06_28ts42b29kblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (730, 239, N'20170708_13_06_32ts42b29kblk_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (731, 240, N'20170708_13_04_49ts42k04kblk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (732, 240, N'20170708_13_04_53ts42k04kblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (733, 240, N'20170708_13_04_58ts42k04kblk_zoom_m_2.jpg', 3)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (734, 240, N'20170708_13_05_02ts42k04kblk_zoom_m_3.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (735, 241, N'20170708_13_03_37ts32f49lred_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (736, 241, N'20170708_13_03_41ts32f49lred_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (737, 241, N'20170708_13_03_45ts32f49lred_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (738, 242, N'20170708_13_02_49ts42a08mred_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (739, 242, N'20170708_13_02_53ts42a08mred_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (740, 242, N'20170708_13_02_58ts42a08mred_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (741, 243, N'20170708_13_01_34ts32k24lblk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (742, 243, N'20170708_13_01_41ts32k24lblk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (743, 244, N'20170708_13_02_09ts32k24lwht_zoom_f_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (744, 244, N'20170708_13_02_13ts32k24lwht_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (745, 243, N'20170708_13_01_46ts32k24lblk_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (746, 244, N'20170708_13_02_18ts32k24lwht_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (747, 245, N'20170707_21_58_34ts42a08mwht_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (748, 245, N'20170707_21_58_38ts42a08mwht_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (749, 245, N'20170707_21_58_43ts42a08mwht_zoom_m_2.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (750, 246, N'20170707_21_51_23ts32j27lsge_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (751, 246, N'20170707_21_51_34ts32j27lsge_zoom_m_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (752, 246, N'20170707_21_51_39ts32j27lsge_zoom_m_2.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (753, 247, N'20170707_21_49_52ts32j36mpnk_zoom_f_1.jpg', 0)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (754, 247, N'20170707_21_49_56ts32j36mpnk_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (755, 247, N'20170707_21_50_01ts32j36mpnk_zoom_m_2.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (756, 248, N'20170707_21_49_09ts32r57lmul_zoom_f_1.jpg', 1)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (757, 248, N'20170707_21_49_14ts32r57lmul_zoom_m_1.jpg', 2)
INSERT [dbo].[productSubImgs] ([subImgID], [colorID], [urlImg], [subImgOrder]) VALUES (758, 248, N'20170707_21_49_18ts32r57lmul_zoom_m_2.jpg', 0)
SET IDENTITY_INSERT [dbo].[productSubImgs] OFF
GO

--INSERT PRODUCT SIZEBYCOLOR
SET IDENTITY_INSERT [dbo].[sizesByColor] ON 
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (1, 1, N'M', 10, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (2, 1, N'S', 10, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (3, 3, N'M', 10, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (4, 2, N'S', 10, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (5, 3, N'S', 10, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (6, 2, N'M', 10, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (7, 3, N'L', 10, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (8, 1, N'L', 5, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (9, 2, N'L', 6, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (10, 4, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (11, 4, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (12, 4, N'L', 70, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (13, 5, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (14, 10, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (15, 7, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (16, 8, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (17, 6, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (18, 9, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (19, 11, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (20, 11, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (21, 11, N'L', 70, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (22, 14, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (23, 12, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (24, 13, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (25, 13, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (26, 12, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (27, 14, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (28, 12, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (29, 14, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (30, 13, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (31, 12, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (32, 13, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (33, 14, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (34, 16, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (35, 15, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (36, 16, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (37, 16, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (38, 15, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (39, 15, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (40, 19, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (41, 17, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (42, 18, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (43, 19, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (44, 18, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (45, 17, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (46, 18, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (47, 19, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (48, 18, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (49, 17, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (50, 19, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (51, 17, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (52, 20, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (53, 22, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (54, 21, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (55, 20, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (56, 20, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (57, 21, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (58, 22, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (59, 22, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (60, 21, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (61, 23, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (62, 23, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (63, 23, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (64, 24, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (65, 25, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (66, 25, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (67, 24, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (68, 25, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (69, 24, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (70, 26, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (71, 27, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (72, 29, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (73, 30, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (74, 30, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (75, 29, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (76, 28, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (77, 28, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (78, 30, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (79, 28, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (80, 29, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (81, 31, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (82, 31, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (83, 31, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (84, 31, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (85, 32, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (86, 33, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (87, 32, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (88, 32, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (89, 33, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (90, 33, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (91, 32, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (92, 33, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (93, 34, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (94, 34, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (95, 34, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (96, 35, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (97, 36, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (98, 37, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (99, 39, N'L', 100, 2, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (100, 38, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (101, 38, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (102, 39, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (103, 38, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (104, 39, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (105, 40, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (106, 40, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (107, 40, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (108, 42, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (109, 41, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (110, 43, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (111, 46, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (112, 45, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (113, 44, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (114, 47, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (115, 50, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (116, 49, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (117, 48, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (118, 52, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (119, 51, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (120, 52, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (121, 51, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (122, 51, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (123, 52, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (124, 53, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (125, 53, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (126, 53, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (127, 53, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (128, 54, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (129, 54, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (130, 54, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (131, 54, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (132, 55, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (133, 55, N'L', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (134, 55, N'S', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (135, 55, N'XS', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (136, 57, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (137, 56, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (138, 56, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (139, 57, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (140, 57, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (141, 56, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (142, 58, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (143, 60, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (144, 59, N'FREE', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (145, 62, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (146, 61, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (147, 62, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (148, 61, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (149, 61, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (150, 62, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (151, 63, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (152, 63, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (153, 65, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (154, 65, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (155, 64, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (156, 65, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (157, 63, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (158, 64, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (159, 64, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (160, 66, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (161, 66, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (162, 66, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (163, 67, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (164, 69, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (165, 68, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (166, 68, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (167, 69, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (168, 67, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (169, 68, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (170, 67, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (171, 69, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (172, 70, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (173, 70, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (174, 71, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (175, 70, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (176, 71, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (177, 71, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (178, 72, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (179, 72, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (180, 72, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (181, 73, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (182, 73, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (183, 73, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (184, 74, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (185, 75, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (186, 74, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (187, 75, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (188, 74, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (189, 75, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (190, 76, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (191, 76, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (192, 76, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (193, 77, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (194, 77, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (195, 77, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (196, 78, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (197, 79, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (198, 78, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (199, 78, N'M', 100, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (200, 79, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (201, 79, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (202, 80, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (203, 81, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (204, 81, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (205, 81, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (206, 80, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (207, 80, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (208, 82, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (209, 83, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (210, 84, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (211, 84, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (212, 82, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (213, 83, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (214, 84, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (215, 85, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (216, 85, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (217, 83, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (218, 82, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (219, 85, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (220, 86, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (221, 86, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (222, 86, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (223, 88, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (224, 87, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (225, 88, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (226, 88, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (227, 87, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (228, 87, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (229, 89, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (230, 90, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (231, 89, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (232, 90, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (233, 89, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (234, 90, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (235, 92, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (236, 92, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (237, 92, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (238, 91, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (239, 91, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (240, 91, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (241, 93, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (242, 93, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (243, 93, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (244, 94, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (245, 94, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (246, 94, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (247, 96, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (248, 97, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (249, 95, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (250, 97, N'M', 10, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (251, 97, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (252, 95, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (253, 96, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (254, 95, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (255, 96, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (256, 98, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (257, 98, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (258, 98, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (259, 99, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (260, 99, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (261, 99, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (262, 101, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (263, 101, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (264, 100, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (265, 100, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (266, 101, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (267, 100, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (268, 102, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (269, 102, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (270, 102, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (271, 103, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (272, 103, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (273, 103, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (274, 105, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (275, 104, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (276, 105, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (277, 105, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (278, 104, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (279, 104, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (280, 106, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (281, 106, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (282, 106, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (283, 107, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (284, 107, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (285, 107, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (286, 108, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (287, 108, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (288, 108, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (289, 109, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (290, 109, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (291, 109, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (292, 110, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (293, 110, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (294, 110, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (295, 111, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (296, 111, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (297, 111, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (298, 112, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (299, 112, N'S', 100, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (300, 112, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (301, 113, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (302, 113, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (303, 113, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (304, 114, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (305, 114, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (306, 114, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (307, 116, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (308, 115, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (309, 115, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (310, 116, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (311, 115, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (312, 116, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (313, 118, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (314, 119, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (315, 118, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (316, 119, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (317, 119, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (318, 117, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (319, 117, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (320, 118, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (321, 117, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (322, 120, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (323, 120, N'M', 10, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (324, 120, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (325, 121, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (326, 121, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (327, 121, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (328, 122, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (329, 122, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (330, 123, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (331, 123, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (332, 122, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (333, 123, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (334, 124, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (335, 124, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (336, 124, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (337, 125, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (338, 125, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (339, 125, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (340, 126, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (341, 126, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (342, 126, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (343, 127, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (344, 127, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (345, 127, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (346, 128, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (347, 128, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (348, 128, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (349, 129, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (350, 129, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (351, 129, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (352, 130, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (353, 130, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (354, 130, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (355, 131, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (356, 131, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (357, 131, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (358, 132, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (359, 132, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (360, 133, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (361, 132, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (362, 133, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (363, 133, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (364, 134, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (365, 134, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (366, 134, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (367, 135, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (368, 135, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (369, 135, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (370, 136, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (371, 136, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (372, 137, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (373, 137, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (374, 137, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (375, 138, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (376, 138, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (377, 138, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (378, 139, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (379, 139, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (380, 139, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (381, 140, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (382, 140, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (383, 140, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (384, 141, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (385, 141, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (386, 142, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (387, 142, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (388, 141, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (389, 142, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (390, 143, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (391, 144, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (392, 144, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (393, 143, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (394, 144, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (395, 143, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (396, 146, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (397, 145, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (398, 145, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (399, 146, N'M', 100, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (400, 146, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (401, 145, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (402, 147, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (403, 147, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (404, 147, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (405, 148, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (406, 148, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (407, 148, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (408, 149, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (409, 149, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (410, 149, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (411, 150, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (412, 151, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (413, 152, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (414, 151, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (415, 152, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (416, 151, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (417, 150, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (418, 152, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (419, 150, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (420, 153, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (421, 154, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (422, 155, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (423, 153, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (424, 154, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (425, 153, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (426, 155, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (427, 154, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (428, 155, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (429, 158, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (430, 158, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (431, 157, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (432, 156, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (433, 157, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (434, 156, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (435, 156, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (436, 158, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (437, 157, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (438, 159, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (439, 159, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (440, 159, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (441, 160, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (442, 160, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (443, 160, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (444, 162, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (445, 161, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (446, 162, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (447, 161, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (448, 161, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (449, 162, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (450, 163, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (451, 163, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (452, 163, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (453, 164, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (454, 164, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (455, 164, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (456, 167, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (457, 165, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (458, 167, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (459, 166, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (460, 166, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (461, 165, N'M', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (462, 166, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (463, 165, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (464, 167, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (465, 168, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (466, 168, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (467, 168, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (468, 170, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (469, 170, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (470, 169, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (471, 169, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (472, 170, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (473, 169, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (474, 171, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (475, 171, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (476, 171, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (477, 172, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (478, 172, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (479, 172, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (480, 173, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (481, 173, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (482, 173, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (483, 174, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (484, 174, N'S', 10, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (485, 174, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (486, 175, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (487, 175, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (488, 175, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (489, 177, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (490, 176, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (491, 177, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (492, 176, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (493, 177, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (494, 176, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (495, 178, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (496, 178, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (497, 178, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (498, 179, N'L', 40, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (499, 179, N'M', 40, 1, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (500, 179, N'S', 40, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (501, 180, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (502, 180, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (503, 180, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (504, 181, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (505, 181, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (506, 181, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (507, 182, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (508, 182, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (509, 182, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (510, 183, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (511, 183, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (512, 183, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (513, 184, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (514, 184, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (515, 184, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (516, 185, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (517, 185, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (518, 185, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (519, 186, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (520, 186, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (521, 186, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (522, 187, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (523, 187, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (524, 187, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (525, 188, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (526, 188, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (527, 188, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (528, 189, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (529, 189, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (530, 189, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (531, 190, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (532, 190, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (533, 190, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (534, 191, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (535, 191, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (536, 191, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (537, 192, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (538, 192, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (539, 192, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (540, 193, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (541, 193, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (542, 193, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (543, 194, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (544, 194, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (545, 194, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (546, 195, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (547, 195, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (548, 195, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (549, 196, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (550, 196, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (551, 196, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (552, 197, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (553, 197, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (554, 197, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (555, 198, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (556, 198, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (557, 198, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (558, 199, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (559, 199, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (560, 199, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (561, 200, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (562, 200, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (563, 200, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (564, 201, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (565, 201, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (566, 201, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (567, 202, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (568, 202, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (569, 202, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (570, 203, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (571, 203, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (572, 203, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (573, 204, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (574, 204, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (575, 204, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (576, 205, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (577, 205, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (578, 205, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (579, 206, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (580, 206, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (581, 206, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (582, 207, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (583, 207, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (584, 207, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (585, 208, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (586, 208, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (587, 208, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (588, 209, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (589, 209, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (590, 209, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (591, 210, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (592, 210, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (593, 210, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (594, 211, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (595, 211, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (596, 211, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (597, 212, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (598, 212, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (599, 212, N'S', 100, 0, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (600, 213, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (601, 213, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (602, 213, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (603, 214, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (604, 214, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (605, 214, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (606, 215, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (607, 215, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (608, 215, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (609, 216, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (610, 216, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (611, 216, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (612, 217, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (613, 217, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (614, 217, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (615, 217, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (616, 218, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (617, 218, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (618, 218, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (619, 218, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (620, 219, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (621, 219, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (622, 219, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (623, 220, N'L', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (624, 220, N'M', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (625, 220, N'S', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (626, 221, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (627, 221, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (628, 221, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (629, 221, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (630, 222, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (631, 222, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (632, 222, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (633, 222, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (634, 225, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (635, 223, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (636, 224, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (637, 224, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (638, 225, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (639, 225, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (640, 223, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (641, 224, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (642, 223, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (643, 225, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (644, 224, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (645, 223, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (646, 226, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (647, 226, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (648, 226, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (649, 226, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (650, 227, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (651, 227, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (652, 227, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (653, 227, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (654, 228, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (655, 228, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (656, 228, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (657, 228, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (658, 230, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (659, 229, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (660, 229, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (661, 229, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (662, 230, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (663, 229, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (664, 230, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (665, 230, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (666, 232, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (667, 231, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (668, 231, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (669, 232, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (670, 232, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (671, 231, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (672, 231, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (673, 232, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (674, 233, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (675, 233, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (676, 233, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (677, 233, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (678, 235, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (679, 235, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (680, 234, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (681, 235, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (682, 234, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (683, 234, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (684, 234, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (685, 235, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (686, 236, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (687, 236, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (688, 236, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (689, 236, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (690, 237, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (691, 238, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (692, 238, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (693, 237, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (694, 238, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (695, 237, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (696, 237, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (697, 238, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (698, 239, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (699, 239, N'39', 100, 3, 1)
GO
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (700, 239, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (701, 239, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (702, 240, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (703, 240, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (704, 240, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (705, 240, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (706, 241, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (707, 241, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (708, 241, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (709, 241, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (710, 242, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (711, 242, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (712, 242, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (713, 242, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (714, 243, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (715, 244, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (716, 244, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (717, 243, N'38', 10, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (718, 243, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (719, 244, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (720, 243, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (721, 244, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (722, 245, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (723, 245, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (724, 245, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (725, 245, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (726, 246, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (727, 246, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (728, 246, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (729, 246, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (730, 247, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (731, 247, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (732, 247, N'39', 100, 3, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (733, 247, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (734, 248, N'36', 100, 0, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (735, 248, N'37', 100, 1, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (736, 248, N'38', 100, 2, 1)
INSERT [dbo].[sizesByColor] ([sizeID], [colorID], [size], [quantity], [sizeOrder], [status]) VALUES (737, 248, N'39', 100, 3, 1)
SET IDENTITY_INSERT [dbo].[sizesByColor] OFF
GO

--INSERT RATING
SET IDENTITY_INSERT [dbo].[productRating] ON 
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (1, 2, 17, 3, CAST(N'2017-05-18' AS Date), N'That''s the best Product that i had ever seen!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (2, 2, 10, 5, CAST(N'2017-05-19' AS Date), N'It''s Awesome.', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (3, 2, 5, 1, CAST(N'2017-05-19' AS Date), N'I will buy it for my husband!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (4, 2, 7, 2, CAST(N'2017-05-19' AS Date), N'I don''t think it is the best product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (5, 2, 6, 5, CAST(N'2017-05-19' AS Date), N'That product must be voted for 5 Stars', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (6, 4, 10, 3, CAST(N'2017-05-19' AS Date), N'Here is the first review for this product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (7, 17, 17, 1, CAST(N'2017-05-19' AS Date), N'This product is too expensive!!!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (8, 2, 8, 5, CAST(N'2017-05-19' AS Date), N'Haha, Bruce Wayne will buy this product!', 0)
GO
INSERT [dbo].[productRating] ([ratingID], [productID], [userID], [rating], [ratingDate], [review], [status]) VALUES (9, 32, 17, 5, CAST(N'2017-05-19' AS Date), N'It''s beautiful, I Will buy it for my wife.', 0)
GO
SET IDENTITY_INSERT [dbo].[productRating] OFF
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU01', 20, 20, NULL, NULL, N'discount 20%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU02', 15, 100, CAST(N'2017-04-30' AS Date), CAST(N'2017-05-01' AS Date), N'discount 15%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU03', 10, 50, CAST(N'2017-05-01' AS Date), CAST(N'2017-05-31' AS Date), N'discount 10%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU04', 5, 200, CAST(N'2017-06-01' AS Date), CAST(N'2017-06-30' AS Date), N'discount 5%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU05', 50, 0, CAST(N'2017-05-01' AS Date), CAST(N'2017-05-31' AS Date), N'discount 50%')
GO
INSERT [dbo].[discountVoucher] ([voucherID], [discount], [quantity], [beginDate], [endDate], [description]) VALUES (N'VOU06', 70, 0, NULL, NULL, N'discount 70%')
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (1, 5, CAST(N'2017-05-01 09:12:22.290' AS DateTime), N'Laurel', N'Lance', N'0168726543', N'District 1, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (2, 6, CAST(N'2017-05-01 10:18:47.800' AS DateTime), N'Oliver', N'Queen', N'0918727328', N'Thu Duc District, Ho Chi Minh City', NULL, NULL, 3)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (3, 7, CAST(N'2017-05-01 11:20:39.293' AS DateTime), N'Barry', N'Allen', N'0967827631', N'District 8, Ho Chi Minh City', NULL, NULL, 3)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (4, 9, CAST(N'2017-05-01 12:21:12.223' AS DateTime), N'Luke', N'Cage', N'0987264813', N'District 5, Ho Chi Minh City', NULL, NULL, 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (5, 10, CAST(N'2017-05-01 13:22:38.497' AS DateTime), N'Clark', N'Kent', N'0128736817', N'Tan Binh District, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (6, 8, CAST(N'2017-05-01 14:23:17.583' AS DateTime), N'Bruce', N'Wayne', N'0188726813', N'District 3, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (7, 13, CAST(N'2017-05-01 15:23:49.050' AS DateTime), N'Tim', N'Drake', N'0935124897', N'District 4, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (8, 16, CAST(N'2017-05-01 16:25:23.120' AS DateTime), N'Steve', N'Roger', N'0951235487', N'District 3, Ho Chi Minh City', NULL, NULL, 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (9, 17, CAST(N'2017-05-01 17:26:22.193' AS DateTime), N'Tony', N'Stark', N'0963548425', N'District 2, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (10, 14, CAST(N'2017-05-01 18:29:16.660' AS DateTime), N'Lex', N'Luthor', N'0122458725', N'District 7, Ho Chi Minh City', NULL, NULL, 1)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (11, 5, CAST(N'2017-05-10 15:18:03.977' AS DateTime), N'Laurel', N'Lance', N'0168726543', N'District 1, Ho Chi Minh City', N'VOU01', N'deliver before 12h', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (12, 6, CAST(N'2017-05-10 15:26:22.743' AS DateTime), N'Oliver', N'Queen', N'0918727328', N'Thu Duc District, Ho Chi Minh City', N'VOU02', N'...', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (13, 7, CAST(N'2017-05-12 15:30:42.913' AS DateTime), N'Barry', N'Allen', N'0967827631', N'District 8, Ho Chi Minh City', N'VOU03', N'deliver before 5h afternoon', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (14, 8, CAST(N'2017-05-12 15:32:34.397' AS DateTime), N'Bruce', N'Wayne', N'0188726813', N'District 3, Ho Chi Minh City', NULL, N'', 2)
GO
INSERT [dbo].[orders] ([ordersID], [userID], [ordersDate], [receiverFirstName], [receiverLastName], [phoneNumber], [deliveryAddress], [voucherID], [note], [status]) VALUES (15, 9, CAST(N'2017-05-13 15:43:36.753' AS DateTime), N'Luke', N'Cage', N'0987264813', N'District 5, Ho Chi Minh City', NULL, N'NO COMMENT', 2)
GO
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[wishList] ON 

GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (1, 17, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (2, 17, 14, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (3, 17, 15, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (4, 17, 16, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (5, 11, 27, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (6, 11, 28, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (7, 11, 29, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (8, 11, 30, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (9, 12, 17, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (10, 12, 8, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (11, 12, 9, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (12, 13, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (13, 13, 15, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (14, 13, 16, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (15, 14, 2, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (16, 14, 3, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (17, 15, 13, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (18, 15, 3, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (19, 16, 8, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (20, 16, 9, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (21, 5, 32, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (22, 5, 31, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (23, 6, 2, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (24, 6, 4, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (25, 7, 5, CAST(N'2017-05-19' AS Date))
GO
INSERT [dbo].[wishList] ([wishID], [userID], [productID], [createDate]) VALUES (26, 7, 6, CAST(N'2017-05-19' AS Date))
GO
SET IDENTITY_INSERT [dbo].[wishList] OFF
GO
SET IDENTITY_INSERT [dbo].[blogCategories] ON 

GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (1, N'STYLE', N'style')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (2, N'BEAUTY', N'beauty')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (3, N'CELEB', N'celeb')
GO
INSERT [dbo].[blogCategories] ([blogCateID], [blogCateName], [blogCateNameNA]) VALUES (4, N'NEWS & RUNWAY', N'news-&-runway')
GO
SET IDENTITY_INSERT [dbo].[blogCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[blogs] ON 

GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (1, 1, 1, N'10 Cute Plus-Size Swimsuits to Buy Right Now', N'10-cute-plus-size-swimsuits-to-buy-right-now', N'Ready for summer? Dive in with these cute plus-size swimsuits for every shape and size. Look sharp! From primers to fragrance to root touch-up tools, there''s a makeup pencil for everything.', N'815x500b.jpeg', CAST(N'2017-01-13' AS Date), N'<p>Rihanna, woman of our hearts, has invented the perfect summer shoe. The Bow Creeper Sandal, Rih&rsquo;s answer to the espadrille, features a soft leather upper, a sweet outsize bow accent and Fenty x Puma&rsquo;s signature serrated gum sole (in lieu of traditional jute rope). The sneaker-sandal hybrid also has&nbsp;lengthy shoelace ties that wind around the ankle to create that coveted pointe shoe effect. (She&rsquo;s coming for you, Miu Miu.)<br />', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (2, 1, 1, N'Say Goodbye to Monochrome Monotony and Hello to Bold Brights', N'say-goodbye-to-monochrome-monotony-and-hello-to-bold-brights', N'Kim Kardashian, your reign of neutrality is over. Ready for summer? Dive in with these cute plus-size swimsuits for every shape and size', N'a1size.jpg', CAST(N'2017-02-13' AS Date), N'<p>Stray Rats&nbsp;hoodie, strapped on some crimson stilettos and shielded your eyes from the sun&rsquo;s glare with coordinating (<a href="https://lespecs.com/the-last-lolita-1502112-opaque-red-silver-mirror-las1502112" onclick="javascript:_gaq.push(['' trackEvent'',''outbound-article'',''http://lespecs.com'']);" rel="nofollow" target="_blank">Adam Selman x Le Specs</a>-reminiscent) shades? For&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/742749-bella-hadid-opens-up-about-her-muslim-heritage/" target="_blank">Bella Hadid</a>, the answer to that question would be &ldquo;last Thursday&rdquo; (or &ldquo;May 4, 2017&rdquo; or &ldquo;Star Wars Day,&rdquo; depending on how technical or festive she was feeling).<br />
<img alt="" src="assets/images/userfiles/images/a3size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>It&rsquo;s official. When it comes to&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/705753-how-to-wear-monochrome-colors-like-a-celebrity/" target="_blank">tonal dressing</a>, that easy-peasy styling trick that, unlike most fashion trends, is more eternal than cyclical, vibrant colors are in and dull neutrals are out. Nowadays, we&rsquo;d rather look like Power Rangers than Kim Kardashian. Why are we of the cult of minimalism suddenly so willing to sport head-to-toe bubble gum? Street style star Pandora Sykes points to the rise of &ldquo;post-truth fashion.&rdquo; In the face of harsh political circumstances, &ldquo;we are led by our emotional gut and seek uplifting fashion that rejuvenates us and distracts us, momentarily,&rdquo; wrote Sykes in a February&nbsp;<a href="http://www.manrepeller.com/2017/02/why-i-love-a-pink-suit.html" onclick="javascript:_gaq.push(['' trackEvent'',''outbound-article'',''http://www.manrepeller.com'']);" rel="nofollow" target="_blank">Man Repeller</a>&nbsp;post.<br />
<img alt="" src="assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (3, 2, 1, N'9 Foot Peels to Get You Ready for Sandal Season', N'9-foot-peels-to-get-you-ready-for-sandal-season', N'Baby-soft feet, right this way. Just when you thought she couldn''t get any cooler.', N'a4.jpg', CAST(N'2017-03-13' AS Date), N'<p>Gucci&nbsp;and&nbsp;<a href="http://www.thefashionspot.com/runway-news/683689-loewe-fall-2016-runway/" target="_blank">Loewe</a>, but&nbsp;the trend really gained traction&nbsp;in September, when striking&nbsp;tonal&nbsp;ensembles walked the Spring 2017 runways of Max Mara, Sies Marjan, Monse, Victoria Beckham and more. The same goes for Fall 2017, when Mara Hoffman, Celine, Balenciaga, Christopher Kane, Tibi and again Monse favored eye-grabbing monochromatic palettes.</p><p>&nbsp;</p>
<p><img alt="" src="assets/images/userfiles/images/815x500a.jpeg" style="height:500px; width:815px" /><br />
&nbsp;</p>
<p>You&rsquo;ve probably seen the dramatic before and after photos on social media &mdash; because the results are&nbsp;<em>that</em>&nbsp;good. In just a few days (or weeks, depending on the foot peel), you&rsquo;ll see some seriously impressive results. The right foot peel will take off months of dead skin without any burning and without the need for any aggressive scrubbing. If you&rsquo;ve been a fan of foot files, one foot peel could be enough for you to throw out that brush and embrace the plastic booties.<br />
&nbsp;</p>
<p><img alt="" src="assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p>
<p>So, grab one of these best foot peels, slip on a pair of plastic booties and get ready to flaunt your new, baby soft feet.<br />
&nbsp;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (4, 3, 1, N'Hate Waxing? Try Sugaring Instead', N'hate-waxing?-try-sugaring-instead', N'Sugaring is the all-natural, less painful answer to waxing. The takeaway? We must try 80s draping.', N'a3size.jpg', CAST(N'2017-04-13' AS Date), N'<p>body hair removal. If you&rsquo;ve been going au naturel under your jeans and cozy sweaters, the warmer weather may be your signal to bust out the wax strips and&nbsp;<a href="http://www.thefashionspot.com/beauty/740689-best-drugstore-razors/">razors</a>. Before you go back to your usual hair removal regimen, it&rsquo;s worth considering other methods &mdash; and a&nbsp;brilliant one is sugaring.<br />
<img alt="" src="assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>Sugaring hair removal may not be as well known as waxing, plucking and shaving, but it should be. (And not just because&nbsp;<a href="https://books.google.com/books?id=9Z6vCGbf66YC&amp;pg=PA180&amp;lpg=PA180&amp;dq=encyclopedia+egyptian+hair+removal&amp;source=bl&amp;ots=YL16CYj9re&amp;sig=AE4vcRG1bj02RAEymcfkPVteliI&amp;hl=en&amp;sa=X&amp;ei=JdNHVdyuGMvooAS3-ICgBg&amp;ved=0CD8Q6AEwBQ#v=onepage&amp;q=encyclopedia%20egyptian%20hair%20removal&amp;f=false" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://books.google.com'']);" rel="nofollow" target="_blank">the technique has been used since ancient times</a>&nbsp;in the Middle East, Greece and parts of Africa.) Not only does sugaring take full advantage of one of our favorite guilty pleasures, it also has many other benefits.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a3size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p><h3>What is Sugaring?</h3>
<p>Sugaring is sometimes referred to as sugaring wax or sugared waxing, but make no mistake, sugaring and traditional waxing are very different. Angela Rosen, founder of&nbsp;<a href="http://www.daphne.studio/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.daphne.studio'']);" rel="nofollow" target="_blank">DAPHNE Studio</a>&nbsp;beauty store and spa in New York City, explains that traditional Egyptian sugaring involves a technique that mixes sugar with water and lemon to create a paste. When this mixture is applied to skin, it is able to remove hair in the direction of hair growth &mdash; and it does so without having to use any traditional waxing strips or additional tools.</p>
<p><img alt="" src="assets/images/userfiles/images/815x500b.jpeg" style="height:500px; width:815px" /></p>
<p>&quot;&gt;</p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (5, 4, 1, N'Watch: Amandla Stenberg Just Made Her Musical Debut', N'watch:-amandla-stenberg-just-made-her-musical-debut', N'Just when you thought she couldn''t get any cooler. Spring cleaning your beauty routine is a top priority.', N'815x500c.jpeg', CAST(N'2017-05-13' AS Date), N'<p>&nbsp;</p><p>&nbsp;</p>
<p>The message is fairly straightforward: obsessive phone use inhibits&nbsp;you from fully engaging with the world. In the video, Stenberg dances in a hazy, Technicolor, &ldquo;Hotline Bling&rdquo;-reminiscent room. She&rsquo;s surrounded by a crew of zombie-like teens who&rsquo;ve been completely hypnotized by their screens. (Like we said, none too subtle.) The setup is simple yet striking, and the extras, though static, are stylish AF. We can&rsquo;t wait for more where this came from.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a6size.jpg" style="height:500px; width:815px" /></p>
<p>Makeup pencils are easy to use and deposit the right amount of color while staying in both real and imaginary lines. Whether they&rsquo;re super skinny or supersized, pencils get the job done and they do it fast. Pencils are also perfect for travel and on-the-go touchups &mdash; and the slim shape makes it easy to fit into&nbsp;<a href="http://www.thefashionspot.com/style-trends/700799-fashion-trend-micro-bags/" target="_blank">the tiniest micro bag</a>.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p>', 0, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (6, 3, 1, N'Watch: Amandla Stenberg Just Made Her Musical Debut', N'watch:-amandla-stenberg-just-made-her-musical-debut', N'Just when you thought she couldn''t get any cooler.', N'a4.jpg', CAST(N'2017-03-12' AS Date), N'<p>When she&rsquo;s not writing poetry, illustrating comic books, directing films, studying at NYU, fronting international fashion campaigns or schooling her peers on&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/697995-amandla-stenberg-sexuality/" target="_blank">intersectional feminism</a>, Amandla Stenberg is an actress. In her latest film,&nbsp;<em>Everything, Everything</em>&nbsp;&mdash; which already has&nbsp;<a href="http://pagesix.com/2017/05/08/beyonce-throws-support-behind-amandla-stenberg/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://pagesix.com'']);" target="_blank">Beyonc&eacute;&rsquo;s stamp of approval</a>&nbsp;&mdash; Stenberg plays Madeline Whittier, an 18-year-old girl with a severe immunodeficiency (SCID) that&rsquo;s left her allergic to just about everything. Then young love strikes, inspiring Madeline to defy fate and venture outside her hermetically sealed home. (Get ready to exercise those tear ducts.)<br />
<img alt="" src="assets/images/userfiles/images/815x500b.jpeg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>Stenberg, Jane of All Trades that she is, shows off her vocal talents on the film&rsquo;s soundtrack. Her debut single, a cover of Mac DeMarco&rsquo;s &ldquo;Let My Baby Stay,&rdquo; is bluesy, ethereal and very Solange-reminiscent. The accompanying music video, released today on Vevo, is equally impressive, mostly because it was recorded, directed and edited by Stenberg herself.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p>
<p>The message is fairly straightforward: obsessive phone use inhibits&nbsp;you from fully engaging with the world. In the video, Stenberg dances in a hazy, Technicolor, &ldquo;Hotline Bling&rdquo;-reminiscent room. She&rsquo;s surrounded by a crew of zombie-like teens who&rsquo;ve been completely hypnotized by their screens. (Like we said, none too subtle.) The setup is simple yet striking, and the extras, though static, are stylish AF. We can&rsquo;t wait for more where this came from.</p>', 3, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (7, 1, 1, N'Watch: Paris Hilton on the Early 2000s Trends That Are Still ‘So Hot’', N'watch:-paris-hilton-on-the-early-2000s-trends-that-are-still-‘so-hot’', N'"Tracksuits are so cute and comfortable. But always wear ones that are colorful, or else you''ll look like you''re actually going to the gym — ew."', N'a4.jpg', CAST(N'2017-02-12' AS Date), N'<p><a href="http://www.thefashionspot.com/style-trends/744551-denim-jeans-trends/" target="_blank">The early 2000s are back</a>&nbsp;and so, too, is their queen. To accompany her new&nbsp;<a href="http://www.wmagazine.com/story/paris-hilton-interview" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.wmagazine.com'']);" target="_blank"><em>W</em></a>&nbsp;feature,&nbsp;Paris Hilton &mdash; heiress, OG reality star, DJ, entrepreneur, singer and self-proclaimed selfie inventor&nbsp;&mdash; shot a fashion infomercial&nbsp;in which she breaks down&nbsp;the&nbsp;early aughts&nbsp;trends that (in her opinion) are still &ldquo;so hot.&rdquo; In&nbsp;<a href="https://broadly.vice.com/en_us/article/paris-hilton-profile-2015-19-fragrances-and-counting-heiress" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://broadly.vice.com'']);" target="_blank">her patented fake baby voice</a>, Hilton&nbsp;serves up priceless advice for styling 2000s hits like tracksuits, graphic tees, miniskirts, tiaras and low-waist jeans. For instance: &ldquo;Tracksuits are so cute and comfortable. But always wear ones that are colorful, or else you&rsquo;ll look like you&rsquo;re actually going to the gym &mdash; ew.&rdquo; #Iconic as ever.&nbsp;<em>E!&nbsp;</em>execs, if you&rsquo;re listening, we demand&nbsp;a&nbsp;<em>The Simple Life</em>&nbsp;reboot.<br />
<img alt="" src="assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p>
<p>#Queen. When it comes to advocating for body-positivity and self-love, Metz is right up there with national treasures&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/729007-ashley-graham-cellulite-confidence/" target="_blank">Ashley Graham</a>,&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/694185-kesha-instagram-body-shamers/" target="_blank">Kesha</a>&nbsp;and&nbsp;<a href="http://www.thefashionspot.com/runway-news/742911-amy-schumer-instyle/" target="_blank">Amy Schumer</a>. In her&nbsp;aforementioned&nbsp;<em>Harper&rsquo;s Bazaar</em>&nbsp;feature, Metz made it abundantly clear she has no time for body-shamers, nor fashion critics. &ldquo;I want to wear something because I love it, not because it follows the rules,&rdquo; Metz said of her style. She and stylist Jordan Grossman are known for their&nbsp;bold, glamorous&nbsp;fashion choices.&nbsp;&ldquo;I ever end up on the worst-dressed list, it&rsquo;s not going to make me fall apart,&rdquo; Metz stated. &ldquo;I want to look great and feel good and be comfortable, but at the same time, none of this [as in red carpet appearances and photo shoots] really matters. This is the fun stuff.&rdquo; And with that, Metz rolled four&nbsp;important life lessons into one: love yourself, focus on what really matters, brush off the haters and keep fashion fun.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a2size.jpg" style="height:500px; width:815px" /></p>
<p>Chrissy Metz, one-third of&nbsp;<em>This Is Us</em>&rsquo; beloved (present day) Big Three, is not here for internet fat shamers who don&rsquo;t think anyone over a size eight should be allowed to wear latex on camera. The actress, who was recently dubbed &ldquo;Hollywood&rsquo;s New Pin Up Girl&rdquo; by&nbsp;<a href="http://www.harpersbazaar.com/celebrity/a21194/chrissy-metz-this-is-us-interview/" onclick="javascript:_gaq.push([''_trackEvent'',''outbound-article'',''http://www.harpersbazaar.com'']);" target="_blank"><em>Harper&rsquo;s Bazaar</em></a>, attended last night&rsquo;s&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/746737-2017-mtv-movie-tv-awards/" target="_blank">MTV TV and Movie Awards</a>&nbsp;in a custom Jane Doe Latex empire-waist dress. Metz wore the ruffle-sleeved burgundy frock to present Best Duo award alongside co-star (and fictional father of the year) Milo Ventimiglia. As they are wont to do, the internet trolls descended. Metz, a beacon of body-positivity, let the negative, needless comments roll right off her back, tweeting the following response:<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>&nbsp;</p>
<p>Everyone pretty much marched to the beat of their own fashion drum at the newly minted MTV Movie &amp; TV Awards. The award show&nbsp;<a href="http://www.thefashionspot.com/runway-news/743151-mtv-movie-and-tv-awards/" target="_blank">boasted genderless categories this go-round</a>&nbsp;and a majority of the looks were &uuml;ber feminine with a few brave souls diverging from the pack by opting for more gender-neutral ensembles. Sparkle and fancy embroidery were definitely trending as several attendees embraced metallics, even down to their accessories. One-shoulder pieces were popular as were asymmetric hemlines. On the beauty front, strong lips were a real theme with stars rocking everything from deep red to bright blue lip colors. For all the fashion action from last night&rsquo;s ceremony, check out the slideshow above.</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (8, 2, 1, N'The Best (and Worst!) Beauty Looks from the 2017 Met Gala', N'the-best-(and-worst!)-beauty-looks-from-the-2017-met-gala', N'The takeaway? We must try 80s draping.', N'a5size.jpg', CAST(N'2017-02-12' AS Date), N'<p>If there&rsquo;s any time to get wildly experimental with your&nbsp;<em>lewk</em>, it&rsquo;s at a&nbsp;<a href="http://www.thefashionspot.com/buzz-news/latest-news/719281-rei-kawakubo-costume-institute-2017/" target="_blank">Comme des Gar&ccedil;ons-themed Met Gala</a>. While the&nbsp;<a href="http://www.thefashionspot.com/celebrity-fashion/745809-met-gala-2017-red-carpet/" target="_blank">2017 Met Gala red carpet</a>&nbsp;was sorely lacking in Rei Kawakubo-backed designs, attendees were more than willing to show their weird via avant-garde beauty looks.&nbsp;<br />
<img alt="" src="assets/images/userfiles/images/815x500a.jpeg" style="height:500px; width:815px" /></p>
<p>For Cara Delevingne, that meant a bejeweled, spray-painted, hair-free head. Others paid homage to the woman of the hour by rocking&nbsp;<a href="http://www.vogue.com/article/bob-haircuts-met-gala-2017-rei-kawakubo-commes-des-garcons-olivia-wilde" onclick="javascript:_gaq.push([''_trackEvent'',''utbound-article'',''http://www.vogue.com'']);" target="_blank">her signature blunt bob</a>.</p>
<p>&nbsp;High-octane eyeshadow was another overarching theme, seen on the likes of Selena Gomez, Katy Perry, Evan Rachel Wood and Jemima Kirke. And, as with any red carpet, there was no shortage of flawless cat eyes (though Candice Swanepoel&rsquo;s took the crown).</p>
<p><img alt="" src="assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /><br />
Click through the slideshow above to see all the over-the-top transformations and some of the more subtle, yet equally memorable, hair and makeup looks. (And remember, in life, we must take the bad with the good.)<br />
&nbsp;</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (9, 2, 1, N'8 Brand New Beauty Products to Try This May', N'8-brand-new-beauty-products-to-try-this-may', N'Spring cleaning your beauty routine is a top priority.', N'a6size.jpg', CAST(N'2017-01-12' AS Date), N'<p>As the steamy summer days quickly approach &mdash; and spring cleaning is still a top priority &mdash; it&rsquo;s the ideal time to make some swaps in your beauty routine. Toss gunky old creams in exchange for lighter lotions and oils. Think about&nbsp;<a href="http://www.thefashionspot.com/beauty/586511-best-overnight-face-masks/">repairing your skin while you sleep</a>&nbsp;so you have more time to sit alfresco sipping ros&eacute;. And don&rsquo;t neglect your fuzzy legs &mdash; there&rsquo;s a new product for that, too. From French cult favorites to the must-have nail polish color of the season, these beauty buys are sure to up your game pre-summer.</p><p><br />
<img alt="" src="assets/images/userfiles/images/815x500c.jpeg" style="height:500px; width:815px" /></p><p>Another benefit of in-shower masks is that there are a variety of different formulas to target different skin concerns. Looking to tighten and brighten? There&rsquo;s a mask for that. Want to look more awake? There are splash masks to add radiance. Is your skin acting up and you don&rsquo;t know how to deal? There are soothing splash masks for that.<br />
&nbsp;</p><p><img alt="" src="assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>Remember what we said about making some room in your shower? Here are the eight masks worth adding to your routine.<br />
&nbsp;</p>', 4, 0)
GO
INSERT [dbo].[blogs] ([blogID], [blogCateID], [userID], [blogTitle], [blogTitleNA], [blogSummary], [blogImg], [postedDate], [content], [blogViews], [status]) VALUES (10, 4, 1, N'Yesterday’s Chanel Cruise Show May Have Been Karl Lagerfeld’s Final Collection', N'yesterday’s-chanel-cruise-show-may-have-been-karl-lagerfeld’s-final-collection', N'Say it ain''t so. But did you know that almost every type of beauty product now comes in pencil form?', N'a5size.jpg', CAST(N'2017-01-13' AS Date), N'<p>Karl Lagerfeld&nbsp;may be in poor health. According to unnamed Chanel sources, the French fashion house&rsquo;s&nbsp;<a href="http://www.thefashionspot.com/runway-news/746235-chanel-cruise-2018/" target="_blank">2018 Resort Show</a>&nbsp;&mdash; typically staged at&nbsp;<a href="http://www.thefashionspot.com/runway-news/692477-chanel-resort-2017-cruise-cuba/" target="_blank">some exotic locale</a>&nbsp;&mdash; was originally intended for Lisbon, not Paris&rsquo; Grand Palais. However, the faux Temple of Poseidon was ultimately erected in Paris because &ldquo;as more than one put it, &lsquo;Karl is not doing well.&rsquo;&rdquo;<br />
<img alt="" src="assets/images/userfiles/images/a1size.jpg" style="height:500px; width:815px" /></p><p>&nbsp;</p><p>&nbsp;</p>
<p>Apparently, those lucky enough to attend the presentation were struck by the 83-year-old fashion legend&rsquo;s &ldquo;unstable&rdquo; finale walk, throughout which he &ldquo;limped distinctly&rdquo; and held tight to his godson Hudson Kroenig&rsquo;s hand. Adding to the speculation is the fact that Lagerfeld would not see well-wishers and reporters after the show. An &ldquo;unusual&rdquo; no backstage policy ensured his privacy. Another Chanel source implied Lagerfeld will be stepping down from his professional obligations. &ldquo;You can feel the winding down in-house,&rdquo; the&nbsp;source told&nbsp;<em>Town &amp; Country</em>. &ldquo;It definitely feels like an era is coming to an end.&rdquo;<br />
<img alt="" src="assets/images/userfiles/images/a5size.jpg" style="height:500px; width:815px" /></p>
<p>Chanel spokespeople have yet to comment on the subject. Cross your fingers, people.<br />
&nbsp;</p>', 5, 0)
GO
SET IDENTITY_INSERT [dbo].[blogs] OFF
GO


SET IDENTITY_INSERT [dbo].[ordersDetail] ON 

GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (1, 1, 20, 105, 0, 2, 30, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (2, 1, 24, 136, 0, 2, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (3, 2, 1, 4, 0, 1, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (4, 2, 7, 31, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (5, 2, 10, 43, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (6, 3, 3, 9, 0, 2, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (7, 3, 15, 70, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (9, 4, 4, 18, 0, 2, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (10, 5, 7, 33, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (11, 5, 10, 45, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (12, 5, 12, 54, 0, 2, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (13, 6, 8, 36, 0, 1, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (14, 6, 14, 62, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (15, 7, 7, 31, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (16, 7, 13, 59, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (17, 8, 9, 41, 0, 1, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (18, 8, 7, 33, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (19, 8, 11, 48, 0, 1, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (20, 9, 2, 5, 0, 1, 24, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (21, 10, 5, 22, 0, 1, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (22, 10, 6, 28, 0, 1, 36, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (23, 11, 10, 43, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (24, 11, 17, 79, 0, 2, 26, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (25, 11, 29, 158, 0, 2, 35, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (26, 12, 24, 135, 0, 2, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (27, 12, 24, 138, 0, 1, 40, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (28, 13, 23, 134, 0, 3, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (29, 13, 4, 13, 0, 2, 70, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (30, 14, 8, 34, 0, 2, 28, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (31, 15, 28, 155, 0, 1, 35, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (32, 15, 27, 148, 0, 2, 36, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (33, 15, 10, 43, 0, 2, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (34, 15, 10, 42, 0, 1, 32, 0)
GO
INSERT [dbo].[ordersDetail] ([ordersDetailID], [ordersID], [productID], [sizeID], [productDiscount], [quantity], [price], [status]) VALUES (35, 15, 1, 1, 0, 1, 24, 0)
GO
SET IDENTITY_INSERT [dbo].[ordersDetail] OFF
GO

