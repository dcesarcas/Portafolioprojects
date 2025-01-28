--USE PortafolioProject
--Go
---Cleaning Data
--Standardize data format
Select Saledate, CONVERT(Date, Saledate) from NashvilleHousing

UPDATE NashvilleHousing
SET Saledate = CONVERT(Date, saledate)

ALTER TABLE NashvilleHousing
ALTER COLUMN Saledate Date

--Populate property address data
Select * from NashvilleHousing
--where PropertyAddress is null
Order by ParcelID 

--Se repetian ID pero unos no tenian completa la informacion, entonces donde era nulo la informacion se puso la correcta

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing  a
JOIN NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null
 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing  a
JOIN NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]

--Breaking out address into individual columns (Address, city, state)
--Separar los datos de la columna, entre ciudad, direccion y estado en diferentes columnas
Select PropertyAddress from NashvilleHousing

Select  --En el charindex busca la posicion que queremos, es decir despues de la coma 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)  as Address --Busca la , El -1 hace que quite la coma, busca hasta al coma y luego quita una posicion que es la coma
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))
From NashvilleHousing

---CREAMOS LA NUEVA COLUMNA PARA RECIBIR LA DIRECCION 
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

--ACTUALIZAMOS LOS VALORES DE LA NUEVS COLUMNA PARA DIRECCION, BUSCAN SOLO LA PRIMERA PARTE DE LA COLUMNA QUE QUEREMOS
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity =SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select * from NashvilleHousing


--EDITAR EL OWNERADDRESS, hacer lo mismo de arriba pero de forma resumida
Select OwnerAddress from NashvilleHousing

--CON EL PARSENAME ESTE BUSCA SEPARAR PERO BUSCA UN . COMO ACÁ ESTÁ SEPERADO POR UNA , ENTONCES REEMPLAZAMOS LA , POR UN . Y POR ESO YA NOS SEPARA TODO
--Y EL 1 ES LA POSICION DE LA PALABRA DE DERECHA A IZQUIERDA
Select PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
, PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
From NashvilleHousing

--CREAR LAS COLUMNAS CON LA DIRECCION DIVIDIDA EN TRES COLUMNAS, CREANDO PRIMERO LAS COLUMNAS
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * from NashvilleHousing

--CHANGE Y AND N AND NO IN SOLD AS VACANT FIELD
--ESTA COLUMNA ESTÁ REPETIDA EL SI PORQUE ESTÁ COMO Y Y YES, Y EL N Y NO, ENTONCES VAMOS A COMBINARLOS
Select distinct(SoldAsVacant), COUNT(SoldAsVacant) 
from  NashvilleHousing
Group by SoldAsVacant
Order by 2

--SELECCIONAMOS UN CASE PARA CAMBIAR LOS DATOS
SELECT SoldAsVacant
, Case When SoldAsVacant= 'Y' THEN 'Yes'
		When SoldAsVacant= 'N' THEN 'No'
		Else SoldAsVacant
		End
from  NashvilleHousing

--ACTUALIZAMOS LOS VALORES DE LA COMLUMNA
UPDATE NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant= 'Y' THEN 'Yes'
		When SoldAsVacant= 'N' THEN 'No'
		Else SoldAsVacant
		End

--QUITAR DUPLICADOS

---está enumerando las filas segun los datos de las columnas especificadas, es decir que si el conjunto de esas columnas en cada fila está repetido los enumera de 1 a n, entonces si una fila está repetida es un duplicado
--cuando usamos el with es para crear una consulta aparte, donde lo que está adentro se puede usar en otros
--como cuando queremos crear una medida y usarla para comparacion en otras consultas
WITH RowNumCTE as(
Select *,
ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate, 
	LegalReference
	order by 
	UniqueID
	) row_num

from NashvilleHousing
) DELETE ---BORRAMOS TODOS LOS QUE ESTÉN REPETIDOS DONDE LA COLUMNA ROW_NUM QUE ERA LA QUE CONTABA LAS FILAS CON LOS VALORES DE LAS COLUMNAS PARECIDAS Y DEJANDO SOLO LAS FILAS 1
FROM RowNumCTE
Where row_num > 1


--ELIMINAR COLUMNAS QUE NO USAMOS
Select * from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate


