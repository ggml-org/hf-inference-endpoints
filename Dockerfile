# This file is copied from https://github.com/ggerganov/llama.cpp/blob/master/.devops/llama-server-cuda.Dockerfile
# with some modification (see the end of this file)

ARG UBUNTU_VERSION=22.04
# This needs to generally match the container host's environment.
ARG CUDA_VERSION=11.7.1
# Target the CUDA build image
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
# Target the CUDA runtime image
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} AS build

# Unless otherwise specified, we make a fat build.
ARG CUDA_DOCKER_ARCH=all

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev

WORKDIR /app

# COPY . .
# modification: we clone source code from github based on branch name
RUN git clone https://github.com/ggerganov/llama.cpp -b master --depth 1 .

# Set nvcc architecture
ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}
# Enable CUDA
ENV GGML_CUDA=1
# Enable cURL
ENV LLAMA_CURL=1

RUN make -j$(nproc) llama-server

FROM ${BASE_CUDA_RUN_CONTAINER} AS runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1 curl

COPY --from=build /app/llama-server /llama-server

############################
# modifications:

# no need to define healthcheck here, it will be configured on the UI
# HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

ENTRYPOINT [ "/bin/bash" ]

# explain: if LLAMACPP_ARGS variable exists, we use if; otherwise, we default to -fa -c 8192
CMD ["-c", "/llama-server -m /repository/*.gguf $(if [ -n \"$LLAMACPP_ARGS\" ]; then echo \"$LLAMACPP_ARGS\"; else echo \"-fa -c 8192\"; fi) --host 0.0.0.0 --port 80 -ngl 9999"]
