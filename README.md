##### Description of run_analysis.R script file
The topmost function is *GenerateAveragedTidySet* which calls *GenRawTidyDataSet*
to generate an interim tidy table consisting of all the mean and std features. It then calls *ComputeTidySetWithAvgs* to generate the final tidy
table. Each of these routines and their helper functions are described
in detail.


The calling structure is given below where asterisks (ie, \*) are used to
denote that a function is self-contained.

*GenerateAveragedTidySet* ***depends on***  
  -  *GenRawTidyDataSet*    
  -  \**ComputeTidySetWithAvgs*

*GenRawTidyDataSet* depends on:  
  - *GenerateTidyDataSubset*

*GenerateTidyDataSubset* depends on:  
  - \**GetSelectedFeaturesTable*  
  - \**LoadAndDecorateTable*  
  - *AddDescriptors*

*AddDescriptors* depends on:  
 - \**RenameActivityValues*
###### Descriptions of component functions
*LoadAndDecorateTable* is used to create a table of the performance data that consists of only those measurements that are either means or standard deviations. It also labels them the labels indicated by the  "features.txt" file.

*GetSelectedFeaturesTable* creates a two columned data.table whose first column gives the indices of the desired features, and who second column are the slightly transformed feature names.

*AddDescriptors*  creates prefixTab, table that is used as prefix column 
 to the feature measurement columns. prefixTab consists two columns labeled
 Subject, Activity respectively, corresponding to the subject and activity 
 being measured. 

*RenameActivityValues* converts integer activity labels to descriptive labels given in the "activity_labels.txt". The activity labels are modified from all capitals to capitalized forms.

*GenerateTidyDataSubset* generates tidied sub-tables depending on string parameter that indicates whether it should be the training data or test data. It employs *LoadAndDecorateTable* and *AddDescriptors* to do the heavy lifting.

*GenRawTidyDataSet* calls *GenerateTidyDataSubset* twice and row binds the two sub-tables together to produce the total intermediate tidy data table.

*ComputeTidySetWithAvgs* computes for each feature, its average over each combination of participants and activities.

*GenerateAveragedTidySet* is the topmost function that generates the tidy set whose values consist of the averages for each of the 180 distinct groupings of subject and activity.




##### Overview of Samsung accelerometer Data Files
The UCI data is not in tidy form since the data are split into two separate groups of files: X\_train.txt, y\_train.txt, subject\_train.txt for the training data, and X\_test.txt, y\_test.txt, subject\_test.txt respectively for the test data.

Moreover each observation is split across three files: the sensor data file in X\_\*\*\*.txt, the activity type in the y\_\*\*\*.txt, and the participant identifier in the subject\_\*\*\*.txt.

Also the sensor data lacks column labels which must be deduced by mapping their positions to the corresponding line in activity_labels.txt.

Additionally, we are required to reduce the number of variables by removing all variables that are not the mean or std deviation of a given measurement computed over a given observational window.




