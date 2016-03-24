CREATE TABLE [BI].[FactSales]
(
    [FactSalesID] INT IDENTITY NOT NULL
  , [DimCustomerID] INT NOT NULL
  , [DimProductID] INT NOT NULL
  , [ShipDateID] INT NULL
  , [SubTotal] MONEY NOT NULL
  , [TaxAmt] MONEY NOT NULL
  , [Freight] MONEY NOT NULL
  , [TotalDue] MONEY NOT NULL
  , [OrderQty] SMALLINT NOT NULL
  , [ProductID] INT NOT NULL
  , [UnitPrice] MONEY NOT NULL
  , [UnitPriceDiscount] MONEY NOT NULL
  , [LineTotal] NUMERIC(38, 6) NOT NULL
)
