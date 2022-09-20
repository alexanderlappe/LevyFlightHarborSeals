fit_pareto <- function(step_lengths) {
  
  # Performs an ML fit of the Pareto distribution to the data
  
  # Arguments:
  # step_lengths: Vector containing the individual step lengths
  
  # Returns:
  # xmin: Estimate of the lower bound of the distribution
  # alpha: Estimate of the exponent of the distribution
  
  ##################################
  
  fit <- epareto(step_lengths, method = "mle", plot.pos.con = 0.575)
  xmin <- fit$parameters[1]
  alpha <- fit$parameters[2]
  return(c(xmin, alpha))
}

fit_truncated_pareto <- function(step_lengths) {
  
  # Performs an ML fit of the truncated Pareto distribution to the data
  
  # Arguments:
  # step_lengths: Vector containing the individual step lengths
  
  # Returns:
  # xmin: Estimate of the lower bound of the distribution
  # xmax: Estimate of the upper bound of the distribution
  # mu_hat: Estimate of the exponent of the distribution
  
  ##################################
  
  xmin <- min(step_lengths)
  xmax <- max(step_lengths)
  LogLikelihood <- function(mu) return(length(steps_truncated) * log(mu / (xmin**(-mu)-xmax**(-mu))) - (mu+1)*sum(log(steps_truncated)))
  mu_hat <- optimize(LogLikelihood, c(0,4), maximum = T)$maximum
  return(c(xmin, xmax, mu_hat))
}