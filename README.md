## How to build and push

Pre-requirements:
- You need to have docker and docker compose on your machine
- Make sure that you have an account on https://hub.docker.com/
- Login to your account using `docker login`

For image tag name: it will be in format of `{your_docker_username}/llamacpp-server`

In this example, we will use `ngxson` as `{your_docker_username}`

**To select a specific branch or commit**

Modify `Dockerfile`:

```
RUN git clone https://github.com/ggerganov/llama.cpp -b master --depth 1 .
```

Change `-b` to the branch you want, for example:

```
RUN git clone https://github.com/ggerganov/llama.cpp -b gg/phi-2 --depth 1 .
```

Additionally, if you want to select a specific commit, you can add `git reset`. For example:

```
RUN git clone https://github.com/ggerganov/llama.cpp -b master --depth 1 . && git reset --hard 911b437
```

**Build and push to docker hub**

You need to re-build the image whenever you make a change in Dockerfile (for example, change the git branch)

```sh
docker build --platform linux/amd64 -t ngxson/llamacpp-server .
docker push ngxson/llamacpp-server
```

After a while, the image will appear on your docker hub account. You can then use it to create inference endpoint.
