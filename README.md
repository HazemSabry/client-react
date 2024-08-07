Sure! Here's a detailed documentation of your Dockerfile:

### Dockerfile Breakdown

#### 1. **Set Node.js Version**

```dockerfile
ARG NODE_VERSION=19.6
```

- Defines a build-time variable `NODE_VERSION` with the value `19.6`.

#### 2. **Base Image**

```dockerfile
FROM node:${NODE_VERSION}-alpine AS base
WORKDIR /usr/src/app
```

- Uses the Node.js Alpine image based on the specified `NODE_VERSION`.
- Sets the working directory to `/usr/src/app`.

#### 3. **Dependencies Stage**

```dockerfile
FROM base AS dependencies
COPY package*.json ./
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm install
```

- Uses the `base` stage as the base.
- Copies `package.json` and `package-lock.json` (if present) to the working directory.
- Utilizes a cache mount for the npm cache to speed up subsequent builds.
- Sets the npm cache directory and installs dependencies.

#### 4. **Development Stage**

```dockerfile
FROM dependencies AS development
COPY . .
RUN npm run build
```

- Uses the `dependencies` stage as the base.
- Copies the entire application source code to the working directory.
- Runs the build script to compile the application.

#### 5. **Production Stage**

```dockerfile
FROM nginx:stable-alpine-perl AS production
COPY --link nginx.config /etc/nginx/config.d/default.conf
COPY --link --from=development usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
```

- Uses the Nginx stable Alpine image with Perl support as the base.
- Copies the Nginx configuration file to the appropriate directory.
- Copies the built application from the `development` stage to the Nginx HTML directory.
- Exposes port `80` for the application.

### Summary

This Dockerfile is structured to create a multi-stage build for a Node.js application that is served by Nginx. It optimizes the build process by caching dependencies and separating development and production stages. The use of Nginx ensures efficient serving of the built application.

If you have any questions or need further assistance, feel free to ask!

### Try My Docker Container To See It Actually Work

Pull Image From My Docker Hub Repository

```bash
docker pull hazem196/client-react
```
