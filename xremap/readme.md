# xremap

[github link for xremap](https://github.com/xremap/xremap)

## Install

use cargo Install, or download binaries

```bash
cargo install xremap --features x11     # X11
cargo install xremap --features gnome   # GNOME Wayland
cargo install xremap --features kde     # KDE-Plasma Wayland
cargo install xremap --features wlroots # Sway, Wayfire, etc.
cargo install xremap --features hypr    # Hyprland
cargo install xremap                    # Others

```

## Execute xremap as a normal user

- Allow the user to access input events
  Add the user to input group if it's not added.

```bash
sudo gpasswd -a ${USER} input
```

- Then, execute the following command if /etc/udev/rules.d/input.rules doesn't have the entry.

```bash
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
```

- Create $HOME/.config/systemd/user/xremap.service file

```conf
[Unit]
Description=xremap
After=default.target

[Service]
ExecStart=%h/.cargo/bin/xremap %h/.config/xremap/config.yaml
StandardOutput=journal
StandardError=journal
Restart=always

[Install]
WantedBy=default.target
```

- Register the service to systemd

```bash
systemctl --user enable xremap.service
```

- Start the service

```bash
systemctl --user start xremap.service
```
