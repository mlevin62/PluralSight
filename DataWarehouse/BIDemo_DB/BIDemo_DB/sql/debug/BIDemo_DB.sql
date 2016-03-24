﻿/*
Deployment script for AdventureWorksLT2008R2DW
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "AdventureWorksLT2008R2DW"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"

GO
USE [master]

GO
:on error exit
GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL
    AND DATABASEPROPERTYEX(N'$(DatabaseName)','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'$(DatabaseName)') WITH NOWAIT
    RETURN
END

GO
IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [AdventureWorksLT2008R2DW], FILENAME = N'$(DefaultDataPath)AdventureWorksLT2008R2DW.mdf')
    LOG ON (NAME = [AdventureWorksLT2008R2DW_log], FILENAME = N'$(DefaultLogPath)AdventureWorksLT2008R2DW_log.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
EXECUTE sp_dbcmptlevel [$(DatabaseName)], 100;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)]

GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
PRINT N'Creating [BI]...';


GO
CREATE SCHEMA [BI]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Staging]...';


GO
CREATE SCHEMA [Staging]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [BI].[DimCustomer]...';


GO
CREATE TABLE [BI].[DimCustomer] (
    [DimCustomerID] INT            IDENTITY (1, 1) NOT NULL,
    [CustomerID]    INT            NOT NULL,
    [AddressID]     INT            NOT NULL,
    [CountryRegion] NVARCHAR (50)  NOT NULL,
    [StateProvince] NVARCHAR (50)  NOT NULL,
    [City]          NVARCHAR (30)  NOT NULL,
    [CompanyName]   NVARCHAR (128) NULL
);


GO
PRINT N'Creating PK_DimCustomer...';


GO
ALTER TABLE [BI].[DimCustomer]
    ADD CONSTRAINT [PK_DimCustomer] PRIMARY KEY CLUSTERED ([DimCustomerID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [BI].[DimProduct]...';


GO
CREATE TABLE [BI].[DimProduct] (
    [DimProductID] INT           IDENTITY (1, 1) NOT NULL,
    [Category]     NVARCHAR (50) NOT NULL,
    [Subcategory]  NVARCHAR (50) NOT NULL,
    [Product]      NVARCHAR (50) NOT NULL,
    [Color]        NVARCHAR (15) NULL,
    [ListPrice]    MONEY         NOT NULL,
    [ProductID]    INT           NOT NULL
);


GO
PRINT N'Creating PK_DimProduct...';


GO
ALTER TABLE [BI].[DimProduct]
    ADD CONSTRAINT [PK_DimProduct] PRIMARY KEY CLUSTERED ([DimProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [BI].[FactSales]...';


GO
CREATE TABLE [BI].[FactSales] (
    [FactSalesID]       INT             IDENTITY (1, 1) NOT NULL,
    [DimCustomerID]     INT             NOT NULL,
    [DimProductID]      INT             NOT NULL,
    [ShipDateID]        INT             NULL,
    [SubTotal]          MONEY           NOT NULL,
    [TaxAmt]            MONEY           NOT NULL,
    [Freight]           MONEY           NOT NULL,
    [TotalDue]          MONEY           NOT NULL,
    [OrderQty]          SMALLINT        NOT NULL,
    [ProductID]         INT             NOT NULL,
    [UnitPrice]         MONEY           NOT NULL,
    [UnitPriceDiscount] MONEY           NOT NULL,
    [LineTotal]         NUMERIC (38, 6) NOT NULL
);


GO
PRINT N'Creating PK_FactSales...';


GO
ALTER TABLE [BI].[FactSales]
    ADD CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED ([FactSalesID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating [Staging].[DimCustomer]...';


GO
CREATE TABLE [Staging].[DimCustomer] (
    [DimCustomerID] INT            NOT NULL,
    [CustomerID]    INT            NOT NULL,
    [AddressID]     INT            NOT NULL,
    [CountryRegion] NVARCHAR (50)  NOT NULL,
    [StateProvince] NVARCHAR (50)  NOT NULL,
    [City]          NVARCHAR (30)  NOT NULL,
    [CompanyName]   NVARCHAR (128) NULL
);


GO
PRINT N'Creating [Staging].[DimProduct]...';


GO
CREATE TABLE [Staging].[DimProduct] (
    [DimProductID] INT           NOT NULL,
    [Category]     NVARCHAR (50) NOT NULL,
    [Subcategory]  NVARCHAR (50) NOT NULL,
    [Product]      NVARCHAR (50) NOT NULL,
    [Color]        NVARCHAR (15) NULL,
    [ListPrice]    MONEY         NOT NULL,
    [ProductID]    INT           NOT NULL
);


GO
-- Refactoring step to update target server with deployed transaction logs
CREATE TABLE  [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
GO
sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        DECLARE @VarDecimalSupported AS BIT;
        SELECT @VarDecimalSupported = 0;
        IF ((ServerProperty(N'EngineEdition') = 3)
            AND (((@@microsoftversion / power(2, 24) = 9)
                  AND (@@microsoftversion & 0xffff >= 3024))
                 OR ((@@microsoftversion / power(2, 24) = 10)
                     AND (@@microsoftversion & 0xffff >= 1600))))
            SELECT @VarDecimalSupported = 1;
        IF (@VarDecimalSupported > 0)
            BEGIN
                EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
            END
    END


GO
