-- Data Exploration 

select *
from PortfolioProject1..deaths
order by 3,4

-- Selectionnons les donée qui seront utilisées

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..deaths
 order by 1,2

 --looking at total cases vs total deaths
 select Location, date, total_cases, total_deaths, (total_deaths/total_cases)as deathpourcentage
from PortfolioProject1..deaths
where location like '%france%'
 order by 1,2


 --Looking at the total cases vs population
 -- donne quel pourcentage de la population a attraper le covid 
 select location, total_cases, population,date, (total_cases/population)*100 as pourcentage_population_infect
 from PortfolioProject1..deaths
 where location like '%monaco%'
 order by 1,2

 -- le pays ayant le plus grand nombre de cas en fonction de sa population 
 select location, MAX(total_cases), population, Max((total_cases/population)*100) as pourcentage_population_infect
 from PortfolioProject1..deaths
 Group by location, population
 order by pourcentage_population_infect desc

 --le pays avec le plus grand nombre de mort par population 
  select location, max(cast((total_deaths) as int)) as total_mort
 from PortfolioProject1..deaths
 where continent is not null 
 Group by location
 order by total_mort desc

 --classement des continents en fonctions de leur nombre de mort 
 select continent, max(cast((total_deaths) as int)) as total_mort
 from PortfolioProject1..deaths
 where continent is not null 
 Group by continent
 order by total_mort desc 


 -- Pourcentage des descés par rapport au nouveau cas dans le monde 

 select date, SUM(new_cases) as somme_des_cas, SUM(cast(new_deaths as int)) as somme_des_desces,
 SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Pourcentage_desces
 from PortfolioProject1..deaths
 --where location like '%monaco%'
 where continent is not null
 Group by date
 order by 1,2


 --
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location )
 From PortfolioProject1..deaths dea Join PortfolioProject1..vaccination vac
 On dea.location = vac.location and dea.date = vac.date 
 where dea.continent is not null 
 order by 2,3


 --Utilisation d'un cte

 with Popvsvac(continent, location, data, population, New_Vaccinations, RollingPeopleVaccinated)
 as 
 (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(cast(vac.new_vaccinations as int )) OVER (Partition by dea.Location )
 From PortfolioProject1..deaths dea Join PortfolioProject1..vaccination vac
 On dea.location = vac.location and dea.date = vac.date 
 where dea.continent is not null 
 --order by 2,3
 )
 select *, (RollingPeopleVaccinated/population)*100
 From Popvsvac




 -- Temps Table
 drop table if exists #Pourcentagedepersonnesvacciné
 Create table #Pourcentagedepersonnesvacciné
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date nvarchar(255),
 Population float,
 New_vaccinations nvarchar(255),
 Nombredepersonnevacinée int
 )
 Insert into #Pourcentagedepersonnesvacciné

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(cast(vac.new_vaccinations as int) ) OVER (Partition by dea.Location )
 From PortfolioProject1..deaths dea Join PortfolioProject1..vaccination vac
 On dea.location = vac.location and dea.date = vac.date 
 where dea.continent is not null 
 --order by 2,3

select *, (Nombredepersonnevacinée/population)*100
 From #Pourcentagedepersonnesvacciné



 -- creer une view pour enregistrer les donnée pour la les visualiser
 Create View Pourcentagedepersonnesvacciné as 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(cast(vac.new_vaccinations as int) )  OVER (Partition by dea.Location ) as nombredevacciné
 From PortfolioProject1..deaths dea 
 Join PortfolioProject1..vaccination vac
 On dea.location = vac.location 
 and dea.date = vac.date 
 where dea.continent is not null 
 --order by 2,3
 
 

