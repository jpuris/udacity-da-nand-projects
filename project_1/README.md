# Project 1 - HR Database

## Business Scenario

### Business requirement

    Tech ABC Corp saw explosive growth with a sudden appearance onto the gaming scene with their new
AI-powered video game console. As a result, they have gone from a small 10 person operation to 200
employees and 5 locations in under a year. HR is having trouble keeping up with the growth, since they are
still maintaining employee information in a spreadsheet. While that worked for ten employees, it has
becoming increasingly cumbersome to manage as the company expands.

As such, the HR department has tasked you, as the new data architect, to design and build a database
capable of managing their employee information.

### Dataset

    The HR dataset you will be working with is an Excel workbook which consists of 206 records, with eleven
columns. The data is in human readable format, and has not been normalized at all. The data lists the
names of employees at Tech ABC Corp as well as information such as job title, department, manager's name,
hire date, start date, end date, work location, and salary.

### IT Department Best Practices

    The IT Department has certain Best Practices policies for databases you should follow, as detailed in the Best Practices document.

## Data Architecture Foundations

> Hi,
>
> Welcome to Tech ABC Corp. We are excited to have some new talent onboard. As you may already know, Tech ABC Corp has recently experienced a lot of growth. Our AI powered video game console WOPR has been hugely successful and as a result, our company has grown from 10 employees to 200 in only 6 months (and we are projecting a 20% growth a year for the next 5 years). We have also grown from our Dallas, Texas office, to 4 other locations nationwide: New York City, NY, San Francisco, CA, Minneapolis, MN, and Nashville, TN.
>
> While this growth is great, it is really starting to put a strain on our record keeping in HR. We currently maintain all employee information on a shared spreadsheet. When HR consisted of only myself, managing everyone on an Excel spreadsheet was simple, but now that it is a shared document I am having serious reservations about data integrity and data security. If the wrong person got their hands on the HR file, they would see the salaries of every employee in the company, all the way up to the president.
>
> After speaking with Jacob Lauber, the manager of IT, he suggested I put in a request to have my HR Excel file converted into a database. He suggested I reach out to you as I am told you have experience in designing and building databases. When you are building this, please keep in mind that I want any employee with a domain login to be have read only access the database. I just don't want them having access to salary information. That needs to be restricted to HR and management level employees only. Management and HR employees should also be the only ones with write access. By our current estimates, 90% of users will be read only.
>
> I also want to make sure you know that am looking to turn my spreadsheet into a live database, one I can input and edit information into. I am not really concerned with reporting capabilities at the moment. Since we are working with employee data we are required by federal regulations to maintain this data for at least 7 years; additionally, since this is considered business critical data, we need to make sure it gets backed up properly.
>
> As a final consideration. We would like to be able to connect with the payroll department's system in the future. They maintain employee attendance and paid time off information. It would be nice if the two systems could interface in the future
>
> I am looking forward to working with you and seeing what kind of database you design for us.
>
> Thanks,
> Sarah Collins
> Head of HR

### Data Architect Business Requirement

- **Purpose of the new database**: Online transactional processing datastore for Human Resources management (HRM).
- **Describe current data management solution**: Currently the data is managed in a single, shared excel spreadsheet.
- **Describe current data available**: Currently available data consists of flat structured data. The data includes employee and department metadata.
- **Additional data requests**: Strict data governance enforcement via access policies. See access to database section below for more information.
Who will own/manage data
Human resource.
- **Who will have access to database**: Only management and human resources personnel is allowed to access employee salary data as well as have read and write access. Everyone else would have read only access (except for salary data)
- **Estimated size of database**: Data size currently estimated to be around 200 rows.
- **Estimated annual growth**: Expected yearly growth is 20%.
- **Is any of the data sensitive/restricted**: Salary data is restricted to be accessed only by top management and human resources personnel.
- **Justification for the new database**:
  - **Scalability** - The current data store does not support rapid growth of the data.
  - **Data governance** - The way the data is currently stored, there is no way to enforce any restrictions as to who can access and/or edit the data.
- **Database objects**:
  - **Stage** - intended for migration purposes only (stage table).
  - **Staff** - contains information about a person part of staff
  - **Employment** - employee and role/position description entities.
  - **Department** - holds department data as well as it’s manager’s ID
  - **Department Manager** - a mapping table that establishes relationship between department and staff (manager)
  - **Staff Education** - holds staff education level metadata.
  - **Salary** - restricted entity, accessible only by top management and human resources personnel.
  - **Position** - holds employment position’s metadata.
  - **Location, Address, City, State** - location related dimension entities.

- **Data ingestion** - Data will be ingested with ETL approach. First the data will be loaded in landing (stage) table and then via SQL queries moved into the snowflake schema, that will be used for production once migration is complete.

- Data governance (Ownership and User access)
  - **Ownership**: Human resources department
  - **User Access**: Every employee will have read-only access (except salary entity). Human resources as well as top management will have read and write access.

- **Scalability** - Replication may be required as organisation grows, but is not an immediate concern. Sharding will not be used due to its eventual consistency properties.
- **Flexibility** - No additional measures are required.
- **Storage & retention**
  - **Storage (disk or in-memory)**: 1 GB of space for data storage partition is sufficient.
  - **Retention**: Data needs to be kept for at least 7 years due to legal considerations.
  - **Backup**: Daily incremental and weekly full backups.

## Conceptual ERD

![Conceptual ERD]("img/../img/conceptual_erd.png?raw=true")

## Logical ERD

![Logical ERD]("img/../img/logical_erd.png?raw=true")

## Physical ERD

![Physical ERD]("img/../img/physical_erd.png?raw=true")

## Questions and solutions

Please see [sql/4_crud.sql]("sql/4_crud.sql")

## Challanges

Please see [sql/5_challanges.sql]("sql/5_challanges.sql")

## How to run me

### Requirements

- Docker
- Linux or MacOS
- psql (Postgres official CLI)

### Clone the repository

```zsh
git clone https://github.com/jpuris/udacity-da-nand-projects.git
cd udacity-da-nand-projects/project_1
```

### Init DB

```zsh
docker run -p 127.0.0.1:5432:5432 -v $(pwd)/hr-dataset/:/tmp/hr-dataset/ --name udacity_da_nand_project_1 -e POSTGRES_PASSWORD=postgres postgres
```

### Run the Schema creation and ETL

```zsh
# Schema
psql postgresql://postgres:postgres@127.0.0.1:5432/postgres < sql/1_create_schema.sql

# Extract and Load data from the flat file
psql postgresql://postgres:postgres@127.0.0.1:5432/postgres < sql/2_load_stage.sql

# Run the ETL
psql postgresql://postgres:postgres@127.0.0.1:5432/postgres < sql/3_sql_etl.sql

# Optional
# Run the CRUD commands
psql postgresql://postgres:postgres@127.0.0.1:5432/postgres < sql/4_crud.sql

# Optional
# Run the challanges
psql postgresql://postgres:postgres@127.0.0.1:5432/postgres < sql/5_challanges.sql
```

## Disclaimer and Usage

Please read [Udacity Honor Code](https://udacity.zendesk.com/hc/en-us/articles/210667103-What-is-the-Udacity-Honor-Code-), [rules on collaboration](https://udacity.zendesk.com/hc/en-us/articles/207694806-What-are-the-rules-on-collaboration-) and [plagiarism](https://udacity.zendesk.com/hc/en-us/sections/360000345231-Plagiarism)
