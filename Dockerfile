FROM node:22-alpine

WORKDIR /app

# Copy package files
COPY node/package.json ./

# Copy source code
COPY node/ ./

CMD ["node", "src/main.js"]