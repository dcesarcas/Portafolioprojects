Use PortafolioProject
GO

Select * From CovidDeaths
where continent is not null
Order by 3,4

/*
Select * from CovidVaccinations
Order by 3,4
*/

---Select data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2

--Looking at total cases vs total deaths 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
From CovidDeaths
Where location like 'Guatemala' and continent is not null
order by 1,2

--Looking at total cases vs the population
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulation 
From CovidDeaths
--Where location like 'Guatemala'
order by 1,2

--looking at countrys with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as Percentagepopulationinfected 
From CovidDeaths
--Where location like 'Guatemala'
group by location, population
order by Percentagepopulationinfected  desc

--looking at countrys with highest deaths
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like 'Guatemala'
where continent is not null
group by location
order by TotalDeathCount  desc

---lets break things down by continent 



--Showing the continent with the highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like 'Guatemala'
where continent is not null
group by continent
order by TotalDeathCount  desc


--Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage 
From CovidDeaths
Where continent is not null
--group by date
order by 1,2


--lookin at total population vs vaccinations


with PopvsVac (Continent, location, date, population, Rollingpeoplevaccinated, New_vaccinations)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.Date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *,(Rollingpeoplevaccinated/population)*100 from PopvsVac

--Temp table (tabla temporal)
Drop table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
Rollingpeoplevaccinated numeric
)

Insert into #PercentPopulationVaccinated Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.Date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3 


Select *,(Rollingpeoplevaccinated/population)*100 from #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.Date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date

Select * from 
PercentPopulationVaccinated
Where continent is not null