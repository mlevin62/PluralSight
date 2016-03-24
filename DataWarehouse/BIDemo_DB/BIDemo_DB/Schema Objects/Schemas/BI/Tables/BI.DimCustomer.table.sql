CREATE TABLE [BI].[DimCustomer]
(   [DimCustomerID] INT IDENTITY NOT NULL
  , [CustomerID] INT NOT NULL
  , [AddressID] INT NOT NULL
  , [CountryRegion] NVARCHAR(50) NOT NULL
  , [StateProvince] NVARCHAR(50) NOT NULL
  , [City] NVARCHAR(30) NOT NULL
  , [CompanyName] NVARCHAR(128) NULL
)  