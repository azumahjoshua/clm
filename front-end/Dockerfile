# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build
RUN npm prune --production

# Stage 2: Production image
FROM node:18-alpine

WORKDIR /app

# Install curl (for health check or debugging)
RUN apk add --no-cache curl

COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

RUN npm install --production --legacy-peer-deps

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000

CMD ["npm", "start"]

# # Stage 1: Build the application
# FROM node:18-alpine AS builder

# WORKDIR /app

# # Copy only package files to install dependencies first (better caching)
# COPY package.json package-lock.json ./
# RUN npm ci

# # Copy source code and build
# COPY . .
# RUN npm run build

# # Remove devDependencies after build
# RUN npm prune --production

# # Stage 2: Production image
# FROM node:18-alpine

# WORKDIR /app

# # Install curl (for health check or debugging)
# RUN apk add --no-cache curl

# # Copy essential files from builder stage
# COPY --from=builder /app/package.json ./
# COPY --from=builder /app/package-lock.json ./
# COPY --from=builder /app/.next ./.next
# COPY --from=builder /app/public ./public
# COPY --from=builder /app/node_modules ./node_modules

# # Ensure production dependencies are intact (optional if needed)
# RUN npm install --production --legacy-peer-deps

# ENV NODE_ENV=production
# ENV NEXT_TELEMETRY_DISABLED=1

# EXPOSE 3000

# # Start the production server
# CMD ["npm", "start"]