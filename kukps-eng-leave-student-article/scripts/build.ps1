# Build from any working directory; keep all generated files in build/.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$buildDirectory = Join-Path $projectRoot 'build'
$xelatexCommand = Get-Command xelatex -ErrorAction Stop
New-Item -ItemType Directory -Path $buildDirectory -Force | Out-Null

Push-Location -LiteralPath $projectRoot
try {
    for ($pass = 1; $pass -le 2; $pass++) {
        & $xelatexCommand.Source '-synctex=1' '-interaction=nonstopmode' '-file-line-error' '-halt-on-error' '-output-directory=build' 'main.tex'
        if ($LASTEXITCODE -ne 0) {
            throw "XeLaTeX failed on pass $pass. See build/main.log."
        }
    }
    Write-Host "PDF: $(Join-Path $buildDirectory 'main.pdf')"
}
finally {
    Pop-Location
}
