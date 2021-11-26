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


get.multi.coverage<- function(locations,points,distance){                                                       #User inputs - data frame of locations (lat,long), data frame of points (lat, long).

  total_results <- list()
  total_coverage <- list()


  for (i in 1:nrow(points)) {
    total_results[[i]] <- get.total.coverage(
      locations,
      points[i,1],                 # Iterates over the rows pulling out Latitude & Longitude.
      points[i,2],
      distance
    )             # Stores multiple results as a list.
  }

  for (i in 1:nrow(points)) {
    total_coverage[[i]] <- total.coverage(
      locations,
      points[i,1],                 # Iterates over the rows pulling out Latitude & Longitude.
      points[i,2],
      distance
    )             # Stores multiple results as a list.
  }

  total <- as.data.frame(do.call(rbind,total_results))                               # Merges lists into one table.
  total[is.na(total)] <- 0                                                           # Overwrite NA values
  total$`Count of Locations Covered` <- unlist(total$`Count of Locations Covered`)   # Un-lists Coverage (removes Boolean object)
  overall_coverage <- as.data.frame(do.call(rbind,total_coverage))
  overall_coverage <- overall_coverage %>% unique %>% filter(coverage == TRUE) %>% nrow()

  total <- cbind(total, overall_coverage)

  total <- total %>% rename(`Total Unique Coverage` = overall_coverage)


  return(total)                                                                      # Prints table when function is called.

}




