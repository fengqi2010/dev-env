# CUDA基础镜像
FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04
# CPU版本
# FROM ubuntu:20.04

# 安装基础包
RUN apt update && \
    apt install -y \
        wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
        libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /temp

# 下载python
RUN wget https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz && \
    tar -xvf Python-3.9.10.tgz

# 编译&安装python
RUN cd Python-3.9.10 && \
    ./configure --enable-optimizations && \
    make && \
    make install

WORKDIR /workspace

RUN rm -r /temp && \
    ln -s /usr/local/bin/python3 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3 /usr/local/bin/pip

# 安装pytorch
# https://pytorch.org/get-started/locally/
RUN pip3 install torch==1.10.2+cu113 torchvision==0.11.3+cu113 torchaudio==0.10.2+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html && \
    rm -r /root/.cache/pip