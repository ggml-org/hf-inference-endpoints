FROM ghcr.io/ggerganov/llama.cpp:server-cuda

ENTRYPOINT [ "/bin/bash" ]

CMD [ "-c", "/llama-server -m /repository/*.gguf -c 8096 -np 2" ]
