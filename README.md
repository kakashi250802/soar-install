# Soar downloads

Prebuilt Soar command line tools and the VS Code extension. The install guide is at
<https://kakashi250802.github.io/soar-install/>.

## Install

macOS and Linux:

```bash
curl -fsSL https://kakashi250802.github.io/soar-install/install.sh | sh
```

Windows (PowerShell):

```powershell
irm https://kakashi250802.github.io/soar-install/install.ps1 | iex
```

Then create and run an app:

```bash
soar new my-app && cd my-app && soar start
```

## What is here

| Path | What it is |
|---|---|
| [Releases](https://github.com/kakashi250802/soar-install/releases) | `soar` + `soar-desktop` per platform, `soar-vscode.vsix`, `SHA256SUMS` |
| `index.html` | The install guide (GitHub Pages) |
| `install.sh`, `install.ps1` | The install scripts the guide links to |

Releases are published by the release workflow of the Soar engine repository; do not upload
files here by hand.
