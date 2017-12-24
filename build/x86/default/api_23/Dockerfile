# Android Emulator
#
# VERSION    x86_default_api_23

FROM phusion/baseimage:0.9.22
MAINTAINER James Brink, brink.james@gmail.com

# Install needed system packages
RUN apt-get update \
      && apt-get dist-upgrade -y \
      && useradd -g users -s /bin/bash -d /home/android -m android \
      && apt-get install socat wget unzip openjdk-8-jdk-headless tightvncserver qemu -y \
			&& apt-get install automake cmake clang gettext libx11-dev git build-essential autopoint -y  \
			&& cd /tmp \
			&& git clone https://github.com/joewing/jwm.git \
			&& cd jwm \
			&& ./autogen.sh \
			&& ./configure \ 
			&& make \
			&& make install \
			&& cd / \
			&& rm -rf /tmp/jwm \
			&& apt-get remove automake cmake clang gettext libx11-dev git build-essential autopoint -y \
			&& apt-get autoremove -y \
      && rm -rf /var/lib/apt/lists/*

# Setup Android user and SDK
USER android
ENV ANDROID_HOME=/home/android/Android/Sdk
ENV USER=android
ENV PATH=${ANDROID_HOME}/emulator:/${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:$PATH
ENV DISPLAY=:1

ARG DEVICE_NAME="Nexus 5X"
ARG DEVICE_MODEL=Nexus_5X
ARG ARCH=x86
ARG IMAGE_TYPE=default
ARG API=23

# Download Android SDK
RUN mkdir -p ${ANDROID_HOME} \
      && cd ${ANDROID_HOME} \
      && chown android:users ${ANDROID_HOME} \
      && wget -q "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" -O android-sdk-tools.zip \
      && unzip -q android-sdk-tools.zip \
      && rm android-sdk-tools.zip \
      && yes | sdkmanager --licenses \
      && sdkmanager emulator platform-tools tools \
      && sdkmanager "system-images;android-${API};${IMAGE_TYPE};${ARCH}" "platforms;android-${API}" \
      && avdmanager create avd \
        -n ${DEVICE_MODEL}_API_${API} \
        -d "${DEVICE_NAME}" \
        -p /home/android/.android/avd/${DEVICE_MODEL}_API_${API} \
        -k "system-images;android-${API};${IMAGE_TYPE};${ARCH}" \
      && mkdir /home/android/.vnc \
      && echo "password" | vncpasswd -f > /home/android/.vnc/passwd \
      && chmod 600 /home/android/.vnc/passwd \
      && cd /home/android/ \
      && mkdir -p "/home/android/.config/Android Open Source Project/"

# Add our docker-assets.
ADD docker-assets/config.ini /home/android/.android/avd/${DEVICE_MODEL}_API_${API}/
ADD docker-assets/entrypoint.sh /home/android/entrypoint.sh
ADD docker-assets/jwmrc /home/android/.jwmrc
ADD docker-assets/xsession /home/android/.xsession
ADD ["docker-assets/Emulator.conf", "/home/android/.config/Android Open Source Project/Emulator.conf"]

# Expose vnc port.
EXPOSE 5901
EXPOSE 5554
EXPOSE 5555
ENTRYPOINT ["/home/android/entrypoint.sh"]