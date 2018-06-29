#Import csv file and check number of rows, columns, datatypes, null values. 
import pandas as pd
df = pd.read_csv('movies_metadata.csv')
df.info()

'''From the results we observe that budget column datatype should be int/float, but its datatype is object(budget45466 non-null object),
which needs to be change. One reason of mismatch datatype could be that there can be few non numeric values (string)present in numeric columns, due to which there datatype is listed as object. So, we need to check for non-numeric values 
in numeric columns.'''

#Search for the rows having non numeric values in budget column, so that we can decide whether we can drop them or replace them with 0/ mean etc.
print (df[pd.to_numeric(df['budget'], errors='coerce').isnull()])

"'Output
                                          adult  \
19730                                 - Written by Ørnås   
29503   Rune Balot goes to a casino connected to the ...   
35587   Avalanche Sharks tells the story of a bikini ...   

      belongs_to_collection                            budget  \
19730              0.065736  /ff9qCepilowshEtG2GYWwzt2bs4.jpg   
29503              1.931659  /zV8bHuSL6WXoD6FWogP9j4x80bL.jpg   
35587              2.185485  /zaSf5OG7V8X8gqFvly88zDdRm46.jpg   

                                                homepage          id imdb_id  \
19730  [{'iso_3166_1': 'CA', 'name': 'Canada'}, {'iso...  1997-08-20       0   
29503  [{'iso_3166_1': 'US', 'name': 'United States o...  2012-09-29       0   
35587           [{'iso_3166_1': 'CA', 'name': 'Canada'}]  2014-01-01       0   

      original_language                            original_title  overview  \
19730             104.0  [{'iso_639_1': 'en', 'name': 'English'}]  Released   
29503              68.0      [{'iso_639_1': 'ja', 'name': '日本語'}]  Released   
35587              82.0  [{'iso_639_1': 'en', 'name': 'English'}]  Released   

         ...     release_date revenue runtime spoken_languages status  \
19730    ...                1     NaN     NaN              NaN    NaN   
29503    ...               12     NaN     NaN              NaN    NaN   
35587    ...               22     NaN     NaN              NaN    NaN   

       tagline  title video vote_average vote_count  
19730      NaN    NaN   NaN          NaN        NaN  
29503      NaN    NaN   NaN          NaN        NaN  
35587      NaN    NaN   NaN          NaN        NaN  

'''From the above output we can see that there are 3 rows having non-numeric values in budget column. Due to which budget column was listed as object datatype. It will be wiser to drop these 3 rows  as these rows have many NaN values and 
many mismatch datatypes other than budget, like original_language (should have string but have int values)'''

#Droping rows
df = df[pd.to_numeric(df['budget'], errors='coerce').notnull()]

#Output : new number of entries will be 45463 
'''If we don't want to drop whole row, beacuse it might have useful info in other columns then we can just drop values from that
particular cell (like in this case 3 values only from budget column will be dropped instead of complete rows) while converting the column to numeric datatype'''

df.budget = pd.to_numeric(df.budget, errors='coerce')

#Output : In total,number of entries will be 45466, but in budget column it will be 45463

#To check total number of null values in all columns
df.isnull().sum() 

'''Output Sample (Pasted only the columns having high null values)

belongs_to_collection    40972
homepage                 37684
overview                   954
tagline                  25051'''

'''From output we can see that some columns have too many null values. Like: belongs_to_collection column(null values = 40972), 
it have only 10% non-null values. Hence we can do dimension reduction and can drop columns with higher % of null values from our dataframe.'''

#Drop multiple columns-> First method
df = df.drop(labels= ['belongs_to_collection','homepage','tagline'], axis = 1)

#Drop multiple columns-> Second method
columns = ['belongs_to_collection','homepage','tagline']
df.drop(columns, inplace=True, axis=1)

#Output: Now dataframe have 21 columns and 45463 rows.
