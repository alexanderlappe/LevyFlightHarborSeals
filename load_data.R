load_data <- function(path, animal) {
  data <- tibble(read.csv(path))
  data <- data %>% mutate(lat = LAT, lon = LON) %>%
    filter(V_MASK == 0) %>%
    select(-c(Data_type, Species, Capture_site, LAT, LON)) %>%
    filter(Seal_ID == animal)
  return(data)
}