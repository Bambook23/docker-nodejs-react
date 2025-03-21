# Stage 1: building frontend

# Base image
FROM node:16.20.2-alpine3.18 AS builder

# Set working directory
WORKDIR /home/node/app

# Copy data from host
COPY ./ ./

# Install dependencies
RUN npm i

# Build frontend
RUN npm run build


# Stage 2: serving app

FROM node:16.20.2-alpine3.18

WORKDIR /home/node/app

# Copy package.json, server folder and static folder
COPY --from=builder /home/node/app/package.json ./
COPY --from=builder /home/node/app/src/server ./src/server
COPY --from=builder /home/node/app/static ./static

# Install only prod dependencies (express)
RUN npm install --omit=dev

# Expose port
EXPOSE 3000

# Start server
CMD ["npm", "start"]
