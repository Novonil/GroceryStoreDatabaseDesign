USE MASTER
GO

-------------------------------
-------  DROP DATABASE  -------
-------------------------------

IF EXISTS(SELECT * FROM SYSDATABASES WHERE Name = 'FoodFestiveSuperMarket')
BEGIN
	DROP DATABASE FoodFestiveSuperMarket
END
GO

-------------------------------
------- CREATE DATABASE -------
-------------------------------

IF NOT EXISTS(SELECT * FROM SYSDATABASES WHERE Name = 'FoodFestiveSuperMarket')
BEGIN
	CREATE DATABASE FoodFestiveSuperMarket
END
GO

USE FoodFestiveSuperMarket
GO


CREATE TABLE Person
(
	PersonID				NVARCHAR(8)		PRIMARY KEY,
	FirstName				NVARCHAR(100)					NOT NULL,
	MiddleName				NVARCHAR(50)					NULL,
	LastName				NVARCHAR(100)					NOT NULL,
	Gender					NVARCHAR(20)					NOT NULL,
	DateOfBirth				DATE							NOT NULL,
	StreetAddress			NVARCHAR(200)					NULL,
	City					NVARCHAR(100)					NULL,
	State					NVARCHAR(100)					NULL,
	Country					NVARCHAR(100)					NULL,
	ZipCode					NVARCHAR(10)					NULL,
	
	CONSTRAINT CHK_PersonID CHECK (PersonID LIKE 'P[0-9][0-9][0-9]'),
	CONSTRAINT CHK_Gender	CHECK (Gender IN ('Male', 'Female', 'Others')),
	CONSTRAINT CHK_DOB		CHECK (YEAR(GETDATE()) - YEAR(DateOfBirth) >= 16),
	CONSTRAINT CHK_ZipCode	CHECK (ZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]')
)


CREATE TABLE PhoneNumber
(
	PersonID				NVARCHAR(8)						NOT NULL,
	PhoneNumber				NVARCHAR(10)					NOT NULL,

	PRIMARY KEY(PersonID, PhoneNumber),
	FOREIGN KEY(PersonID) REFERENCES Person(PersonID)
)


CREATE TABLE SilverCustomer
(
	SilverCustomerID		NVARCHAR(8)		PRIMARY KEY,
	IsOnlineCustomer		BIT								NOT NULL,
	IsNonOnlineCustoner		BIT								NOT NULL,
	EmailID					NVARCHAR(50)					NULL,
	MembershipDate			DATE							NOT NULL,

	FOREIGN KEY(SilverCustomerID) REFERENCES Person(PersonID),
	CONSTRAINT CHK_EmailID	CHECK ((IsOnlineCustomer = 0) OR (IsOnlineCustomer = 1 AND EmailID IS NOT NULL))
)


CREATE TABLE Employee
(
	EmployeeID				NVARCHAR(8)		PRIMARY KEY,
	EmployeeType			NVARCHAR(22)					NOT NULL,
	HiringDate				DATE							NOT NULL,

	FOREIGN KEY(EmployeeID)	REFERENCES Person(PersonID),
	CONSTRAINT CHK_EmployeeType	CHECK (EmployeeType IN ('Manager', 'Floor Staff', 'Cashier'))
)


CREATE TABLE GoldCustomer
(
	MembershipID			BIGINT			PRIMARY KEY		IDENTITY(1,1),
	PersonID				NVARCHAR(8)		UNIQUE			NOT NULL,
	IDIssueDate				DATE							NOT NULL,

	FOREIGN KEY(PersonID) REFERENCES Person(PersonID),
	CONSTRAINT CHK_IDIssueDate CHECK (IDIssueDate <= GETDATE())
)

CREATE TABLE EmployeeDesignationHistories
(
	EmployeeDesignationHistoryID	BIGINT		PRIMARY KEY		IDENTITY(1,1),
	EmployeeID						NVARCHAR(8)					NOT NULL,
	EmployeeDesignation				NVARCHAR(22)				NOT NULL,
	StartDate						DATE						NOT NULL,

	UNIQUE(EmployeeID, EmployeeDesignation),
	FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT CHK_EmpDesgn	CHECK (EmployeeDesignation IN ('Manager', 'Floor Staff', 'Cashier')),
	CONSTRAINT CHK_StartDate CHECK (StartDate <= GETDATE())
)

CREATE TABLE Aisle
(
	AisleID					BIGINT			PRIMARY KEY		IDENTITY(1,1),
	AisleNumber				INT								NOT NULL,
	AisleSection			NVARCHAR(10)					NOT NULL
)

CREATE TABLE Supplier
(
	SupplierID				BIGINT			PRIMARY KEY		IDENTITY(1,1),
	SupplierName			NVARCHAR(200)					NOT NULL,
	SupplierContact			NVARCHAR(10),
	SupplierAddress			NVARCHAR(500)
)

CREATE TABLE Product
(
	ProductID				BIGINT			PRIMARY KEY		IDENTITY(1,1),
	Quantity				INT								NOT NULL,
	Description				NVARCHAR(200),
	IsPerishable			BIT								NOT NULL,
	DateOfExpiry			DATE,
	SupplierID				BIGINT							NOT NULL,
	SupplyDate				DATE							NOT NULL,
	Price					NUMERIC(20,2)					NOT NULL,

	FOREIGN KEY(SupplierID)	REFERENCES Supplier(SupplierID),
	CONSTRAINT CHK_Quantity CHECK (Quantity >= 0),
	CONSTRAINT CHK_SupplyDate CHECK (SupplyDate <= GETDATE()),
	CONSTRAINT CHK_Expiry CHECK ((IsPerishable = 0) OR (IsPerishable = 1 AND DateOfExpiry IS NOT NULL)),
)

CREATE TABLE Store
(
	StoreID					BIGINT			PRIMARY KEY		IDENTITY(1,1),
	StoreName				NVARCHAR(200)					NOT NULL,
	StoreContact			NVARCHAR(10),
	StoreAddress			NVARCHAR(500)
)


CREATE TABLE EmployeeStoreAssignmentDetails
(
	EmployeeID				NVARCHAR(8)						NOT NULL,
	StoreID					BIGINT							NOT NULL,
	Date					DATE							NOT NULL,
	WorkingHours			SMALLINT						NOT NULL,

	PRIMARY KEY(EmployeeID, StoreID, Date),
	FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
	CONSTRAINT CHK_WorkHrs CHECK (WorkingHours >= 0)
	
)							
				
CREATE TABLE SALE
(
	StoreID					BIGINT							NOT NULL,
	SaleID					BIGINT							NOT NULL,
	Description				NVARCHAR(500),
	DurationInDays			SMALLINT,

	PRIMARY KEY(StoreID, SaleID),
	FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
	CONSTRAINT CHK_Duration CHECK (DurationInDays >= 0)
)


CREATE TABLE Vouchers
(
	VoucherID				BIGINT				PRIMARY KEY		IDENTITY(1,1),
	VoucherNumber			NVARCHAR(20)						NOT NULL,
	Description				NVARCHAR(500)
)

CREATE TABLE PromotionalDiscounts
(
	VoucherID				BIGINT								NOT NULL,
	PromotionID				BIGINT								NOT NULL,
	Description				NVARCHAR(500),

	PRIMARY KEY(VoucherID, PromotionID),
	FOREIGN KEY(VoucherID) REFERENCES Vouchers(VoucherID)
)

CREATE TABLE StoreVoucherIssueDetails
(
	StoreID					BIGINT								NOT NULL,
	VoucherID				BIGINT								NOT NULL,
	IssueDate				DATE								NOT NULL,
	
	PRIMARY KEY(StoreID, VoucherID),
	FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
	FOREIGN KEY(VoucherID) REFERENCES Vouchers(VoucherID)
)

CREATE TABLE FloorStaffAisleAssignmentDetails
(
	FloorStaffID			NVARCHAR(8)							NOT NULL,
	AisleID					BIGINT								NOT NULL,
	AssignedDate			DATE								NOT NULL,

	PRIMARY KEY(FloorStaffID, AisleID),
	FOREIGN KEY(AisleID) REFERENCES Aisle(AisleID),
	FOREIGN KEY(FloorStaffID) REFERENCES Employee(EmployeeID)
)

CREATE TABLE ProductAisleArrangementDetails
(
	ProductID				BIGINT								NOT NULL,
	AisleID					BIGINT								NOT NULL,
	ArrangementDate			DATE								NOT NULL,

	PRIMARY KEY(ProductID, AisleID),
	FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
	FOREIGN KEY(AisleID) REFERENCES Aisle(AisleID)
)

CREATE TABLE Orders
(
	OrderID					BIGINT				PRIMARY KEY		IDENTITY(1,1),
	OrderNumber				NVARCHAR(100)		UNIQUE			NOT NULL,
	OrderDate				DATE								NOT NULL,
	OrderAmount				NUMERIC(20,2)						NOT NULL,
	OnlineCustomerID		NVARCHAR(8)							NOT NULL,
	
	FOREIGN KEY(OnlineCustomerID) REFERENCES SilverCustomer(SilverCustomerID),
	CONSTRAINT CHK_OrderAmount CHECK (OrderAmount >= 0.00),
	CONSTRAINT CHK_OrderDate CHECK (OrderDate <= GETDATE())
)


CREATE TABLE OrderDetails
(
	OrderDetailID			BIGINT				PRIMARY KEY		IDENTITY(1,1),
	OrderID					BIGINT								NOT NULL,
	ProductID				BIGINT								NOT NULL,
	OrderedQuantity			INT									NOT NULL,
	OrderAmount				NUMERIC(20,2)						NOT NULL,

	FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
	CONSTRAINT CHK_OrderedQuantity CHECK (OrderedQuantity > 0),
	CONSTRAINT CHK_OrderDetAmount CHECK (OrderAmount >= 0.00)
)

CREATE TABLE VouchersBought
(
	VoucherID				BIGINT								NOT NULL,
	NonOnlineCustomerID		NVARCHAR(8)							NOT NULL,
	VoucherPurchaseDate		DATE								NOT NULL,

	PRIMARY KEY(VoucherID, NonOnlineCustomerID),
	FOREIGN KEY(VoucherID) REFERENCES Vouchers(VoucherID),
	FOREIGN KEY(NonOnlineCustomerID) REFERENCES SilverCustomer(SilverCustomerID),
	CONSTRAINT CHK_VoucherPurchaseDate CHECK (VoucherPurchaseDate <= GETDATE())
)

CREATE TABLE VouchersReceivedFree
(
	VoucherID				BIGINT								NOT NULL,
	MembershipID			BIGINT								NOT NULL,

	PRIMARY KEY(VoucherID, MembershipID),
	FOREIGN KEY(VoucherID) REFERENCES Vouchers(VoucherID),
	FOREIGN KEY(MembershipID) REFERENCES GoldCustomer(MembershipID)
)

CREATE TABLE Purchase
(
	PurchaseID				BIGINT				PRIMARY KEY		IDENTITY(1,1),
	PersonID				NVARCHAR(8)							NOT NULL,
	StoreID					BIGINT								NOT NULL,
	DateOfPurchase			DATE								NOT NULL,
	BillAmount				NUMERIC(20,2)						NOT NULL,
	CashierID				NVARCHAR(8)							NOT NULL,
	PaymentMethod			NVARCHAR(30)						NOT NULL,

	
	FOREIGN KEY(PersonID) REFERENCES Person(PersonID),
	FOREIGN KEY(StoreID) REFERENCES Store(StoreID),
	FOREIGN KEY(CashierID) REFERENCES Employee(EmployeeID),
	CONSTRAINT CHK_BillAmount CHECK (BillAmount >= 0.00),
	CONSTRAINT CHK_DateOfPurchase CHECK (DateOfPurchase <= GETDATE())
)


CREATE TABLE PurchaseDetails
(
	PurchaseDetailID		BIGINT				PRIMARY KEY		IDENTITY(1,1),
	PurchaseID				BIGINT								NOT NULL,
	ProductID				BIGINT								NOT NULL,
	PurchasedQuantity		INT									NOT NULL,
	PurchaseAmount			NUMERIC(20,2)						NOT NULL,

	FOREIGN KEY(PurchaseID) REFERENCES Purchase(PurchaseID),
	FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
	CONSTRAINT CHK_PurchasedQuantity CHECK (PurchasedQuantity > 0),
	CONSTRAINT CHK_PurchaseAmount CHECK (PurchaseAmount >= 0.00)
)
