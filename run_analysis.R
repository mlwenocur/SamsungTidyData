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
        endTable <- mutate(endTable, Participant = paste0("participant_", as.character(endTable$Participant)))
        cbind(endTable, targTable)
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
    tidyDataSubset <- RenameActivityValues(finalTidyDataSubset)
}

GenerateTidyDataSet <- function(){
    tidyTrainingSet <- GenerateTidyDataSubset()
    tidyTestSet     <- GenerateTidyDataSubset('test')
    rbind(tidyTrainingSet, tidyTestSet)
}


CreateCondAvgsAndCombine <- function(tidyData){
    mut = data.table(select(tidyData, -Activity))
    mut <- mut[, lapply(.SD, mean), by=Participant]
    mut <- rename(mut, Condition_Var = Participant)

    nut <- data.table(select(tidyData, -Participant))
    nut <- nut[, lapply(.SD, mean), by = Activity]
    nut <- rename(nut, Condition_Var =  Activity)
    return (rbind(mut, nut))
}
