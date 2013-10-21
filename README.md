imgur-uploader-linux
====================

Captures and uploads screenshots to imgur
---

---

Requirements
---
* `bash`
* `curl`
* `scrot`
* `libnotify`
* `xdotool`
* `xterm`

---

Install on Ubuntu/Mint
---
`sudo apt-get install bash curl scrot libnotify-bin xdotool xterm`  
`git clone https://github.com/cory-sherman/imgur-uploader-linux.git`

---

Usage
---
Create a keyboard shortcut to `imgur_upload_non-interactive.sh`.
By default, the entire screen is captured and uploaded.
The address is placed in your clipboard and displayed as a notification.

If you want to capture only the active window, create a shortcut to `imgur_upload_non-interactive.sh -u`.

If you want to select an arbitrary rectangle to capture, create a shortcut to `imgur_upload_non-interactive.sh -s`.
When you activate it, click and drag to select a rectangle.

---

Create a keyboard shortcut
---
This varies in each WM.

In Gnome, Cinnamon, or Unity,

  `System Settings` > `Keyboard` > `Keyboard Shortcuts` > `Custom Shortcuts`. Add a custom shortcut.
  
In KDE,

  `System Settings` > `Input Actions` > right-click > `New Global Shortcut` > `Command/URL`.

