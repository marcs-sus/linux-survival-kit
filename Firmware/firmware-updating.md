# Firmware Updating Guide

**Firmware** is software that directly controls a hardware device's core functions, serving as a bridge between **hardware** and **software**.

Keeping firmware updated is crucial for enhancing device stability, security, and performance. While updates can be performed manually, automating the process is more efficient.

The most widely used and reliable tool for firmware updates on Linux is [`fwupd`](https://github.com/fwupd/fwupd), a system daemon that makes updating firmware simple, automatic, and secure.

### Installation

To install `fwupd` on Debian-based distributions (if not already installed), run:

```bash
sudo apt update
sudo apt install fwupd
```

Verify the installation by checking the version:

```bash
fwupdmgr --version
```

If a version number is displayed, `fwupd` is successfully installed.

### Basic Usage

Here’s a straightforward workflow to check for and install firmware updates using `fwupd`:

```bash
sudo fwupdmgr get-devices
```

This command lists all devices supported by `fwupd` for updates.

```bash
sudo fwupdmgr refresh
```

This checks the Linux Vendor Firmware Service (LVFS) for the latest firmware versions.

```bash
sudo fwupdmgr get-updates
```

This displays available firmware updates for your devices.

```bash
sudo fwupdmgr update
```

This downloads and installs the updates. A reboot may be required afterward.

**Note**: Some updates may require the device to remain plugged in or involve specific instructions (e.g., avoiding disconnection). Always follow on-screen prompts carefully.
