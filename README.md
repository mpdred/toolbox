# toolbox ![build](https://img.shields.io/docker/cloud/build/mpdred/toolbox) ![tag](https://img.shields.io/github/v/tag/mpdred/toolbox)
## tools
- awscli-v2
- helm-v3
- kubectl
- terraform-v0.12

## run container
```bash
docker run \
    --tty \
    --interactive \
    --volume /etc/passwd:/etc/passwd \
    --volume /etc/shadow:/etc/shadow \
    --volume /etc/group:/etc/group \
    --volume /etc/sudoers:/etc/sudoers \
    --volume $HOME/.aws/:/home/user/.aws/ \
    --volume $HOME/.gitconfig:/home/user/.gitconfig \
    --volume $HOME/.kube/:/home/user/.kube/ \
    --volume $HOME/.ssh/:/home/user/.ssh/ \
    --volume $HOME/src/:/home/user/src/ \
    --workdir /home/user/src/ \
    --user `id --user`:`id --group` \
    mpdred/toolbox
```
