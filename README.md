# Walkthrough: Deploying a Hugging Face Model as a Worker Node on the Allora Network

This guide provides a step-by-step process to deploy a Hugging Face model as a Worker Node within the [Allora Network](https://docs.allora.network/). By following these instructions, you will be able to integrate and run models from Hugging Face, contributing to the Allora decentralized machine intelligence ecosystem.

See [complete walkthrough and instructions here](https://docs.allora.network/devs/workers/walkthroughs/walkthrough-hugging-face-worker).

---
## Components

- **Worker**: The node that publishes inferences to the Allora chain.
- **Inference**: A container that conducts inferences, maintains the model state, and responds to internal inference requests via a Flask application. This node operates with a basic linear regression model for price predictions.


### Steps to Setup

1. **Clone the Repository**
 
     ```sh
    git clone https://github.com/Kitbodee4/allora-huggingface-walkthrough.git
    ```
     

2. **run script**
    
   
    ```sh
    chmod +x setup.sh
    ./setup.sh
    ```
   
3. **Enter  Wallet_Name & Seed_phase**
    During the setup, you will be prompted to enter your wallet name and seed phrase. Make sure you have these ready.
    
## Testing Inference Only

This setup allows you to develop your model without the need to bring up the offchain worker. To test the inference model only:

1. Run the following command to start the inference node:
    ```sh
    docker compose up --build inference
    ```

2. Send requests to the inference model. For example, request ETH price inferences:
    
    ```sh
    curl http://127.0.0.1:8000/inference/ETH
    ```
    Expected response:
    ```json
    {"value":"2564.021586281073"}
    ```

