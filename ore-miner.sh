#!/bin/bash

# Define your Solana RPC endpoint
DEFAULT_RPC_URL=""
# Define your Solana pubkey path
DEFAULT_KEY=""
# Define Solana gas fee
DEFAULT_FEE=
# Define how many CPU cores to use
DEFAULT_CORES=

# Set variables with defaults or override with arguments
RPC_URL=${1:-$DEFAULT_RPC_URL}
KEY=${2:-$DEFAULT_KEY}
FEE=${3:-$DEFAULT_FEE}
CORES=${4:-$DEFAULT_CORES}

# Construct the command string
COMMAND="ore --rpc $RPC_URL --keypair $KEY --priority-fee $FEE mine --cores $CORES"

# Infinite loop to keep trying the command
while true; do
    echo "Starting the process..."
    eval $COMMAND
    if [ $? -eq 0 ]; then
        break
    fi
    echo "Restarting in 15 to 30 seconds..."
    sleep $((15 + RANDOM % 16))  # Random sleep between 15 and 30 seconds
done
