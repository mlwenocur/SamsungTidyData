##### Description of run_analysis.R script file
The topmost function is *GenerateAveragedTidySet* which calls *GenRawTidyDataSet*
to generate an interim tidy table consisting of all the means and stds features. It then calls *ComputeTidySetWithAvgs* to generate the final tidy
table. Each of these routines and their helper functions are described
in detail.


The calling structure looks like this where asterisks (ie, \*) are used to
indicate that a function is a base function.

*GenerateAveragedTidySet* depends on:
  *GenRawTidyDataSet*, \*ComputeTidySetWithAvgs

*GenRawTidyDataSet* depends on:
  *GenerateTidyDataSubset*

*GenerateTidyDataSubset* depends on:
  \*GetSelectedFeaturesTable, \**LoadAndDecorateTable*, *AddDescriptors*

*AddDescriptors* depends on:
  \*RenameActivityValues

###### Descriptions of component functions
*LoadAndDecorateTable* is used to create a table of the performance data that consists of only those measurements that are either means or standard deviations. It also labels them the labels indicated by the  "features.txt" file.

*GetSelectedFeaturesTable* creates a two columned data.table whose first column gives the indices of the desired features, and who second column are the slightly transformed feature names.

*AddDescriptors* creates prefTab, table that is used as a prefix column to the performance measurement columns. prefTable consists one column labeled Participant_Activity whose values are a composition of the subject and  activity, eg, Partic_12_Standing is a trial where the 12-th participant was measured while standing.

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




##### Explanation of Experimental Data and Code Book

###### Overview of Experimental Data
Each subject was measured doing six distinct activities: Laying, Sitting, Standing, Walking, Walking_downstairs, and Walking_upstairs. Each observation row consists of various normalized statistical summaries of 128 sensor readings taken during during a 2.56 second interval. Each activity lasted for 2 minutes 26 seconds.

Our task is to compute the averages of each observation class (ie, for a specific subject doing a specific activity) over the entire activity.

The authors of the study created a condensed way of describing what each variable name indicates:

* t prefix indicates a feature measured in ***t***ime.
* f prefix indicates Fourier transformation of the 128 readings
* Jerk is the derivative of acceleration or more usually force.
* Acc infix indicates a measurement of acceleration.
* Gyro infix indicates that the measurement is that of angular and not translational.
* X, Y, Z and Mag infixes respectively indicate X, Y, Z dimensions and Mag the Euclidean magnitude of the X, Y, Z features.
* It is odd that they make three angular measurements since they must be linearly dependent (each angle defines a plane and any three planes are linearly dependent).
* The authors also fail to mention how they are normalizing the data to range between -1 and 1, and how they are smoothing the data to compute jerk and acceleration.

###### Code Book variables
The first column labeled Participant\_Activity marks which subject was performing the indicated activity. All other column labels inherit their meanings as explained in the features\_info.txt and README.txt files, the difference being that the postfix \_Avg indicates that the feature has been averaged over the entire 2.56 second window.
 
**Note** when selecting features I omitted the angle data which are defined in terms of window means. The reason for doing this is that the angle of two means is no longer a mean or standard deviation.

1. Participant\_Activity
2. tBodyAcc\_mean\_X\_Avg
3. tBodyAcc\_mean\_Y\_Avg
4. tBodyAcc\_mean\_Z\_Avg
5. tBodyAcc\_std\_X\_Avg
6. tBodyAcc\_std\_Y\_Avg
7. tBodyAcc\_std\_Z\_Avg
8. tGravityAcc\_mean\_X\_Avg
9. tGravityAcc\_mean\_Y\_Avg
10. tGravityAcc\_mean\_Z\_Avg
11. tGravityAcc\_std\_X\_Avg
12. tGravityAcc\_std\_Y\_Avg
13. tGravityAcc\_std\_Z\_Avg
14. tBodyAccJerk\_mean\_X\_Avg
15. tBodyAccJerk\_mean\_Y\_Avg
16. tBodyAccJerk\_mean\_Z\_Avg
17. tBodyAccJerk\_std\_X\_Avg
18. tBodyAccJerk\_std\_Y\_Avg
19. tBodyAccJerk\_std\_Z\_Avg
20. tBodyGyro\_mean\_X\_Avg
21. tBodyGyro\_mean\_Y\_Avg
22. tBodyGyro\_mean\_Z\_Avg
23. tBodyGyro\_std\_X\_Avg
24. tBodyGyro\_std\_Y\_Avg
25. tBodyGyro\_std\_Z\_Avg
26. tBodyGyroJerk\_mean\_X\_Avg
27. tBodyGyroJerk\_mean\_Y\_Avg
28. tBodyGyroJerk\_mean\_Z\_Avg
29. tBodyGyroJerk\_std\_X\_Avg
30. tBodyGyroJerk\_std\_Y\_Avg
31. tBodyGyroJerk\_std\_Z\_Avg
32. tBodyAccMag\_mean\_Avg
33. tBodyAccMag\_std\_Avg
34. tGravityAccMag\_mean\_Avg
35. tGravityAccMag\_std\_Avg
36. tBodyAccJerkMag\_mean\_Avg
37. tBodyAccJerkMag\_std\_Avg
38. tBodyGyroMag\_mean\_Avg
39. tBodyGyroMag\_std\_Avg
40. tBodyGyroJerkMag\_mean\_Avg
41. tBodyGyroJerkMag\_std\_Avg
42. fBodyAcc\_mean\_X\_Avg
43. fBodyAcc\_mean\_Y\_Avg
44. fBodyAcc\_mean\_Z\_Avg
45. fBodyAcc\_std\_X\_Avg
46. fBodyAcc\_std\_Y\_Avg
47. fBodyAcc\_std\_Z\_Avg
48. fBodyAcc\_meanFreq\_X\_Avg
49. fBodyAcc\_meanFreq\_Y\_Avg
50. fBodyAcc\_meanFreq\_Z\_Avg
51. fBodyAccJerk\_mean\_X\_Avg
52. fBodyAccJerk\_mean\_Y\_Avg
53. fBodyAccJerk\_mean\_Z\_Avg
54. fBodyAccJerk\_std\_X\_Avg
55. fBodyAccJerk\_std\_Y\_Avg
56. fBodyAccJerk\_std\_Z\_Avg
57. fBodyAccJerk\_meanFreq\_X\_Avg
58. fBodyAccJerk\_meanFreq\_Y\_Avg
59. fBodyAccJerk\_meanFreq\_Z\_Avg
60. fBodyGyro\_mean\_X\_Avg
61. fBodyGyro\_mean\_Y\_Avg
62. fBodyGyro\_mean\_Z\_Avg
63. fBodyGyro\_std\_X\_Avg
64. fBodyGyro\_std\_Y\_Avg
65. fBodyGyro\_std\_Z\_Avg
66. fBodyGyro\_meanFreq\_X\_Avg
67. fBodyGyro\_meanFreq\_Y\_Avg
68. fBodyGyro\_meanFreq\_Z\_Avg
69. fBodyAccMag\_mean\_Avg
70. fBodyAccMag\_std\_Avg
71. fBodyAccMag\_meanFreq\_Avg
72. fBodyBodyAccJerkMag\_mean\_Avg
73. fBodyBodyAccJerkMag\_std\_Avg
74. fBodyBodyAccJerkMag\_meanFreq\_Avg
75. fBodyBodyGyroMag\_mean\_Avg
76. fBodyBodyGyroMag\_std\_Avg
77. fBodyBodyGyroMag\_meanFreq\_Avg
78. fBodyBodyGyroJerkMag\_mean\_Avg
79. fBodyBodyGyroJerkMag\_std\_Avg
80. fBodyBodyGyroJerkMag\_meanFreq\_Avg