FROM node:20-alpine

RUN apk add bash
RUN apk add wget

RUN npm install -g @bitwarden/cli

RUN apk add python3
RUN apk add py3-pip
RUN deactivate
RUN pip3 install fastapi uvicorn requests

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY main.py /main.py

# Run the script with bash
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
