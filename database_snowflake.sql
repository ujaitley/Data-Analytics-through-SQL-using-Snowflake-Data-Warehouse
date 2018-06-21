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

#Copy the file into snowflake table, with header as True

copy into movies_metadata
from @%movies_metadata
file_format =(skip_header=1 null_if=('') field_optionally_enclosed_by='"') 
pattern = '.*movies_metadata.csv.gz'
on_error = 'skip_file';

