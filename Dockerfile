FROM ghcr.io/ggerganov/llama.cpp:server-cuda

ENTRYPOINT [ "/bin/bash" ]

CMD [ "-c", "/llama-server -m /repository/*.gguf -c 8096 -np 2 --host 0.0.0.0 --port 80 -ngl 9999" ]
