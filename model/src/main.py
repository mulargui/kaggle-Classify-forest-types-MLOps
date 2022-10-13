import sys

#create a data object and prepare it to train the model
from data import Data
d = Data('/data/train.csv')
d.data_engineering()
if d.validationError:
    print('error in validation')
    sys.exit(-1)
d.split(0.2)

#create the model object, train it and save it
from model import Model
m = Model()
m.train(d.x_train, d.y_train, d.x_test, d.y_test)
m.save()
