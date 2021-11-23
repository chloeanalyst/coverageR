# coverageR
 
# openweatherr: Simple wrapper for Open Weather Map API

# Version - 1.0.0

**Author:** Chloe Morgan

**License:** GPL-3

**coverageR**  Functions to calculate how many points are within the radius of a location. Utilises the distHaversine function from the geosphere package to calculate one to many or many to many location relationships. 

## Use case example

*Which area of New York has the largest coverage of Hotels within 1km distance of a bus stop?* 

   | Coverage %|Count of Locations Covered|                   Street |
   |-----------|--------------------------|--------------------------|
   |     37.11 |                      2042|                5 AVENUE  |
   |     33.81 |                      1860|                 7 AVENUE |
   |     33.77 |                      1858|          WEST 57 STREET  |


- Midtown Manhattan (5th Avenue) 32 Stops, 37.11% Hotel Coverage. 

_Output & Original Data Visualised with Kepler_

<img width="1007" alt="Screenshot 2021-09-12 at 00 33 25" src="https://user-images.githubusercontent.com/52977984/132966047-d5cbcbb6-7aea-4382-8055-ac94f45d9bc3.png">


# Available Functions:

### One to many

`get.total.coverage(locations, lon, lat, distance)`

**Use case:** Calculating the number of locations around a single point.

locations = _DATA FRAME_ or TWO _LIST_(s)
- restrictions = Can only contain 2 columns
- column order = Columns MUST be in this order -> 1: Longitude 2: Latitude

lon = Longitude _NUMERIC_ (-73.97537)

lat = latitude _NUMERIC_ (40.76126)

distance = km _NUMERIC_ (3)


### Many to many 

`get.multi.coverage(locations, points, distance)`

**Use case:** Calculating the number of locations around multiple points.

locations = _DATA FRAME_ or TWO _LIST_(s)
- restrictions = Can only contain 2 columns
- column order = Columns MUST be in this order -> 1: Longitude 2: Latitude


points (of interest) = _DATA FRAME_ or TWO _LIST_(s)
- restrictions = Can only contain 2 columns
- column order = Columns MUST be in this order -> 1: Longitude 2: Latitude

distance = km _NUMERIC_ (3)


# Installation:

```
devtools::install_github("chloeanalyst/coverager")

library(coverager)
```

# How to use - Example scripts

## Coverage of one point to many points. 
**Example:** How many hotels are around a bus stop on 5th Ave in New York?

**Data Sources**

- New York Hotels: https://data.cityofnewyork.us/City-Government/Hotels-Properties-Citywide/tjus-cn27

- New York Bus Stops: https://data.cityofnewyork.us/Transportation/Bus-Stop-Shelters/qafz-7myz


**Required function:** `get.total.coverage(locations, lon, lat, distance)`

- locations - This can be one location or a dataframe of many locations (Must be in 2 columns as Lon, Lat)
- lat - This is the Latitude of the place of interest. 
- lon - This is the Longitude of the place of interest. 
- distance - This is the required distance of the radius in KM.

```
#----------------------------------------------------------# Load required packages 

library(coverager) #- Will calculate the coverage
library(readr) #- Used to read in CSV's
library(purrr) #- Used to run multiple distances
library(dplyr) #- Language preference for R (Like SQL)

#----------------------------------------------------------# Read in data from preferred source.

stop <- read_csv("data/Bus_Stop_Shelter.csv")
hotel <- read_csv("data/Hotels_Properties_Citywide.csv")

#----------------------------------------------------------# Prepare the data

hotel_locations <- hotel %>% select(Longitude,Latitude)               # Location points - The data we want to check coverage for. 

# get.total.coverage(location, lon, lat, distance)

result <- get.total.coverage(hotel_locations, -73.97537, 40.76126, 3)   # Run function and save output as result

result                                                                # Print the result

```

**Output**
This tells us that 55% of the Hotels in the New York Hotels data set are covered by the stop on 5th Avenue.

   | Coverage %|Count of Locations Covered|          Total Locations |
   |-----------|--------------------------|--------------------------|
   |    55.27  |                      3041|                     5519 |



## Coverage of many points to many points.

Example: Which bus stop has the largest coverage of Hotels? 

**Required function:** `get.multi.coverage(locations, points, distance)`

- locations - A dataframe of many locations (Must be in 2 columns as Lon, Lat)
- points - This is a dataframe of many points of interest (Bus Stops)
- distance - This is the required distance of the radius in KM

```
#----------------------------------------------------------# Load required packages 

library(coverager) #- Will calculate the coverage
library(readr) #- Used to read in CSV's
library(purrr) #- Used to run multiple distances
library(dplyr) #- Language preference for R (Like SQL)

#----------------------------------------------------------# Read in data from preferred source.

stop <- read_csv("data/Bus_Stop_Shelter.csv")
hotel <- read_csv("data/Hotels_Properties_Citywide.csv")

#----------------------------------------------------------# Prepare the data
stop_data <- as.data.frame(stop %>% select(LONGITUDE,LATITUDE))                 # Location points - To be used within the function.
stop_locations <- stop %>% select(Street, LONGITUDE, LATITUDE)                  # Stop Names - To be joined to the output so we have the names of the stops and the coverage.

hotel_locations <- hotel %>% select(Longitude,Latitude)                         # Location points - The data we want to check 

#-----------------------------------------------------------# Calculate Coverage



distances <- c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)                          # Create a list of distances we would like to run coverage for, this can be as long as you like. 


walking_time <- function(i) {                                                   # Function for distance mapping
  
  distance <- i                                                                 # We will be iterating through the list of distances.
  print(i)                                                                      # Prints the value of the distance the function is current calculating. 
  output <- get.multi.coverage(hotel_locations,stop_data,i)                     # Run the coverage function and store it as output. i = the distance from the list above.                               
  output <- output %>% cbind(stop_locations)                                    # Take the result of the coverage function and join the names of the stops and additional information. The output will be in the same order as your original data.                              
  output <- output %>% distinct                                                 # Remove any duplicate stops
  output$distance <- distance                                                   # Create a column with the distance radius we have calculated.
  return(output)                                                                # Return the final output
  
}


result <- map_df(distances, walking_time)                                       # Maps distances to coverage results. (Does the iteration)

```

**Output**

As this script is running it will print the distance radius (km) it is working on in the console. 

_Expected in your console:_

```
 > result <- map_df(distances, walking_time)    
[1] 0.1
[1] 0.2
[1] 0.3
[1] 0.4
[1] 0.5
[1] 0.6
[1] 0.7
[1] 0.8
[1] 0.9
[1] 1

```

Expected output, the coverage and count of Locations covered are the same across all rows as this is an example but you'd expect to see coverage increase as the distance increases. 

The number of rows in your output will be the number of points of interest X the number of distances.


   | Coverage %|Count of Locations Covered|          Total Locations |Street         |Longitude  |Latitude |Distance |
   |-----------|--------------------------|--------------------------|---------------|-----------|---------|---------|
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.1     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.1     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.1     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.2     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.2     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.2     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.3     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.3     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.3     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.4     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.4     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.4     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.5     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.5     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.5     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.6     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.6     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.6     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.7     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.7     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.7     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.8     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.8     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.8     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 0.9     |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 0.9     |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 0.9     |
   |     37.11 |                      2042|                      5519|     5 AVENUE  |-73.93495  |40.67940 | 1       |
   |     33.81 |                      1860|                      5519|      7 AVENUE |-73.94330  |40.68110 | 1       |
   |     33.77 |                      1858|                      5519| WEST 57 STREET|-73.92362  |40.69613 | 1       |
