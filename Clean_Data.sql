#Check that the SELECT statement below allows us to create a table with NO NULL value
SELECT 
  COUNTIF(ride_id IS NULL) as ride_id_empty,
  COUNTIF(rideable_type IS NULL) as rideable_type_empty,
  COUNTIF(started_at IS NULL) as started_at_empty,
  COUNTIF(ended_at IS NULL) as ended_at_empty,
  COUNTIF(start_station_name IS NULL) as start_station_name_empty,
  COUNTIF(start_station_id IS NULL) as start_station_id_empty,
  COUNTIF(end_station_name IS NULL) as end_station_name_empty,
  COUNTIF(end_station_id IS NULL) as end_station_id_empty,
  COUNTIF(start_lat IS NULL) as start_lat_empty,
  COUNTIF(start_lng IS NULL) as start_lng_empty,
  COUNTIF(end_lat IS NULL) as end_lat_empty,
  COUNTIF(end_lng IS NULL) as end_lng_empty,
  COUNTIF(member_casual IS NULL) as member_casual_empty
FROM ( #Show only the rows that do not have NULL values and avoid duplicates
  SELECT DISTINCT *
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_divvy_tripdata`
  WHERE 
    ride_id IS NOT NULL AND
    rideable_type IS NOT NULL AND
    started_at IS NOT NULL AND
    ended_at IS NOT NULL AND
    start_station_name IS NOT NULL AND
    start_station_id IS NOT NULL AND
    end_station_name IS NOT NULL AND
    end_station_id IS NOT NULL AND
    start_lat IS NOT NULL AND
    start_lng IS NOT NULL AND
    end_lat IS NOT NULL AND
    end_lng IS NOT NULL AND
    member_casual IS NOT NULL);


#Use that SELECT statement to create a new table
#In this table we also add two new columns:
# ride_length = ended_at - started_at
# day_of_week = started_at
CREATE TABLE `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_10_divvy_tripdata_clean` AS
(
  SELECT DISTINCT *,
    #round correctly to minutes
    #TIMESTAMP_DIFF(ended_at, started_at, MINUTE) truncates (rounds down) the value in minutes
    ROUND(TIMESTAMP_DIFF(ended_at, started_at, SECOND) / 60.0) AS ride_length,
    #get the day of the week (Monday-Sunday format)
    FORMAT_DATE('%A', DATE(started_at)) AS day_of_week
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_10_divvy_tripdata`
  WHERE 
    ride_id IS NOT NULL AND
    rideable_type IS NOT NULL AND
    started_at IS NOT NULL AND
    ended_at IS NOT NULL AND
    start_station_name IS NOT NULL AND
    start_station_id IS NOT NULL AND
    end_station_name IS NOT NULL AND
    end_station_id IS NOT NULL AND
    start_lat IS NOT NULL AND
    start_lng IS NOT NULL AND
    end_lat IS NOT NULL AND
    end_lng IS NOT NULL AND
    member_casual IS NOT NULL
);

#Check the new created tables
SELECT *
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_divvy_tripdata_clean`
ORDER BY ride_length ASC
LIMIT 5;

#check for negative ride_length values (due to time change in the USA)
SELECT
  COUNTIF(ride_length<0) AS negative_times
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_divvy_tripdata_clean`;

#create a table containing all 12 months
CREATE TABLE `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean` AS
(
  SELECT *
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_divvy_tripdata_clean`
  WHERE ride_length>=0
UNION ALL
  SELECT *
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_12_divvy_tripdata_clean`
UNION ALL
  SELECT *
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_01_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_02_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_03_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_04_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_05_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_06_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_07_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_08_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_09_divvy_tripdata_clean`
UNION ALL
  SELECT * 
  FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_10_divvy_tripdata_clean`
);

# check the new table
SELECT *
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean`
WHERE member_casual="member"
ORDER BY ride_length ASC
LIMIT 5;
