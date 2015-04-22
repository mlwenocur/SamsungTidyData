library(data.table)
library(dplyr)

LoadAndDecorateTable <- function (tableFile, selectedIndices, labels){
    newTable <- read.table(tableFile, colClasses="numeric")
    filteredTable <- select(newTable, selectedIndices)
    names(filteredTable) <- labels
    return(filteredTable)
}

GetSelectedFeaturesTable <- function(featFile ='features.txt'){
    features <- readLines(featFile)
    selectionIndex <- grep('mean|std', features)
    selectedFeatures <- features[selectionIndex]
    selectedFeatures <- gsub('\\(\\)', '', selectedFeatures)
    selectedFeatures <- gsub('[0-9 ]+', '', selectedFeatures)
    return(data.frame(index = selectionIndex, labels = selectedFeatures))
}

AddDescriptors <- function(targTable, subjFile, activFile){
        subjIndicators <- readLines(subjFile)
        activType <- readLines(activFile)
        endTable <- data.frame(Participant = subjIndicators, 
                               Activity= activType)
        endTable <- mutate(endTable, Partic = sprintf("partic_%02d",endTable$Participant))
        prefTable <- RenameActivityValues(endTable)
        prefTable <- mutate(prefTable, Participant_Activity = paste0(prefTable$Partic, "_", prefTable$Activity)) %>%
                     select(Participant_Activity)
        
        cbind(prefTable, targTable)
}

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

# For each performance measure this routine computes its average 
# for each combination of  participants and activities.

# The approach to averaging wa suggested in a stackoverflow. discussion.
# http://tinyurl.com/kq9xg9u 
CreateCondAvgsAndCombine <- function(tidyData){
    tidyDataTable <- data.table(tidyData)
    tidyDataTable <- tidyDataTable[, lapply(.SD, mean), by=Participant_Activity]
    return (tidyDataTable)
}
