plot_distribution <- function(step_lengths, xmin, xmax, alpha, alpha_truncated, verbose=T,
                              ylabel=F, cutoff=F, animal=F, pvalue=F, N=F, title=F) {
  
  # Plots the empirical distribution function of the tail together with 
  # the theoretical Pareto and truncated Pareto distributions fitted by
  # Maximum Likelihood

  # Arguments:
  # step_lengths: Vector containing the individual step lengths
  # xmin: Lower bound of the (truncated) Pareto distribution
  # xmax: Upper bound of the truncated Pareto distribution
  # alpha: Exponent of the pareto distribution
  # alpha_truncated: Exponent of the truncated Pareto distribution
  # verbose: Controls level of detail. If set to False, a small plot is produced
  # that can be used to put all animals in one plot using ggarrange.
  # All other arguments are used only if verbose = False
  
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

  if (verbose == TRUE) {
    # Plot with Legend for presentation
    plot_object <- ggplot(data = plot_data, aes(x=log(x_range))) + 
      geom_line(aes(y=log(trunc_pareto), color = "Truncated Pareto")) + 
      geom_line(aes(y=log(pareto), color = "Pareto")) + 
      scale_colour_manual("", breaks = c("Truncated Pareto", "Pareto"), values = c("green3", "blue")) + 
      theme_bw() + 
      theme(legend.position=c(0.2,0.15), axis.title.x = element_text(size=15), axis.title.y = element_text(size=15), title = element_text(size=15), text = element_text(size=20)) + 
      geom_point(data = empirical_data, aes(x = log(x), y = log(y)), shape = 1) + 
      xlab("Step length")  + 
      ylab("Fraction of steps greater than x") + 
      ggtitle("Empirical Survivor function (log-log-scale)")
  }
  else {
    plot_object <- ggplot(data = plot_data, aes(x=log(x_range)), height=15) + 
      geom_line(aes(y=log(trunc_pareto)), size=0.33) + 
      geom_point(data = empirical_data, aes(x = log(x), y = log(y)), shape = 1, size=0.33) +
      theme_bw() +
      theme(axis.line = element_line(colour = "black", size=0.33),
            axis.ticks = element_line(size=0.1),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank(),
            axis.title = element_blank(),
            plot.title=element_text(size=10))
    if (ylabel == F) {
      plot_object <- plot_object + theme(axis.text.y = element_blank())
    }
    
    lower_annotation <- glue(
      "*p* = {pvalue}<br>&alpha; = {round(alpha_truncated, 3)}<br>*N* = {N}"
      )
    plot_object <- plot_object +
      annotate(geom="richtext", x=cutoff, y=-Inf,
               label=lower_annotation,
               size=3, parse=T, fill = NA, label.colour = NA,
               hjust=0, vjust=0, lineheight=0.7, size=10,
               label.padding = grid::unit(1.5, "pt")) +
      annotate(geom="text", x=Inf, y=Inf,
               label=animal,
               size=3,
               hjust=1, vjust=1, lineheight=0.8) +
      ggtitle(title)
  }
  return(plot_object)

}