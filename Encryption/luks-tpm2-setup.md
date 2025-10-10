# LUKS and TPM2 Auto Decryption setup

Encrypting the disk of your operating system can be a very useful security approach, helping to prevent unwanted access to your data in cases such as theft or other forms of physical access to your device. Disk encryption itself is the process of converting all data stored on the disk into a form that cannot be read without proper authorization, using a password or key.

On Linux systems, this task is usually handled through **LUKS** (Linux Unified Key Setup). It provides a common encryption format across different Linux distributions and uses strong encryption ciphers and key derivation functions.

When you boot a LUKS-encrypted partition, the encryption key is required to unlock it. This process can sometimes be inconvenient; however, there’s a solution for this: storing the key inside a **TPM 2.0** chip.

TPM 2.0 is a hardware security chip found in most modern motherboards, especially on laptops. It securely stores cryptographic keys and verifies system integrity during boot. In the context of disk encryption, it can securely store the key for your encrypted drive, automatically unlocking your LUKS-encrypted volume and providing both convenience and security to the system.

Some Linux distributions may include the option to encrypt your disk during installation but don’t configure automatic unlocking through the TPM chip — for example, _Debian_. Next, we'll cover how to configure LUKS with TPM integration manually.

---

First, check if your device supports a TPM security chip. You can do so by running the following command:

```bash
systemd-cryptenroll --tpm2-device=list
```

It should return something like this:

```
PATH        DEVICE     DRIVER
/dev/tpmrm0 ******     tpm_tis
```

Next, locate the disk that contains the encrypted volume. For this, you can use the `lsblk` command or any similar tool.
Note that you'll need the **partition itself**, not the mapped volume — it could be something like `nvme0n1p3` or `sda3`.

> **Note**: TPM auto-unlock requires your encrypted partition to use the **LUKS2** format.
> You can check this by running `cryptsetup luksDump /dev/<your-partition>` and verifying that the version is `LUKS2`.

With the disk name in hand, generate the TPM key for it using the `systemd-cryptenroll` command, as shown below:

```bash
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/<your-partition>
```

> This command will enroll a cryptographic key into the TPM chip.
> The `--tpm2-device=auto` option tells the command to automatically detect a TPM device, while the `--tpm2-pcrs=0+2+7` option specifies the PCRs (Platform Configuration Registers) in the TPM to use for storing the key.
> These are PCRs 0, 2, and 7 — typically used to store the measured bootloader code, configuration, and kernel code, respectively.

Install `dracut` and `tpm2-tools` using APT:

```bash
sudo apt install dracut tpm2-tools
```

Next, edit the following line in the `/etc/dracut.conf` file, making it look like this:

```bash
add_dracutmodules+=" tpm2-tss crypt "
```

Then, edit this line in `/etc/default/grub`:

```bash
GRUB_CMDLINE_LINUX="rd.auto rd.luks=1"
```

Also, you may comment out the line in `/etc/crypttab`. This is no longer needed if you want to auto-decrypt the volume with TPM.

```bash
# <your-crypt-partition> UUID=****-****-*** none luks,discard
```

Apply all the changes made with the following commands:

```bash
dracut -f
update-grub
```

With all that done, restart the system and check if the configuration worked.
It should no longer ask for the encryption key, unlocking your system automatically.

### Important Consideration

If, for any reason, your device boots and asks for the key even though your setup should work (in my case, this happened after updating my device’s firmware), run the following command.
It will wipe all TPM-assigned keys and allocate a new one, as before:

```bash
systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/nvme0n1p3
```

> **Note**: Firmware, kernel, or initramfs updates may change TPM measurements (PCRs) and cause the auto-decryption to fail.
> If this happens, simply re-enroll the key using the same command as above.
