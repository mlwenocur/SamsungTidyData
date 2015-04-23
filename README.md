##### Overview of Samsung accelerometer Data Files
The UCI data is not in tidy form since the data are split into two separate 
groups of files: X_train.txt, y_train.txt, subject_train.txt for the training file, and X_test.txt, y_test.txt, subject_test.txt respectively
for the test data.

Moreover each observation is split across three files: the sensor data file in X_***.txt, the activity type in the y_***.txt, and the participant identifier in the subject_***.txt.

Also the sensor data lacks column labels which must be inferred by mapping
their position by to the corresponding line in activity_labels.txt.

Moreover we are requested to reduce the number of variables by removing all variables that are not the mean or std deviation of a given measurement computed over a given observational window