# Simple UFW configuration setup

A **Firewall** is a network security system, either software or hardware, that monitors and controls incoming and outgoing network traffic based on predefined security rules.

Some operating system installations include a pre-configured firewall, but many lightweight or minimal Linux distributions do not. For these systems, setting up a firewall is essential for security.

A popular and user-friendly firewall software is `ufw`, which stands for *Uncomplicated Firewall*. It simplifies the process of configuring firewall rules, providing an intuitive yet effective way to secure your system.

### Installation

To install `ufw` on Debian-based Linux distributions, update the package sources and install using `apt`:

```bash
sudo apt update
sudo apt install ufw
```

### Setting Default Policies

Configure the default policies to deny all incoming traffic and allow all outgoing traffic for a secure baseline:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Allowing Specific Services

Use the `allow` and `limit` commands to customize permitted services. The `limit` command is particularly useful for services like SSH to prevent brute-force attacks. Below is a well-rounded configuration example:

```bash
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Enabling Logging

Enable logging to monitor firewall activity. The `low` setting provides a balance between useful information and minimal log clutter:

```bash
sudo ufw logging low
```

### Activating the Firewall

Apply the changes by enabling `ufw`. This will activate the firewall with your configured rules:

```bash
sudo ufw enable
```

**Note**: Ensure you have allowed necessary services before enabling the firewall to avoid locking yourself out of the system.
