
#constants
import constants

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

class Data:
    #persist if we found any validation error
    validationError = False

    #constructor
    def __init__(self, source):
        #read the csv file in a pandas dataframe
        df = pd.read_csv(source)

        #validate the data source
        self.data_prevalidation(df)
 
        #split in features and labels
        self.y = df.Cover_Type
        self.x = df.drop(['Cover_Type'], axis=1)

    #data validation - pre
    def data_prevalidation(self, df):
        #validate no nans in the data set
        if df.isna().sum().sum():
            validationError = True

        #validate no nulls in the data set
        if df.isnull().sum().sum():
           validationError = True

    #data validation - post
    def data_postvalidation(self):
        #validate data - no rows with all zeros
        if not self.x[self.x.eq(0).all(1)].empty:
            validationError = True

    #data engineering
    def data_engineering(self):
        #remove the Id feature, not needed (it just enaumerates the samples)
        self.x = self.x.drop(['Id'], axis=1)

        #force all types to float
        self.x = self.x.astype(float)

        #normalize features
        #in the future it can be done more elegantly, for now just using the max min values of the data that we know
        #x['Elevation']=(x['Elevation']-x['Elevation'].min())/(x['Elevation'].max()-x['Elevation'].min())                             
        self.x['Elevation']=(self.x['Elevation']-1859)/(3858-1859)                             
        self.x['Aspect']=self.x['Aspect']/360                      
        self.x['Slope']=self.x['Slope']/66                      
        self.x['Horizontal_Distance_To_Hydrology']=self.x['Horizontal_Distance_To_Hydrology']/1397                      
        self.x['Vertical_Distance_To_Hydrology']=(self.x['Vertical_Distance_To_Hydrology']+173)/(601+173)                             
        self.x['Horizontal_Distance_To_Roadways']=self.x['Horizontal_Distance_To_Roadways']/7117                      
        self.x['Hillshade_9am']=self.x['Hillshade_9am']/254                      
        self.x['Hillshade_Noon']=self.x['Hillshade_Noon']/254                      
        self.x['Hillshade_3pm']=self.x['Hillshade_3pm']/254                      
        self.x['Horizontal_Distance_To_Fire_Points']=self.x['Horizontal_Distance_To_Fire_Points']/67173                      

        #run validation tests after transformations
        self.data_postvalidation()
    
        #convert the features dataframes to numpy arrays
        self.x = self.x.to_numpy()

        # convert the label to One Hot Encoding
        #to_categorical requires 0..6 instead of 1..7
        self.y -=1
        self.y = self.y.to_numpy()

        from tensorflow.keras.utils import to_categorical
        self.y = to_categorical(self.y, constants.NUM_CLASSES)

    #split in train and test sets 
    def split(self, percentage):
        from sklearn.model_selection import train_test_split
        self.x_train, self.x_test, self.y_train, self.y_test = train_test_split(self.x, self.y,test_size = percentage)
