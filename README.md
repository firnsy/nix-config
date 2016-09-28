# nix-config - version 0

This is home for the collection of tools and configurations I use to
personalise my linux experience.

Install necessary packages [Fedora]:
```
sudo dnf install powerline tmux-powerline vim-powerline
sudo pip3 install powerline-gitstatus
```

Install to local directory via:
```
$ ./install.sh
```

Next, configure your bash shell to use powerline by default. Add the following snippet to your ~/.bashrc file:

```
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi
```
