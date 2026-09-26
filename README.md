# Gnome-Screenshot-JPG

Automatically convert GNOME screenshots from PNG to compressed JPEG (JPG) on Linux, with a focus on **uBlue Bluefin** and other **GNOME desktop environments**.

This repository provides a small **systemd user service + systemd path watcher + Python/Pillow image processor**. When a screenshot changes in `~/Pictures/Screenshots`, the watcher starts the converter, which finds PNG screenshots, converts them to JPEG, and progressively reduces image dimensions and JPEG quality when necessary to keep the output near the **1 MB (1000 KiB) target**.

The project is intended as a practical, user-built solution for people who want **automatic PNG-to-JPG screenshot conversion**, smaller screenshot files, and less manual image compression on GNOME Linux.

[![CI Verification](https://github.com/mhasanmuammar/Gnome-Screenshot-JPG/actions/workflows/main.yml/badge.svg)](https://github.com/mhasanmuammar/Gnome-Screenshot-JPG/actions/workflows/main.yml)

## Why use Gnome-Screenshot-JPG?

GNOME screenshot tools commonly produce PNG files. PNG is lossless and useful for archival or editing, but screenshots containing large desktop images can become unnecessarily large for websites, documentation uploads, messaging, and other workflows that have file-size limits.

Gnome-Screenshot-JPG automates the conversion step:

`GNOME screenshot → PNG file → systemd path event → Python/Pillow conversion → optimized JPG`

There is no need to run a conversion command manually after each screenshot.

## Features

- **Automatic GNOME screenshot conversion:** watches `~/Pictures/Screenshots` and processes PNG screenshots after the folder changes.
- **PNG to JPG conversion:** converts lossless PNG screenshots to web-friendly JPEG files.
- **Automatic JPEG compression:** starts with a high-quality JPEG export and only applies additional shrinking when the result exceeds the configured size threshold.
- **Adaptive size reduction:** progressively reduces image dimensions and JPEG quality instead of applying an unnecessarily aggressive compression setting to every screenshot.
- **1 MB-oriented output:** targets **1000 KiB (1,024,000 bytes)** per JPG. The current algorithm makes a best effort; exceptionally difficult images may still exceed the target.
- **Transparency handling:** PNG images with alpha/transparency are composited onto a white background before JPEG export.
- **systemd user service:** runs as a per-user service, so the converter integrates with the Linux desktop session without requiring a system-wide daemon.
- **Suitable for Bluefin and GNOME Linux:** designed around the standard `~/Pictures/Screenshots` location and user-level systemd available on modern GNOME Linux systems.

## How it works

The installer creates two user-level systemd units.

`gnome-screenshot-jpg.path` watches `~/Pictures/Screenshots` with `PathChanged=`.

When that directory changes, systemd starts `gnome-screenshot-jpg.service`.

The service runs:

`~/.local/bin/gnome-screenshot-jpg.sh`

The converter scans the screenshot directory for `.png` files. Each PNG is opened with **Pillow**, converted to RGB/JPEG, and initially saved at JPEG quality 85 with optimization enabled.

If the resulting JPG is larger than the configured 1,000 KiB threshold, the script enters an adaptive loop. It repeatedly reduces the image dimensions and JPEG quality until the file is below the threshold or the configured minimum scale is reached.

After a JPG has been created successfully, the original PNG is removed. **Back up important PNG screenshots before using this tool if you need to retain the lossless originals.**

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/mhasanmuammar/Gnome-Screenshot-JPG.git
cd Gnome-Screenshot-JPG
chmod +x install.sh
./install.sh
```

### Dependency

The converter is a Python 3 script and requires **Pillow**.

Check whether Pillow is already available:

```bash
python3 -c "from PIL import Image; print(Image.__version__)"
```

If Pillow is not installed on your system, install it using the Python/package-management method appropriate for your Linux distribution.

The current installer creates the systemd units but does **not** install Pillow automatically.

## Default paths

Input screenshots:

```text
~/Pictures/Screenshots/*.png
```

Installed converter:

```text
~/.local/bin/gnome-screenshot-jpg.sh
```

User service:

```text
~/.config/systemd/user/gnome-screenshot-jpg.service
```

User path watcher:

```text
~/.config/systemd/user/gnome-screenshot-jpg.path
```

## Configuration

The main settings are defined near the top of `gnome-screenshot-jpg.sh`.

```python
TARGET_DIR = os.path.expanduser("~/Pictures/Screenshots")
SIZE_THRESHOLD = 1000 * 1024
```

The current conversion starts at JPEG quality 85. If the output is too large, the fallback loop begins at a 90% scale and quality 80, then decreases the scale and quality in steps.

To change the target size or screenshot directory, edit the script before reinstalling or copy the updated script to `~/.local/bin/`.

## Check the service

Check whether the path watcher is enabled and running:

```bash
systemctl --user status gnome-screenshot-jpg.path
```

Inspect the converter service:

```bash
systemctl --user status gnome-screenshot-jpg.service
```

View recent logs:

```bash
journalctl --user -u gnome-screenshot-jpg.service
```

Run the converter manually for troubleshooting:

```bash
~/.local/bin/gnome-screenshot-jpg.sh
```

## Important behaviour and limitations

This project is intentionally simple and local. It does not upload screenshots anywhere and does not require a container, cloud service, or separate web application.

The watcher responds to changes in the screenshot directory and then scans for PNG files. It is therefore better understood as a **directory-change-triggered screenshot converter** than as an individual-file event queue.

The current script deletes the source PNG after a JPG file has been created successfully. JPEG is lossy, so this conversion should not be treated as a lossless archival workflow.

The 1 MB limit is a target, not a mathematical guarantee. The current fallback loop stops after reaching its minimum configured scale. Very large or difficult images can therefore remain above 1,000 KiB.

## Compatibility

The project is primarily aimed at:

- **uBlue Bluefin**
- **GNOME desktop environments on Linux**
- Linux systems with **systemd user services**
- Python 3 with the **Pillow** package

The installer assumes the screenshot directory is:

`~/Pictures/Screenshots`

Users with a different GNOME screenshot location should adjust `TARGET_DIR` and the systemd path/service definitions accordingly.

## Verification

The repository includes a GitHub Actions workflow that installs Pillow and runs Python bytecode compilation against the converter script.

This CI check verifies that the Python source is syntactically valid in the configured Python environment. It does not replace an end-to-end test of the GNOME/systemd watcher on a real desktop session.

## Keywords

GNOME screenshot JPG converter, GNOME screenshot PNG to JPEG, Linux screenshot compressor, automatic screenshot compression, Bluefin screenshot tool, uBlue Bluefin GNOME, systemd path watcher, systemd user service, Python Pillow image compression, PNG to JPG Linux, JPEG screenshot compression, screenshot under 1MB, reduce screenshot file size, automatic PNG conversion, GNOME screenshot automation.

## Repository

GitHub: https://github.com/mhasanmuammar/Gnome-Screenshot-JPG

This is a small, focused utility intended to solve a specific Linux desktop workflow: automatically convert GNOME PNG screenshots into smaller JPG files without requiring a manual compression step for every screenshot.

---

*Disclaimer: This project repository codebase structure, configurations, and scripts were fully generated using the Gemini 2.5 Pro model context.*
