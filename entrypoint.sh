#!/bin/bash
set -e

# Configure BW CLI server
bw config server "${BW_HOST}"

# ---- LOGIN (STATEFUL — required for KDF) ----
if [ -n "$BW_CLIENTID" ] && [ -n "$BW_CLIENTSECRET" ]; then
    echo "Using API key to log in"
    bw login --apikey --passwordenv BW_PASSWORD
else
    echo "Using username/password to log in"
    bw login "${BW_USER}" --passwordenv BW_PASSWORD
fi

# ---- UNLOCK (stateless, export session) ----
export BW_SESSION="$(bw unlock --passwordenv BW_PASSWORD --raw)"

# Optional sanity check
bw unlock --check

echo "Starting FastAPI on port 8088..."
exec uvicorn main:app --host 0.0.0.0 --port 8088
