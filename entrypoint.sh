#!/bin/bash
set -e

# Configure BW CLI server
bw config server "${BW_HOST}"

# Log in
if [ -n "$BW_CLIENTID" ] && [ -n "$BW_CLIENTSECRET" ]; then
    echo "Using API key to log in"
    bw login --apikey --raw
else
    echo "Using username/password to log in"
    bw login "${BW_USER}" --passwordenv BW_PASSWORD --raw
fi

# Unlock vault and export BW_SESSION
export BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)

# Optional: check session
bw unlock --check

echo "Starting FastAPI on port 8088..."
exec uvicorn main:app --host 0.0.0.0 --port 8088