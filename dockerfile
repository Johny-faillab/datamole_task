# Build base image.

FROM ubuntu:18.04

# Set default working directory.

WORKDIR /home/ubuntu

# Install TTYD including dependencies.

RUN apt-get update && \
    apt-get install -y \
      - build-essential \
      - cmake \
      - git \
      - libjson-c-dev \
      - libwebsockets-dev && \
    git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && \
    make && make install && \

# Install HTOP and SUDO.

    apt-get install -y \
      - htop \
      - sudo && \

# Create user "ubuntu" with group "sudo" with specific password and allow him to use sudo without password.

    useradd -m ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu sudo && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Run docker container as a specific user.
USER ubuntu

# Expose port for docker container.
EXPOSE 7681

# Run ttyd bash command upon docker container start.
CMD ["ttyd", "bash"]
