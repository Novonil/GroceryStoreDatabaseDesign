USE FoodFestiveSuperMarket
GO


INSERT INTO Person VALUES

('P001', 'Novonil',NULL, 'Das', 'Male', '06-08-1991', '7825 McCallum Blvd', 'Dallas', 'Texas', 'USA', '75252'),

('P002', 'Parth',NULL, 'Padalkar', 'Male', '07-18-1993', '7826 McCallum Blvd', 'New York', 'New York', 'USA', '52689'),

('P003', 'Ashrafi', 'Akbar', 'Khandakar', 'Female', '08-28-1994', '7827 McCallum Blvd', 'Cali', 'California', 'USA', '10001'),

('P004', 'Srijit', 'B', 'Majumder', 'Male', '12-10-1991', '7828 McCallum Blvd', 'Kolkata', 'West Bengal', 'India', '70001'),

('P005', 'Aritra', NULL, 'Dasgupta', 'Male', '12-23-1991', '7829 McCallum Blvd', 'Bangalore', 'Karnataka', 'India', '50001'),
				    
('P006', 'Subhankar', NULL, 'Roy', 'Male', '08-06-1991', '7830 McCallum Blvd', 'Trento', 'Italy', 'Italu', '30001'),
				    
('P007', 'Tanmoy', 'Kumar', 'Goswami', 'Male', '04-15-1989', '7831 McCallum Blvd', 'Mumbai', 'Maharashtra', 'India', '10001'),
				    
('P008', 'Sujata', NULL, 'Sinha', 'Female', '01-20-1990', '7832 McCallum Blvd', 'Chennai', 'Tamil Nadu', 'India', '60001'),
				    
('P009', 'Ahana', NULL, 'Patil', 'Female', '10-07-1991', '7833 McCallum Blvd', 'Hyderabad', 'Andhra Pradesh', 'India', '80001'),

('P010', 'Rituparna', 'Sinha', 'Roy', 'Female', '10-07-1994', '7834 McCallum Blvd', 'Delhi', 'New Delhi', 'India', '20001'),

('P011', 'Sinchan', NULL, 'Bhattacharya', 'Male', '10-07-1992', '7835 McCallum Blvd', 'Leh', 'Jammu Kashmir', 'India', '90001'),

('P012', 'Arnab', NULL, 'Choudhury', 'Male', '10-07-1996', '7836 McCallum Blvd', 'Shimla', 'Himachal Pradesh', 'India', '23001')

GO

INSERT INTO PhoneNumber VAlUES

('P001', '4699961541'),

('P002', '3699972354'),

('P003', '2699971234'),

('P004', '5699972354'),

('P005', '6699972354'),
				
('P006', '7699972354'),
				
('P007', '8699972354'),
				
('P008', '9699972354'),
				
('P009', '1699972354'),

('P010', '1099972354'),
				
('P011', '1199972354'),
				
('P012', '1299972354')

GO

INSERT INTO SilverCustomer VALUES

('P002', 1, 0, 'parth@utdallas.edu', '01-01-2010'),

('P003', 0, 1, NULL, '01-01-2003'),

('P004', 1, 1, 'srijit@utdallas.edu', '01-01-2006'),

('P005', 1, 0, 'aritra@utdallas.edu', '01-01-2020'),
		
('P006', 0, 1, NULL, '01-01-2000'),
		
('P007', 1, 1, 'tanmoy@utdallas.edu', '01-01-2015')

GO	

INSERT INTO Employee VALUES
('P001', 'Manager', '01-01-1998'),
('P008', 'Manager', '01-01-2008'),
('P009', 'Cashier', '01-01-2019'),
('P010', 'Cashier', '01-01-2014'),
('P011', 'Floor Staff', '01-01-2005'),
('P012', 'Floor Staff', '01-01-2003')

GO

INSERT INTO GoldCustomer VALUES

('P001', '01-01-1998'),
('P003', '01-31-2008'),
('P004', '01-01-2012'),
('P006', '01-01-2001'),
('P009', '01-28-2019'),
('P011', '01-01-2018')

GO

INSERT INTO EmployeeDesignationHistories VALUES
('P001', 'Manager', '01-01-2000'),
('P001', 'Cashier', '01-01-1999'),
('P001', 'Floor Staff', '01-01-1998'),
('P008', 'Manager', '01-01-2010'),
('P008', 'Cashier', '01-01-2009'),
('P008', 'Floor Staff', '01-01-2008'),
('P009', 'Cashier', '01-01-2020'),
('P009', 'Floor Staff', '01-01-2019'),
('P010', 'Cashier', '01-01-2015'),
('P010', 'Floor Staff', '01-01-2014'),
('P011', 'Floor Staff', '01-01-2005'),
('P012', 'Floor Staff', '01-01-2003')

GO

INSERT INTO Aisle VALUES

(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(2, 'B'),
(3, 'A'),
(4, 'A'),
(5, 'A'),
(5, 'B'),
(5, 'C')
GO

INSERT INTO Supplier VALUES
('Supplier A', '1234567890', 'Dallas, Texas'),
('Supplier B', '2345678901', 'Denton, Texas'),
('Supplier C', '3456789012', 'Irving, Texas'),
('Supplier D', '4567890123', 'Garland, Texas'),
('Supplier E', '5678901234', 'Plano, Texas')

GO

INSERT INTO Product VALUES
(100, 'Product 1', 0, NULL, 1, GETDATE(), 120.50),
(0, 'Product 2', 1, DATEADD(DD, 8, GETDATE()), 1, DATEADD(DD, -1, GETDATE()), 10),
(0, 'Product 3', 1, DATEADD(MM, 1, GETDATE()), 2, DATEADD(DD, -2, GETDATE()), 20),
(0, 'Product 4', 1, DATEADD(MM, 2, GETDATE()), 3, DATEADD(MM, -2, GETDATE()), 30),
(0, 'Product 5', 0, NULL, 1, DATEADD(MM, -3, GETDATE()), 40),
(0, 'Product 6', 0, NULL, 2, DATEADD(DD, -3, GETDATE()), 50),
(200, 'Product 7', 1, GETDATE(), 1, DATEADD(DD, -4, GETDATE()), 60),
(300, 'Product 8', 1, DATEADD(DD, -1, GETDATE()), 4, DATEADD(DD, -5, GETDATE()), 50),
(400, 'Product 9', 1, DATEADD(DD, -2, GETDATE()), 5, DATEADD(DD, -6, GETDATE()), 70),
(500, 'Product 10', 0, NULL, 3, DATEADD(DD, -7, GETDATE()), 80),
(600, 'Product 11', 0, NULL, 4, DATEADD(DD, -8, GETDATE()), 90.10),
(700, 'Product 12', 0, NULL, 5, DATEADD(DD, -9, GETDATE()), 100)

GO

INSERT INTO STORE VALUES 

('Store A', '1234567890', 'Richardson, Texas'),
('Store B', '7734567890', 'Denton, Texas'),
('Store C', '6684567890', 'Dallas, Texas')

GO

INSERT INTO EmployeeStoreAssignmentDetails VALUES

('P001', 1, '01-01-2020',10),
('P001', 1, '04-01-2020',10),
('P001', 1, '05-01-2020',10),
('P008', 1, '01-01-2020',10),
('P008', 1, '04-01-2020',10),
('P008', 1, '05-01-2020',10),
('P001', 2, '04-01-2020',10),
('P008', 3, '04-01-2020',10),
('P010', 1, GETDATE(),10),
('P010', 1, DATEADD(DD, -1, GETDATE()),10),
('P010', 2, DATEADD(DD, -2, GETDATE()),10),
('P010', 2, DATEADD(DD, -3, GETDATE()),10),
('P010', 3, DATEADD(DD, -4, GETDATE()),10),
('P010', 3, DATEADD(DD, -5, GETDATE()),10),
('P010', 3, DATEADD(DD, -6, GETDATE()),10),
('P010', 3, DATEADD(DD, -7, GETDATE()),10),
('P012', 2, GETDATE(),10),
('P012', 2, DATEADD(DD, -1, GETDATE()),10),
('P012', 3, DATEADD(DD, -2, GETDATE()),10),
('P012', 3, DATEADD(DD, -3, GETDATE()),10),
('P012', 1, DATEADD(DD, -4, GETDATE()),10),
('P012', 1, DATEADD(DD, -5, GETDATE()),10),
('P012', 1, DATEADD(DD, -6, GETDATE()),10),
('P012', 1, DATEADD(DD, -7, GETDATE()),10)

GO


INSERT INTO Vouchers VALUES
('Voucher A', '10% Off'),
('Voucher B', '20% Off'),
('Voucher C', '30% Off'),
('Voucher D', '40% Off'),
('Voucher E', '50% Off'),
('Voucher F', '60% Off'),
('Voucher G', '70% Off'),
('Voucher H', '80% Off'),
('Voucher I', '90% Off'),
('Voucher J', 'Buy 1 Get 1 Free'),
('Voucher K', 'Buy 1 Get 2 Free'),
('Voucher L', 'Buy 1 Get 3 Free')

GO


INSERT INTO VouchersBought VALUES

(1, 'P002', GETDATE()),
(2, 'P002', DATEADD(DD, -1, GETDATE())),
(3, 'P002', DATEADD(DD, -2, GETDATE())),
(4, 'P002', DATEADD(DD, -3, GETDATE())),
(5, 'P002', DATEADD(DD, -4, GETDATE())),
(6, 'P002', DATEADD(DD, -5, GETDATE())),
(7, 'P002', DATEADD(DD, -6, GETDATE())),
(8, 'P002', DATEADD(DD, -7, GETDATE())),
(9, 'P002', DATEADD(DD, -8, GETDATE())),
(10, 'P002', DATEADD(DD, -9, GETDATE())),
(11, 'P002', DATEADD(DD, -1, GETDATE())),
(1, 'P003', GETDATE()),
(2, 'P003', DATEADD(DD, -1, GETDATE())),
(3, 'P003', DATEADD(DD, -2, GETDATE())),
(4, 'P003', DATEADD(DD, -3, GETDATE())),
(5, 'P003', DATEADD(DD, -4, GETDATE())),
(6, 'P003', DATEADD(DD, -5, GETDATE())),
(7, 'P003', DATEADD(DD, -6, GETDATE())),
(8, 'P003', DATEADD(DD, -7, GETDATE())),
(9, 'P003', DATEADD(DD, -8, GETDATE())),
(10, 'P003', DATEADD(DD, -9, GETDATE())),
(12, 'P003', DATEADD(DD, -10, GETDATE())),
(1, 'P004', DATEADD(DD, -1, GETDATE())),
(2, 'P005', DATEADD(DD, -1, GETDATE()))


GO

INSERT INTO Orders VALUES
('Order1', GETDATE(), 100.00, 'P002'),
('Order2', DATEADD(MM, -1, GETDATE()), 200.00, 'P002'),
('Order3', DATEADD(MM, -2, GETDATE()), 1200.00, 'P004')

GO

INSERT INTO OrderDetails VALUES
(1, 6, 2, 100.00),
(2, 6, 4, 200.00),
(3, 6, 24, 1200.00)

GO



INSERT INTO Purchase VALUES

('P001', 1, GETDATE(), 241, 'P009','Card'),
('P001', 2, GETDATE(), 641, 'P010','Card'),
('P001', 1, DATEADD(MM, -1, GETDATE()), 180.20, 'P009','Card'),
('P001', 1, DATEADD(MM, -1, GETDATE()), 200.00, 'P010','Card'),
('P001', 1, DATEADD(MM, -2, GETDATE()), 100.00, 'P009','Card'),
('P001', 1, DATEADD(MM, -2, GETDATE()), 200.00, 'P010','Card'),
('P001', 1, DATEADD(MM, -3, GETDATE()), 100.00, 'P009','Card'),
('P001', 1, DATEADD(MM, -3, GETDATE()), 200.00, 'P010','Cash'),
('P001', 2, DATEADD(MM, -4, GETDATE()), 100.00, 'P009','Cash'),
('P001', 1, DATEADD(MM, -4, GETDATE()), 200.00, 'P010','Cash'),
('P001', 1, DATEADD(MM, -5, GETDATE()), 100.00, 'P009','Cash'),
('P001', 2, DATEADD(MM, -5, GETDATE()), 200.00, 'P010','Cash'),
('P001', 1, DATEADD(MM, -6, GETDATE()), 100.00, 'P009','Cash'),
('P001', 2, DATEADD(MM, -6, GETDATE()), 200.00, 'P010','Cash'),
('P001', 1, DATEADD(MM, -7, GETDATE()), 100.00, 'P009','Cash'),
('P001', 2, DATEADD(MM, -7, GETDATE()), 200.00, 'P010','Cash'),
('P003', 1, GETDATE(), 100.00, 'P009','Card'),
('P010', 3, GETDATE(), 500.00, 'P009','Card'),
('P012', 3, GETDATE(), 200, 'P010','Cash'),
('P001', 1, DATEADD(MM, -7, GETDATE()), 100.00, 'P010','Cash'),
('P001', 2, DATEADD(MM, -7, GETDATE()), 100.00, 'P010','Cash')

GO


INSERT INTO PurchaseDetails VALUES

(1, 1, 2, 241.00),
(2, 1, 2, 241.00),
(2, 2, 2, 20.00),
(2, 3, 2, 40.00),
(2, 4, 1, 30.00),
(2, 5, 1, 40.00),
(2, 9, 1, 70.00),
(2, 12, 2, 200.00),
(3, 11, 2, 180.20),
(4, 12, 2, 200.00),
(5, 12, 1, 100.00),
(6, 12, 2, 200.00),
(7, 12, 1, 100.00),
(8, 12, 2, 200.00),
(9, 12, 1, 100.00),
(10, 12, 2, 200.00),
(11, 12, 1, 100.00),
(12, 12, 2, 200.00),
(13, 12, 1, 100.00),
(14, 12, 2, 200.00),
(15, 12, 1, 100.00),
(16, 12, 2, 200.00),
(17, 12, 1, 100.00),
(18, 12, 5, 500.00),
(19, 12, 2, 200.00),
(20, 5, 1, 40.00),
(20, 7, 1, 60.00),
(21, 8, 2, 100.00)

GO