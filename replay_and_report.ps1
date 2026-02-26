function Run-WafTest {
    param (
        [string]$Name,
        [string]$Path
    )
    Write-Host "Replaying: $Name" -ForegroundColor Cyan
    $fullUrl = "http://localhost:8080$Path"
    # Execute attack, send output to NUL
    curl.exe -s -i --path-as-is "$fullUrl" --max-time 5 -o NUL
}

Write-Host "Starting Replay of Laboratory Attacks..." -ForegroundColor Magenta

# 1. SQL Injection Simple
Run-WafTest "SQLi - OR 1=1" "/rest/products/search?q=%27%20OR%201%3D1--"

# 2. XSS Script tag
Run-WafTest "XSS - Script Tag" "/rest/products/search?q=<script>alert(1)</script>"

# 3. Path Traversal
Run-WafTest "Path Traversal - etc/passwd" "/ftp/../../../../etc/passwd"

# 4. Command Injection
Run-WafTest "Command Injection - whoami" "/rest/products/search?q=|whoami"

Write-Host "Replay complete. Extracting structured logs..." -ForegroundColor Magenta
Start-Sleep -Seconds 3

# Capture the last 300 lines to ensure we get the full JSON blocks
$logLines = docker logs --tail 300 modintel-nginx-1

$report = @()
$report += "# ModSecurity Attack Analysis Report"
$report += "Generated on: $(Get-Date)"
$report += ""
$report += "| Status | URI | Rule ID | Message | Matched Data |"
$report += "| :--- | :--- | :--- | :--- | :--- |"

foreach ($line in $logLines) {
    # Match the start of the JSON block
    if ($line -match '^{"transaction":') {
        try {
            $data = $line | ConvertFrom-Json
            $uri = $data.transaction.request.uri
            $status = $data.transaction.response.http_code
            
            # Filter noise from background socket.io polling
            if ($uri -match "socket.io") { continue }

            foreach ($msg in $data.transaction.messages) {
                # In this JSON format, ruleId is specifically inside "details"
                $ruleId = $null
                if ($msg.details -and $msg.details.ruleId) {
                    $ruleId = $msg.details.ruleId
                } elseif ($msg.ruleId) {
                    $ruleId = $msg.ruleId
                }
                
                # Skip summary/noise rule IDs if needed, but here we want to see them
                if (-not $ruleId) { continue }
                
                $msgTxt = $msg.message
                $matchData = $msg.details.data
                
                # Format for Markdown
                $matchDataClean = if ($matchData) { "``$matchData``" } else { "-" }
                $uriClean = "``$uri``"
                
                $report += "| $status | $uriClean | **$ruleId** | $msgTxt | $matchDataClean |"
            }
        } catch {
            # Skip invalid JSON or parsing errors
        }
    }
}

$report | Out-File "c:\Users\Hp\Downloads\modintel\attack_report.md" -Encoding utf8
Write-Host "Report generated: attack_report.md" -ForegroundColor Green
