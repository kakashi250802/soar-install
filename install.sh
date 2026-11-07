#!/bin/sh
# Installs the Soar command line tools: `soar` and the `soar-desktop` host it runs apps in.
#
#   curl -fsSL https://kakashi250802.github.io/soar-install/install.sh | sh
#
# Puts both binaries in ~/.soar/bin (or $SOAR_INSTALL/bin), installs the VS Code extension when
# the `code` command exists, and says how to add the folder to PATH. Rerun it to update.
# SOAR_VERSION=v0.1.0 picks a release; the default is the latest one.
set -eu

REPO="kakashi250802/soar-install"
VERSION="${SOAR_VERSION:-latest}"
DIR="${SOAR_INSTALL:-$HOME/.soar}/bin"

case "$(uname -s)-$(uname -m)" in
  Darwin-arm64) TARGET=aarch64-apple-darwin ;;
  Darwin-x86_64) TARGET=x86_64-apple-darwin ;;
  Linux-x86_64) TARGET=x86_64-unknown-linux-gnu ;;
  *)
    echo "soar: no prebuilt download for $(uname -s) $(uname -m) yet." >&2
    echo "      See https://github.com/$REPO/releases for what exists." >&2
    exit 1
    ;;
esac

if [ "$VERSION" = latest ]; then
  BASE="https://github.com/$REPO/releases/latest/download"
else
  BASE="https://github.com/$REPO/releases/download/$VERSION"
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Downloading soar ($TARGET, $VERSION)..."
curl -fSL --progress-bar "$BASE/soar-$TARGET.tar.gz" -o "$TMP/soar.tar.gz"
mkdir -p "$DIR"
tar -xzf "$TMP/soar.tar.gz" -C "$DIR"
chmod +x "$DIR/soar" "$DIR/soar-desktop"
echo "Installed $("$DIR/soar" --version) to $DIR"

if command -v code >/dev/null 2>&1; then
  echo "Installing the VS Code extension..."
  if curl -fsSL "$BASE/soar-vscode.vsix" -o "$TMP/soar-vscode.vsix" &&
    code --install-extension "$TMP/soar-vscode.vsix" --force >/dev/null; then
    echo "Installed the Soar extension. Reload VS Code to use it."
  else
    echo "Could not install the VS Code extension; download soar-vscode.vsix from the release page." >&2
  fi
fi

case ":$PATH:" in
  *":$DIR:"*) ;;
  *)
    case "${SHELL:-}" in
      */zsh) PROFILE="$HOME/.zshrc" ;;
      */bash) PROFILE="$HOME/.bashrc" ;;
      *) PROFILE="$HOME/.profile" ;;
    esac
    echo
    echo "Add soar to your PATH, then open a new terminal:"
    echo
    echo "  echo 'export PATH=\"$DIR:\$PATH\"' >> $PROFILE"
    ;;
esac

echo
echo "Next: soar new my-app && cd my-app && soar start"
