## Create a new Windows VM

```bash
# Create a New Disk for Installation
qemu-img create -f qcow2 dste_windows.qcow2 120G

# Alt+CTRL+2
sendkey alt-ctrl-delete
# Alt+CTRL+1

sudo cp ./dste_windows.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl status dste_windows

sudo systemctl start dste_windows
```