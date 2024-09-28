# Use the amd64 architecture for Ubuntu
FROM --platform=linux/amd64 ubuntu:latest

# Set environment variables to handle prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools and dependencies, including 32-bit libraries for GCC
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    nasm \
    xorriso \
    qemu-system-x86 \
    git \
    wget \
    bison \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    libisl-dev \
    ca-certificates \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV PREFIX="/usr/local/i686-elf"
ENV TARGET=i686-elf
ENV PATH="$PREFIX/bin:$PATH"

# Download and build binutils
RUN wget --no-check-certificate https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz \
    && tar xf binutils-2.37.tar.xz \
    && mkdir build-binutils \
    && cd build-binutils \
    && ../binutils-2.37/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf build-binutils binutils-2.37 binutils-2.37.tar.xz

# Download and build GCC
RUN wget --no-check-certificate https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz \
    && tar xf gcc-11.2.0.tar.xz \
    && mkdir build-gcc \
    && cd build-gcc \
    && ../gcc-11.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers \
    && make all-gcc -j$(nproc) \
    && make all-target-libgcc -j$(nproc) \
    && make install-gcc \
    && make install-target-libgcc \
    && cd .. \
    && rm -rf build-gcc gcc-11.2.0 gcc-11.2.0.tar.xz

# Set working directory
WORKDIR /os

# Copy your source files into the container
COPY . /os

# Set the default command
CMD ["/bin/bash"]
