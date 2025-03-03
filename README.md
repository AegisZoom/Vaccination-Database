# SQL Project: COVID-19 Vaccination Database

## ISYS1055: Database Concepts

### Grade: 97.5%

## Introduction

This repository contains my work for the fourth and final assessment for ISYS1055 in my Graduate Diploma of Data Science. This assessment was
split into four phases: the first required me to investigate and understand the datasets provided.
The second phase required me to design a database that would adequately house all the data using good design principles. The third phase
required me to construct the database using SQLiteStudio and to load the transformed data into it successfully. The fourth and final phase
was where I constructed SQL queries to extract data based on requested specifications to perform data visualisations. This page will summarise the work I conducted beyond the
first phase.

## Skills Used

- 💾 **Programming**:
Used SQL 🌐 to construct a database and to extract data based on conditions. SQL programming was also used to perform statistical analyses of records. R 📉 was used as a programming language to transform and visualise the data.
- 🔨 **Database Design**: Constructed the database by firstly designing an Entity-Relationship Diagram, mapping the diagram to a relational schema, then finally performing normalisation procedures to streamline database design.
- 🎣 **SQL Query Extraction**: Performed complex SQL queries to extract data based on specifications while conducting complex statistical operations and presenting them as additional data columns.
- 📈 **Data Analysis**:
Performed statistical operations using SQL queries. Constructed data visualisations to summarise trends in data.
- 📊 **Data Visualisation**:
Constructed a variety of different visualisations in the last phase to showcase trends and compare different groups of data.
- 🧼 **Data Cleaning**:
Split and combined datasets together, performed data tidying procedures to reformat datasets for database integration, scanned for missing values, errors and inconsistencies.
- 📐 **Problem-Solving**:
Strategised creative means to incorporate statistical data into SQL queries for extraction, with statistical data being dependent on neighbouring/grouped data.
- 🔍 **Debugging/Attention to Detail**:
Devoted extensive time to identifying root cause of errors in SQL query outputs. Scrutinised query outputs for incorrect/missing records.
- ⏰ **Time Management**:
Organised weekly schedules and deadlines for individual milestones with leeway for unexpected obstacles both related to and outside of the assessment.
- 🔬 **Research**:
Conducted research on datasets to understand design requirements of the final database schema.

## Phase 1: Data Retrieval

Phase 1 of the project was to investigate and understand the source datasets for the project. The original datasets are made accessible in *original_data.zip* in the *csv_data* folder. The original source is referenced below:

Mathieu, E., Ritchie, H., Ortiz-Ospina, E. et al. A global database of COVID-19 vaccinations. Nat Hum Behav 5, 947–953 (2021). https://doi.org/10.1038/s41562-021-01122-8

**Note**: The dataset can more accessibly be downloaded here: https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations

A total of nine csv files were supplied for the purpose of this task, and a database needed to be designed to house everything. The example below features *Ireland.csv*, a csv file detailing vaccination statistics for Ireland across the COVID-19 pandemic with citations and available manufacturers provided.

![Dataset](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/Dataset.PNG)

The contents of all the other source csv files used for the assessment are described below. For more detailed descriptions, please see *Database Concepts A4 Phase 1.pdf*
in the *csv_data* folder.

- **China.csv**: Equivalent in contents to *Ireland.csv*, except that it covers vaccinations in China instead.
- **India.csv**: Equivalent in contents to *Ireland.csv*, except that it covers vaccinations in India instead.
- **locations.csv**: Lists all nations and their available vaccines on their last observation dates with citations.
- **United States.csv**: Equivalent in contents to *Ireland.csv*, except that it covers vaccinations in the United States instead.
- **us_state_vaccinations.csv**: Provides various vaccination statistics for each state in the US across the COVID-19 pandemic, including full vaccinations, daily vaccinations, and boosters administered.
- **vaccinations.csv**: Provides various vaccination statistics for each nation across the COVID-19 pandemic, including full vaccinations, daily vaccinations, and boosters administered.
- **vaccinations-by-age-group.csv**: Provides various vaccination statistics for each nation per age group across the COVID-19 pandemic.
- **vaccinations-by-manufacturer.csv**: Provides total vaccination statistics for each nation per vaccine manufacturer across the COVID-19 pandemic.

## Phase 2: Database Design

With Phase 1 completed, the next step was to map the relations and relationships of the database using an entity-relationship diagram. The final result is shown below:

![ER_Diagram](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/ER_Diagram.PNG)

This diagram makes several assumptions about the nature of the data, which can be found in the *Model.pdf* file.

Afterwards, the seven steps of mapping the entity-relationship model to a relational schema were applied. Afterwards, the schema was normalised to satisfy 1NF, 2NF, and 3NF conditions. The final relational schema is shown below. For context the name of the table is listed outside the brackets, the variables are listed inside, and the underline signifies the variable is a primary key while the asterisk signifies it is a foreign key.

- Country (<ins>CountryName</ins>, CountryCode) 
- Manufacturer (<ins>ManufacturerName</ins>) 
- Source (<ins>SourceName</ins>) 
- ManufacturerStats (<ins>ManufacturerName</ins>\*, <ins>CountryName</ins>\*, <ins>Date</ins>, TotalVaccinations) 
- State (<ins>CountryName</ins>\*, <ins>StateName</ins>) 
- StateStats (<ins>StateName</ins>\*, <ins>Date</ins>, TotalVaccinations, TotalDistributed, PeopleVaccinated, PeopleFullyVaccinated, TotalVaccinations_p100, PeopleVaccinated_p100, PeopleFullyVaccinated_p100, Distributed_p100, DailyVaccinationsRaw, DailyVaccinations, DailyVaccinations_pM, ShareDosesUsed, TotalBoosters, TotalBoosters_p100) 
- CountryStats (<ins>CountryName</ins>\*, <ins>Date</ins>, <ins>AgeRange</ins>, TotalVaccinations, PeopleVaccinated, PeopleFullyVaccinated, TotalBoosters, TotalVaccinations_p100, PeopleVaccinated_p100, PeopleFullyVaccinated_p100, DailyVaccinationsRaw, DailyVaccinations, DailyPeopleVaccinated, DailyVaccinations_pM, DailyPeopleVaccinated_p100, TotalBoosters_p100, SourceName*) 
- CountryManufacturer (<ins>CountryName</ins>\*, <ins>ManufacturerName</ins>\*) 
- URLSource (<ins>CountryName</ins>\*, <ins>Date</ins>\*, <ins>AgeRange</ins>\*, <ins>SourceName</ins>\*, URL)

For more details about the relational mapping and normalisation process, see the *Model.pdf* file.

## Phase 3: Database Loading

This phase involved programming a database, transforming the source data into valid formats for the database, and finally populating the database with data. An example of constructing a relation for the database is shown below. The *ManufacturerStats* relation uses non-null specifications, primary keys, and foreign keys to connect with
other relations in the database. This relation is later populated with the data from *ManufacturerStats.csv* found in the *csv_data* folder. For the other queries used to construct the database, please view the *Database.sql* file.

![Query_P3](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/Query_P3.PNG)

## Phase 4: Queries and Visualisation

Finally, this phase involved performing analysis and visualisation on data extracted using SQL queries. The extracted data would also feature statistical variables that contained information on trends in vaccinations over time. For example, the query below fetches the total number of new people fully vaccinated on each observation date between 2022 and 2023. This required imposing seven self-joins on the dataset with the *Date* column to feature each of the four countries as separate columns in one query.

![Query2](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/Query.png)

![D5](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/D5_Output.PNG)

![Chart](https://github.com/AegisZoom/Vaccination-Database/blob/main/Images/Chart.png)
