// Size of all DB
SELECT table_schema "DB Name",
Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB"
FROM information_schema.tables
GROUP BY table_schema; 

// SIZE of one table
SELECT 
    table_name AS `Table`, 
    round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` 
FROM information_schema.TABLES 
WHERE table_schema = "bdd"
    AND table_name = "table";
