from sklearn.preprocessing import MinMaxScaler
import pandas as pd
from csv import writer

# Function to make a prediction and update the dataset
def make_prediction_and_update(model , df):
    n_input = 12
    n_features = 1

    # Prepare data (same as in your code)
    scaler = MinMaxScaler()
    scaled_data = scaler.fit_transform(df[['total bottles_sold']])

    # Get the last 12 months of data
    last_data = scaled_data[-n_input:].reshape((1, n_input, n_features))

    # Predict the next month's sales
    prediction = model.predict(last_data)[0][0]
    prediction_rescaled = scaler.inverse_transform([[prediction]])[0][0]

    # Append the prediction to the dataframe
    last_date = df.index[-1] + pd.DateOffset(months=1)
    prediction_date = last_date.strftime('%Y-%m-%d')

    new_data = pd.DataFrame([[prediction_rescaled]], columns=['total bottles_sold'], index=[last_date])
    df = pd.concat([df, new_data])  # Update the dataframe

    # Save the updated dataframe to CSV (appending the new prediction)
    with open('../data/data_new.csv', 'a') as file:
        writer(file).writerow([prediction_date, prediction_rescaled])

    return df, prediction_rescaled, prediction_date