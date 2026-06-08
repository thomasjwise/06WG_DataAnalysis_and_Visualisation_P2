# Package Installation 

pkg_list <- c("tidyverse", 
              "Rcpp", 
              "stats",
              "broom",
              "dials",
              "infer",
              "modeldata",
              "parsnip",
              "yardstick",
              "tidymodels",
              "rpart",
              "rpart.plot")

missing_packages <- pkg_list[!pkg_list %in% rownames(installed.packages())]

if (length(missing_packages) > 0) {
  install.packages(missing_packages, quiet = TRUE)
  message("Missing Packages Installed")
} 

message("All Packages Installed")

# Establish Working Directory
# Identify working directory using the getwd() function, setting it to environmental variable WD
WD <- getwd()
# Check working directory is as expected (the folder of this github repo)
if (grepl("dataanalysis_and_visualisation", WD, ignore.case = TRUE)){
  message ("Working directory looks correct")
} else {
  stop ("Please review working directory")
}

