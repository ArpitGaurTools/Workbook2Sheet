#R code to merge multiple workbooks in one sheet side-by-side
#Works well to merge n numbers of workbooks same number of columns and row names


#install packages if needed
install.packages(c("dplyr", "tidyr", "textshape", "xlsx"))

#Activate libraries
library(dplyr)
library(tidyr)
library(textshape)
library(xlsx)


#setwd()

#change file extensions as needed

myFiles<-list.files(pattern="\\.csv$")

#function to read and rename the headers with the file name as a prefix
#change file extension if needed

new_headers <- function(file) {
  data <- read.csv(file)
  filename <- gsub(".csv", "", file)
  data_with_prefix <- data %>% 
    rename_all(~paste0(filename, "_", .))
  return(data_with_prefix)
}

list_with_new_headers<- lapply(myFiles,new_headers)

merged_file<-as.data.frame(list_with_new_headers)

#for setting a specific column as the row name of dataframe replace the column number with x if 
merged_file<-column_to_rownames(merged_file, loc=1)

#replace NN to remove multiple columns from the dataframe containing a specific string
merged_file <- select(merged_file, -contains("fid"))
mergedfile<-select(merged_file, contains("mean"))

#save file as .xlx or .csv

write.csv(mergedfile, file="myfile2.csv",row.names=TRUE)

