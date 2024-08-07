# This Dockerfile is used to build a multi-stage Docker image for a Node.js application
# and an Nginx server. The stages are: base, dependencies, development, and production.

ARG NODE_VERSION=19.6

# Stage 1: Base image for Node.js
# - Sets the working directory to /usr/src/app
FROM node:${NODE_VERSION}-alpine AS base
WORKDIR /usr/src/app

# Stage 2: Install dependencies
# - Uses the baseImage as the starting point
# - Copies package.json and package-lock.json (if exists) to the working directory
# - Installs project dependencies using npm
# - Utilizes Docker build cache for faster builds
FROM base AS dependencies
COPY package*.json ./
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm install

# Stage 3: Build the application
# - Uses the dependencies stage as the starting point
# - Copies the entire project to the working directory
# - Runs the build script
FROM dependencies AS development
COPY . .
RUN npm run build

# Stage 4: Nginx production
# - Copies the Nginx configuration file
# - Copies the built application from the development stage
FROM nginx:stable-alpine-perl AS production
COPY --link nginx.conf /etc/nginx/config.d/default.conf
COPY --link --from=development usr/src/app/dist /usr/share/nginx/html

# - Exposes port 80
EXPOSE 80