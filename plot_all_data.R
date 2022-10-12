### Settings ###

# Set path leading to excel file containing the GPS data
path = "C:\\Users\\Alex\\OneDrive - UT Cloud\\Documents\\Uni\\LevyFlight\\95167.csv"
ncol <- 3
nrow <- 5

### Code ###
animals = list("S11", "S12", "S13", "S14", "S15", "S16", "S17", "S18", "S19",
               "S20", "S21", "S22", "S23", "S24", "S25")
ylabels <- rep(c(TRUE, rep(FALSE, ncol - 1)), nrow)
cutoffs <- log(c(665, 665, 150, 400, 7000, 4000, 665, 1800, 1800, 6500, 2270,
                 8000, 665, 6650, 1400))
pvalues = list(0.148, 0.261, 0.106, 0.122, 0.098, 0.117, 0.217,
               0.042, 0.199, 0.06, 0.037, 0.133, 0.09, 0.603, 0.002)
Ns <- list("317 (37%)", "594 (37%)", "232 (58%)", "583 (26%)", "181 (9%)",
           "277 (16%)", "515 (38%)", "444 (18%)", "499 (27%)", "144 (9%)",
           "360 (25%)", "123 (11%)", "869 (38%)", "99 (11%)", "282 (26%)")
titles <- list("A", "B", "C", "D", "E", 
               "F", "G", "H", "I", "J", 
               "K", "L", "M", "N", "O")
# animals <- list("S15", "S16")
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
library(purrr)
library(ggpubr)
library(ggtext)
library(glue)
library(Cairo)
source("get_steps.R")
source("fit_distributions.R")
source("plot_distribution.R")
source("bootstrapped_cvm.R")
source("load_data.R")

generate_subplot <- function(animal, ylabel, cutoff, pvalue, N, title) {
  # Load Data
  data <- load_data(path, animal)
  print(animal)
  
  # Generate step lengths
  steps = get_steps(data=data)
  steps_truncated = truncate_steps(steps, animal)

  # Fit distributions
  alpha = fit_pareto(steps_truncated)[2]
  xmin = fit_truncated_pareto(steps_truncated)[1]
  xmax = fit_truncated_pareto(steps_truncated)[2]
  alpha_truncated = fit_truncated_pareto(steps_truncated)[3]
  p <- plot_distribution(steps_truncated, xmin, xmax, alpha, alpha_truncated, verbose=F,
                         ylabel=ylabel, cutoff=cutoff, animal=animal, pvalue=pvalue, N=N,
                         title)
  return(p)
}
subplots <- mapply(generate_subplot, animals, ylabels, cutoffs, pvalues, Ns,
                   titles, SIMPLIFY = F)
plot <- ggarrange(plotlist=subplots, ncol=3, nrow=5,
                  hjust=0, vjust=1, heights=c(1, 1, 1, 1, 1))
plot <- annotate_figure(plot, bottom="Step length [m] (log-scale)",
                        left="Fraction of steps greater than x (log-scale)")
print(plot)
ggsave("plot_all_animals.pdf", plot=plot, device=cairo_pdf, dpi=2500, height=7)


