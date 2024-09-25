Flutter Dockerfile for Android CI

!!! Не скачивает build-tools 30.0.3 (только на MacOS M1):
Failed to install the following SDK components:
      build-tools;30.0.3 Android SDK Build-Tools 30.0.3
      
docker build -t flutter:latest ./     

docker run \
        --interactive \
        --tty \
        --rm \
        --hostname flutter \
        --entrypoint bash \
        --volume ./:/app \
        --workdir /app \
        flutter:latest
