#' CoverageR
#'
#' Calculates whether locations are within a defined radius.
#'
#'
#'
#' @param locations Data Frame of locations
#' @param lon Longitude for point of interest eg: The starting point
#' @param lat Latitude for point of interest eg: The starting point
#' @param distance Value for the size of the radius in KM eg: 1.4 or 3.0
#'
#' @author Chloe Morgan
#'
#' @import geosphere
#' @import purrr
#' @import dplyr
#'
#' @return Table containing coverage information.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' Example One
#'
#'distances <- c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1)
#'walking_time <- function(i) {
#'  distance <- i
#'  print(i)
#'  output <- get.multi.coverage(hotel,stop_data,i)
#'  output <- output %>% cbind(stop_locations)
#'  output <- output %>% distinct
#'  output$distance <- distance
#'  return(output)
#'  }
#'
#'  result <- map_df(distances, walking_time)
#'
#'
#' }
#'


#                                                                                     Calculate the number of locations with a radius of a point.

get.total.coverage <- function(locations,lon,lat,distance) {

  output <- data.frame(locations,                                                       #Calculate the distance of the point of interest for each row in locations data frame.
                       coverage = distHaversine(
                         locations,
                         c (lon,lat)
                       ) / 1000 < distance)                    # Convert the distance to Kilometers.


  result <- table(output$coverage)                                                      # Extract the coverage results from the output.
  result$coverage_percentage <- c(round(result[2] / nrow(locations) * 100,2))   # Calculate the percentage of locations within range of the point of interest.
  result$covered_locations <- result[2]                                                 # Calculate the total number of locations that are within range of the point of interest.
  result$total_locations <- nrow(locations)                                             # The total number of locations in the data set.



  result <- tibble(result$coverage_percentage,                                          # Create a tibble of results.
                   result$covered_locations,
                   result$total_locations)



  names(result) <- c("Coverage %",                                                      # Rename the columns.
                     "Count of Locations Covered",
                     "Total Locations")

  return(result)                                                                        # Prints the output when function is called.

}

