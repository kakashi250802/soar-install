# Installs the Soar command line tools on Windows: `soar.exe` and the `soar-desktop.exe` host.
#
#   irm https://kakashi250802.github.io/soar-install/install.ps1 | iex
#
# Puts both in %USERPROFILE%\.soar\bin, adds that folder to the user PATH, and installs the VS Code
# extension when the `code` command exists. Rerun it to update. $env:SOAR_VERSION picks a release.
$ErrorActionPreference = "Stop"

$repo = "kakashi250802/soar-install"
$version = if ($env:SOAR_VERSION) { $env:SOAR_VERSION } else { "latest" }
$base = if ($version -eq "latest") { "https://github.com/$repo/releases/latest/download" }
        else { "https://github.com/$repo/releases/download/$version" }
$dir = Join-Path $env:USERPROFILE ".soar\bin"
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("soar-" + [Guid]::NewGuid())
New-Item -ItemType Directory -Force $dir, $tmp | Out-Null

try {
  Write-Host "Downloading soar (x86_64-pc-windows-msvc, $version)..."
  $zip = Join-Path $tmp "soar.zip"
  Invoke-WebRequest "$base/soar-x86_64-pc-windows-msvc.zip" -OutFile $zip -UseBasicParsing
  Expand-Archive $zip -DestinationPath $dir -Force
  Write-Host "Installed $(& (Join-Path $dir 'soar.exe') --version) to $dir"

  if (Get-Command code -ErrorAction SilentlyContinue) {
    $vsix = Join-Path $tmp "soar-vscode.vsix"
    Invoke-WebRequest "$base/soar-vscode.vsix" -OutFile $vsix -UseBasicParsing
    code --install-extension $vsix --force | Out-Null
    Write-Host "Installed the Soar extension. Reload VS Code to use it."
  }

  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (-not ($userPath -split ";" -contains $dir)) {
    [Environment]::SetEnvironmentVariable("Path", "$dir;$userPath", "User")
    Write-Host "Added $dir to your PATH. Open a new terminal to use soar."
  }
  Write-Host "Next: soar new my-app; cd my-app; soar start"
} finally {
  Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
