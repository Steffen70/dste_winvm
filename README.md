## Create a new Windows VM

```bash
# Create a New Disk for Installation
qemu-img create -f qcow2 dste_windows.qcow2 120G

# Alt+CTRL+2
sendkey alt-ctrl-delete
# Alt+CTRL+1

sudo cp ./dste_windows.service /etc/systemd/system/

# Allow QEMU to forward host port 443 by granting CAP_NET_BIND_SERVICE capability - non-root users are not allowed to bind ports below 1024
which qemu-system-x86_64
# /usr/bin/qemu-system-x86_64

sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/qemu-system-x86_64

getcap /usr/bin/qemu-system-x86_64
# /usr/bin/qemu-system-x86_64 cap_net_bind_service=eip

sudo systemctl daemon-reload

sudo systemctl status dste_windows

sudo systemctl start dste_windows

# regsvr32 “C:\Program Files (x86)\Windows Photo Viewer\PhotoViewer.dll”

# Get-ChildItem -Path $directory_path -Recurse | Unblock-File
```
