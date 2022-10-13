-- Cleaning Data in SQL
select *
from NashvilleHousing

--Standardize data format
select SaleDate, CONVERT(Date, SaleDate)
from NashvilleHousing


ALTER TABLE	NashvilleHousing
ADD SaleDateconverted Date;


Update NashvilleHousing
SET SaleDateconverted  = CONVERT(Date, SaleDate)


-- Populate Address data
select PropertyAddress
from NashvilleHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out address into individual Columns(Address, City, State)
select PropertyAddress
from NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARIndex(',', PropertyAddress) -1) as Address


from NashvilleHousing

Update NashvilleHousing
SET PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARIndex(',', PropertyAddress) -1)


select ownerAddress
from NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);
update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

select*
from NashvilleHousing

-- CHange Y and N to sold/vacant column

-- finding the total number of sold as vacant propterty
select SoldAsVacant, Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select soldAsVacant,
CASE when soldasVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when soldasVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END

	-- Remove Duplicate
	
	with RowNum As(
	select *,
	ROW_NUMBER() OVER(
	Partition By ParcelId,PropertyAddress,SalePrice,SaleDate, LegalReference
	Order BY UniqueID) row_num

	from NashvilleHousing)

	delete
	from RowNum
	where row_num > 1
	-- Delete unused columns
	select *
	from NashvilleHousing

	ALTER TABLE NashvilleHousing
	DROP column OwnerAddress, TaxDistrict, PropertyAddress

	ALTER TABLE NashvilleHousing
	DROP column SaleDate