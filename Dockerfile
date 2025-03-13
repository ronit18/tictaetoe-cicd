# Use Node.js as the build stage
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker cache
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the Vite application
RUN npm run build

# Use Nginx to serve the built files
FROM nginx:alpine AS runner

# Copy the build output to Nginx's web root
COPY --from=builder /app/dist /usr/share/nginx/html


# Expose the default Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]