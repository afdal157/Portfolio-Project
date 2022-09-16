/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject..SprocketCustomer

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


ALTER TABLE SprocketCustomer
Add LastPurchaseDateConverted Date;

Update SprocketCustomer
SET LastPurchaseDateConverted = CONVERT(Date,LastPurchaseDate)

ALTER TABLE SprocketCustomer
Add DateOfBirthConverted Date;

Update SprocketCustomer
SET DateOfBirthConverted = CONVERT(Date,DateOfBirth)


Select *
From PortfolioProject..SprocketCustomer

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, PostCode, State)


Select *
From PortfolioProject..SprocketCustomer
--WHERE Address IS NULL

Select
PARSENAME(REPLACE(Address, ',', '.') , 3),
PARSENAME(REPLACE(Address, ',', '.') , 2),
PARSENAME(REPLACE(Address, ',', '.') , 1)
From PortfolioProject..SprocketCustomer


ALTER TABLE SprocketCustomer
Add NewAddress Nvarchar(255);

Update SprocketCustomer
SET NewAddress = PARSENAME(REPLACE(Address, ',', '.') , 3)


ALTER TABLE SprocketCustomer
Add PostCode Nvarchar(255);

Update SprocketCustomer
SET PostCode = PARSENAME(REPLACE(Address, ',', '.') , 2)


ALTER TABLE SprocketCustomer
Add State Nvarchar(255);

Update SprocketCustomer
SET State = PARSENAME(REPLACE(Address, ',', '.') , 1)


Select *
From PortfolioProject..SprocketCustomer


--------------------------------------------------------------------------------------------------------------------------


-- Change F to Female, Femal to Female, U to Unknown, and M to Male in "Gender" field


Select Distinct(Gender), Count(Gender)
From PortfolioProject..SprocketCustomer
Group by Gender
order by 2



Select Gender
, CASE When Gender = 'F' THEN 'Female'
	   When Gender = 'Femal' THEN 'Female'
	   When Gender = 'U' THEN 'Unknown'
	   When Gender = 'M' THEN 'Male'
	   ELSE Gender
	   END
From PortfolioProject..SprocketCustomer


Update SprocketCustomer
SET Gender = CASE When Gender = 'F' THEN 'Female'
	   When Gender = 'Femal' THEN 'Female'
	   When Gender = 'U' THEN 'Unknown'
	   When Gender = 'M' THEN 'Male'
	   ELSE Gender
	   END


	   		 	  
---------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in the DeceasedIndicator field


Select Distinct(DeceasedIndicator), Count(DeceasedIndicator)
From PortfolioProject..SprocketCustomer
Group by DeceasedIndicator
--order by 2



Select DeceasedIndicator
, CASE When DeceasedIndicator = 'Y' THEN 'Yes'
	   When DeceasedIndicator = 'N' THEN 'No' 
	   ELSE DeceasedIndicator
	   END
From PortfolioProject..SprocketCustomer


Update SprocketCustomer
SET DeceasedIndicator = CASE When DeceasedIndicator = 'Y' THEN 'Yes'
	   When DeceasedIndicator = 'N' THEN 'No' 
	   ELSE DeceasedIndicator
	   END

SELECT *
FROM PortfolioProject..SprocketCustomer


	   		 	  
--------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY FirstName,
				 LastName,
				 Gender,
				 DateOfBirth,
				 LastPurchaseDate
				 ORDER BY
					CustomerID
					) row_num

From PortfolioProject.dbo.SprocketCustomer
)
Select *
From RowNumCTE
Where row_num > 1
Order by LastPurchaseDate



Select *
From PortfolioProject..SprocketCustomer


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject..SprocketCustomer


ALTER TABLE PortfolioProject..SprocketCustomer
DROP COLUMN Address, LastPurchaseDate, DateOfBirth



--------------------------------------------------------------------------------------------------------------------------


-- Change data type for CustomerID, LastPurchasePrice, And Tenure to Integer


ALTER TABLE PortfolioProject..SprocketCustomer
ALTER COLUMN LastPurchasePrice INTEGER;


ALTER TABLE PortfolioProject..SprocketCustomer
ALTER COLUMN Tenure INTEGER;


ALTER TABLE PortfolioProject..SprocketCustomer
ALTER COLUMN CustomerID INTEGER;


Select *
From PortfolioProject..SprocketCustomer

--------------------------------------------------------------------------------------------------------------------------

/*

My second SQL Project. Thanks to Alex the Analyst who has motivated me to build this project.


*/