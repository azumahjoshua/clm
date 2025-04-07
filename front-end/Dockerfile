# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only package files to install dependencies first (better caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# Remove devDependencies after build
RUN npm prune --production

# Stage 2: Production image
FROM node:20-alpine

WORKDIR /app

# Copy essential files from builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000

# Start the production server
CMD ["npm", "start"]