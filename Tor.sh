#!/bin/bash

# Start the Tor Browser
tor-browser-en.sh &

# Wait for the Tor Browser to start
sleep 30

# Set the Tor Control Port
TOR_CONTROL_PORT=9151

# Read the search description from the command line
read -p "Enter the description to search for .onion websites: " SEARCH_DESCRIPTION

# Generate a random port number for the SOCKS proxy
SOCKS_PROXY_PORT=$((RANDOM + 20000))

# Set the environment variable to use the SOCKS proxy
export SOCKS_SERVER="localhost:$SOCKS_PROXY_PORT"

# Launch the Tor Control Port proxy
tor --ControlPort $TOR_CONTROL_PORT --quiet &

# Wait for the Tor Control Port to start
sleep 5

# Function to execute Tor Control Port commands
execute_tor_command() {
  echo "$1" | nc localhost $TOR_CONTROL_PORT
}

# Authenticate with the Tor Control Port
execute_tor_command "AUTHENTICATE"

# Search for .onion websites using the Tor Control Port
onion_list=$(execute_tor_command "ECHO \"SEARCH $SEARCH_DESCRIPTION\"")

# Display the list of .onion websites
echo "$onion_list"

# Stop the Tor Browser process
killall -9 tor-browser-en.sh

# Stop the Tor Control Port proxy
killall -9 tor