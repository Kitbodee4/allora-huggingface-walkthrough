from flask import Flask, Response
import requests
import json
import pandas as pd
import torch
from chronos import ChronosPipeline

# create our Flask app
app = Flask(__name__)

# define the Hugging Face model we will use
model_name = "amazon/chronos-t5-tiny"

def get_binance_url(token):
    base_url = "https://api.binance.com/api/v3/klines"
    token_pair_map = {
        'ETH': 'ETHUSDT',
        'SOL': 'SOLUSDT',
        'BTC': 'BTCUSDT',
        'BNB': 'BNBUSDT',
        'ARB': 'ARBUSDT'
    }
    
    token = token.upper()
    if token in token_pair_map:
        symbol = token_pair_map[token]
        url = f"{base_url}?symbol={symbol}&interval=1d&limit=30"
        return url
    else:
        raise ValueError("Unsupported token")

# define our endpoint
@app.route("/inference/<string:token>")
def get_inference(token):
    """Generate inference for given token."""
    try:
        # use a pipeline as a high-level helper
        pipeline = ChronosPipeline.from_pretrained(
            model_name,
            device_map="auto",
            torch_dtype=torch.bfloat16,
        )
    except Exception as e:
        return Response(json.dumps({"pipeline error": str(e)}), status=500, mimetype='application/json')

    try:
        # get the data from Binance
        url = get_binance_url(token)
    except ValueError as e:
        return Response(json.dumps({"error": str(e)}), status=400, mimetype='application/json')

    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        df = pd.DataFrame(data, columns=["timestamp", "open", "high", "low", "close", "volume", "close_time", "quote_asset_volume", "number_of_trades", "taker_buy_base_asset_volume", "taker_buy_quote_asset_volume", "ignore"])
        df["timestamp"] = pd.to_datetime(df["timestamp"], unit='ms')
        df = df[["timestamp", "close"]]  # Keep only date and close price
        df.columns = ["date", "price"]
        df = df[:-1] # removing today's price
        print(df.tail(5))
    else:
        return Response(json.dumps({"Failed to retrieve data from the API": str(response.text)}), 
                        status=response.status_code, 
                        mimetype='application/json')

    # define the context and the prediction length
    context = torch.tensor(df["price"].astype(float).values)
    prediction_length = 1

    try:
        forecast = pipeline.predict(context, prediction_length)  # shape [num_series, num_samples, prediction_length]
        print(forecast[0].mean().item()) # taking the mean of the forecasted prediction
        return Response(str(forecast[0].mean().item()), status=200)
    except Exception as e:
        return Response(json.dumps({"error": str(e)}), status=500, mimetype='application/json')

# run our Flask app
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8000, debug=True)
