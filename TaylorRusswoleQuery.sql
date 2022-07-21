Select *
From FirstSQL..['tayloratwood Dataset$']
Select *
From FirstSQL..['russelorhii Dataset$']


-- Combine Table for dataset
Select *
From FirstSQL..['russelorhii Dataset$']
UNION ALL
Select *
From FirstSQL..['tayloratwood Dataset$']


-- This will be the main dataset used for Tableau, Meets in USAPL Only
Create View AtwoodRusswoleUSAPL as
Select Name, Age, AgeClass, Division, BodyweightKg, WeightClassKg, Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg, Dots, Wilks, Federation, CAST(Date AS DATE) as Date, MeetName
From FirstSQL..['russelorhii Dataset$']
Where Federation = 'USAPL'
UNION ALL
Select Name, Age, AgeClass, Division, BodyweightKg, WeightClassKg, Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg, Dots, Wilks, Federation, CAST(Date AS DATE)as Date, MeetName 
From FirstSQL..['tayloratwood Dataset$']
Where Federation = 'USAPL'


-- This will be used to make a geographic map of the states that they have competed in 
Create View USAMeets as
Select name,MeetState, MeetTown, MeetCountry, MeetName
From FirstSQL..['russelorhii Dataset$']
Where MeetCountry='USA'
UNION ALL
Select name, MeetState, MeetTown, MeetCountry, MeetName
From FirstSQL..['tayloratwood Dataset$']
Where MeetCountry='USA'

-- What if we compared meets that they competed in together?
Select russ.Date, russ.MeetName, russ.Name, russ.BodyweightKg, russ.Best3BenchKg, russ.Best3DeadliftKg, russ.Best3SquatKg, russ.TotalKg, russ.Dots, tay.Name, tay.BodyweightKg, tay.Best3BenchKg, tay.Best3DeadliftKg, tay.Best3SquatKg, tay.TotalKg, tay.Dots
From FirstSQL..['russelorhii Dataset$'] russ
Join FirstSQL..['tayloratwood Dataset$']tay
	On russ.Date = tay.Date
-- Issue with this way: Tay Table will simply just be added on the same row as the dates, making reading and visualizing data harder (data becomes 'uglier' as well)

-- Looking at when Atwood competed in Russ's weightclass
Select Name, Age, AgeClass, Division, BodyweightKg, WeightClassKg, Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg, Dots, Wilks, Federation, CAST(Date AS DATE) as Date, MeetName
From FirstSQL..['russelorhii Dataset$']
Where WeightClassKg = '83'
UNION ALL
Select Name, Age, AgeClass, Division, BodyweightKg, WeightClassKg, Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg, Dots, Wilks, Federation, CAST(Date AS DATE)as Date, MeetName 
From FirstSQL..['tayloratwood Dataset$']
Where WeightClassKg = '83'
order by Dots desc
-- We use Dots when comparing lifters as it takes into account their body weight as opposed to just straight Total, and it is the system used in USAPL




-- Turn altered table query into file to use for Tableau
