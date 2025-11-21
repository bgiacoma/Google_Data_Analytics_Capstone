#Show the number or rides per month and day of the week
SELECT
  COUNT(ride_id) AS Number_of_Rides,
  -- Get month name (e.g., "January")
  EXTRACT(MONTH FROM started_at) AS Month,
  day_of_week
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean`
GROUP BY Month, day_of_week
ORDER BY 
  Month,
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;

#Show the number or rides per month
SELECT
  COUNT(ride_id) AS Number_of_Rides,
  -- Get month name (e.g., "January")
  EXTRACT(MONTH FROM started_at) AS Month
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean`
WHERE member_casual = "casual"
GROUP BY Month
ORDER BY Month;

#Show the number or rides per day of the week
SELECT
  COUNT(ride_id) AS Number_of_Rides,
  day_of_week
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean`
WHERE member_casual = "member"
GROUP BY day_of_week
ORDER BY 
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;

#Show the average ride length per user type per day of the week
SELECT
  day_of_week,
  ROUND(AVG(ride_length),2) as Average_Ride_Length,
  member_casual
FROM `micro-harbor-478513-t9.Divvy_TripData_Nov24_Oct25.2024_11_to_2025_10_divvy_tripdata_clean`
GROUP BY day_of_week,member_casual
ORDER BY 
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;