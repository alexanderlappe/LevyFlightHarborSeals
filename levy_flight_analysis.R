### Settings ###

# Set path leading to excel file containing the GPS data
path = "C:\\Users\\Alex\\OneDrive - UT Cloud\\Documents\\Uni\\LevyFlight\\95167.csv"

# Choose animal by setting the string to the name of the corresponding sheet in the excel file
animal = "S22"

### Code ###

print(paste0("Animal: ", animal))
# Set working directory to current folder, import functions
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Clear console0,20,0595613

cat("\014") 
set.seed(42)
# Load libraries and helper files
library(tidyverse)
library(readxl)
library(lubridate)
library(EnvStats)
library(pracma)
library(VGAM)
library(goftest)
source("get_steps.R")
source("fit_distributions.R")
source("plot_distribution.R")
source("bootstrapped_cvm.R")
source("load_data.R")

# Load Data
data <- load_data(path, animal)
print(nrow(data))

# Generate step lengths
steps = get_steps(data=data)
print(paste0("Number of steps in the data set: ", length(steps)))
steps_truncated = truncate_steps(steps, animal)
print(paste0("Number of steps in the tail data: ", length(steps_truncated)))

# Fit distributions
alpha = fit_pareto(steps_truncated)[2]
xmin = fit_truncated_pareto(steps_truncated)[1]
xmax = fit_truncated_pareto(steps_truncated)[2]
alpha_truncated = fit_truncated_pareto(steps_truncated)[3]
print(paste0("Estimated exponent for the truncated Pareto distribution: ", round(alpha_truncated, 3)))

# Plot data
plot_object = plot_distribution(steps_truncated, xmin, xmax, alpha, alpha_truncated)
print(plot_object)

# Compute the bootstrapped Cramer-von Mises test
print("Bootstrapping the p-value for the CVM test...")
p = bootstrapped_cvm(steps_truncated)
print(paste0("Bootstrapped p-value: ", p))