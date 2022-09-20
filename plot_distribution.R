plot_distribution <- function(step_lengths, xmin, xmax, alpha, alpha_truncated) {
  
  # Plots the empirical distribution function of the tail together with 
  # the theoretical Pareto and truncated Pareto distributions fitted by
  # Maximum Likelihood

  # Arguments:
  # step_lengths: Vector containing the individual step lengths
  # xmin: Lower bound of the (truncated) Pareto distribution
  # xmax: Upper bound of the truncated Pareto distribution
  # alpha: Exponent of the pareto distribution
  # alpha_truncated: Exponent of the truncated Pareto distribution
  
  # Returns:
  # ggplot plot to pe passed to print()
  
  ##################################
  
  # Range of the y-axis
  x_range <- linspace(min(step_lengths), max(step_lengths), n = 1000)
  # Generate the empirical cdf
  empirical <- c()
  for (i in 1:length(step_lengths)) {
    empirical <- c(empirical, length(step_lengths[step_lengths > step_lengths[i]]) / length(step_lengths))
  }
  empirical_data <- tibble(x = step_lengths, y = empirical)
  
  # Generate the continuous functions
  plot_data <- tibble(x_range = x_range, trunc_pareto = ptruncpareto(x_range, xmin, xmax, alpha_truncated, lower.tail = F), pareto = ppareto(x_range, xmin, alpha, lower.tail = F))

  # Plot with Legend for presentation
  plot_object <- ggplot(data = plot_data, aes(x=log(x_range))) + geom_line(aes(y=log(trunc_pareto), color = "Truncated Pareto")) + geom_line(aes(y=log(pareto), color = "Pareto")) + scale_colour_manual("",
                                                                                                                                                                                          breaks = c("Truncated Pareto", "Pareto"),
                                                                                                                                                                                          values = c("green3", "blue")) + theme_bw() + theme(legend.position=c(0.2,0.15), axis.title.x = element_text(size=15), axis.title.y = element_text(size=15), title = element_text(size=15), text = element_text(size=20)) + geom_point(data = empirical_data, aes(x = log(x), y = log(y)), shape = 1) + xlab("Step length")  + ylab("Fraction of steps greater than x") +ggtitle("Empirical Survivor function (log-log-scale)")
  return(plot_object)

}