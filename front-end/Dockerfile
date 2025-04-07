# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production image
FROM node:20-alpine

WORKDIR /app
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

RUN node -e "require.resolve('next/dist/bin/next')" || exit 1

ENV NODE_ENV=production
EXPOSE 3000
CMD ["npm", "start"]


# # Stage 1: Build the application
# FROM node:20-alpine AS builder

# WORKDIR /app

# # Copy package files first for better layer caching
# COPY package.json package-lock.json ./

# # Install dependencies (including devDependencies for build)
# RUN npm ci && npm cache clean --force

# # Copy the rest of the application
# COPY . .

# # Build the Next.js app
# RUN npm run build

# # Preserve next binary while pruning other dev dependencies
# RUN npm prune --production && \
#     npm install next --production --no-save

# # Stage 2: Production image
# FROM node:20-alpine

# WORKDIR /app

# # Copy necessary files from builder
# COPY --from=builder /app/package.json ./
# COPY --from=builder /app/.next ./.next
# COPY --from=builder /app/public ./public
# COPY --from=builder /app/node_modules ./node_modules

# # Verify next exists (safety check)
# RUN ls node_modules/.bin/next || { echo "Next.js binary missing!"; exit 1; }

# # Environment variables
# ENV NODE_ENV=production
# ENV NEXT_TELEMETRY_DISABLED=1
# EXPOSE 3000

# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD wget --quiet --tries=1 --spider http://localhost:3000/api/health || exit 1

# # Start the application (your preferred method)
# CMD ["npm", "start"]

# # Stage 1: Build the application
# FROM node:20-alpine AS builder

# # Set working directory
# WORKDIR /app

# # Copy package files first for better layer caching
# COPY package.json package-lock.json ./

# # Install dependencies (including devDependencies for build)
# RUN npm ci && npm cache clean --force

# # Copy the rest of the application
# COPY . .

# # Build the Next.js app
# RUN npm run build

# # Prune dev dependencies after build
# RUN npm prune --production

# # Stage 2: Production image
# FROM node:20-alpine

# WORKDIR /app

# # Copy necessary files from builder
# COPY --from=builder /app/package.json ./
# COPY --from=builder /app/.next ./.next
# COPY --from=builder /app/public ./public
# COPY --from=builder /app/node_modules ./node_modules

# # Environment variables
# ENV NODE_ENV=production
# ENV NEXT_TELEMETRY_DISABLED=1

# # Expose the port
# EXPOSE 3000

# # Health check
# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD wget --quiet --tries=1 --spider http://localhost:3000/api/health || exit 1

# # Start the application
# CMD ["npm", "start"]