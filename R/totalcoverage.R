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
#'



total.coverage <- function(locations,lon,lat,distance){


  output <- data.frame(locations,                                                       #Calculate the distance of the point of interest for each row in locations data frame.
                       coverage = distHaversine(
                         locations,
                         c (lon,lat)
                       ) / 1000 < distance)

  return(output)

}
