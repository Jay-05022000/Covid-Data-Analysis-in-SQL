/* The aim for this project is to find meaningfull insights from the "Coronavirus Pandemic (COVID-19)" dataset ehich was
published on 'https://ourworldindata.org/' website by using SQL skillsets.*/


-- Selecting the requiredd data from the table.  

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

-- Find the percentage of people died after getting affected from the corona virus.
 
select location,date,total_cases,total_deaths,( total_deaths/total_cases)*100 as death_percentage
from CovidDeaths
where continent is not null and total_cases > 1000
order by  5  

/* Key insights :
 1) Yeman has more death percentages  when the total_cases are > 1000.
 2) In India the maximum death percentage is 3.59% over the given period.
 3) Uganda has the lowest death percentaged when cases > 1000 in the given period. */

---------------------------------------------------------------------------------------------------------------------------------------------

/* Let's find out the chances of death if you come in a contact with corona virus on a given date in india and also if you where
anywhere else in the globe.*/

select location,date,total_cases,total_deaths,( total_deaths/total_cases)*100 as death_percentage
from CovidDeaths
where  location='india'
order by 5  desc

/* Key insights :
 1) If I  came in the contact with corona virus on my birthday (5th February) in 2021 then I had 1.4325% of dyingin india.
 2) In yeman I had 28.95% chances of dying on the same day.
 3) Guernsey is the place where I won't get affected on that day.
 4) 12th april 2020 was the day when india had maximum death percentage of 3.59%. */

---------------------------------------------------------------------------------------------------------------------------------------------

-- Find out the percentage of population that was affected by covid in india on daily basis.
 
select location,date,total_cases,population,(total_cases/population)*100 as Percentage_of_people_got_affected
from CovidDeaths
where continent is not null and location='india'
order by 1,2

--------------------------------------------------------------------------------------------------------------------------------------------- 

-- Look for contries that has the highest percentage of infection.
 
select location,max(total_cases),max((total_cases)/population)*100 as Percentage_of_people_got_affected
from CovidDeaths
where continent is not null
group by location
order by 3 desc

/* Key insights : Andorra - 17.12 
				: Montenegro - 15.50 */

---------------------------------------------------------------------------------------------------------------------------------------------

-- Look for countries that has Highest deaths percentage per population.
 
select location,max(cast(total_deaths as int)) as max_deaths,max(cast(total_deaths as int)/population)*100 as highest_deaths_count_per_population
from CovidDeaths
where continent is not null
group by location
order by 3 desc

/* Key insights : Hungary - 0.2850   
				: Czechia - 0.2732 */

---------------------------------------------------------------------------------------------------------------------------------------------

-- what was the death percentage per population of india?
 
select location,max(cast(total_deaths as int)) as max_deaths,max(cast(total_deaths as int)/population)*100 as highest_deaths_count_per_population
from CovidDeaths
where continent is not null and location ='india'
group by location

/* Answer : 0.015 */

---------------------------------------------------------------------------------------------------------------------------------------------

-- which country has the highest death count?
 
select location,max(cast(total_deaths as int)) as max_deathcount
from CovidDeaths
where continent is not null
group by location
order by 2 desc

/* Answer : United states */

---------------------------------------------------------------------------------------------------------------------------------------------

-- LET'S BREAKDOWN THINGS BY CONTINENTS.

select continent,max(cast(total_deaths as int)) as max_deathcount
from CovidDeaths
where continent is not null
group by continent
order by 2 desc

---------------------------------------------------------------------------------------------------------------------------------------------

-- which continent has highest death count?

select continent,max(cast(total_deaths as int)) as max_death_counts
from CovidDeaths
where continent is not null
group by continent

/* Answer : North America - 576232  */

---------------------------------------------------------------------------------------------------------------------------------------------

-- Now find out the total_new_cases,total_new_deaths and death percentage across the glob on daily basis.

select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
from CovidDeaths
where continent is not null
group by date
ORDER BY 1

---------------------------------------------------------------------------------------------------------------------------------------------

-- Find out the total-cases,total_deaths and total death percentage across the gloab over the given time period.
  
select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_percentage
from CovidDeaths
where continent is not null

/* Answer : total_cases : 150574977
		  : total_deaths : 3180206 
		  : Death_percentage : 2.11204149810363 */

 --------------------------------------------------------------------------------------------------------------------------------------------
 
-- Find out the total population that got vaccinated in the world by continents.

 drop table if exists #temp_table
 create table #temp_table
 ( continent varchar(50),total_population int,total_vaccinations int)
 
 insert into #temp_table
select deaths.continent,max(population) as total_population ,sum(cast(vac.new_vaccinations as int)) as total_vaccinations
from CovidDeaths as deaths
join CovidVaccinations as vac
on deaths.location=vac.location
and deaths.date=vac.date
 --	group by deaths.continent
 where deaths.continent is not null
 group by deaths.continent
 order by 1

 select *
from #temp_table

/* Answer :
  continent	      total_population  total_vaccinations
  North America	  331002647	        259442763
  Asia	          1439323774	    414209682
  Africa	      206139587	        10172674
  Oceania	      25499881	        2440594
  South America	  212559409	        70118969
  Europe	      145934460	        190470453 */

---------------------------------------------------------------------------------------------------------------------------------

-- creating view for later data visualisation :views are stored permanently in database and you can also access them same as tables.

create view temp_table_for_total_pop_vs_vacc as,
select deaths.continent,max(population) as total_population ,sum(cast(vac.new_vaccinations as int)) as total_vaccinations
from CovidDeaths as deaths
join CovidVaccinations as vac
on deaths.location=vac.location
and deaths.date=vac.date
 --	group by deaths.continent
 where deaths.continent is not null
 group by deaths.continent
 --order by 1

 select *
 from temp_table_for_total_pop_vs_vacc
