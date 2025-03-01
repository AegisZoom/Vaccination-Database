-- Peter Ljubisic
-- S4081442

--D1
SELECT strftime('%d/%m/%Y', cs1.Date) AS 'Date 1', cs1.CountryName AS 'Country Name', cs1.DailyVaccinations AS 'Vaccine On OD1', 
       strftime('%d/%m/%Y', cs2.Date) AS 'Date 2', cs2.DailyVaccinations AS 'Vaccine On OD2', 
       strftime('%d/%m/%Y', cs3.Date) AS 'Date 3', cs3.DailyVaccinations AS 'Vaccine On OD3', 
       (((cs2.DailyVaccinations - cs1.DailyVaccinations)/cs1.DailyVaccinations) - 
        ((cs3.DailyVaccinations - cs2.DailyVaccinations)/cs2.DailyVaccinations)) AS 'Percentage change of totals'
FROM CountryStats AS cs1 
     JOIN CountryStats AS cs2 ON cs1.CountryName = cs2.CountryName 
     JOIN CountryStats AS cs3 ON cs2.CountryName = cs3.CountryName
WHERE cs1.Date = '2021-03-15' AND cs1.AgeRange = '0+'
      AND cs2.Date = '2022-03-15' AND cs2.AgeRange = '0+' 
      AND cs3.Date = '2023-03-15' AND cs3.AgeRange = '0+';

--D2
SELECT cs1.CountryName AS 'Country Name', strftime('%m', cs1.Date) AS 'Month', strftime('%Y', cs1.Date) AS 'Year', 
       1.0*SUM(cs1.DailyVaccinations)/SUM(cs2.DailyVaccinations) AS 'Growth rate of vaccine', 
       1.0*SUM(cs1.DailyVaccinations)/SUM(cs2.DailyVaccinations) - 3.8471719510352 AS 'Difference of growth rate to global average'
FROM CountryStats AS cs1 
     JOIN CountryStats AS cs2 ON cs1.CountryName = cs2.CountryName
WHERE cs1.AgeRange='0+' AND cs2.AgeRange = '0+' 
      AND strftime('%m/%Y', cs1.Date) = strftime('%m/%Y', DATE(cs2.Date, '+30 days'))
GROUP BY cs1.CountryName, strftime('%m', cs1.Date), strftime('%Y', cs1.Date)
ORDER BY cs1.CountryName, cs1.Date;

-- NOTE: The query used to generate the global monthly cumulative average of 3.8471719510352 that was inserted into the above query 
--       is as follows:
SELECT `Country Name`, Month, Year, AVG(Growth) AS A FROM
(SELECT cs1.CountryName AS 'Country Name', strftime('%m', cs1.Date) AS 'Month', strftime('%Y', cs1.Date) AS 'Year', 
       1.0*SUM(cs1.DailyVaccinations)/SUM(cs2.DailyVaccinations) AS 'Growth', SUM(cs1.DailyVaccinations), 
       SUM(cs2.DailyVaccinations), strftime('%m', cs2.Date), strftime('%Y', cs2.Date)
FROM CountryStats AS cs1 JOIN CountryStats AS cs2 ON cs1.CountryName = cs2.CountryName
WHERE cs1.AgeRange='0+' AND cs2.AgeRange = '0+' AND strftime('%m/%Y', cs1.Date) = strftime('%m/%Y', DATE(cs2.Date, '+30 days'))
GROUP BY cs1.CountryName, strftime('%m', cs1.Date), strftime('%Y', cs1.Date)
ORDER BY cs1.CountryName, cs1.Date);
-- The full single query was too computationally expensive to run even with a 32GB PC, so I had to stick with this compromise 
-- unfortunately.

--D3
SELECT MN1 AS 'Vaccine Type', C1 AS 'Country', 
       100.0*M1/SUM(M2) AS 'Percentage of vaccine type'
FROM
     (SELECT ms1.ManufacturerName AS 'MN1', ms1.CountryName AS 'C1', 
             ms2.ManufacturerName AS 'MN2', ms2.CountryName AS 'C2', 
             MAX(ms1.TotalVaccinations) AS M1, MAX(ms2.TotalVaccinations) AS M2
      FROM ManufacturerStats AS ms1 
           JOIN ManufacturerStats AS ms2 ON ms1.CountryName = ms2.CountryName
      GROuP BY ms1.ManufacturerName, ms1.CountryName, 
               ms2.ManufacturerName, ms2.CountryName
      ORDER BY ms1.CountryName)
GROUP BY MN1, C1
ORDER BY C1;

-- D4
SELECT cs1.CountryName AS 'Country Name', strftime('%m/%Y', cs1.Date) AS 'Month', ur.URL AS 'Source Name (URL)',
       MAX(cs1.TotalVaccinations) - MAX(cs2.TotalVaccinations) AS 'Total Administered Vaccines'
FROM CountryStats AS cs1 
     JOIN CountryStats AS cs2 ON cs1.CountryName = cs2.CountryName 
     JOIN URLSource AS ur ON cs1.CountryName = ur.CountryName AND 
                             cs1.Date = ur.Date AND 
                             cs1.AgeRange = ur.AgeRange
WHERE cs1.AgeRange='0+' AND cs2.AgeRange = '0+' 
      AND strftime('%m/%Y', cs1.Date) = strftime('%m/%Y', DATE(cs2.Date, '+30 days'))
GROUP BY cs1.CountryName, strftime('%m/%Y', cs1.Date), ur.URL
ORDER BY `Total Administered Vaccines` DESC;

-- D5 (ISYS1055)
SELECT Dates, USA_1 - USA_2 AS 'United States', 
              CHN_1 - CHN_2 AS 'China', 
              IRL_1 - IRL_2 AS 'Ireland', 
              IND_1 - IND_2 AS 'India' 
FROM
     (SELECT cs1.Date AS 'Dates', cs1.PeopleFullyVaccinated AS 'USA_1', cs11.PeopleFullyVaccinated AS 'USA_2', 
                                  cs2.PeopleFullyVaccinated AS 'CHN_1', cs22.PeopleFullyVaccinated AS 'CHN_2', 
                                  cs3.PeopleFullyVaccinated AS 'IRL_1', cs33.PeopleFullyVaccinated AS 'IRL_2', 
                                  cs4.PeopleFullyVaccinated AS 'IND_1', cs44.PeopleFullyVaccinated AS 'IND_2'
      FROM CountryStats AS cs1 JOIN CountryStats AS cs2 ON cs1.Date = cs2.Date
                               JOIN CountryStats AS cs3 ON cs2.Date = cs3.Date
                               JOIN CountryStats AS cs4 ON cs3.Date = cs4.Date
                               JOIN CountryStats AS cs44 ON cs4.CountryName = cs44.CountryName
                               JOIN CountryStats AS cs33 ON cs44.Date = cs33.Date
                               JOIN CountryStats AS cs22 ON cs22.Date = cs33.Date
                               JOIN CountryStats AS cs11 ON cs11.Date = cs22.Date
      WHERE cs1.CountryName = 'United States' AND cs2.CountryName = 'China' AND cs3.CountryName = 'Ireland' AND cs4.CountryName = 'India' 
            AND strftime('%Y', cs1.Date) BETWEEN '2022' AND '2023' AND cs4.Date = DATE(cs44.Date, '+1 days') 
            AND cs33.CountryName = 'Ireland' AND cs22.CountryName = 'China' AND cs11.CountryName = 'United States'
      GROUP BY cs1.Date);