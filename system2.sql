--First we combine two tables to have data for March and April combined
-- 3���� 4���� �����͸� �����ϱ� ���� �� ���� ���̺��� ���� ������
SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2;

SELECT DISTINCT(ID)
FROM dailyActivity_merged



-- Let check how many rows does out new table has
-- ���� ���� ���̺��� �� ������ Ȯ����
SELECT COUNT (*)
FROM (SELECT *
FROM dailyActivity_merged
UNION
SELECT *
FROM dailyActivity_merged_2);

--  1397 rows ( March/April table 457 rows +  April/May table 940 rows)
-- �� 1397�� (3��~4�� ���̺�: 457�� + 4��~5�� ���̺�: 940��)
SELECT COUNT(*)
FROM dailyActivity_merged;

SELECT COUNT(*)
FROM dailyActivity_merged_2;

SELECT *
FROM weightLogInfo_merged;


-- We have only 8 distinct Id in weightLogInfo 2
-- weightLogInfo 2 ���̺��� �ߺ��� ������ ������ ID�� �� 8�� ����
SELECT DISTINCT ID
FROM weightLogInfo_merged_2;

-- And only 11 distinct Id in weightLogInfo 1
-- weightLogInfo 1 ���̺��� �ߺ��� ������ ������ ID�� �� 11�� ����
SELECT DISTINCT ID
FROM weightLogInfo_merged;

-- Only 6 people log in and record their weight several times for two months
-- �� �� ���� 6���� �α����Ͽ� ���� �� ü���� �����
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
-- �� �� �̻� �α����ϰ� ü���� ����� ������� ���� �����ִ� �ڵ���
-- ����Ʈ ����� Ȱ�� ��� �� �ϳ��� ü���� ���������� ����ϴ� ����

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
-- ü���� �� �� �̻� ����� 7�� �� 2���� 30ȸ �̻� �����
-- �̵��� ü�� ��ȭ�� Ȱ���� �� ���� Į�θ��� ���غ� �� ���� (6962181067/43ȸ, 8877689391/32ȸ)

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
-- �� ������ ID 6962181067 ������� ���� �����͸� ������
-- �ش� ����ڴ� ���� ���� ü���� ���������Ƿ�, Ȱ����, Į�θ�, �ɾ��ִ� �ð��� ü�߿� ��ġ�� ������ ������ �� ����
-- ������ �Ⱓ ���� �ּ� ü�߰� �ִ� ü���� Ȯ�� �ʿ� 

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
-- ID 6962181067�� �ּ� ü���� 4�� 1�Ͽ� 60.9kg������,
-- ��� ��ǥ���� �ش����� ��ġ�� ������ �ʾ���.

The max total steps indicator is 20031
Total distance is 13.23999977
Very active minutes 73 
Max sedentary minutes 862
Max calories 2571
ANd the max weight is 61.5


-- What date the index of the calories was on the maximum? 
-- Į�θ� ������ �ִ뿴�� ��¥�� Ȯ����
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
-- �ִ� ü�߰� �ּ� ü���� ���̴� 1.599kg��
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
-- ������ ��¥�� ����� �����ϴ��� Ȯ����
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
-- 16/04/12 ��¥�� ���� �� ���� ���ڵ尡 ������
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
-- �ش� ��¥���� Į�θ� ���� 1994�� 917 �� �� ������
-- �ϳ��� ���� �ٸ� ���� �����ϴ���, �ƴϸ� �� ���� ���ľ� �ϴ��� Ȯ���� �ʿ���
-- �̸� Ȯ���ϱ� ���� Į�θ� �����͸� �и��� ���Ͽ��� �м��غ� ����

SELECT SUM(CALORIES)
FROM (SELECT *
FROM minuteCaloriesNarrow_merged
UNION 
SELECT *
FROM minuteCaloriesNarrow_merged_2)
WHERE ID = '6962181067' and LPAD(activityminute,4) = '4/12'

-- Thus we checked that the value of calories for  16/04/12 is 1994 
-- It means that one row where calories equels 917 included in the other row and we can delete the row from the table
-- 16/04/12 ��¥�� Į�θ� ���� 1994���� Ȯ����
-- ��, Į�θ� 917�� ���� �ٸ� �࿡ ���Ե� ������ �ǴܵǾ� �ش� ���� ������ �� ����

-- the same table for 8877689391
-- ID 8877689391�� ������ ���̺�

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
-- id_391�� ü���� 32ȸ ����� ���� Ȯ����. ���̺��� �� ���� Ȯ����
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
-- id_391�� �Ϸ翡 �� �� ����ߴ��� Ȯ����
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
-- id_067�� ���������� id_391�� 16/04/12�� ���� Ȱ���� �� �� �����
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
-- �ش� ��¥���� Į�θ� ���� 3921�� 938 �� �� ����
-- �� ������ ���� ���ԵǴ���, �ƴϸ� �� �� �ջ��ؾ� �ϴ��� Ȯ���ϱ� ���� Į�θ� �����Ͱ� �и��� ������ �м� �ʿ�
SELECT SUM(CALORIES)
FROM (SELECT *
FROM minuteCaloriesNarrow_merged
UNION 
SELECT *
FROM minuteCaloriesNarrow_merged_2)
WHERE ID = '8877689391' and LPAD(activityminute,4) = '4/12'

-- Thus we checked that the value of calories for  16/04/12 is 3921
-- It means that one row where calories equels 938 included in the other row and we can delete the row from the table
-- 16/04/12 ��¥�� Į�θ� ���� 3921���� Ȯ����
-- ��, Į�θ� 938�� ���� �ٸ� �࿡ ���Ե� ������ �ǴܵǾ� �ش� ���� ������ �� ����