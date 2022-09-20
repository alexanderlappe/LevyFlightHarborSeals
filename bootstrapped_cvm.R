bootstrapped_cvm <- function(step_lengths, num_samples=10000) {
  
  # Computes the bootstrapped Cramer-von Mises goodness-of-fit test.
  
  # Arguments:
  # step_lengths: Vector of individual steps
  # num_samples: Number of samples to draw for the bootstrapping
  
  # Returns:
  # p: The bootstrapped p-value for the CVM test of the original sample
  
  ##################################
  
  # Statistics of the original samples
  a <- min(step_lengths)
  b <- max(step_lengths)
  at <- alpha_truncated
  n = length(step_lengths)

  # Calculate CVM statistic for the original sample
  cvm_original <- cvm.test(steps_truncated, null = 'ptruncpareto', lower = xmin, upper = xmax, shape = alpha_truncated, estimated = F)$statistic 
  
  
  cvm_bootstrap <- c()
  # Loop over number of bootstrapped samples
  for (i in 1:num_samples) {
    # Generate random sample based on original parameters
    sample <- rtruncpareto(n, a, b, at)
    a_sample <- min(sample)
    b_sample <- max(sample)
    LogLikelihood_boot <- function(mu) return(length(sample) * log(mu / (a_sample**(-mu)-b_sample**(-mu))) - (mu+1)*sum(log(sample)))
    alpha_bootstrap <- optimize(LogLikelihood_boot, c(0,4), maximum = T)$maximum
    # Compute CVM statistic of the sample
    omega <- cvm.test(sample, null = 'ptruncpareto', lower = a_sample, upper = b_sample, shape = alpha_bootstrap, estimated = F)$statistic
    cvm_bootstrap <- c(cvm_bootstrap, omega)
  }
  # Compute fraction of bootstrapped samples yielding a higher CVM-statistic than the original sample
  p = length(cvm_bootstrap[cvm_bootstrap > cvm_original]) / length(cvm_bootstrap)
  return(p)
}