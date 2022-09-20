get_steps <- function(data) {
  
  # Extracts the individual steps from the GPS data. For details, please refer
  # to the methods section of the paper
  
  # Arguments:
  # data: Tibble containing the original data (GPS over time)
  
  # Returns:
  # steps: A vector of step lengths in meter
  
  ##################################
  
  # Compute the successive steps in the original data
  steps <- c(0)
  times <- c(0)
  lon <- data$lon
  positive <- 0
  negative <- 0
  i <- 1
  while (i < length(lon)) {
    start <- lon[i]
    if (lon[i+1] >= lon[i]){
      j <- i
      while (lon[j+1] >= lon[j]) {
        j <- j + 1
        end <- lon[j]
        if (j == length(lon)) {
          break
        }
      }
    }
    else{
      j <- i
      while (lon[j+1] < lon[j]){
        j <- j + 1
        end <- lon[j]
        if (j == length(lon)) {
          break
        }
      }
    }
    step <- end - start
    times <- c(times, date(data$Date[i]))
    i <- j
    steps <- c(steps, step)
  }
  
  # Consider absolute lengths, steps larger than zero
  steps <- abs(steps)
  steps <- steps[steps > 0]
  
  # Convert the steps into steps along the earths surface (in meters)
  steps <- steps * 6371 * 1000 * (pi / 180)
  
  return(steps)
}

truncate_steps <- function(steps, animal) {
  
  # Truncates the data such that only the tail is kept. The truncation point is
  # different for each animal (see methods)
  
  # Arguments:
  # steps: Vector of step lengths as output by get_steps()
  # animal: string indicating the identity of the animal for which the data 
  #         was observed
  
  # Returns:
  # steps_truncated: Vector containing the long steps
  
  ##################################
  
  dict <- c()
  dict["S11"] <- 665
  dict["S12"] <- 665
  dict["S13"] <- 150
  dict["S14"] <- 400
  dict["S15"] <- 7000
  dict["S16"] <- 4000
  dict["S17"] <- 665
  dict["S18"] <- 1800
  dict["S19"] <- 1800
  dict["S20"] <- 6500
  dict["S21"] <- 2270
  dict["S22"] <- 8000
  dict["S23"] <- 665
  dict["S24"] <- 6650
  dict["S25"] <- 1400
  
  truncation_point = dict[animal]
  steps_truncated <- steps[steps > truncation_point]
  return(steps_truncated)
}