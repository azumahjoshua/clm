# Stage 1: Install dependencies
FROM node:20-alpine AS deps
WORKDIR /app

# Install Netcat, Curl (optional debugging tools)
RUN apk add --no-cache netcat-openbsd curl

# Copy only the package files first for efficient caching
COPY package.json package-lock.json ./

# Install dependencies without dev dependencies
RUN npm ci --omit=dev

# Stage 2: Build the Next.js app
FROM node:20-alpine AS builder
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy the rest of the application
COPY . .

# Set production environment
ENV NODE_ENV=production

# Build Next.js app
RUN npm run build && rm -rf node_modules

# Stage 3: Run the Next.js app (Final lightweight image)
FROM node:20-alpine AS runner
WORKDIR /app

# Copy only necessary files from builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=deps /app/node_modules ./node_modules 

# Expose Next.js port
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]