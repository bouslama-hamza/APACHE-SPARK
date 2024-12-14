import streamlit as st
import pandas as pd
import time
from keras.models import load_model
from keras.losses import MeanSquaredError

# Import the function from the functions.prediction module
from functions.prediction import make_prediction_and_update


# Load the LSTM model
model = load_model('../model/lstm_forcasting_model.h5', compile=False)  
model.compile(optimizer='adam', loss=MeanSquaredError())


# Streamlit app layout
st.set_page_config(page_title="Sales Prediction Dashboard", layout="wide")


# Title and Description
st.title("Sales Forecasting Dashboard")
st.markdown("""
This dashboard shows the historical sales data and provides real-time sales predictions using an LSTM model
""")


# Display the initial metrics
df = pd.read_csv('../data/data.csv', index_col='date', parse_dates=True)

# Create two columns to display metrics (Sum of sales, costs, etc.)
col1, col2, col3, col4 = st.columns(4)

# Display sum metrics for columns
col1.metric(label="Total Sales ($)", value=f"${df['total sale_dollars'].sum():,.2f}")
col2.metric(label="Total State Bottle Cost ($)", value=f"${df['total state_bottle_cost'].sum():,.2f}")
col3.metric(label="Total Volume Sold (liters)", value=f"{df['total volume_sold_liters'].sum():,.0f}")
col4.metric(label="Average Sales per Month ($)", value=f"${df['total sale_dollars'].mean():,.2f}")

# Add an animated prediction graph
st.subheader("Real-time Sales Prediction")

# Initial plot for historical data
chart_placeholder = st.empty()
chart_placeholder.line_chart(df['total bottles_sold'])

# Real-time prediction updates
prediction_container = st.empty()
predictions = []


for _ in range(10):  # Run prediction for 10 iterations (10 * 3 seconds)
    df, predicted_value, prediction_date = make_prediction_and_update(model , df)

    # Append the new prediction to the list and plot it
    predictions.append(predicted_value)

    # Update the line chart dynamically
    chart_placeholder.line_chart(df['total bottles_sold'], width=800, height=500)

    # Wait 3 seconds before the next prediction update
    time.sleep(3)
