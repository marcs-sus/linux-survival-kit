# Linux Desktop Survival Kit

A curated collection of scripts, guides, and configurations to streamline the setup and maintenance of Linux desktop environments. Whether you're setting up a new system or hardening an existing one, this toolkit provides practical solutions for common tasks.

<h2 id="table-of-contents">📋 Table of Contents</h2>

- [Quick Start](#quick-start)
- [Guides](#guides)
- [Scripts](#scripts)
- [Systemd Services](#systemd-services)
- [License](#license)
- [Acknowledgments](#acknowledgments)

<h2 id="quick-start">Quick Start</h2>

Clone the repository:

```bash
git clone https://github.com/yourusername/linux-desktop-survival-kit.git
cd linux-desktop-survival-kit
```

Make scripts executable:

```bash
chmod +x **/*.sh
```

Run any script with:

```bash
sudo ./path/to/script.sh
```

<h2 id="guides">📚 Guides</h2>

Comprehensive guides covering setup and configuration:

| Guide                                                           | Description                                                                                             |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [APT Package Manager](Package-Manager/package-manager-guide.md) | Complete reference for APT commands, frontends (Nala), and alternative package managers (Snap, Flatpak) |
| [Firmware Updating](Firmware/firmware-updating.md)              | Keep your hardware firmware up-to-date with `fwupd`                                                     |
| [UFW Firewall Setup](Firewall/firewall-setup.md)                | Simple yet effective firewall configuration with UFW                                                    |
| [LUKS and TPM2 Auto Decryption](Encryption/luks-tpm2-setup.md)  | Configure automatic disk decryption using TPM 2.0 hardware security chips                               |

<h2 id="scripts">🔧 Scripts</h2>

All scripts include error handling, colored output, and helpful feedback.
They can be placed in `/usr/local/bin/` for system-wide execution or `~/.local/bin/` for user-specific execution. But most can be run from anywhere.

| Script                                                       | Description                                                                                     | Usage                                                |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| [ufw-config.sh](Firewall/ufw-config.sh)                      | Installs and configures UFW with secure defaults, rate limiting for SSH, and opens common ports | `sudo ./Firewall/ufw-config.sh`                      |
| [debian-update-all.sh](Package-Manager/debian-update-all.sh) | Updates packages across APT, Flatpak, and Snap; supports APT frontends (Nala, Aptitude)         | `sudo ./Package-Manager/debian-update-all.sh`        |
| [arch-update-all.sh](Package-Manager/arch-update-all.sh)     | Updates packages across pacman, AUR (yay/paru), Flatpak, and Snap                               | `sudo ./Package-Manager/arch-update-all.sh`          |
| [fwupd-flow.sh](Firmware/fwupd-flow.sh)                      | Automates firmware update workflow: checks devices, refreshes metadata, and installs updates    | `sudo ./Firmware/fwupd-flow.sh`                      |
| [git-autosync.sh](Scripts/Automation/git-autosync.sh)        | Syncs Git repositories (fetch, pull, push); supports recursive scanning                         | `./Scripts/Automation/git-autosync.sh [--recursive]` |
| [auto-aliases.sh](Scripts/Automation/auto-aliases.sh)        | Automatically creates aliases and organizes them into ~/.<SHELL_NAME>\_aliases                  | `./Scripts/Automation/auto-aliases.sh`               |
| [install-chrome.sh](Misc/install-chrome.sh)                  | Installs Google Chrome with proper repository setup and signing keys                            | `sudo ./Misc/install-chrome.sh`                      |
| [switch-audio.sh](Scripts/System/switch-audio.sh)            | Switches audio output between available PulseAudio/Pipewire-Pulse sinks                         | `./Scripts/System/switch-audio.sh`                   |

<h2 id="systemd-services">⚙️ Systemd Services</h2>

Systemd unit files for automating system tasks.
They can be placed in `/etc/systemd/system/`.

| Unit                                                   | Description                                             | Usage                                                            |
| ------------------------------------------------------ | ------------------------------------------------------- | ---------------------------------------------------------------- |
| [rclone-mount@.service](Systemd/rclone-mount@.service) | Mounts an RClone remote as a systemd service (template) | `sudo systemctl enable --now rclone-mount@<remote_name>.service` |

<h2 id="license">License</h2>

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<h2 id="acknowledgments">Acknowledgments</h2>

Special thanks to the open-source community for the tools that make these configurations possible:

- UFW (Uncomplicated Firewall)
- fwupd (Firmware update daemon)
- systemd-cryptenroll
- APT and its frontends

---

**Note**: Always review scripts before running them with elevated privileges. While these scripts are designed to be safe, it's good practice to understand what they do to your system.
