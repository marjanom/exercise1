# Stage 1: Build the Next.js application
FROM node:18 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install --omit=dev

# Copy the source code into the container
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Create a smaller image for running the application
FROM node:18-alpine AS runner

# Set the working directory in the container
WORKDIR /app

# Copy the production build from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

# Expose the port your application listens on (replace with your actual port)
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
