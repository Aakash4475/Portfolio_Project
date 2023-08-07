select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4 

-- Select Data that we going to be using 

Select location,date, total_cases , new_cases, total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2


-- Looking at Toatal Deaths vs Total Cases
-- shows likelihood if you dying in you contact covid in your conuntry

Select location,date, total_cases, total_deaths , (total_deaths/total_cases)*100 as Deathpercentage
From PortfolioProject..CovidDeaths

order by 1,2

-- Look at Total cases vs Population 
-- Shows the percentage of poulation got in Covid

Select location,date, population, total_cases, (total_cases/population)*100 as Casespercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to population 


Select location,  population, MAX(total_cases)as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location,  population
order by HighestInfectionCount desc


-- Showing countries with Highest Death Count per population 

Select location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--Let's Break things dwon by continent 

Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select  SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) total_deaths , SUM(cast(new_deaths as int))/SUM
	(New_cases)*100 as DeathPercetage
from PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null 
--group by date
order by 1,2


-- Looking at Total population vas Vaccinations


Select dea.continent, dea.location , dea.date, population , vac.new_vaccinations
	,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations  vac
	on dea.location  = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by  2,3


-- USE CTE

with PopvsVac (continent, Location , Date , population , New_vaccinations , RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location , dea.date, population , vac.new_vaccinations
	,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations  vac
	on dea.location  = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by  2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac





--- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location , dea.date, population , vac.new_vaccinations
	,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations  vac
	on dea.location  = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by  2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated





-- Createing View  

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location , dea.date, population , vac.new_vaccinations
	,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
	--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations  vac
	on dea.location  = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by  2,3


select *
from PercentPopulationVaccinated