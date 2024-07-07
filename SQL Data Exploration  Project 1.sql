
Select *
From [Portfolio Project]..['CovidDeaths I$']
Where Continent is not null
Order By 3,4


----Select *
----From [Portfolio Project]..CovidVaccinations$
----Order by 3,4

----Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths,population 
From [Portfolio Project]..['CovidDeaths I$']
Where Continent is not null
Order By 1,2



---Looking at Total Cases Vs Total Deaths
---These shows the likelihood of dying if you contract Covid in your country
Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..['CovidDeaths I$']
Where location like '%States%'
and Continent is not null
Order By 1,2


---Looking at Total Cases Vs Population
---These shows what percentage of population got Covid

Select Location, date, Population, total_Cases, (total_cases/Population)*100 as PercentOfPopulationInfected
From [Portfolio Project]..['CovidDeaths I$']
---Where location like '%States%'
Order By 1,2


--Looking at Countries With Highest Infection Rate Compared to Population

Select Location,  Population, MAX (total_Cases) as HighestInfectionCount, MAX ((total_cases/Population))*100 as 
  PercentPopulationInfected
From [Portfolio Project]..['CovidDeaths I$']
---Where location like '%States%'
Group by Location, Population
Order By PercentPopulationInfected desc


-- Showing Countries With Highest Death Count Per Population


Select Location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..['CovidDeaths I$']
---Where location like '%States%'\
Where Continent is not null
Group by Continent
Order By TotalDeathCount  desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(Cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..['CovidDeaths I$']
---Where location like '%States%'\
Where Continent is not null
Group by continent
Order By TotalDeathCount  desc


-- LET'S BREAK THINGS DOWN BY CONTINENT


-- Showing Continents With The Highest Death Count Per Population

Select continent, MAX(Cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..['CovidDeaths I$']
---Where location like '%States%'\
Where Continent is not null
Group by continent
Order By TotalDeathCount  desc

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
as DeathPercentage
From [Portfolio Project]..['CovidDeaths I$']
--Where location like '%States%'
Where Continent is not null
--Group By date
Order By 1,2


--- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.Date)
  as RollingPeopleVaccinated
--, ( RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..['CovidDeaths I$'] dea
Join [Portfolio Project]..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date 
 Where dea. Continent is not null
 Order By 2,3


 --USE CTE

 With PopvsVac (Continent,Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 as
 (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.Date)
  as RollingPeopleVaccinated
--, ( RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..['CovidDeaths I$'] dea
Join [Portfolio Project]..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date 
 Where dea. Continent is not null
-- Order By 2,3
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac 


 -- TEMP TABLE


 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.Location Order by dea.location, dea.Date)
  as RollingPeopleVaccinated
--, ( RollingPeopleVaccinated/Population)*100
From [Portfolio Project]..['CovidDeaths I$'] dea
Join [Portfolio Project]..CovidVaccinations$ vac
  On dea.location = vac.location
  and dea.date = vac.date 
 --Where dea. Continent is not null
-- Order By 2,3
 
 Select *, (RollingPeopleVaccinated/Population)*100
 From  #PercentPopulationVaccinated
 








