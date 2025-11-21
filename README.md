# Case Study 1: How does a bike-share navigate speedy success?

This Markdown notebook has been written for the Capstone project of the course [Google Data Analytics Professional Certificate](https://www.coursera.org/professional-certificates/google-data-analytics) on Coursera.

This project follows the main steps of the data analysis process:

-   Ask
-   Prepare
-   Process
-   Analyze
-   Share

Each of the following sections is dedicated to one of these steps.

## Ask

A bike sharing company wants to increase the number of customers with an annual subscription by targeting their casual users. The main task to be accomplished in this data analysis is to **understand how differently annual members and casual riders use their bikes**. This will help understanding how to convince more casual riders to buy annual subscriptions.

## Prepare

For this project I used publicly available data of the City of Chicago Divvy bicycle sharing service. The data are located in a [publicly accessible database](https://divvy-tripdata.s3.amazonaws.com/index.html). Since I have to compare the previous 12 months, I am using data from November 2024 to October 2025.
This is the lis of files I used:

1. 202411-divvy-tripdata.zip
2. 202412-divvy-tripdata.zip
3. 202501-divvy-tripdata.zip
4. 202502-divvy-tripdata.zip
5. 202503-divvy-tripdata.zip
6. 202504-divvy-tripdata.zip
7. 202505-divvy-tripdata.zip
8. 202506-divvy-tripdata.zip
9. 202507-divvy-tripdata.zip
10. 202508-divvy-tripdata.zip
11. 202509-divvy-tripdata.zip
12. 202510-divvy-tripdata.zip

I unzipped all the files and obtained 12 csv files (in square brackets I indicated the file size and the number of lines, the latter one has been obtained with the Linux terminal command ```wc -l```):

1. 202411-divvy-tripdata.csv [66M] [335076]
2. 202412-divvy-tripdata.csv [35M] [178373]
3. 202501-divvy-tripdata.csv [27M] [138690]
4. 202502-divvy-tripdata.csv [30M] [151881]
5. 202503-divvy-tripdata.csv [58M] [298156]
6. 202504-divvy-tripdata.csv [72M] [371342]
7. 202505-divvy-tripdata.csv [97M] [502457]
8. 202506-divvy-tripdata.csv [130M] [678905]
9. 202507-divvy-tripdata.csv [145M] [763433]
10. 202508-divvy-tripdata.csv [150M] [790178]
11. 202509-divvy-tripdata.csv [136M] [714760]
12. 202510-divvy-tripdata.csv [122M] [646040]

I then run the following linux terminal command to check that all files had the same header:
```
diff <(head -n 1 202411-divvy-tripdata.csv) <(head -n 1 202412-divvy-tripdata.csv) 
```
This allowed me to confirm that indeed all files had the same structure. All files consist of the following columns:
```
"ride_id","rideable_type","started_at","ended_at","start_station_name","start_station_id","end_station_name","end_station_id","start_lat","start_lng","end_lat","end_lng","member_casual"
```

The data should be reliable and they have been provided by Motivate International Inc. under [this license](https://divvybikes.com/data-license-agreement). This data collect information on the City of Chicago's Divvy bicycle sharing service. The data provide details regarding all the rides performed by "casual" and "member" riders, referring respectively to casual and subscribed members. For each ride we have information that can allow us to understand the type of bicycle used, the duration, origin and destination of each trip.

Unfortunately the data do not provide details about the rider's id and therefore we cannot estimate how many rides have been performed by the same user or by different users.

## Process

Due to the large amount of data, I am using SQL to process the data.

I created a new database in BigQuery called `Divvy_TripData_Nov24_Oct25` and I uploaded each csv file to create tables with the name `YYYY_MM_divvy_tripdata` (e.g., `2024_11_divvy_tripdata`). Some csv files are larger than 100 MB and BigQuery did not allow me to upload them directly. I therefore uploaded all the csv file in a Google Drive folder and imported that data into BigQuery from that Google Drive folder.

The first step was to make sure that all rows were filled. The script is contained in the BigQuery file named `Check_data_for_null_values`. Doing this I found that that many rows do not have either a starting or an ending station specified. As an example, `202411-divvy-tripdata.csv` has a total of 335075 records: 56203 are missing `start_station_name` and `start_station_id`, 57644 are missing `end_station_name` and `end_station_id`, 273 are missing `end_lat` and `end_lng`.

In the second step of my analysis, I decided to remove the rows with NULL values and create a new table for each month. The tables were named ``YYYY_MM_divvy_tripdata_clean`` (e.g., ``2024_11_divvy_tripdata_clean``). These tables also contains two additional columns: ride_length (duration of each trip in minutes) and day_of_week (day of the week when the ride started). These steps were performed in the BigQuery file named `Clean_Data`. 

When performing this operation I also noticed that ``2024_11_divvy_tripdata_clean`` contains negative values for ``ride_length``. This happened for rides performed in the first Sunday of November when time is changed in the USA. This affects 26 of the 245971 records. I can therefore safely ignore them without affecting my analysis. The same problem may happen for the data taken on the second Sunday in March (``2025_03_divvy_tripdata_clean``) for rides that started before 2 am and ended after 2 am. Considering that very few records were affected by the time change in November, I make (for the moment) the assumption that the same is true for the rides affected by the time change in March.

In the third step I merged all 12 "clean" tables into a single table that contains one year of data (from November 2024 to October 2025). The table was named `2024_11_to_2025_10_divvy_tripdata_clean`.

## Analyze

As mentioned at the beginning, the main task to be accomplished in this data analysis is to understand how differently annual members (``member_casual=member``) and casual (``member_casual=casual``) riders use Cyclistic bikes.

This analysis will make use of our newly crated table ``2024_11_to_2025_10_divvy_tripdata_clean`` that contains one year of data. The BigQuery script is contained in the file Analyze.

I first had a look at the total number of rides grouped by month and I noticed that most rides happen in the Summer months. This seems to be same for both member and casual users.

When calculating the number of rides for users by day_of_week (over the entire year). The day with most rides is Saturday for casual users. While for members, there is almost an equal distribution over the days of the week, with most rides happening from Monday to Friday. It seems that casual users tend to rent the bikes during the weekend, while members use the bike regularly.

The average ride length (over the entire year) is 12 minutes for members and 22 minutes for casual users. If I compute the average ride length per day of the week, I see that casual users have slightly average longer rides in the weekend and the shortest ride on Wednesday. Member users tend also to ride longer during the weekend while the average ride length betweem Monday and Friday is essentially constant.

## Share

I used Looker Studio to visualize the results that I found in BigQuery. Looker Studio can easily import data from BigQuery and I was therefore able to use my `2024_11_to_2025_10_divvy_tripdata_clean` table.

The results can be seen in this [interactive dashboard](https://lookerstudio.google.com/reporting/36353abc-8e7f-41f7-a0e1-abae5237d09b).

## Act

The aim of this data analysis project was to understand how differently annual members and casual riders use this bike sharing service.

Casual users tend to rent the bikes for much longer than members. They also tend to rent more during the weekend than during the rest of the week. Members instead show a more constant use of the bikes during the week, with a slightly lower use during the weekend.

It may be possible that members mainly use the bike to drive to work.

Both users and members prefer to rent during the summer months (August and September show the largest usage). While January, February, and December are the months with the lowest amount of rents (consistent probably with being the coldest months).

Please note that the data did not provide information of the users renting the bikes. So it was not possible to know if multiple rents where done by the same group of users. Data have therefore been analyzed in a cumulative way.
