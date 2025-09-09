# Package Manager guide

A **Package Manager** is a software tool designed to automate the processes of installing, removing, upgrading, and configuring software packages. It ensures all necessary components for a program are present and compatible to run the application.

**APT** is the default package manager for Debian-based Linux distributions, with a simple syntax and wide repositories. Its use can improve the user's system stability, security, and ease of software management.

## Usage

### Searching and Listing packages

Search for a package from the remote sources with the command `search`:

```bash
apt search <keyword>
```

List installed packages with the command `list` and the option `--installed`

```bash
apt list --installed
```

List which installed packages have upgrades available with `list` and the option `--upgradable`:

```bash
apt list --upgradable
```

Show details of a determined package with `show`:

```bash
apt show <package-name>
```

### Installing, Removing and Upgrading packages

To install, remove or upgrade a package, use the command `install`, `remove` or `upgrade` with a package name, like the following:

```bash
apt install <package-name>
apt remove <package-name>
apt upgrade <package-name>
```

Its often required `sudo` to run it as root, like the following:

```bash
sudo apt install <package-name>
```

Note that the command `purge` has a similar effect to `remove`, the diference being it also deletes any configuration file a package has:

```bash
sudo apt purge <package-name>
```

Use `upgrade` without any package name to upgrade all available packages:

```bash
sudo apt upgrade
```

Adding the option `-y` removes the need to confirm a specific action:

```bash
sudo apt upgrade -y
```

### Updating sources

To always get the latest package versions available, it's necessary to keep the APT sources up-to-date. To do that, simply use the `update` command (not to be confused with `upgrade`):

```bash
sudo apt update -y
```

### Full upgrades and distribution upgrades

For a more comprehensive system update, use `full-upgrade` (or its alias `dist-upgrade`). This command not only upgrades packages but also handles changes in dependencies by installing new ones or removing obsolete ones, which a simple `upgrade` might skip to avoid disrupting the system.

```bash
sudo apt full-upgrade -y
```

### Cleaning up the system

APT can accumulate downloaded package files and unused dependencies over time.
For this, the command `autoremove` is used to remove any unnecessary dependency installed:

```bash
sudo apt autoremove
```

Along with that, the command `autoclean` helps cleaning cache files:

```bash
sudo apt autoclean
```

## Tips and tricks

### Safe update routine

To quickly upgrade all packages to their latest version, remove any unnecessary dependency and unused cache, use the following commands:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
```

If any issues arise, try running the command, in which attempts to fix broken dependencies:

```bash
sudo apt --fix-broken install
```

### Simulating before acting

Test any command without changes with the option `--dry-run`:

```bash
sudo apt install <package-name> --dry-run
```

### APT frontends

Frontends for APT are user interfaces or applications that provide better visuals and interactions for the user. A very popular option for this is `nala`, which can be installed with:

```bash
sudo apt install nala
```

Simply replace the `apt` command with `nala`, and enjoy a better interface, plus faster downloads. Note that most commands are the same for both (since Nala is just a frontend, not a whole package manager), but some commands may differ between them.

### Alternative Package Managers

While APT is the standard for Debian-based systems, other package managers exist that offer universal packaging across different Linux distributions. These can be useful for apps not available in APT repositories or for ensuring compatibility. Two popular options are **Snap** and **Flatpak**, which bundle applications with their dependencies, making them self-contained (unlike APT, which installs packages system-wide and shares dependencies, potentially leading to conflicts).

To get started with Snap (developed by Canonical for Ubuntu and other distros):

First, install the Snap daemon if it's not already present:

```bash
sudo apt install snapd
```

Then, install a package:

```bash
sudo snap install <package-name>
```

To remove it:

```bash
sudo snap remove <package-name>
```

For Flatpak (a community-driven alternative):

Install Flatpak:

```bash
sudo apt install flatpak
```

Add the Flathub repository (a common source for apps):

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Install an app (using its ID from Flathub):

```bash
flatpak install flathub <app-id>
```

To uninstall:

```bash
flatpak uninstall <app-id>
```
