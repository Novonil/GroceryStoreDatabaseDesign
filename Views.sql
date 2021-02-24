USE FoodFestiveSuperMarket
GO

-- IN TERMS OF NUMBER OF TRANSACTIONS
CREATE VIEW TopGoldCustomer
AS
(
	-- AS PER THE DESIGN NO GOLD CUSTOMERS WOULD EVER BE AN ONLINE CUSTOMER AND HENCE WE NEED TO CHECK ONLY INSTORE PURCHASES
	SELECT
		Person.FirstName			AS FirstName,
		Person.LastName				AS LastName,
		GoldCustomer.IDIssueDate	AS DateOfMembershipEnrollment,
		COUNT(*)					AS CountOfPurchase
	FROM
		Purchase
		INNER JOIN GoldCustomer
			ON Purchase.PersonID = GoldCustomer.PersonID
		INNER JOIN Person
			ON GoldCustomer.PersonID = Person.PersonID
	WHERE
		Purchase.DateOfPurchase > CAST(DATEADD(YYYY, -1, GETDATE()) AS DATE)
	GROUP BY
		Person.FirstName,
		Person.LastName,
		GoldCustomer.IDIssueDate
	HAVING
		COUNT(*) > 12
)

GO


-- IN TERMS OF QUANTITIES BOUGHT

CREATE VIEW PopularProduct
AS
(
	-- CONSIDER BOTH ORDERS AND PURCHASES
	SELECT
		Product.ProductID,
		Product.Quantity,
		Product.Description,
		Product.IsPerishable,
		Product.DateOfExpiry,
		Product.SupplierID,
		Product.SupplyDate,
		Product.Price
	FROM
		(
			SELECT
				ProductSales.ProductID,
				RANK() OVER (ORDER BY ProductSales.CountOfProductsOrderedMost DESC) AS ProductRank
			FROM
				(
					SELECT
						OnlineOrOfflineSales.ProductID,
						SUM(OnlineOrOfflineSales.CountOfProductsOrderedMost) AS CountOfProductsOrderedMost
					FROM
						(
							SELECT
								PurchaseDetails.ProductID,
								SUM(PurchaseDetails.PurchasedQuantity) AS CountOfProductsOrderedMost
							FROM
								Purchase
								INNER JOIN PurchaseDetails
									ON Purchase.PurchaseID = PurchaseDetails.PurchaseID
							WHERE
								Purchase.DateOfPurchase > CAST(DATEADD(YYYY, -2, GETDATE()) AS DATE)
							GROUP BY
								PurchaseDetails.ProductID

							UNION ALL

							SELECT
								OrderDetails.ProductID,
								SUM(OrderDetails.OrderedQuantity) AS CountOfProductsOrderedMost
							FROM
								Orders
								INNER JOIN OrderDetails
									ON Orders.OrderID = OrderDetails.OrderID
							WHERE
								Orders.OrderDate > CAST(DATEADD(YYYY, -2, GETDATE()) AS DATE)
							GROUP BY
								OrderDetails.ProductID
						) AS OnlineOrOfflineSales
						GROUP BY 
							OnlineOrOfflineSales.ProductID
				) AS ProductSales
		) AS OrderedSales
		INNER JOIN Product
			ON OrderedSales.ProductID = Product.ProductID
	WHERE
		OrderedSales.ProductRank = 1
)

GO

-- TOP Store in terms of the number of items sold(quantity)

CREATE VIEW TopStore
AS
(
	SELECT
		OrderedSales.StoreID,
		OrderedSales.StoreName,
		OrderedSales.StoreContact,
		OrderedSales.StoreAddress
	FROM
		(
			SELECT
				QuantitySoldByStore.StoreID,
				QuantitySoldByStore.StoreName,
				QuantitySoldByStore.StoreContact,
				QuantitySoldByStore.StoreAddress,
				RANK() OVER (ORDER BY QuantitySoldByStore.NumberOfProductsBought DESC) AS StoreRank
			FROM
				(
					SELECT
						Store.StoreID,
						Store.StoreName,
						Store.StoreContact,
						Store.StoreAddress,
						SUM(PurchaseDetails.PurchasedQuantity) AS NumberOfProductsBought
					FROM
						Purchase
						INNER JOIN PurchaseDetails
							ON Purchase.PurchaseID = PurchaseDetails.PurchaseID
							AND Purchase.DateOfPurchase > CAST(DATEADD(YYYY, -1, GETDATE()) AS DATE)
						INNER JOIN Store
							ON Purchase.StoreID = Store.StoreID
					GROUP BY
						Store.StoreID,
						Store.StoreName,
						Store.StoreContact,
						Store.StoreAddress
				) AS QuantitySoldByStore
		) AS OrderedSales
	WHERE
		OrderedSales.StoreRank = 1
)
GO

CREATE VIEW PotentialGoldCustomer
AS
(
	SELECT
		Person.PersonID,
		Person.FirstName,
		Person.MiddleName,
		Person.LastName,
		PhoneNumber.PhoneNumber
	FROM
		VouchersBought
		INNER JOIN Person	
			ON VouchersBought.NonOnlineCustomerID = Person.PersonID
			AND VouchersBought.VoucherPurchaseDate > CAST(DATEADD(MM, -1, GETDATE()) AS DATE)
		INNER JOIN PhoneNumber
			ON Person.PersonID = PhoneNumber.PersonID
	GROUP BY
		Person.PersonID,
		Person.FirstName,
		Person.MiddleName,
		Person.LastName,
		PhoneNumber.PhoneNumber
	HAVING
		COUNT(*) > 10
)

GO


-- IN TERMS OF COUNT OF DISTINCT PERISABLE PRODUCTS
CREATE VIEW TopSupplier
AS
(
	SELECT
		OrderedSupplier.SupplierID,
		OrderedSupplier.SupplierName,
		OrderedSupplier.SupplierContact,
		OrderedSupplier.SupplierAddress
	FROM
	(
		SELECT
			TotalProducts.SupplierID,
			TotalProducts.SupplierName,
			TotalProducts.SupplierContact,
			TotalProducts.SupplierAddress,
			RANK() OVER (ORDER BY TotalProducts.TotalCountOfProducts DESC) AS SupplierRank
		FROM
			(
				SELECT
					Supplier.SupplierID,
					Supplier.SupplierName,
					Supplier.SupplierContact,
					Supplier.SupplierAddress,
					COUNT(*)	AS TotalCountOfProducts
				FROM
					Product
					INNER JOIN Supplier
						ON Product.SupplierID = Supplier.SupplierID
						AND Product.IsPerishable = 1
						AND Product.SupplyDate > CAST(DATEADD(MM, -1, GETDATE()) AS DATE)
				GROUP BY
					Supplier.SupplierID,
					Supplier.SupplierName,
					Supplier.SupplierContact,
					Supplier.SupplierAddress
			) AS TotalProducts
	) AS OrderedSupplier
	WHERE
		OrderedSupplier.SupplierRank = 1
)
GO



SELECT * FROM TopGoldCustomer
GO
SELECT * FROM PopularProduct
GO
SELECT * FROM TopStore
GO
SELECT * FROM PotentialGoldCustomer
GO
SELECT * FROM TopSupplier
GO