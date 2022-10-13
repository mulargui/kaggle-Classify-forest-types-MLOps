#constants
import constants

#avoid TF INFO messages about internal optimizations (This TensorFlow binary is optimized with ...)
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1' 

import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Dropout

class Model:
    NUM_EPOCS = 75
    MODEL_REGISTRY = '/model-registry/model/'

    #constructor
    def __init__(self):
        #here is the NN model
        self.model = Sequential()
        self.model.add(Dense(units = constants.NUM_FEATURES * 2/3, activation = 'relu', kernel_initializer = 'normal', input_dim = constants.NUM_FEATURES))
        self.model.add(Dense(units = constants.NUM_CLASSES, activation = 'softmax'))
        self.model.compile(loss = keras.losses.categorical_crossentropy,
            optimizer = 'Adam',
            metrics = ['accuracy'])

    #train the model
    def train(self, x_train, y_train, x_test, y_test):
        self.model.fit(x_train, y_train, validation_data = (x_test, y_test), epochs = self.NUM_EPOCS)
    
    #save the model
    def save(self):
        self.model.save(self.MODEL_REGISTRY)

    #import a model
    def load(self):
        self.model = tf.keras.models.load_model(self.MODEL_REGISTRY)

