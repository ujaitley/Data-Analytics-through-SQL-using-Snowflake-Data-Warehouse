#Log in to Snowflake account:

In terminal, added connection information to the ~/.snowsql/config file:
accountname = <account_name>
username = <account_name>
password = <password> 
Executed the following command to connect to Snowflake:
snowsql

#Create Database

create or replace database movie_database;

#Create Table with 24 columns

create or replace table movies_metadata (
  adult boolean,
  belongs_to_collection string,
  budget numeric,
  genres string,
  homepage string,
  id numeric,
  imdb_id string,
  original_language string,
  original_title string,
  overview string,
  popularity numeric,
  poster_path string,
  production_companies string,
  production_countries string,
  release_date date,
  revenue numeric,
  runtime numeric,
  spoken_languages string,
  status string,
  tagline string,
  title string, 
  video boolean,
  vote_average numeric, 
  vote_count numeric );
  
  #Create Warehouse (Small Size in Snowflake)
  
  create or replace warehouse movie_table_wh with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;

#Stagging movies_metadata.csv.csv file from desktop

put file:///Users/urvashijaitley/Desktop/movies_metadata.csv @movie_database.public.% movies_metadata;

#If datatype mismatch is there, then datafile will not be copied in snowflake table. Below error will be displayed.
+------------------------+-------------+-------------+-------------+-------------+-------------+-------------------------------------------+------------------+-----------------------+---------------------------+
| file                   | status      | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                               | first_error_line | first_error_character | first_error_column_name   |
|------------------------+-------------+-------------+-------------+-------------+-------------+-------------------------------------------+------------------+-----------------------+---------------------------|
| movies_metadata.csv.gz | LOAD_FAILED |       21117 |           0 |           1 |           2 | Numeric value '8/20/97' is not recognized |            19764 |                   372 | "MOVIES_METADATA"["ID":6] |
+------------------------+-------------+-------------+-------------+-------------+-------------+-------------------------------------------+-

#Make sure all datatypes are correct. I cleaned my data using Python(Pandas). And then uploaded the data file successflly.

#Copy the file into snowflake table, with header as True. 
copy into movies_metadata
from @%movies_metadata
file_format =(skip_header=1 null_if=('') field_optionally_enclosed_by='"') 
pattern = '.*movies_metadata.csv.gz'
on_error = 'skip_file';

#message on terminal :
+------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                   | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| movies_metadata.csv.gz | LOADED |       45463 |       45463 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 4.184s

#Ceating new table and uploading another data file in same database(movie_database)

create or replace table ratings (userId NUMERIC, movieId NUMERIC , rating NUMERIC );

put file:///Users/urvashijaitley/Desktop/ratings.csv @movie_database.public.%ratings;

copy into RATINGS 
from @%ratings
file_format =(skip_header=1 null_if=('') field_optionally_enclosed_by='"') 
pattern = '.*ratings.csv.gz'
on_error = 'skip_file';


