# -----------------------------
# Stage 1: Build React / Vite App
# -----------------------------
    FROM node:20-alpine AS builder
    WORKDIR /app
    
    COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
    RUN if [ -f package-lock.json ]; then npm ci; \
        elif [ -f pnpm-lock.yaml ]; then corepack enable && pnpm i --frozen-lockfile; \
        elif [ -f yarn.lock ]; then corepack enable && yarn install --frozen-lockfile; \
        else npm install; fi
    
    COPY . .
    RUN npm run build
    
    
    # -----------------------------
    # Stage 2: Runtime (NGINX)
    # -----------------------------
    FROM nginx:alpine
    
    # (Optional) Needed only if you want runtime env injection
    RUN apk add --no-cache nodejs npm \
        && npm install -g react-inject-env
    
    # Remove default nginx config
    RUN rm /etc/nginx/conf.d/default.conf
    
    # Copy custom nginx config
    COPY nginx /etc/nginx/conf.d
    
    # Copy built app
    WORKDIR /usr/share/nginx/html
    COPY --from=builder /app/dist .
    
    EXPOSE 8080
    
    CMD ["sh", "-c", "react-inject-env set -d . && nginx -g 'daemon off;'"]
    