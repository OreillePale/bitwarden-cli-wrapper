FROM node:20-alpine

RUN apk add bash
RUN apk add wget

RUN npm install -g @bitwarden/cli

RUN apk add python3 py3-pip
RUN pip3 install --break-system-packages fastapi uvicorn requests

WORKDIR /

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY main.py /main.py

# Run the script with bash
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
