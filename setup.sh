#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print error messages
function error_exit {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call error_exit
trap 'error_exit $LINENO' ERR

# Prompt the user for input
echo "=========================="
echo "User Input"
echo "=========================="
read -p "Enter the address key name (e.g., test): " addressKeyName
read -p "Enter the seed phrase: " seedPhrase

# Step 1: Clone the Repository
echo "=========================="
echo "Cloning the repository..."
echo "=========================="
git clone https://github.com/Kitbodee4/allora-huggingface-walkthrough.git
cd allora-huggingface-walkthrough

# Step 2: Initialize Worker
echo "=========================="
echo "Initializing worker..."
echo "=========================="
chmod +x init.config
./init.config

# Step 3: Replace the content of config.json with the provided configuration
echo "=========================="
echo "Updating config.json..."
echo "=========================="
cat <<EOL > config.json
{
    "wallet": {
        "addressKeyName": "$addressKeyName",
        "addressRestoreMnemonic": "$seedPhrase",
        "alloraHomeDir": "/root/.allorad",
        "gas": "1000000",
        "gasAdjustment": 1.0,
        "nodeRpc": "https://allora-rpc.testnet-1.testnet.allora.network/",
        "maxRetries": 3,
        "delay": 3,
        "submitTx": false
    },
    "worker": [
        {
            "topicId": 1,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 2,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 7,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 3,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 10,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "BTC"
            }
        },
        {
            "topicId": 4,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 8,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "BTC"
            }
        },
        {
            "topicId": 5,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 9,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "SOL"
            }
        },
        {
            "topicId": 6,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 10,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "SOL"
            }
        },
        {
            "topicId": 7,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 7,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 8,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 9,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "BNB"
            }
        },
        {
            "topicId": 9,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 12,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ARB"
            }
        }
    ]
}
EOL

# Step 4: Build and run Docker containers
echo "=========================="
echo "Building and running Docker containers..."
echo "=========================="
docker compose up build
docker compose up -d

# Check if the previous command was successful
if [ $? -ne 0 ]; then
    echo "Docker Compose failed to build and start containers."
    exit 1
fi

echo "=========================="
echo "Setup and Docker containers are up and running!"
echo "=========================="
