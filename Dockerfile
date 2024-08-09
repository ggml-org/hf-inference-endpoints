FROM ghcr.io/ggerganov/llama.cpp:server-cuda

ENTRYPOINT [ "/bin/bash" ]

# explain: if LLAMACPP_ARGS variable exists, we use if; otherwise, we default to -fa -c 8196
CMD ["-c", "/llama-server -m /repository/*.gguf $(if [ -n \"$LLAMACPP_ARGS\" ]; then echo \"$LLAMACPP_ARGS\"; else echo \"-fa -c 8196\"; fi) --host 0.0.0.0 --port 80 -ngl 9999"]
