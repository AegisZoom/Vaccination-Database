-- Peter Ljubisic
-- S4081442

-- This SQL Script creates the relations of the database defined in Part B

-- For instructions on importing the data into these tables, please see the end of the script

-- Country Relation
CREATE TABLE Country (
             CountryName CHARACTER NOT NULL,
             CountryCode CHARACTER NOT NULL,
             PRIMARY KEY (CountryName)
             );

-- Manufacturer Relation
CREATE TABLE Manufacturer (
             ManufacturerName CHARACTER NOT NULL,
             PRIMARY KEY (ManufacturerName)
             );

-- Source Relation
CREATE TABLE Source (
             SourceName CHARACTER NOT NULL,
             PRIMARY KEY (SourceName)
             );

-- ManufacturerStats Relation
CREATE TABLE ManufacturerStats (
             ManufacturerName CHARACTER NOT NULL,
             CountryName CHARACTER NOT NULL,
             Date DATE NOT NULL,
             TotalVaccinations INTEGER NOT NULL,
             PRIMARY KEY (ManufacturerName, CountryName, Date),
             FOREIGN KEY (ManufacturerName) REFERENCES Manufacturer(ManufacturerName),
             FOREIGN KEY (CountryName) REFERENCES Country(CountryName)
             );
             
-- State Relation
CREATE TABLE State (
             CountryName CHARACTER NOT NULL,
             StateName CHARACTER UNIQUE,
             PRIMARY KEY (CountryName, StateName)
             FOREIGN KEY (CountryName) REFERENCES Country(CountryName)
             );

-- StateStats Relation
CREATE TABLE StateStats (
             StateName CHARACTER NOT NULL,
             Date DATE NOT NULL,
             TotalVaccinations INTEGER, 
             TotalDistributed INTEGER, 
             PeopleVaccinated INTEGER, 
             PeopleFullyVaccinated INTEGER, 
             TotalVaccinations_p100 REAL, 
             PeopleVaccinated_p100 REAL, 
             PeopleFullyVaccinated_p100 REAL, 
             Distributed_p100 REAL, 
             DailyVaccinationsRaw INTEGER, 
             DailyVaccinations INTEGER, 
             DailyVaccinations_pM INTEGER, 
             ShareDosesUsed REAL,
             TotalBoosters INTEGER,
             TotalBoosters_p100 REAL,
             PRIMARY KEY (StateName, Date),
             FOREIGN KEY (StateName) REFERENCES State(StateName)
             );

-- CountryStats relation
CREATE TABLE CountryStats (
             CountryName CHARACTER NOT NULL,
             Date DATE NOT NULL,
             AgeRange CHARACTER NOT NULL,
             TotalVaccinations INTEGER, 
             PeopleVaccinated INTEGER,
             PeopleFullyVaccinated INTEGER, 
             TotalBoosters INTEGER, 
             TotalVaccinations_p100 REAL, 
             PeopleVaccinated_p100 REAL, 
             PeopleFullyVaccinated_p100 REAL, 
             DailyVaccinationsRaw INTEGER, 
             DailyVaccinations INTEGER, 
             DailyPeopleVaccinated INTEGER, 
             DailyVaccinations_pM INTEGER, 
             DailyPeopleVaccinated_p100 REAL, 
             TotalBoosters_p100 REAL,
             SourceName CHARACTER,
             PRIMARY KEY (CountryName, Date, AgeRange),
             FOREIGN KEY (CountryName) REFERENCES Country(CountryName),
             FOREIGN KEY (SourceName) REFERENCES Source(SourceName)
             );

-- URLSource Relation
CREATE TABLE URLSource (
             CountryName CHARACTER NOT NULL,
             Date DATE NOT NULL,
             AgeRange CHARACTER NOT NULL,
             SourceName CHARACTER NOT NULL,
             URL CHARACTER,
             PRIMARY KEY (CountryName, Date, AgeRange, SourceName),
             FOREIGN KEY (CountryName, Date, AgeRange) REFERENCES CountryStats(CountryName, Date, AgeRange),
             FOREIGN KEY (SourceName) REFERENCES Source(SourceName)
             );

-- CountryManufacturer Relation
CREATE TABLE CountryManufacturer (
             CountryName CHARACTER NOT NULL,             
             ManufacturerName CHARACTER NOT NULL,
             PRIMARY KEY (ManufacturerName, CountryName),
             FOREIGN KEY (CountryName) REFERENCES Country(CountryName),
             FOREIGN KEY (ManufacturerName) REFERENCES Manufacturer(ManufacturerName)
             );

-- Instructions for importing data into relations

-- 1. Run the entire script to generate all relations.

-- 2. Import data for the Country, Manufacturer, and Source relations first. Their corresponding data is
--    located in csv files with the same name as the relation (not included in submission). Make sure 
--    Text Encoding is set to windows-1258 and Column Separator is set to the comma.

-- 3. Import the corresponding data for the State, CountryManufacturer and ManufacturerStats relations.

-- 4. Import the corresponding data for the StateStats relation.

-- 5. Import the corresponding data for the CountryStats relation. Note that when importing the data,
--    you must tick the "NULL Values" box and type "NA" without quotation marks in the text box next to it.

-- 6. Import the corresponding data for the URLSource relation.