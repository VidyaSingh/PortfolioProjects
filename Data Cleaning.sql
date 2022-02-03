SELECT *
FROM DataCleaning.dbo.NashvilleHousing

Select SaleDate, CONVERT(Date,SaleDate)
From DataCleaning.dbo.NashvilleHousing

UPDATE DataCleaning.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

--POPULATING THE PROPERTY ADDRESS DATA

Select *
From DataCleaning.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
JOIN DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

Select PropertyAddress
From DataCleaning.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From DataCleaning.dbo.NashvilleHousing

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM DataCleaning.DBO.NashvilleHousing

Select OwnerAddress
From DataCleaning.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From DataCleaning.dbo.NashvilleHousing

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM DataCleaning.dbo.NashvilleHousing

--CHANGING 'Y' AND 'N' TO 'YES' AND 'NO'

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From DataCleaning.dbo.NashvilleHousing

Update DataCleaning.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--REMOVING DUPLICATES

SELECT *
FROM DataCleaning.DBO.NashvilleHousing

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From DataCleaning.dbo.NashvilleHousing
--order by ParcelID
)
SELECT*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--DELETING UNUSED COLUMNS

SELECT*
FROM DataCleaning.DBO.NashvilleHousing

ALTER TABLE DataCleaning.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







