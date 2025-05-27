--First we combine two tables to have data for March and April combined
-- 3월과 4월의 데이터를 통합하기 위해 두 개의 테이블을 먼저 조인함
SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2;

SELECT DISTINCT(ID)
FROM dailyActivity_merged



-- Let check how many rows does out new table has
-- 새로 만든 테이블의 행 개수를 확인함
SELECT COUNT (*)
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2);

--  1397 rows ( March/April table 457 rows +  April/May table 940 rows)
-- 총 1397행 (3월~4월 테이블: 457행 + 4월~5월 테이블: 940행)
SELECT COUNT(*)
FROM dailyActivity_merged;

SELECT COUNT(*)
FROM dailyActivity_merged_2;

SELECT *
FROM weightLogInfo_merged;


-- We have only 8 distinct Id in weightLogInfo 2
-- weightLogInfo 2 테이블에는 중복을 제외한 고유한 ID가 총 8개 있음
SELECT DISTINCT ID
FROM weightLogInfo_merged_2;

-- And only 11 distinct Id in weightLogInfo 1
-- weightLogInfo 1 테이블에는 중복을 제외한 고유한 ID가 총 11개 있음
SELECT DISTINCT ID
FROM weightLogInfo_merged;

-- Only 6 people log in and record their weight several times for two months
-- 두 달 동안 6명만이 로그인하여 여러 번 체중을 기록함
SELECT DISTINCT a.ID, b.id
FROM weightLogInfo_merged a
LEFT JOIN weightLogInfo_merged_2 b
ON a.id = b.id;


SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN;

-- Here is a code that shows us how many people loged in more than 1 time and they recorded their weight. 
-- So one of the way to use smart devices is to keep record of the weight. 
-- 두 번 이상 로그인하고 체중을 기록한 사용자의 수를 보여주는 코드임
-- 스마트 기기의 활용 방법 중 하나는 체중을 지속적으로 기록하는 것임

SELECT ID, COUNT (ID) 
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
GROUP BY ID;

-- Among 7 people who recorded the weight more than one time , 2 persons recorded more than 30 times.
-- Maybe we can compare their weight with their activity and calories 6962181067/43, 8877689391/32
-- 체중을 두 번 이상 기록한 7명 중 2명은 30회 이상 기록함
-- 이들의 체중 변화와 활동량 및 섭취 칼로리를 비교해볼 수 있음 (6962181067/43회, 8877689391/32회)

SELECT *
FROM dailyActivity_merged;

SELECT * 
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY ACTIVITYDATE;

-- This queri shows us merged data about person who uses ID 6962181067. 
-- As this person did check up the weight almost every day we can trace if activity, calories and sedentary timeshave influence on the weight or not. 
-- Lets check what was his minimum and maximum weight for the period. 
-- 이 쿼리는 ID 6962181067 사용자의 통합 데이터를 보여줌
-- 해당 사용자는 거의 매일 체중을 측정했으므로, 활동량, 칼로리, 앉아있는 시간이 체중에 미치는 영향을 추적할 수 있음
-- 정해진 기간 동안 최소 체중과 최대 체중을 확인 필요 

SELECT *
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY WEIGHTKG;

-- The minimum weight of 6962181067 was on April 1 - 60.9 kg.
-- At that day the indicators was not extremaly low or high. 
-- ID 6962181067의 최소 체중은 4월 1일에 60.9kg였으며,
-- 당시 지표들은 극단적인 수치를 보이지 않았음.

The max total steps indicator is 20031
Total distance is 13.23999977
Very active minutes 73 
Max sedentary minutes 862
Max calories 2571
ANd the max weight is 61.5


-- What date the index of the calories was on the maximum? 
-- 칼로리 지수가 최대였던 날짜를 확인함
SELECT MAX(WEIGHTKG)-MIN(weightkg)
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY WEIGHTKG;

--The difference between the max weight and the minimum weight is 1.599 kg 
-- 최대 체중과 최소 체중의 차이는 1.599kg임
SELECT *
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY ACTIVITYDATE;

SELECT Count(*)
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY ACTIVITYDATE;

-- Let's check if there is the record for the same date?
-- 동일한 날짜에 기록이 존재하는지 확인함
SELECT ACTIVITYDATE, count(*)
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
GROUP BY ACTIVITYDATE
HAVING COUNT(*) >1
ORDER BY ACTIVITYDATE;

-- We can see that there is two records for 16/04/12
-- 16/04/12 날짜에 대해 두 개의 레코드가 존재함
SELECT *
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 6962181067
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 6962181067)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
WHERE ACTIVITYDATE = '16/04/12';

-- For this date there 2 values of calories 1994 and 917. The question is if one value includes one another or we have have to add up these values
-- To check this we have let's analize separated files for calories.
-- 해당 날짜에는 칼로리 값이 1994와 917 두 개 존재함
-- 하나의 값이 다른 값을 포함하는지, 아니면 두 값을 합쳐야 하는지 확인이 필요함
-- 이를 확인하기 위해 칼로리 데이터를 분리된 파일에서 분석해볼 예정

SELECT SUM(CALORIES)
FROM (SELECT *
FROM minuteCaloriesNarrow_merged
UNION 
SELECT *
FROM minuteCaloriesNarrow_merged_2)
WHERE ID = '6962181067' and LPAD(activityminute,4) = '4/12'

-- Thus we checked that the value of calories for  16/04/12 is 1994 
-- It means that one row where calories equels 917 included in the other row and we can delete the row from the table
-- 16/04/12 날짜의 칼로리 값이 1994임을 확인함
-- 즉, 칼로리 917인 행은 다른 행에 포함된 값으로 판단되어 해당 행을 삭제할 수 있음

-- the same table for 8877689391
-- ID 8877689391의 동일한 테이블

SELECT * 
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 8877689391
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 8877689391)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY ACTIVITYDATE;

-- We know that id_391 made 32 records of weight. Let's check how many rows do we have in the table
-- id_391이 체중을 32회 기록한 것을 확인함. 테이블의 행 수를 확인함
SELECT count(*)
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 8877689391
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 8877689391)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
ORDER BY ACTIVITYDATE;

-- Let's check if the id_391 made the records twice per a day 
-- id_391이 하루에 두 번 기록했는지 확인함
SELECT ACTIVITYDATE, count(*)
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 8877689391
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 8877689391)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
GROUP BY ACTIVITYDATE
HAVING COUNT(*) >1
ORDER BY ACTIVITYDATE;

-- As well as id_067, id_391 made two records of daily activity on 16/04/12
-- id_067와 마찬가지로 id_391도 16/04/12에 일일 활동을 두 번 기록함
SELECT *
FROM (SELECT DATE_OF_LOGIN, WEIGHTKG
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2) 
WHERE ID IN (SELECT ID
FROM (SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged
UNION 
SELECT ID, DATE_OF_LOGIN, WEightkg, Fat
FROM weightLogInfo_merged_2)
GROUP BY ID
HAVING COUNT(ID) > 1)
ORDER BY ID, DATE_OF_LOGIN)
WHERE ID = 8877689391
ORDER BY WEIGHTKG)a
LEFT OUTER JOIN (SELECT ID, ACTIVITYDATE, TOTALSTEPS, TOTALDISTANCE,VERYACTIVEMINUTES,SEDENTARYMINUTES, CALORIES 
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2)
WHERE ID = 8877689391)b
ON to_date(trim(SUBstr(a.DATE_OF_LOGIN,1,9)), 'mm/dd/yyyy') = b. ACTIVITYDATE
WHERE ACTIVITYDATE = '16/04/12';

-- For this date there 2 values of calories 3921 and 938.
-- To checking if this is the the values include one another or both has to be considered, we have let's analize separated files for calories.
-- 해당 날짜에는 칼로리 값이 3921과 938 두 개 있음
-- 이 값들이 서로 포함되는지, 아니면 둘 다 합산해야 하는지 확인하기 위해 칼로리 데이터가 분리된 파일을 분석 필요
SELECT SUM(CALORIES)
FROM (SELECT *
FROM minuteCaloriesNarrow_merged
UNION 
SELECT *
FROM minuteCaloriesNarrow_merged_2)
WHERE ID = '8877689391' and LPAD(activityminute,4) = '4/12'

-- Thus we checked that the value of calories for  16/04/12 is 3921
-- It means that one row where calories equels 938 included in the other row and we can delete the row from the table
-- 16/04/12 날짜의 칼로리 값이 3921임을 확인함
-- 즉, 칼로리 938인 행은 다른 행에 포함된 값으로 판단되어 해당 행을 삭제할 수 있음