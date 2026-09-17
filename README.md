# Gnome-Screenshot-JPG

An automated tool designed for **uBlue Bluefin OS** (and other GNOME environments) that natively captures folder modification events, converts lossless uncompressed PNG screenshots into web-friendly `.jpg` files, and runs an adaptive loop compression threshold system to safely force individual image sizes below **1MB**.

## Features
- **Host Native Processing:** Operates directly on the atomic host via built-in Python system features, eliminating container execution resource limits or performance drops.
- **Adaptive Fallback Loop:** Intelligently checks file metrics and step-scales image resolutions and parameters only if the target exceeds 1MB.
- **Standardized Nomenclature:** Perfectly mapped user script execution paths paired linearly with native systemd service managers.

## Installation
Run the local deployment script:
```bash
./install.sh
```

---
*Disclaimer: This project repository codebase structure, configurations, and scripts were fully generated using the Gemini 2.5 Pro model context.*
