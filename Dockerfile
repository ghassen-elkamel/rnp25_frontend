# Build stage
FROM ubuntu:20.04 AS build-env

# Install dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa && \
    apt-get clean

# Download specific Flutter version (3.27.1)
RUN git clone -b 3.27.1 https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter config --enable-web

# Create app directory
RUN mkdir /app/
WORKDIR /app/

# Copy pubspec files
COPY pubspec.* ./

# Get Flutter dependencies
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Run flutter clean first to ensure a clean build
RUN flutter clean

# Get dependencies again after cleaning
RUN flutter pub get

# Build the app for the web
RUN flutter build web --release --dart-define=PROTOCOL=https --dart-define=HOST=api.rnp25.com

# Production stage
FROM nginx:1.21.1-alpine

# Copy the build output to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Configure nginx for SPA routing with no caching
RUN echo 'server { \
    listen 80; \
    server_name app.rnp25.com; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 