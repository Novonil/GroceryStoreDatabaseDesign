USE FoodFestiveSuperMarket
GO

---------------------------------------------------------------------------------------
	  -- 1. List the details of all the managers of the store in the past two months. 
---------------------------------------------------------------------------------------

SELECT DISTINCT
	Person.PersonID,
	Person.FirstName,
	Person.MiddleName,
	Person.LastName,
	Person.Gender,
	Person.DateOfBirth,
	Person.StreetAddress,
	Person.City,
	Person.State,
	Person.Country,
	Person.ZipCode,
	Store.StoreID,
	Store.StoreName,
	Store.StoreContact,
	Store.StoreAddress
FROM
	EmployeeStoreAssignmentDetails
	INNER JOIN Employee
		ON EmployeeStoreAssignmentDetails.EmployeeID = Employee.EmployeeID
		AND Employee.EmployeeType = 'Manager'
		AND EmployeeStoreAssignmentDetails.DATE > DATEADD(MM, -2, GETDATE())
		AND EmployeeStoreAssignmentDetails.DATE <= GETDATE()
	INNER JOIN Person
		ON Employee.EmployeeID = Person.PersonID
	INNER JOIN Store
		ON EmployeeStoreAssignmentDetails.StoreID = Store.StoreID

GO

---------------------------------------------------------------------------------------
   -- 2. List customers who have bought all perishable items available in the store
---------------------------------------------------------------------------------------

SELECT
	Person.PersonID,
	Person.FirstName,
	Person.MiddleName,
	Person.LastName,
	Person.Gender,
	Person.DateOfBirth,
	Person.StreetAddress,
	Person.City,
	Person.State,
	Person.Country,
	Person.ZipCode
FROM
	Person
WHERE
	NOT EXISTS
	(
		(
			SELECT
				ProductID
			FROM
				Product
			WHERE
				IsPerishable = 1
		)
		EXCEPT
		(
			SELECT
				ProductID
			FROM
				Purchase
				INNER JOIN PurchaseDetails
					ON Purchase.PurchaseID = PurchaseDetails.PurchaseID
			WHERE
				Purchase.PersonID = Person.PersonID
		)
	)

GO

---------------------------------------------------------------------------------------
	 -- 3. Find the average number of purchases made by the top five Gold Customers
---------------------------------------------------------------------------------------

SELECT
	AVG(ISNULL(TopFiveGoldCustomer.CountOfPurchase,0.00)) AS AverageNumberOfPurchases
FROM
	(
		SELECT TOP 5
			TopGoldCustomer.FirstName,
			TopGoldCustomer.LastName,
			TopGoldCustomer.CountOfPurchase
		FROM
			TopGoldCustomer
		ORDER BY
			TopGoldCustomer.CountOfPurchase DESC
	) AS TopFiveGoldCustomer
GO

---------------------------------------------------------------------------------------
	  -- 4. Find the expiry date of the perishable item that is purchased the most
---------------------------------------------------------------------------------------

SELECT
	OrderedSale.ProductID,
	OrderedSale.Description,
	OrderedSale.DateOfExpiry
FROM
	(
		SELECT
			TotalSales.ProductID,
			TotalSales.Description,
			TotalSales.DateOfExpiry,
			RANK() OVER (ORDER BY TotalSales.TotalQuantityPurchased DESC) AS ProductRank
		FROM
			(
				SELECT
					Product.ProductID,
					Product.Description,
					Product.DateOfExpiry,
					SUM(PurchaseDetails.PurchasedQuantity)	AS TotalQuantityPurchased
				FROM
					PurchaseDetails
					INNER JOIN Product
						ON PurchaseDetails.ProductID = Product.ProductID
						AND Product.IsPerishable = 1
				GROUP BY
					Product.ProductID,
					Product.Description,
					Product.DateOfExpiry
			) AS TotalSales
	) AS OrderedSale
WHERE
	OrderedSale.ProductRank = 1
		
GO

---------------------------------------------------------------------------------------
		 -- 5. Find the supplier details of products that are out of stock
---------------------------------------------------------------------------------------

SELECT
	Supplier.SupplierID,
	Supplier.SupplierName,
	Supplier.SupplierContact,
	Supplier.SupplierAddress,
	Product.ProductID,
	Product.Description,
	Product.IsPerishable,
	Product.DateOfExpiry,
	Product.Price,
	Product.Quantity
FROM
	Product
	INNER JOIN Supplier
		ON Product.SupplierID = Supplier.SupplierID
		AND Product.Quantity = 0


GO

---------------------------------------------------------------------------------------
			-- 6. Find the total number transactions made at each store
---------------------------------------------------------------------------------------

SELECT
	Store.StoreID,
	Store.StoreName,
	COUNT(*)	AS TotalNumberOfTransactionsMade
FROM
	Purchase
	INNER JOIN Store
		ON Purchase.StoreID = Store.StoreID
GROUP BY
	Store.StoreID,
	Store.StoreName


GO
---------------------------------------------------------------------------------------
	  -- 7. Find the employee details who has worked every day of the past week
---------------------------------------------------------------------------------------

SELECT
	Employee.EmployeeID,
	Person.FirstName,
	Person.MiddleName,
	Person.LastName,
	Person.Gender,
	Person.DateOfBirth,
	Employee.EmployeeType
FROM 
	Employee
	INNER JOIN Person
		ON Employee.EmployeeID = Person.PersonID
WHERE
	NOT EXISTS
	(
		(
			SELECT
				CAST(DATEADD(DD, -1, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -2, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -3, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -4, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -5, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -6, GETDATE()) AS DATE)
			UNION ALL
			SELECT
				CAST(DATEADD(DD, -7, GETDATE()) AS DATE)
		)
		EXCEPT
		(
			SELECT
				EmployeeStoreAssignmentDetails.Date
			FROM
				EmployeeStoreAssignmentDetails
			WHERE
				EmployeeStoreAssignmentDetails.EmployeeID = Employee.EmployeeID
		)
	)

	
GO


---------------------------------------------------------------------------------------
	  -- 8. Find the count of customers who have bought the most popular product
---------------------------------------------------------------------------------------

SELECT
	PopularProduct.ProductID,
	COUNT(DISTINCT Purchase.PersonID)	AS CountOfCustomers
FROM
	PopularProduct
	INNER JOIN PurchaseDetails
		ON PopularProduct.ProductID = PurchaseDetails.ProductID
	INNER JOIN Purchase
		ON PurchaseDetails.PurchaseID = Purchase.PurchaseID
GROUP BY
	PopularProduct.ProductID

UNION ALL

SELECT
	PopularProduct.ProductID,
	COUNT(DISTINCT Orders.OnlineCustomerID)	AS CountOfCustomers
FROM
	PopularProduct
	INNER JOIN OrderDetails
		ON PopularProduct.ProductID = OrderDetails.ProductID
	INNER JOIN Orders
		ON OrderDetails.OrderID = Orders.OrderID
GROUP BY
	PopularProduct.ProductID

GO
---------------------------------------------------------------------------------------
  -- 9. List all transaction details issued after the most current employee was hired
---------------------------------------------------------------------------------------

DECLARE @LatestHiringDate DATE = (SELECT MAX(Employee.HiringDate) AS LatestHiringDate FROM Employee)

SELECT
	Purchase.PurchaseID,
	Purchase.PersonID,
	Purchase.DateOfPurchase,
	Purchase.BillAmount
FROM
	Purchase
WHERE
	Purchase.DateOfPurchase > @LatestHiringDate

UNION ALL

SELECT
	Orders.OrderID,
	Orders.OnlineCustomerID,
	Orders.OrderDate,
	Orders.OrderAmount
FROM
	Orders
WHERE
	Orders.OrderDate > @LatestHiringDate

GO

---------------------------------------------------------------------------------------------------
-- 10. List all the employees that have enrolled as Gold Customer within a month of being employed.
---------------------------------------------------------------------------------------------------

SELECT
	Employee.EmployeeID,
	Person.FirstName,
	Person.MiddleName,
	Person.LastName,
	Person.Gender,
	Person.DateOfBirth,
	Employee.EmployeeType
FROM
	GoldCustomer
	INNER JOIN Employee
		ON GoldCustomer.PersonID = Employee.EmployeeID
		AND GoldCustomer.IDIssueDate < CAST(DATEADD(MM, 1, Employee.HiringDate) AS DATE)
		AND GoldCustomer.IDIssueDate >= Employee.HiringDate
	INNER JOIN Person
		ON Employee.EmployeeID = Person.PersonID

GO


---------------------------------------------------------------------------------------
		-- 11. Find the details of the voucher that are purchased the most.
---------------------------------------------------------------------------------------

SELECT
	Vouchers.VoucherID,
	Vouchers.VoucherNumber,
	Vouchers.Description
FROM
	(
		SELECT
			TotalVouchersSold.VoucherID,
			RANK() OVER (ORDER BY TotalVouchersSold.CountOfVouchersPurchased DESC) AS VoucherRank
		FROM
			(
				SELECT
					VouchersBought.VoucherID,
					COUNT(*)		AS CountOfVouchersPurchased
				FROM
					VouchersBought
				GROUP BY
					VouchersBought.VoucherID
			) AS TotalVouchersSold
	) AS OrderedVouchers
	INNER JOIN Vouchers
		ON OrderedVouchers.VoucherID = Vouchers.VoucherID
		AND OrderedVouchers.VoucherRank = 1

GO

---------------------------------------------------------------------------------------
		-- 12. Find customers who have been Silver Customer for over 5 years
---------------------------------------------------------------------------------------

SELECT
	SilverCustomer.SilverCustomerID,
	SilverCustomer.IsOnlineCustomer,
	SilverCustomer.IsNonOnlineCustoner,
	Person.FirstName,
	Person.MiddleName,
	Person.LastName,
	Person.Gender,
	Person.DateOfBirth
FROM	
	SilverCustomer
	INNER JOIN Person
		ON SilverCustomer.SilverCustomerID = Person.PersonID
WHERE 
	SilverCustomer.MembershipDate <= CAST(DATEADD(YYYY, -5, GETDATE()) AS DATE)
	AND SilverCustomer.SilverCustomerID NOT IN (SELECT PersonID FROM GoldCustomer WHERE GoldCustomer.IdIssueDate < CAST(DATEADD(YYYY, 5, SilverCustomer.MembershipDate) AS DATE))

GO

---------------------------------------------------------------------------------------
-- 13. Find the number of purchases made by the potential Gold Members in the last year
---------------------------------------------------------------------------------------

SELECT
	PotentialGoldCustomer.PersonID,
	COUNT(Orders.OrderID) AS TotalOrdersMade
FROM
	PotentialGoldCustomer
	INNER JOIN Orders
		ON PotentialGoldCustomer.PersonID = Orders.OnlineCustomerID
		AND Orders.OrderDate > CAST(DATEADD(YYYY, -1, GETDATE()) AS DATE)
GROUP BY
	PotentialGoldCustomer.PersonID

UNION ALL

SELECT
	PotentialGoldCustomer.PersonID,
	COUNT(Purchase.PurchaseID) AS TotalPurchaseMade
FROM
	PotentialGoldCustomer
	INNER JOIN Purchase
		ON PotentialGoldCustomer.PersonID = Purchase.PersonID
		AND Purchase.DateOfPurchase > CAST(DATEADD(YYYY, -1, GETDATE()) AS DATE)
GROUP BY
	PotentialGoldCustomer.PersonID

GO

---------------------------------------------------------------------------------------------------------------------
--14. Find the maximum bill amount and details of the store that has the maximum number of purchases in the last year
---------------------------------------------------------------------------------------------------------------------

SELECT
	TopStore.StoreID,
	TopStore.StoreName,
	TopStore.StoreAddress,
	TopStore.StoreContact,
	MAX(Purchase.BillAmount) AS MaxBillAmount
FROM
	TopStore
	INNER JOIN Purchase
		ON TopStore.StoreID = Purchase.StoreID
GROUP BY
	TopStore.StoreID,
	TopStore.StoreName,
	TopStore.StoreAddress,
	TopStore.StoreContact

GO

----------------------------------------------------------------------------------------------------------------------------------------
  --15. Find the date of the transaction that has a bill amount greater than the average bill amount of all transactions in the system. 
----------------------------------------------------------------------------------------------------------------------------------------

DECLARE @AverageBillAmount NUMERIC(20,2)

SELECT
	@AverageBillAmount = SUM(ISNULL(Temp.TotalAmount,0.00))/SUM(ISNULL(IIF(Temp.TotalTransactions = 0,1,Temp.TotalTransactions),1))
FROM
	(
		SELECT
			SUM(Purchase.BillAmount)	AS  TotalAmount,
			COUNT(*)					AS TotalTransactions
		FROM
			Purchase

		UNION ALL

		SELECT
			SUM(Orders.OrderAmount) AS  TotalAmount,
			COUNT(*)				AS TotalTransactions
		FROM
			Orders
	) AS Temp


SELECT
	Purchase.PurchaseID,
	Purchase.DateOfPurchase,
	Purchase.BillAmount
FROM
	Purchase
WHERE
	BillAmount > @AverageBillAmount

UNION ALL

SELECT
	Orders.OrderID,
	Orders.OrderDate,
	Orders.OrderAmount
FROM
	Orders
WHERE
	OrderAmount > @AverageBillAmount

GO

