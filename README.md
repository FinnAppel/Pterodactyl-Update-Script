# Pterodactyl Update Script

This automated script allows you to update your Pterodactyl panel effortlessly in just a few seconds.

## How to Use
To update your Pterodactyl panel, simply run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/FinnAppel/Pterodactyl-Update-Script/main/update.sh | sudo bash
```
_Note: On some systems, it's required to be already logged in as root before executing the one-line command (where `sudo` is in front of the command does not work)._

## Requirements
- `curl` must be installed on your system.
- Sufficient permissions to execute commands with `sudo`.

## Supported Linux (Unix) OS

| Linux Distro | Support          |
| ------- | ------------------ |
| Debian | :heavy_check_mark: Supported|
| Ubuntu | :heavy_check_mark: Supported|
| CentOS | :heavy_check_mark: Supported|

## Notes
- The script puts your panel into maintenance mode during the update process.

---

Enjoy a seamless update experience with this script!

