#environment setup
#Load Packages
#install.packages("dplyr")
library(dplyr)

# read data

test_X <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
test_y <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
test_sub <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))

train_X <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
train_y <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
train_sub <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))

# Row bind for the test and train data sets and the filter for the mean
#combined_x <- rbind(test_X,test

#Column Bind
test <- cbind(test_X,test_y,test_sub)
train <- cbind(train_X,train_y,train_sub)
#Row Bind for combining test and train datasets
com_data <- rbind(test,train)

# Reading the column names 
#colnames(com_data) <- read.csv(UCI HAR Dataset/fetures.txt)
cnames <-tbl_df(read.table("UCI HAR Dataset/features.txt")) %>% select(V2)  %>% t

# Adding the reminding column names
cn<- cbind(cnames,"activity_num","subject")

# Assigning the column names to the dataset
colnames(com_data)<-cn

# Subsetting column with "mean" and "std" in them 
mean1 <- com_data[,grepl("mean", colnames(com_data))]
std1 <- com_data[,grepl("std", colnames(com_data))]
sub_act <- com_data[c(562,563)]
subset_data <- cbind(mean1,std1,sub_act)

# Read Activty Meta data and assign the right column names
activty_names <-  tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))
colnames(activty_names)<- c("activity_num", "activity_desc")

# Labeling the activity
subset_data_lab <- inner_join(subset_data,activty_names) 
subset_data_lab <- subset_data_lab[-c(80)]
by_act_sub<- group_by(subset_data_lab,activity_desc, subject) 
final_tdy_dset <- summarise_each(by_act_sub,funs(mean))

write.table(final_tdy_dset, "final_tdy_dset1.txt", row.name=FALSE)

