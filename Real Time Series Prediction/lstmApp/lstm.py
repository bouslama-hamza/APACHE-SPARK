from keras.models import load_model
from sklearn.preprocessing import MinMaxScaler
import pandas as pd
from csv import writer

# load the LSTM model
model = load_model('lstmApp/models/LSTM_model.h5')
n_input = 12
n_features = 1

def make_whole_prediction():

    df = pd.read_csv('lstmApp/static/data/data_new.csv' ,index_col = 'date' , parse_dates=True)
    first_data = df[(len(df)-12):]
    scaler = MinMaxScaler().fit(first_data)
    first_data = scaler.transform(first_data)[-n_input:]
    last_train_data = first_data[-12:]
    last_train_data = last_train_data.reshape(
        (1 , n_input , n_features)
    )
    prediction = scaler.inverse_transform(
        model.predict(last_train_data)
    )
    prediction = round(prediction[0][0])
    last_date = df.index[-1]
    last_date = last_date + pd.DateOffset(months=1)
    last_date = last_date.strftime('%Y-%m-%d')

    with open('lstmApp/static/data/data_new.csv' , 'a') as file:
        object_write = writer(file)
        object_write.writerow([last_date , prediction])
        file.close()