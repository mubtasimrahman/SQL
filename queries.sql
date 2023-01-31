connect to cs2db3;


-- q1)
select FirstName, LastName, SalaryPerMonth, YearsOfService
from Employees
where SalaryPerMonth > 12000 and YearsOfService >= 10;

-- q2)
select FirstName, LastName
from Employees 
where FirstName Like 'C%' and Year(BirthDate) > 1970;

-- q3) 
select AVG(SalaryPerMonth) as AVGSALPERMONTH
from Employees
where Gender = 'F';

-- q4)
Select Distinct(GroupName)
FROM ResearchGroups, Rooms , Buildings
WHERE ResearchGroups.ID = Rooms.ResearchGroupID and Buildings.ID= Rooms.BuildingID and Buildings.Name = 'John Hodgins Building';
--BOTH RETURN SAME ANSWER. I KEPT BOTH FOR FUTURE REFERENCE
-- q4)
Select Distinct(ResearchGroups.GroupName)
FROM ResearchGroups Inner Join Rooms 
ON ResearchGroups.ID = Rooms.ResearchGroupID
Inner Join Buildings
ON Buildings.ID= Rooms.BuildingID
WHERE Buildings.Name = 'John Hodgins Building';

-- q5)
select E1.LastName, E1.FirstName
from Employees E1, Employees E2
where E1.LastName = E2.LastName and E1.FirstName <> E2.FirstName
Group by E1.LastName, E1.FirstName
ORDER BY E1.LastName;

-- q6a)
select Buildings.Name, count(*) AS NumOfElevators
FROM Buildings Inner Join hasArea
ON Buildings.ID = hasArea.BuildingID
where hasArea.BuildingAreaTypeID = 2 
Group By Buildings.Name;

-- q6b)
select Buildings.Name, count(*) AS NumOfElevators
FROM Buildings Inner Join hasArea
ON Buildings.ID = hasarea.BuildingID
where hasArea.BuildingAreaTypeID = 2 
Group By Buildings.Name
Having count(*) > 2;

-- q7)
SELECT Distinct(Buildings.Name), BuildingAreaType.TypeName
FROM Buildings Inner Join  hasArea 
ON Buildings.ID = hasarea.BuildingID
Inner Join BuildingAreaType
ON hasArea.BuildingAreaTypeID = BuildingAreaType.ID
where (BuildingAreaType.TypeName = 'Food Area' or  BuildingAreaType.TypeName ='Lobby') and
(hasArea.BuildingAreaTypeID = 4 or hasArea.BuildingAreaTypeID = 8)  ;

-- q8)
Select Employees.ID, LastName, FirstName
FROM Employees,Departments
where (Departments.ChairEmpID = Employees.ID) and Employees.ID not in (Select Distinct(ChairEmpID)	
from Departments, ResearchGroups
where Departments.ID = ResearchGroups.DepartmentID);

-- q9)
select SUM(Hydrobill) as HydroBill
from(
select Meters.ID, ((Max(Rel_MeterInstalledInRoom.Reading)- Min(Rel_MeterInstalledInRoom.Reading))*0.109) as Hydrobill
FROM ResearchGroups Inner Join Rooms
ON ResearchGroups.ID = Rooms.ResearchGroupID 
Inner Join Rel_MeterInstalledInRoom
ON Rel_MeterInstalledInRoom.RoomID = Rooms.ID,
Meters Inner Join MeterType
ON Meters.MeterTypeID = MeterType.ID
Inner Join Rates 
ON MeterType.RateID = Rates.ID
where ResearchGroups.ID = 4 and  Meters.MeterTypeID= 1 and (Month(DateOfRecord) = 1 or (Month(DateOfRecord) = 2 and Day(DateofRecord) =1)) and Meters.ID = Rel_MeterInstalledInRoom.MeterID 
Group BY Meters.ID);


-- q10)
select GroupName, SUM(Hydrobill) as HydroBill
from(
select ResearchGroups.GroupName, Meters.ID, ((Max(Rel_MeterInstalledInRoom.Reading)- Min(Rel_MeterInstalledInRoom.Reading))*0.109) as Hydrobill
FROM ResearchGroups Inner Join Rooms
ON ResearchGroups.ID = Rooms.ResearchGroupID 
Inner Join Rel_MeterInstalledInRoom
ON Rel_MeterInstalledInRoom.RoomID = Rooms.ID,
Meters Inner Join MeterType
ON Meters.MeterTypeID = MeterType.ID
Inner Join Rates 
ON MeterType.RateID = Rates.ID
where  Meters.MeterTypeID= 1 and (Month(DateOfRecord) = 1 or (Month(DateOfRecord) = 2 and Day(DateofRecord) =1)) and Meters.ID = Rel_MeterInstalledInRoom.MeterID 
Group BY Meters.ID,ResearchGroups.GroupName)
Group BY GroupName
Order by HydroBill desc;



SELECT SUM(V2.Reading*R.CostPerUnit - V1.Reading*R.CostPerUnit) AS HydroBill
FROM Rel_MeterInstalledInRoom V1, Rel_MeterInstalledInRoom V2, Meters MTR,
	 MeterType MT, Rates R, Rooms RM, ResearchGroups RG
WHERE V1.MeterID = V2.MeterID AND V1.RoomID = V2.RoomID
	AND V1.MeterID = MTR.ID
	AND MTR.MeterTypeID = MT.ID AND MT.TypeName = 'Hydro'
	AND MT.RateID = R.ID
	AND V1.RoomID = RM.ID
	AND RM.ResearchGroupID = RG.ID AND RG.GroupName = 'Pulp and Paper Technology'
	AND V1.DateOfRecord = '2021-01-01'
	AND V2.DateOfRecord = '2021-02-01';



SELECT RG.GroupName, SUM(V2.Reading - V1.Reading) AS HydroUsage
FROM Rel_MeterInstalledInRoom V1, Rel_MeterInstalledInRoom V2,
	Meters MTR, MeterType MT, Rooms RM, ResearchGroups RG
WHERE V1.MeterID = V2.MeterID AND V1.RoomID = V2.RoomID
	AND V1.DateOfRecord = '2021-01-01'
	AND V2.DateOfRecord = '2021-02-01'
	AND V1.MeterID = MTR.ID
	AND MTR.MeterTypeID = MT.ID AND MT.TypeName = 'Hydro'
	AND V1.RoomID = RM.ID
	AND RM.ResearchGroupID = RG.ID 
GROUP BY RG.GroupName
ORDER BY HydroUsage DESC;










