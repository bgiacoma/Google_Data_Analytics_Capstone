#View the first 5 records
SELECT *
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_10_divvy_tripdata`
LIMIT 5;

#Check if any rows has null or empty values and show them
SELECT *
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_divvy_tripdata`
WHERE 
  ride_id IS NULL OR ride_id = '' OR
  rideable_type IS NULL OR rideable_type = '' OR
  started_at IS NULL OR
  ended_at IS NULL OR
  start_station_name IS NULL OR start_station_name = '' OR
  start_station_id IS NULL OR start_station_id = '' OR
  end_station_name IS NULL OR end_station_name = '' OR
  end_station_id IS NULL OR end_station_id = '' OR
  start_lat IS NULL OR
  start_lng IS NULL OR
  end_lat IS NULL OR
  end_lng IS NULL OR
  member_casual IS NULL OR member_casual = '';


#Count the number of rows that have null values
#(note that in BigQuery a CSV record that has an empty string will be assigned a NULL value)
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
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2025_07_divvy_tripdata`

