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
- It updates your Pterodactyl panel to the latest available version, ensuring your installation is up to date.
- If the panel encounters issues or breaks down, the script can also be used to reinstall it without deleting any server data, effectively restoring functionality.

---

If you found this useful, feel free to leave a star on my GitHub.
