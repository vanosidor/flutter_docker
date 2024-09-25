FROM ubuntu:24.10

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# download and install Android SDK
# https://developer.android.com/studio#command-line-tools-only
ARG ANDROID_SDK_VERSION=11076708
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm *tools*linux*.zip

RUN cd ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin && yes | ./sdkmanager --licenses
RUN cd ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin && ./sdkmanager "build-tools;34.0.0" "platform-tools" "platforms;android-34" "sources;android-34"

ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin"

ENV FLUTTER_VERSION='3.22.2'

RUN git clone \
        --branch="${FLUTTER_VERSION}" \
        --single-branch \
        --depth=1 \
            https://github.com/flutter/flutter.git /home/developer/flutter


ENV PATH="/home/developer/flutter/bin:/home/developer/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v