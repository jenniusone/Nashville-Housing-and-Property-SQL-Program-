-- cleaning data in SQL 

select*
from [portfolio ]..NashvilleHousing

--standardize date format 

select SaleDateConverted, convert (date,SaleDate)
from [portfolio ]..NashvilleHousing

update NashvilleHousing
set SaleDate = convert (date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert (date,SaleDate)

--populated property address data

select *
from [portfolio ]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress,b.PropertyAddress)
from [portfolio ]..NashvilleHousing a
join [portfolio ]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update  a
set PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress)
from [portfolio ]..NashvilleHousing a
join [portfolio ]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-- breaking out adddress into individual columns (addrre, city, state)

select PropertyAddress
from [portfolio ]..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID
  
select
SUBSTRING(PropertyAddress,1, CHARINDEX (',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, len(PropertyAddress))as Address

from [portfolio ]..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress varchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX (',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity varchar(255);

update NashvilleHousing
set PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX (',',PropertyAddress) +1, len(PropertyAddress))

select*
from [portfolio ]..NashvilleHousing



select OwnerAddress
from [portfolio ]..NashvilleHousing

select 
parsename ( replace (OwnerAddress,',','.'),1)
, parsename ( replace (OwnerAddress,',','.'),2)
,parsename ( replace (OwnerAddress,',','.'),3)
from [portfolio ]..NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress varchar(255);

update NashvilleHousing
set OwnerSplitAddress =parsename ( replace (OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity varchar(255);

update NashvilleHousing
set OwnerSplitCity  = parsename ( replace (OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnerSplitState varchar(255);

update NashvilleHousing
set OwnerSplitState  = parsename ( replace (OwnerAddress,',','.'),1)

select *
from [portfolio ]..NashvilleHousing


-- change y and N yo yes and no in " sold as vacant" field 

select distinct(SoldAsVacant), count(SoldAsVacant)
from [portfolio ]..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [portfolio ]..NashvilleHousing

UPDATE NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

-- remove duplicate 
with ROWNumCTE as (
select*,
	row_number() over(
	partition by parcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num 


from [portfolio ]..NashvilleHousing
--order by ParcelID
)

select*
from ROWNumCTE
where row_num >1
order by PropertyAddress

select *
from [portfolio ]..NashvilleHousing

-- delete unused column 

select *
from [portfolio ]..NashvilleHousing

alter table [portfolio ]..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [portfolio ]..NashvilleHousing
drop column  SaleDate

alter table [portfolio ]..NashvilleHousing
drop column  OwnerSplitSatet