FROM node:20-alpine

RUN apk add bash
RUN apk add wget

RUN npm install -g @bitwarden/cli

RUN apk add python3
RUN python -m pip install "fastapi[standard]"

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY main.py /main.py

# Run the script with bash
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
