-- Viewing Dataset / Playing with SQL 
Select *
From FirstSQL..val_stats
--Ordering by win_percent
--order by 20 asc

-- Question 1: Which region has the best win percentage ?

Select region, CONVERT(DECIMAL(10,2),AVG(win_percent)) as Average_Win_Percentage
From FirstSQL.dbo.val_stats
group by region
order by Average_Win_Percentage desc;

-- Latin America has highest win percentage across all regions with Asian Pacific having 2nd highest win percentage

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Question 2: Which region has best headshot percentage

Select region, CONVERT(DECIMAL(10,3),AVG(headshot_percent)) as headshot_percentage
From FirstSQL..val_stats
group by region
order by region asc;
-- AP Has best headshot_percentage

-- Question 3: Is there difference between Rad1, Rad2, and Immortal in headshot_percent

Select rating, CONVERT(DECIMAL(10,3),AVG(headshot_percent)) as headshot_percentage
From FirstSQL..val_stats
group by rating
order by rating desc;
-- TODO: Find way to order rating column in specific Riot Games rank order

-- Making a new column that displays total number of games played in IMM+
Select region, name, tag, wins, CONVERT(DECIMAL(10,0),wins/(win_percent/100)) as games, win_percent
From FirstSQL..val_stats
order by games desc

--Adding the total games column into our table (Note: Reordering Columns not allowed)
ALTER TABLE val_stats
ADD games float;
UPDATE val_stats
SET games = CONVERT(DECIMAL(10,0),wins/(win_percent/100)) 

--To keep this dataset more consistent, we want to remove the players that are not IMM and above
Select region, name, tag, rating
From FirstSQL..val_stats
Delete From val_stats 
Where rating NOT IN ('Radiant','Immortal 3', 'Immortal 2', 'Immortal 1');

Select *
From FirstSQL..val_stats

-- For Fun: Is there any correlation in the number of first bloods and whether or not the main agent was a duelist?
Select region, name, rating, first_bloods, agent_1, agent_2, agent_3
From FirstSQL..val_stats
Where agent_1 NOT IN ('Jett', 'Reyna')
order by first_bloods desc
-- Another way we can look at this is if we group by agents and show sum of first bloods for each agent!
Select agent_1, SUM(first_bloods) as total_first_bloods
From FirstSQL..val_stats--We only use agent 1 as we will only take into account most played agents
group by agent_1
order by total_first_bloods desc -- What other info could we associate with different agents?
-- Main focus of this project is to compare regions, so for now we'll table comparing different agents for a later project !

-- Now, we'll create new table that will only have information we need for visualization purposes
DROP table if exists #TopPlayersInformation
Create Table #TopPlayersInformation
(
region nvarchar(255),
name nvarchar(255),
tag nvarchar(255),
rating nvarchar(255),
damage_round float,
headshots float,
headshot_percent float,
kills float,
kd_ratio float,
kills_round float,
score_round float,
wins float,
games float,
win_percent float
)


Insert into #TopPlayersInformation
Select region, name, tag, rating, damage_round, headshots, headshot_percent, kills, kd_ratio, kills_round, score_round, wins, games, win_percent
From FirstSQL..val_stats

Select *
From #TopPlayersInformation
Delete From #TopPlayersInformation 
Where name is null

Select *
From #TopPlayersInformation
Where name is null

-- Creating View to store data for visualizations 
Create View TopPlayersInformation as
Select region, name, tag, rating, damage_round, headshots, headshot_percent, kills, kd_ratio, kills_round, score_round, wins, games, win_percent
From FirstSQL..val_stats
Where name is not null

Select *
From TopPlayersInformation
