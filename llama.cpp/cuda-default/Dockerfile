ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.6.0
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} AS build

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev curl libgomp1 cmake

WORKDIR /app

RUN git clone https://github.com/ggerganov/llama.cpp -b master --depth 1 .

RUN cmake -S . -B build \
    -DBUILD_SHARED_LIBS=OFF \
    -DLLAMA_CURL=ON \
    -DLLAMA_SERVER_VERBOSE=OFF \
    -DLLAMA_DISABLE_LOGS=1 \
    -DGGML_CUDA=ON \
    -DGGML_F16C=ON \
    -DGGML_FMA=ON \
    -DGGML_AVX=ON \
    -DGGML_AVX2=ON \
    -DGGML_CUDA_FORCE_MMQ=ON

RUN cmake --build build --config Release --target llama-server --target llama-bench -j$(nproc)

FROM ${BASE_CUDA_RUN_CONTAINER} AS runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1 curl

COPY --from=build /app/build/bin/* /

ENTRYPOINT [ "/bin/bash" ]

# run llama-bench and then start llama-server
CMD ["-c", "/llama-bench -m /repository/*.gguf -ngl 9999 -fa 1 -p 1,2,4,8,16,32,64,128,256,512,1024 && /llama-server -m /repository/*.gguf -ngl 9999 $(if [ -n \"$LLAMACPP_ARGS\" ]; then echo \"$LLAMACPP_ARGS\"; else echo \"-fa -c 8192\"; fi) --host 0.0.0.0 --port 80"]
