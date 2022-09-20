# Lévy flight movements of harbor seals (Phoca vitulina) at sea

This repo contains code to run the analysis performed in "Lévy flight movements of harbor seals (Phoca vitulina) at sea".

### Cloning And Opening The Repo
The script levy_flight_analysis.R outputs the relevant findings of the data analysis. After cloning the repo, open this script in RStudio. The code has not been tested on other IDEs,
and it is possible that issues with the working directory arise if not opened in RStudio. 

### Preparing The Analysis Settings
The only file that needs to be edited is levy_flight_analysis.R, in particular its first two lines: The path variable should be set to the excel file containing
the raw GPS data. The second line relates to the individual animal of interest. The variable should be set to a string corresponding to one of the sheets in the excel file.

### Running The Analysis
After setting the necessary parameters, simply run the script to obtain the analysis results. The other files only contain helper functions and need not be run individually.
