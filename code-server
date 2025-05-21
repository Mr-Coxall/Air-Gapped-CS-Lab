# Code Server

## VS Code running locally on your server, but accessable in a web browser!

https://coder.com/docs/code-server/install#debian-ubuntu

Root can do the install
```bash
  curl -fOL https://github.com/coder/code-server/releases/download/v$VERSION/code-server_${VERSION}_amd64.deb
  sudo dpkg -i code-server_${VERSION}_amd64.deb
```

The user, NOT root should do this.
```bash
  sudo systemctl enable --now code-server@$USER
  # Now visit http://127.0.0.1:8080. Your password is in ~/.config/code-server/config.yaml
```
