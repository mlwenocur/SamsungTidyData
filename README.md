### SamsungTidyData script for tidying up Samsung accelerometer data from UCI


#### Overview of UCI Data Files
The UCI data is not in tidy form since each training observation is split across three files: the sensor data file in X_train.txt, the activity type in the y_train.txt, and the participant identifier in the subject_train.txt and correspondingly for the test data X_test.txt, y_test.txt and subject_test.txt.

Also the sensor data has no columnar labels but must be inferred by position by mapping them to the activity_labels.txt.

Moreover we are requested to reduce the number of variables by removing all variables that are not the mean or std deviation of a given measurement computed over a given observational window