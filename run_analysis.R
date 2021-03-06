# The topmost function is GenerateAveragedTidySet which calls GenRawTidyDataSet
# to generate an interim tidy table consisting of all the means and stds input
# data. It then calls ComputeTidySetWithAvgs to generate the final tidy
# table. Each of these routines and their helper functions are described
# in detail.


# The calling structure looks like this where asterisks (ie, *) are used to
# indicate that a function is self-contained.

# GenerateAveragedTidySet depends on:
#   GenRawTidyDataSet, *ComputeTidySetWithAvgs
#
# GenRawTidyDataSet depends on:
#   GenerateTidyDataSubset
#
# GenerateTidyDataSubset depends on:
#   *GetSelectedFeaturesTable, *LoadAndDecorateTable, AddDescriptors
#
# AddDescriptors depends on:
#   *RenameActivityValues
#
library(data.table)
library(dplyr)

# LoadAndDecorateTable is used to create a table of the performance data that 
# consists of only those measurements that are either means or standard
# deviations. It also labels them the labels indicated by the "features.txt"
# file.
LoadAndDecorateTable <- function (tableFile, selectedIndices, labels){
    newTable <- read.table(tableFile, colClasses="numeric")
    filteredTable <- select(newTable, selectedIndices)
    names(filteredTable) <- labels
    return(filteredTable)
}


# This function creates a two columned data.table whose first column
# gives the indices of the desired features, and who second column
# are the slightly transformed feature names.
GetSelectedFeaturesTable <- function(featFile ='features.txt'){
    features <- readLines(featFile)
    selectionIndex <- grep('mean|std', features) #grep return indices of matching lines.
    selectedFeatures <- features[selectionIndex]
    #Process features to remove line numbers, capitalize them and add postfix.
    selectedFeatures <- gsub('\\(\\)', '', selectedFeatures)
    selectedFeatures <- gsub('[0-9 ]+', '', selectedFeatures)
    selectedFeatures <- gsub('-', '_', selectedFeatures)
    selectedFeatures <- gsub('$', '_Avg', selectedFeatures)
    
    return(data.frame(index = selectionIndex, labels = selectedFeatures))
}

# AddDescriptors creates prefixTab, table that is used as prefix column 
# to the feature measurement columns. prefixTab consists two columns labeled
# Subject, Activity respectively.
AddDescriptors <- function(targTable, subjFile, activFile){
    subjIndicators <- readLines(subjFile)
    activType <- readLines(activFile)
    endTable <- data.frame(Subject = as.integer(subjIndicators), 
                           Activity= as.integer(activType))
    prefixTab <- mutate(endTable, Subject = sprintf("%02d",endTable$Subject))
    prefixTab <- RenameActivityValues(prefixTab)
    cbind(prefixTab, targTable)
 
}

# Helper routine that converts integer activity labels to descriptive labels 
# given in the "activity_labels.txt". The activity labels are modified from
# all capitals to capitalized forms.
RenameActivityValues <- function(targTable){
    al <- read.table('activity_labels.txt')
    al <- al %>% 
          mutate(V2 = tolower(al$V2)) %>%
          mutate(V2 = gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", V2, perl=TRUE))
    mutate(targTable, Activity = al$V2[targTable$Activity])   
}

GenerateTidyDataSubset <- function(dataSetType = 'training'){
    selFeatTable <- GetSelectedFeaturesTable()
    if (dataSetType == 'training') {
        xTableFile <- 'X_train.txt'
        activFile  <- 'y_train.txt'
        subjFile   <- 'subject_train.txt'
    }
    else {
        xTableFile <- 'X_test.txt'
        activFile  <- 'y_test.txt'
        subjFile   <- 'subject_test.txt'
    }
    tidyDataSubset <- LoadAndDecorateTable(xTableFile, selFeatTable$index, 
                                          selFeatTable$labels)
    finalTidyDataSubset <- AddDescriptors(tidyDataSubset, subjFile, activFile);
}

GenRawTidyDataSet <- function(){
    tidyTrainingSet <- GenerateTidyDataSubset()
    tidyTestSet     <- GenerateTidyDataSubset('test')
    rbind(tidyTrainingSet, tidyTestSet)
}

# This routine computes for each feature, its average 
# over each combination of subject and activities.

# The approach to averaging was suggested by a StackOverFlow discussion:
# http://tinyurl.com/kq9xg9u 
ComputeTidySetWithAvgs <- function(tidyData){
    tidyDataTable <- data.table(tidyData)
    tidyDataTable <- tidyDataTable[, lapply(.SD, mean), by=list(Subject, Activity)]
    tidySetWithAvgs <-arrange(tidyDataTable, Subject, Activity)
    return(tidySetWithAvgs)
}

# This is the topmost function that generates the tidy set whose
# values consist of the averages for each of the 180 distinct groupings
# of subject and activity.
GenerateAveragedTidySet <- function(){
    unaveragedTidySet <- GenRawTidyDataSet()
    averagedTidySet <- ComputeTidySetWithAvgs(unaveragedTidySet)
    return (averagedTidySet)
    
}