param(
  [Parameter(Mandatory = $true)]
  [string]$MarkdownPath,

  [Parameter(Mandatory = $true)]
  [string]$OutputPath
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

function Convert-ToXmlText {
  param([string]$Text)
  return [System.Security.SecurityElement]::Escape($Text)
}

$markdown = Get-Content -LiteralPath $MarkdownPath -Encoding UTF8
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
$wordDir = Join-Path $tempRoot "word"
$relsDir = Join-Path $tempRoot "_rels"
$wordRelsDir = Join-Path $wordDir "_rels"
$docPropsDir = Join-Path $tempRoot "docProps"

New-Item -ItemType Directory -Path $wordDir, $relsDir, $wordRelsDir, $docPropsDir | Out-Null

$body = New-Object System.Text.StringBuilder

foreach ($line in $markdown) {
  $style = $null
  $text = $line

  if ($line.StartsWith("# ")) {
    $style = "Title"
    $text = $line.Substring(2)
  } elseif ($line.StartsWith("## ")) {
    $style = "Heading1"
    $text = $line.Substring(3)
  } elseif ($line.StartsWith("### ")) {
    $style = "Heading2"
    $text = $line.Substring(4)
  } elseif ($line.StartsWith("- ")) {
    $text = "• " + $line.Substring(2)
  }

  if ([string]::IsNullOrWhiteSpace($text)) {
    [void]$body.AppendLine('<w:p/>')
    continue
  }

  $escaped = Convert-ToXmlText $text
  if ($style) {
    [void]$body.AppendLine("<w:p><w:pPr><w:pStyle w:val=`"$style`"/></w:pPr><w:r><w:t>$escaped</w:t></w:r></w:p>")
  } else {
    [void]$body.AppendLine("<w:p><w:r><w:t>$escaped</w:t></w:r></w:p>")
  }
}

$documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
$body
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

$stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:styleId="Normal"><w:name w:val="Normal"/></w:style>
  <w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/><w:rPr><w:b/><w:sz w:val="32"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:rPr><w:b/><w:sz w:val="26"/></w:rPr></w:style>
  <w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:rPr><w:b/><w:sz w:val="22"/></w:rPr></w:style>
</w:styles>
"@

$contentTypesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
"@

$relsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
"@

$documentRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
"@

$coreXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>Relatorio Tecnico Executivo - Pipeline CI com SonarQube</dc:title>
  <dc:creator>Codex</dc:creator>
  <dcterms:created xsi:type="dcterms:W3CDTF">2026-08-07T00:00:00Z</dcterms:created>
</cp:coreProperties>
"@

$appXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>Codex</Application>
</Properties>
"@

Set-Content -LiteralPath (Join-Path $tempRoot "[Content_Types].xml") -Value $contentTypesXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $relsDir ".rels") -Value $relsXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $wordDir "document.xml") -Value $documentXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $wordDir "styles.xml") -Value $stylesXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $wordRelsDir "document.xml.rels") -Value $documentRelsXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $docPropsDir "core.xml") -Value $coreXml -Encoding UTF8
Set-Content -LiteralPath (Join-Path $docPropsDir "app.xml") -Value $appXml -Encoding UTF8

$resolvedOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

if (Test-Path -LiteralPath $resolvedOutputPath) {
  Remove-Item -LiteralPath $resolvedOutputPath
}

$archive = [System.IO.Compression.ZipFile]::Open($resolvedOutputPath, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  Get-ChildItem -LiteralPath $tempRoot -File -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($tempRoot.Length + 1).Replace("\", "/")
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $_.FullName, $relativePath) | Out-Null
  }
} finally {
  $archive.Dispose()
}

Remove-Item -LiteralPath $tempRoot -Recurse -Force
