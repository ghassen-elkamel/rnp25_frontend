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

# Build the app for the web 
RUN flutter build web --release --dart-define=PROTOCOL=https --dart-define=HOST=api.rnp25.com

# Create a smaller image with just the built web files
FROM alpine:3.14

# Create directory for the web files
RUN mkdir -p /app/web

# Copy the build output from the build stage
COPY --from=build-env /app/build/web /app/web

# Set the working directory
WORKDIR /app

# This container is meant to be used as a build artifact
# The /app/web directory contains the built web app that can be copied to your existing nginx
CMD ["echo", "Flutter web app built successfully. Copy the contents of /app/web to your nginx html directory."] 