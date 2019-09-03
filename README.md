## tools
- awscli
- eksctl
- helm
- kubectl
- terraform

## run container
```bash
docker run -ti \
    -v /etc/passwd:/etc/passwd -u \`id -u\`:\`id -g\` \
    -v \$HOME/.aws/:$HOME/.aws/ \
    -v \$HOME/.ssh/:$HOME/.ssh/ \
    -v \$HOME/dev/:/home/user/dev/ \
    -w /home/user/dev/ \
    -p 8000:8000 g78ffkud/tools
```
