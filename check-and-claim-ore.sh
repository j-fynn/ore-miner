#!/bin/bash

# Define your RPC URL
RPC_URL="your_rpc_url_here"

# Function to check unclaimed Ore balance
Check_OreBalance() {
    echo "Checking the unclaimed Ore balance..."
    balanceOutput=$(ore --keypair "$HOME/.config/solana/id.json" rewards)
    echo "$balanceOutput"
}

# Function to claim Ore rewards
Claim_OreRewards() {
    echo "Claiming Ore rewards..."
    ore --keypair "$HOME/.config/solana/id.json" --rpc $RPC_URL claim
}

# Function to extract the unclaimed Ore amount from the output
Get_UnclaimedOreAmount() {
    local balanceOutput="$1"
    # Assuming the balance output contains a line like "Unclaimed Ore: 0.5"
    # You may need to adjust the grep/sed pattern based on the actual output format
    unclaimedOre=$(echo "$balanceOutput" | grep -oP 'Unclaimed Ore:\s+\K[0-9]*\.?[0-9]+')
    if [[ -n "$unclaimedOre" ]]; then
        echo "$unclaimedOre"
    else
        echo "0"
    fi
}

# Main loop
while true; do
    # Check Ore balance
    balance=$(Check_OreBalance)
    
    # Extract the unclaimed Ore amount
    unclaimedOre=$(Get_UnclaimedOreAmount "$balance")

    # Check if the unclaimed Ore is between 0.1 and 1
    if (( $(echo "$unclaimedOre >= 0.1" | bc -l) )) && (( $(echo "$unclaimedOre <= 1" | bc -l) )); then
        Claim_OreRewards
    else
        echo "No unclaimed Ore rewards in the range of 0.1 to 1. Checking again in 15 minutes..."
    fi
    
    # Add a delay of 15 minutes (900 seconds) before the next check
    sleep 900
done
