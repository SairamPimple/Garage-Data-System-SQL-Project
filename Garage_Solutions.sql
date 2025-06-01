# Use Garage Database
use Garage;

# Q.1. List all the customers serviced.
SELECT DISTINCT C.CNAME
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON C.CID = SD.CID;

# Q.2 Customers who are not serviced.
SELECT CNAME
FROM CUSTOMER1 
WHERE CID NOT IN (SELECT DISTINCT CID FROM SARE_DATE1 );

# Q.3 Employees who have not received the commission.
SELECT ENAME
FROM EMPLOYEE1 
WHERE EID NOT IN (SELECT DISTINCT EID FROM SARE_DATE1 WHERE COMM IS NOT NULL);

# Q.4 Name the employee who have maximum Commission.
SELECT ENAME
FROM EMPLOYEE1 
WHERE EID IN (SELECT DISTINCT EID FROM SARE_DATE1 WHERE COMM = (SELECT MAX(COMM) FROM SARE_DATE1));

# Q.5 Show employee name and minimum commission amount received by an employee.
SELECT A.ENAME, MIN(SD.COMM) AS MINIMUM_COMMISSION
FROM EMPLOYEE1 A
LEFT JOIN SARE_DATE1 SD ON A.EID = SD.EID
GROUP BY A.ENAME;

# Q.6 Display the Middle record from any table. 


# Q.7 Display last 4 records of any table.
SELECT *
FROM EMPLOYEE1
ORDER BY EID DESC
limit 4;

# Q.8 Count the number of records without count function from any table.
SELECT SUM(1) AS record_count
FROM EMPLOYEE1;

# Q.9 Delete duplicate records from "Ser_det" table on cid.(note Please rollback after execution).
CREATE TABLE temp_table AS
SELECT *
from SARE_DATE1
GROUP BY EID; # only insert one row for each of the records

# Q.10 Show the name of Customer who have paid maximum amount 
SELECT C.CNAME
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON C.CID = SD.CID
JOIN SPAREPART1 S ON S.SPID = SD.SPID
JOIN PURCHASE1 P ON P.SPID = S.SPID
WHERE P.TOTAL = (SELECT MAX(TOTAL) FROM PURCHASE1);

# Q.11 Display Employees who are not currently working.
SELECT ENAME
FROM EMPLOYEE1
WHERE EDOL IS NOT NULL;

# Q.12 How many customers serviced their two wheelers.
SELECT COUNT(CNAME)
FROM CUSTOMER1 
WHERE CID IN (SELECT DISTINCT CID FROM SARE_DATE1 WHERE TYPE_VEH = 'TWO WHEELER');

# Q.13 List the Purchased Items which are used for Customer Service with Unit of that Item.
SELECT SPNAME,SPUNIT
FROM SPAREPART1 
WHERE SPID IN (SELECT SPID FROM SARE_DATE1);

SELECT SP.SPNAME, SP.SPUNIT
FROM SPAREPART1 SP
JOIN SARE_DATE1 SD ON SP.SPID = SD.SPID;

# Q.14 Customers who have Colored their vehicles.
SELECT CNAME,CID
FROM CUSTOMER1
WHERE CID IN (SELECT CID FROM SARE_DATE1 WHERE TYPE_SER = 'COLOUR');

# Q.15 Find the annual income of each employee inclusive of Commission
SELECT E.EID, E.ENAME, (E.ESAL * 12) + COALESCE(SUM(SD.COMM), 0)  AS ANNUAL_INCOME
FROM EMPLOYEE1 E
LEFT JOIN SARE_DATE1 SD ON E.EID = SD.EID
GROUP BY E.EID, E.ENAME, E.ESAL;

# Q.16 Vendor Names who provides the engine oil.
SELECT V.VNAME
FROM VENDORS1 V
JOIN PURCHASE1 P ON P.VID = V.VID
JOIN SPAREPART1 S ON S.SPID = P.SPID
WHERE SPNAME = 'TWO ENGINE OIL';

# Q.17 Total Cost to purchase the Color and name the color purchased.
SELECT SP.SPNAME AS COLOR_PURCHASED, SUM(P.TRANCOST) AS TOTAL_COST
FROM SPAREPART1 SP
JOIN PURCHASE1 P ON SP.SPID = P.SPID
JOIN SARE_DATE1 SD ON SP.SPID = SD.SPID
WHERE SP.SPNAME LIKE '%COLOUR%'  
GROUP BY SP.SPNAME;

# Q.18 Purchased Items which are not used in "Ser_det".
SELECT P.*
FROM PURCHASE1 P
LEFT JOIN SARE_DATE1 SD ON P.SPID = SD.SPID
WHERE SD.SPID IS NULL;

# Q.19 Spare Parts Not Purchased but existing in Sparepart
SELECT SP.*
FROM SPAREPART1 SP
LEFT JOIN PURCHASE1 P ON SP.SPID = P.SPID
WHERE P.SPID IS NULL;

# Q.20 Calculate the Profit/Loss of the Firm. Consider one month salary of each employee for Calculation.
#  sum up the total expenses and subtract it from the total revenue
SELECT 
	SUM(P.TRANCOST) AS total_Purchases,
    SUM(P.TRANCOST) - SUM(E.ESAL) AS Profit_Loss
FROM 
	PURCHASE1 P
LEFT JOIN 
	EMPLOYEE1 E ON P.EID = E.EID;


# Q.21 Specify the names of customers who have serviced their vehicles more than one time.
SELECT C.CNAME
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON C.CID = SD.CID
GROUP BY C.CID, C.CNAME
HAVING COUNT(*) > 1;

# Q.22 List the Items purchased from vendors locationwise.
SELECT V.VNAME AS Vendor_Name, V.VADD AS Vendor_Location
FROM VENDORS1 V
JOIN PURCHASE1 P ON V.VID = P.VID
JOIN SPAREPART1 SP ON P.SPID = SP.SPID;

# Q.23 Display count of two wheeler and four wheeler from ser_details
SELECT TYPE_VEH, COUNT(*) AS Vehicle_Count
FROM SARE_DATE1
WHERE TYPE_VEH IN ('TWO WHEELER', 'FOUR WHEELER')
GROUP BY TYPE_VEH;

# Q.24 Display name of customers who paid highest SPGST and for which item 
SELECT C.CNAME, SP.SPNAME, P.SPGST AS Highest_SPGST
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON C.CID = SD.CID
JOIN PURCHASE1 P ON SD.SPID = P.SPID
JOIN SPAREPART1 SP ON P.SPID = SP.SPID
WHERE P.SPGST = (SELECT MAX(SPGST) FROM SARE_DATE1);

# Q.25 Display vendors name who have charged highest SPGST rate  for which item
SELECT V.VNAME, SP.SPNAME, P.SPGST AS Highest_SPGST
FROM VENDORS1 V
JOIN PURCHASE1 P ON V.VID = P.VID
JOIN SPAREPART1 SP ON P.SPID = SP.SPID
WHERE P.SPGST = (SELECT MAX(SPGST) FROM PURCHASE1);

# Q.26 List name of item and employee name who have received item 
SELECT SP.SPNAME, E.ENAME
FROM PURCHASE1 P
JOIN EMPLOYEE1 E ON P.EID = E.EID
JOIN SPAREPART1 SP ON SP.SPID = P.SPID;

#  Q.27 Display the Name and Vehicle Number of Customer who serviced his vehicle, And Name 
# the Item used for Service, And specify the purchase date of that Item with his vendor and Item Unit and Location, 
# And employee Name who serviced the vehicle. for Vehicle NUMBER "MH-14PA335".'

SELECT 
	C.CNAME AS Customer_Name,
    SD.VEH_NUMBER AS Vehicle_Number,
    SP.SPNAME AS Item_Used_for_Service,
    P.SPDATE AS Purchase_Date,
    V.VNAME AS Vendor_Name,
    SP.SPUNIT AS Item_Unit,
    V.VADD AS Location,
    E.ENAME AS Employee_Name
FROM SARE_DATE1 SD
JOIN CUSTOMER1 C ON C.CID = SD.CID
JOIN SPAREPART1 SP ON SP.SPID = SD.SPID 
JOIN EMPLOYEE1 E ON SD.EID = E.EID
JOIN PURCHASE1 P ON SD.SPID = P.SPID
JOIN VENDORS1 V ON P.VID = V.VID
WHERE 
    SD.VEH_NUMBER = 'MH14PA335';

# Q.28 who belong this vehicle  MH-14PA335" Display the customer name 
SELECT C.CNAME 
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON SD.CID = C.CID
WHERE VEH_NUMBER = "MH14PA335";

# Q.29 Display the name of customer who belongs to New York and when 
# he /she service their vehicle on which date    
SELECT C.CNAME AS Customer_Name, SD.SERVICE_DATE AS Service_Date
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON SD.CID = C.CID
WHERE C.CADRESS = 'New York';

# Q.30 from whom we have purchased items having maximum cost?
SELECT V.VNAME AS Vendor_Name
FROM VENDORS1 V
JOIN PURCHASE1 P ON P.VID = V.VID
WHERE P.TOTAL = (SELECT MAX(TOTAL) FROM PURCHASE1);

# Q.31 Display the names of employees who are not working as Mechanic and that employee done services.
SELECT E.ENAME AS Employee_Name
FROM EMPLOYEE1 E
JOIN SARE_DATE1 SD ON E.EID = SD.EID
WHERE E.EJOB = "MACHANIC";

# Q.32 Display the various jobs along with total number of employees in each job. The output should
# contain only those jobs with more than two employees.
SELECT EJOB as Job, COUNT(*) AS Number_of_Employee
FROM EMPLOYEE1
GROUP BY EJOB
HAVING COUNT(*) > 2;

# Q.33 Display the details of employees who done service 
#  and give them rank according to their no. of services .
SELECT 
    EID,
    ENAME,
    EJOB,
    EADD,
    ECONTACT,
    ESAL,
    EDOJ,
    EDOL,
    RANK() OVER (ORDER BY Num_Services DESC) AS Service_Rank
FROM (
    SELECT 
        E.EID,
        E.ENAME,
        E.EJOB,
        E.EADD,
        E.ECONTACT,
        E.ESAL,
        E.EDOJ,
        E.EDOL,
        COUNT(SD.TYPE_SER) AS Num_Services
    FROM 
        EMPLOYEE1 E
    JOIN 
        SARE_DATE1 SD ON E.EID = SD.EID
    GROUP BY 
        E.EID, E.ENAME, E.EJOB, E.EADD, E.ECONTACT, E.ESAL, E.EDOJ, E.EDOL
) AS EmployeeServices;


# Q 34 Display those employees who are working as Painter and fitter and who provide service 
# and total count of service done by fitter and painter  
SELECT 
    E.*,
    COUNT(SD.SIDD) AS Total_Services
FROM 
    EMPLOYEE1 E
JOIN 
    SARE_DATE1 SD ON E.EID = SD.EID
WHERE 
    E.EJOB IN ('PAINTER', 'FITTER')
GROUP BY 
    E.EID, E.ENAME, E.EJOB, E.EADD, E.ECONTACT, E.ESAL, E.EDOJ, E.EDOL
ORDER BY 
    E.EJOB;

# Q.35 Display employee salary and as per highest salary provide Grade to employee 
SELECT EID,ENAME,EJOB,
	CASE
		WHEN ESAL >= max_sal * 0.8 THEN 'A'
        WHEN ESAL >= max_sal * 0.6 THEN 'B'
        WHEN ESAL >= max_sal * 0.4 THEN 'C'
        ELSE 'D'
	END AS Grade
FROM EMPLOYEE1, 
(SELECT MAX(ESAL) AS max_sal FROM EMPLOYEE1) AS Max_Salary;

# Q.36 Display the 4th record of emp table without using group by and rowid
SELECT *
FROM EMPLOYEE1
LIMIT 1 OFFSET 3;

# Q.37 Provide a commission 100 to employees who are not earning any commission.
SELECT E.EID, E.ENAME, COALESCE(SD.COMM, 100) AS Commission
FROM EMPLOYEE1 E
LEFT JOIN SARE_DATE1 SD ON SD.EID = E.EID
ORDER BY E.EID,E.ENAME;

# Q.38 write a query that totals no. of services  for each day and place the results in descending order
SELECT SERVICE_DATE, COUNT(*) AS Total_Services
FROM SARE_DATE1
GROUP BY SERVICE_DATE
ORDER BY Total_Services DESC;

# Q.39 Display the service details of those customer who belong from same city 
SELECT SD.*
FROM SARE_DATE1 SD
JOIN CUSTOMER1 c1 ON sd1.CID = c1.CID
JOIN CUSTOMER1 c2 ON c1.CADRESS = c2.CADRESS AND c1.CID != c2.CID;

# Q.40 write a query join customers table to itself to find all pairs of
# customers service by a single employee
SELECT DISTINCT C1.CID AS Customer1_ID, C1.CNAME AS Customer1_Name,
                C2.CID AS Customer2_ID, C2.CNAME AS Customer2_Name,
                E.EID AS Employee_ID, E.ENAME AS Employee_Name
FROM SARE_DATE1 SD1
JOIN CUSTOMER1 C1 ON SD1.CID = C1.CID
JOIN EMPLOYEE1 E ON SD1.EID = E.EID
JOIN SARE_DATE1 SD2 ON SD1.EID = SD2.EID AND SD1.CID < SD2.CID
JOIN CUSTOMER1 C2 ON SD2.CID = C2.CID;

# Q.41 List each service number follow by name of the customer who made that service
SELECT SD.SIDD,C.CNAME
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON SD.CID = C.CID
GROUP BY SD.SIDD,C.CNAME;

# Q.42 Write a query to get details of employee and provide rating on basis of maximum services provide by employee  
# .Note (rating should be like A,B,C,D)
SELECT E.*,
	CASE 
		WHEN Num_Services = Max_Services THEN 'A'
        WHEN Num_Services = Max_Services * 0.75 THEN 'B'
        WHEN Num_Services = Max_Services * 0.5 THEN 'C'
        ELSE 'D'
	END AS Rating
    FROM EMPLOYEE1 E
    JOIN (
		SELECT 
			EID, 
			COUNT(*) AS Num_Services,
            (SELECT COUNT(*) FROM SARE_DATE1 GROUP BY EID ORDER BY COUNT(*) DESC LIMIT 1) AS Max_Services
        FROM SARE_DATE1
        GROUP BY EID
	) AS ServiceCounts ON E.EID = ServiceCounts.EID;
    
# Q43 Write a query to get maximum service amount of each customer with their customer details ?
SELECT C.*, MAX(SD.SERVICE_AMT) AS maximum_service_amount
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON SD.CID=C.CID
GROUP BY C.CID,C.CNAME;
   
# Q.44 Get the details of customers with his total no of services ?
SELECT C.*, COUNT(SD.SIDD) AS Total_Services
FROM CUSTOMER1 C
JOIN SARE_DATE1 SD ON SD.CID = C.CID
GROUP BY C.CID, C.CNAME;

# Q.45 From which location sparpart purchased  with highest cost ?
SELECT V.VADD AS Location, SUM(P.TRANCOST) AS Highest_Cost 
FROM PURCHASE1 P
JOIN SPAREPART1 SP ON SP.SPID = P.SPID
JOIN VENDORS1 V ON V.VID = P.VID
GROUP BY V.VADD
ORDER BY Highest_Cost DESC
LIMIT 1;

# Q.46 Get the details of employee with their service details who has salary is null
SELECT E.*,SD.*
FROM EMPLOYEE1 E
LEFT JOIN SARE_DATE1 SD ON E.EID = SD.EID
WHERE E.ESAL IS NULL;

# Q.47 find the sum of purchase location wise 
SELECT V.VADD AS Location, SUM(P.TRANCOST) AS Cost 
FROM PURCHASE1 P
JOIN VENDORS1 V ON V.VID = P.VID
GROUP BY V.VADD;

# Q.48 write a query sum of purchase amount in word location wise ?
SELECT 
    V.VADD AS Purchase_Location,
    SUM(P.TRANCOST) AS Purchase_Sum,
    CASE 
        WHEN SUM(P.TRANCOST) >= 1000000 THEN 'Million' 
        WHEN SUM(P.TRANCOST) >= 1000 THEN 'Thousand' 
        ELSE 'Less than Thousand' 
    END AS Total_Purchase_Amount_In_Words
FROM PURCHASE1 P
JOIN VENDORS1 V ON P.VID = V.VID
GROUP BY V.VADD
ORDER BY Purchase_Sum DESC;

# Q.49 Has the customer who has spent the largest amount money has been give highest rating
SELECT 
    C.CID AS Customer_ID,
    C.CNAME AS Customer_Name,
    CASE 
        WHEN C.CID = MaxSpending.CID THEN 'Highest Spender'
        ELSE 'Not Highest Spender'
    END AS Rating
FROM CUSTOMER1 C
JOIN (
    SELECT 
        CID, 
        SUM(TOTAL) AS Total_Spending
    FROM 
        SARE_DATE1
    GROUP BY 
        CID
    ORDER BY 
        Total_Spending DESC
    LIMIT 1
) AS MaxSpending ON C.CID = MaxSpending.CID;

# Q.51  List the customer name and sparepart name used for their vehicle and vehicle type
SELECT
	C.CNAME AS Customer_Name,
    SD.TYPE_VEH AS Vehicle_Type,
    SP.SPNAME AS Sparepart_Name
FROM 
	SARE_DATE1 SD
JOIN 
	CUSTOMER1 C ON C.CID = SD.CID
JOIN
	SPAREPART1 SP ON SP.SPID = SD.SPID
GROUP BY
	C.CNAME, SD.TYPE_VEH, SP.SPNAME;

# Q.52 Write a query to get spname ,ename,cname quantity ,rate ,service amount for record exist in service table 
SELECT 
	SP.SPNAME AS Sparepart_Name,
    E.ENAME AS Employee_Name,
    C.CNAME AS Customer_Name,
    SD.QUANT AS Quantity,
    SD.SP_RATE AS Rate,
    SD.SERVICE_AMT AS Service_Amount
FROM 
	SARE_DATE1 SD
JOIN 
	SPAREPART1 SP ON SP.SPID = SD.SPID
JOIN 
	CUSTOMER1 C ON C.CID = SD.CID
JOIN 
	EMPLOYEE1 E ON E.EID = SD.EID;
    
# Q.53 specify the vehicles owners who’s tube damaged.
SELECT 
	C.CNAME AS Owner
FROM 
	SARE_DATE1 SD
JOIN 
	CUSTOMER1 C ON C.CID = SD.CID
WHERE
	TYPE_SER = 'TUBE DAMAGE';

# Q.54 Specify the details who have taken full service.
SELECT
    C.CNAME AS Customer_Name
FROM
    SARE_DATE1 SD
JOIN
    CUSTOMER1 C ON SD.CID = C.CID
WHERE
    SD.TYPE_SER = 'FULL SERVICE';

# Q.55 Select the employees who have not worked yet and left the job.
SELECT
	EID AS ID,
	ENAME AS Employee_Name,
    CASE
		WHEN EDOL IS NOT NULL THEN 'Left the job'
        ELSE 'Still Working'
	END AS Status
FROM 
	EMPLOYEE1;


# Q.56  Select employee who have worked first ever.
SELECT 
	EID AS ID,
    ENAME AS Employee_Name,
    EDOJ AS Joining_Date
FROM 
	EMPLOYEE1
ORDER BY  EDOJ DESC
LIMIT 1;

# Q.57 Display all records falling in odd date
SELECT *
FROM employee1
WHERE DAY(EDOJ ) % 2 != 0;

# Q.58 Display all records falling in even date
SELECT *
FROM employee1
WHERE DAY(EDOJ ) % 2 = 0;

# Q.59 Display the vendors whose material is not yet used.
SELECT *
FROM VENDORS1 
WHERE VID NOT IN (SELECT VID FROM PURCHASE1);

SELECT V.*
FROM VENDORS1 V
LEFT JOIN PURCHASE1 P ON V.VID = P.VID
WHERE P.VID IS NULL;

# Q.60 Difference between purchase date and used date of spare part.
SELECT 
    SD.SPID,
    SD.SERVICE_DATE AS Used_Date,
    P.SPDATE AS Purchase_Date,
    DATEDIFF(SD.SERVICE_DATE, P.SPDATE) AS Date_Difference
FROM 
    SARE_DATE1 SD
JOIN 
    PURCHASE1 P ON SD.SPID = P.SPID;
