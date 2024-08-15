## Inference endpoints for Hugging Face

This repo contains Docker containers that can be used to deploy ggml-based inference endpoints at:

https://ui.endpoints.huggingface.co

## Instructions

During dedicated endpoint creation, select custom container type like this:

![image](https://github.com/user-attachments/assets/671f2efb-b81d-48ea-aecc-50f73da2887b)

*note: the `LLAMACPP_ARGS` environment variable is a temporary mechanism to pass custom arguments to `llama-server`*
