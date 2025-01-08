#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# VM Configuration
ALLOCATED_RAM="16384"  # MiB
CPU_SOCKETS="1"
CPU_CORES="4"
CPU_THREADS="8"

# Paths for Virtual Disk, Windows Server ISO, and VirtIO ISO
VMDISK="$SCRIPT_DIR/dste_windows.qcow2"
# WINDOWS_ISO="$SCRIPT_DIR/en-us_windows_server_2022_updated_oct_2024_x64_dvd_d1a47ecc.iso"  
# VIRTIO_ISO="$SCRIPT_DIR/virtio-win-0.1.262.iso"

# Alternative Spice port to avoid conflicts (5900+5901 => macOS VMs)
SPICE_PORT=5902

# RDP port forwarding (Alternative port to avoid conflicts)
HOST_RDP_PORT=3390
HOST_SSH_PORT=2224

args=(
    # Allocate specified RAM to the VM
    -m "$ALLOCATED_RAM"M

    # Use Q35 machine type (modern chipset with PCIe support), enable KVM acceleration
    -M q35,accel=kvm

    # Use host CPU with Hyper-V optimizations for Windows
    -cpu host,hv_relaxed,hv_vpindex,hv_time,hv-vapic,hv_spinlocks=0x1fff

    # Configure CPU topology: sockets, cores, and threads
    -smp sockets="$CPU_SOCKETS",cores="$CPU_CORES",threads="$CPU_THREADS"

    # Set the VGA device using VirtIO for better performance in VMs
    -device virtio-vga

    # Attach the main virtual disk using VirtIO for optimized disk I/O
    -drive file="$VMDISK",format=qcow2,if=virtio

    # -drive file="$WINDOWS_ISO",media=cdrom,index=2
    # -drive file="$VIRTIO_ISO",media=cdrom,index=3

    # Boot order set to prioritize the main disk (c)
    -boot order=c

    # Configure network with VirtIO and a specified MAC address
    -device virtio-net-pci,netdev=net0,mac=52:54:00:12:34:56

    # User-mode networking with port forwarding for RDP and SSH
    -netdev user,id=net0,hostfwd=tcp::"$HOST_RDP_PORT"-:3389,hostfwd=tcp::"$HOST_SSH_PORT"-:22 

    # Enable KVM for hardware acceleration
    -enable-kvm

    # SPICE display server on localhost with port forwarding to LAN
    -spice port="$SPICE_PORT",addr=0.0.0.0,disable-ticketing=on

    # Attach a SPICE channel for improved performance and remote management
    -device virtio-serial-pci
    -chardev spicevmc,id=spicechannel0,name=vdagent
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0

    # Run without a graphical window on the host
    -display none
)

# Start the VM with essential settings
qemu-system-x86_64 "${args[@]}"