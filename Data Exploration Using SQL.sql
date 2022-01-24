SELECT *
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4

--SELECT*
--FROM SQLDataExploration..CovidVaccination
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
--WHERE location = 'Asia'
ORDER BY 1,2

--
SELECT location, date, total_cases, population, (total_deaths/population)*100 AS PercentPopulationInfected
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
--WHERE location = 'india'
ORDER BY 1,2
--
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_deaths/population))*100 AS PercentPopulationInfected
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
--WHERE location = 'india'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--
SELECT location, MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT continent, MAX(CAST(total_deaths AS int)) as TotalDeathCount
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

--
SELECT SUM(new_cases) AS Total_cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int)) / SUM(new_cases)*100 AS DeathPercentage
FROM SQLDataExploration..CovidDeaths
WHERE continent is not NULL
--WHERE location = 'Asia'
--GROUP BY date
ORDER BY 1,2


With PopVsVac (Continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location
, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM SQLDataExploration..CovidDeaths dea
JOIN SQLDataExploration..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT*, (RollingPeopleVaccinated/population)*100
FROM PopVsVac

--
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location
, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM SQLDataExploration..CovidDeaths dea
JOIN SQLDataExploration..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location
, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM SQLDataExploration..CovidDeaths dea
JOIN SQLDataExploration..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT*
FROM PercentPopulationVaccinated
 


