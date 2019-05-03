USE GE2017;

CREATE TABLE election_night_tweets ( 
date_time DATETIME, 
subject VARCHAR(255) NOT NULL
);

CREATE TABLE hocl_result_summary ( 
ons_id VARCHAR(20) NOT NULL, 
ons_region_id VARCHAR(20) NOT NULL, 
constituency_name VARCHAR(255) NOT NULL, 
county_name VARCHAR(100) NOT NULL, 
region_name VARCHAR(100) NOT NULL, 
country_name VARCHAR(100) NOT NULL, 
constituency_type VARCHAR(100) NOT NULL, 
declaration_time DATETIME, 
result VARCHAR(100) NOT NULL, 
first_party VARCHAR(100) NOT NULL, 
second_party VARCHAR(100) NOT NULL, 
electorate BIGINT, 
valid_votes INT, 
invalid_votes INT, 
majority INT, 
con INT, 
lab INT, 
ld INT, 
ukip INT, 
green INT, 
snp INT, 
pc INT, 
dup INT, 
sf INT, 
sdlp INT, 
uup INT, 
alliance INT, 
other INT
);

CREATE TABLE hocl_result_detail ( 
ons_id VARCHAR(20) NOT NULL, 
ons_region_id VARCHAR(20) NOT NULL, 
constituency_name VARCHAR(255) NOT NULL, 
county_name VARCHAR(100) NOT NULL, 
region_name VARCHAR(100) NOT NULL, 
country_name VARCHAR(100) NOT NULL, 
constituency_type VARCHAR(100) NOT NULL,
party_name VARCHAR(100) NOT NULL,
party_abbreviation VARCHAR(100) NOT NULL,
firstname VARCHAR(100) NOT NULL,
surname VARCHAR(100) NOT NULL,
gender VARCHAR(100) NOT NULL,
sitting_mp VARCHAR(3) NOT NULL,
former_mp VARCHAR(3) NOT NULL,
votes INT,
share DECIMAL(5, 5)
);

BULK INSERT election_night_tweets
FROM 'C:\Users\Lucy\Google Drive\TM351VM\notebooks\GE2017\data\election_night_tweets_import.csv'
WITH
( FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

BULK INSERT hocl_result_summary
FROM 'C:\Users\Lucy\Google Drive\TM351VM\notebooks\GE2017\data\hocl_ge2017_sum_cleaned_import.csv'
WITH
( FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

BULK INSERT hocl_result_detail
FROM 'C:\Users\Lucy\Google Drive\TM351VM\notebooks\GE2017\data\hocl_ge2017_full_cleaned_import.csv'
WITH
( FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO


SELECT s.[ons_id]
      ,s.[ons_region_id]
      ,s.[constituency_name]
      ,s.[county_name]
      ,s.[region_name]
      ,s.[country_name]
      ,s.[constituency_type]
      ,s.[declaration_time]
      ,s.[result]
      ,s.[first_party]
      ,s.[second_party]
      ,s.[electorate]
      ,s.[valid_votes]
      ,s.[invalid_votes]
      ,s.[majority]
      ,s.[con]
      ,s.[lab]
      ,s.[ld]
      ,s.[ukip]
      ,s.[green]
      ,s.[snp]
      ,s.[pc]
      ,s.[dup]
      ,s.[sf]
      ,s.[sdlp]
      ,s.[uup]
      ,s.[alliance]
      ,s.[other]
      ,d.[party_name]
      ,d.[party_abbreviation]
      ,d.[firstname]
      ,d.[surname]
      ,d.[gender]
      ,d.[sitting_mp]
      ,d.[former_mp]
      ,d.[votes]
      ,d.[share]
FROM [dbo].[hocl_result_summary] AS s
INNER JOIN [dbo].[hocl_result_detail] AS d
ON s.[ons_id] = d.[ons_id] AND s.[first_party] = d.[party_abbreviation]
ORDER BY s.[constituency_name]


WITH small_date_cte (date_time, subject) AS (
	SELECT CAST([date_time] AS smalldatetime), [subject]
	FROM [GE2017].[dbo].[election_night_tweets]
)
SELECT [date_time], [subject], COUNT([subject]) AS subject_count 
FROM small_date_cte
GROUP BY [date_time], [subject]
ORDER BY [date_time]