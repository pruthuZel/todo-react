FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies based on the lockfile for reproducible builds
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application source and build the production bundle
COPY . .
RUN npm run build

# Production image
FROM nginx:stable-alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 8080

# Use the default nginx startup command
CMD ["nginx", "-g", "daemon off;"]


