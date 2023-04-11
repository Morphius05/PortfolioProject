--SELECT *
--FROM CovidDeaths

--SELECT *
--FROM CovidVaccunations

--SELECT location, date, total_cases, total_deaths,(total_deaths/NULLIF(total_cases, 0))*100 AS DeathsPorcentage
--FROM CovidDeaths
-- where continent is not null
--ORDER BY 2,3


--looking at Total Cases vs total Deaths
--SELECT location, date, total_cases, total_deaths,(total_deaths/NULLIF(total_cases, 0))*100 AS DeathsPorcentage
--FROM CovidDeaths
--WHERE location = 'United States'
-- and continent is not null
--ORDER BY 1,2

--Looking at the Total Cases VS Population

--SELECT location, date, population, total_cases, (total_cases/population)*100 AS PorcentOfPopulationInfected
--FROM CovidDeaths
----WHERE location LIKE '%xico'
-- and continent is not null
--ORDER BY DeathsPorcentage DESC


----Looking at countries with highest infection rate  compared to population
--SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PorcentOfPopulationInfected
--FROM CovidDeaths
----WHERE location LIKE '%xico'
-- and continent is not null
--Group by location, population
--Order by PorcentOfPopulationInfected DESC


--Showing Countries with the Highest Deat Count per Population
--SELECT Location, MAX(Total_Deaths) as TotalDeathsCount
--FROM CovidDeaths
----WHERE location LIKE '%xico'
--where continent is not null
--Group by location
--Order by TotalDeathsCount DESC


---- Lets break things down by continent
--SELECT continent, MAX(Total_Deaths) as TotalDeathsCount
--FROM CovidDeaths
----WHERE location LIKE '%xico'
--where continent is not null
--Group by continent
--Order by TotalDeathsCount DESC


-- Showing Continents with the Highest Deat Count per Population
--SELECT continent, MAX(Total_Deaths) as TotalDeathsCount
--FROM CovidDeaths
----WHERE location LIKE '%xico'
--where continent is not null
--Group by continent
--Order by TotalDeathsCount DESC

---- Global numbers
--SELECT date, SUM(new_cases) AS TotalNewCases, SUM(new_deaths) AS TotalNewDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPorcentage 
--FROM CovidDeaths
--where continent is not null
--Group by date
--ORDER BY 1,2


--Looking at total population vs vaccunations

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM (vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) AS RollinfPeopleVaccinated,
----(RollinfPeopleVaccinated/population)*100
--From CovidDeaths dea
--Join CovidVaccunations vac
--on dea.location=vac.location 
--and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

-- Use CTE

--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM (vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) AS RollinfPeopleVaccinated
----(RollinfPeopleVaccinated/population)*100
--From CovidDeaths dea
--Join CovidVaccunations vac
--on dea.location=vac.location 
--and dea.date=vac.date
--where dea.continent is not null
----order by 2,3
--)
--Select *, (RollingPeopleVaccinated/population)*100
--From PopvsVac

--Tem Table
--Drop Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar (255),
--Location nvarchar (255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)


--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM (vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) AS RollinfPeopleVaccinated
----(RollinfPeopleVaccinated/population)*100
--From CovidDeaths dea
--Join CovidVaccunations vac
--on dea.location=vac.location 
--and dea.date=vac.date
--where dea.continent is not null
----order by 2,3

--Select *, (RollingPeopleVaccinated/population)*100
-- From #PercentPopulationVaccinated

 -- Create view to store for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (vac.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) AS RollinfPeopleVaccinated
--(RollinfPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccunations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null


Select *
from PercentPopulationVaccinated