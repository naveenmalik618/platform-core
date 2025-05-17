#!/bin/bash

# Prompt for DB_USERNAME
echo "Please enter your database username: "
read -s DB_USERNAME

# Check if username is entered
if [ -z "$DB_USERNAME" ]; then
  echo "❌ No username provided. Please provide the username."
  exit 1
fi

# Prompt for DB_PASSWORD securely
echo "Please enter your database password: "
read -s DB_PASSWORD

# Check if password is entered
if [ -z "$DB_PASSWORD" ]; then
  echo "❌ No password provided. Please provide the password."
  exit 1
fi

# enter_your_application_name
APP_NAME=

# enter_your_sb_schema
DB_SCHEMA=

PORT=8080
CONTAINER_NAME="$APP_NAME-container"
TAG="0.0.1"
SPRING_PROFILE="prod"
DB_URL="jdbc:mysql://host.docker.internal:3306/$DB_SCHEMA"

echo "🔄 Stopping and removing old container (if exists)..."
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

echo "🚧 Building Docker image with latest code..."
docker build -t $APP_NAME:$TAG .

if [ $? -ne 0 ]; then
  echo "❌ Docker build failed. Exiting."
  exit 1
fi

echo "🚀 Running container..."
docker run -d -p $PORT:8080 -p 5005:5005 -e SPRING_PROFILES_ACTIVE=$SPRING_PROFILE \
  -e SPRING_DATASOURCE_URL=$DB_URL \
  -e SPRING_DATASOURCE_USERNAME=$DB_USERNAME \
  -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWORD \
   --name $CONTAINER_NAME $APP_NAME:$TAG

echo "✅ Container started: $CONTAINER_NAME"

# Tail logs of the running container
echo "📜 Tailing logs for container $CONTAINER_NAME..."
docker logs -f $CONTAINER_NAME
exit 0