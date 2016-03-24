CREATE TABLE [Staging].[DimProduct]
(   [DimProductID] INT NOT NULL
  , [Category] NVARCHAR(50) NOT NULL
  , [Subcategory] NVARCHAR(50) NOT NULL
  , [Product] NVARCHAR(50) NOT NULL
  , [Color] NVARCHAR(15) NULL
  , [ListPrice] MONEY NOT NULL
  , [ProductID] INT NOT NULL
)
