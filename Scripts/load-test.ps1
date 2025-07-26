param(
    [int]$RPS = 10,
    [int]$Duration = 60,
    [string]$Endpoint = "health",
    [string]$BaseUrl = "http://localhost:5000"
)

Write-Host "Starting load test..." -ForegroundColor Green
Write-Host "RPS: $RPS" -ForegroundColor Yellow
Write-Host "Duration: $Duration seconds" -ForegroundColor Yellow
Write-Host "Endpoint: $Endpoint" -ForegroundColor Yellow
Write-Host "Base URL: $BaseUrl" -ForegroundColor Yellow

$results = @()
$startTime = Get-Date
$endTime = $startTime.AddSeconds($Duration)
$interval = 1.0 / $RPS

Write-Host "Test started at: $startTime" -ForegroundColor Cyan

while ((Get-Date) -lt $endTime) {
    $requestStart = Get-Date
    
    try {
        $uri = switch ($Endpoint) {
            "ai-chat" { "$BaseUrl/api/aichat/ask" }
            "orders" { "$BaseUrl/api/orders" }
            "users" { "$BaseUrl/api/users" }
            default { "$BaseUrl/health" }
        }
        
        $body = if ($Endpoint -eq "ai-chat") {
            @{ query = "медленный запрос для тестирования" } | ConvertTo-Json
        } else {
            $null
        }
        
        $headers = @{
            "Content-Type" = "application/json"
        }
        
        $response = if ($body) {
            Invoke-RestMethod -Uri $uri -Method POST -Body $body -Headers $headers -TimeoutSec 10
        } else {
            Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -TimeoutSec 10
        }
        
        $responseTime = ((Get-Date) - $requestStart).TotalMilliseconds
        
        $results += [PSCustomObject]@{
            Timestamp = Get-Date
            ResponseTime = $responseTime
            StatusCode = 200
            Success = $true
        }
        
        Write-Host "Request completed in $([math]::Round($responseTime, 2))ms" -ForegroundColor Green
        
    } catch {
        $responseTime = ((Get-Date) - $requestStart).TotalMilliseconds
        
        $results += [PSCustomObject]@{
            Timestamp = Get-Date
            ResponseTime = $responseTime
            StatusCode = 0
            Success = $false
            Error = $_.Exception.Message
        }
        
        Write-Host "Request failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Sleep to maintain RPS
    $elapsed = ((Get-Date) - $requestStart).TotalMilliseconds / 1000
    if ($elapsed -lt $interval) {
        Start-Sleep -Milliseconds (($interval - $elapsed) * 1000)
    }
}

Write-Host "Test completed at: $(Get-Date)" -ForegroundColor Cyan

# Calculate statistics
$successfulRequests = $results | Where-Object { $_.Success }
$failedRequests = $results | Where-Object { -not $_.Success }
$responseTimes = $successfulRequests | ForEach-Object { $_.ResponseTime }

if ($responseTimes.Count -gt 0) {
    $avgResponseTime = ($responseTimes | Measure-Object -Average).Average
    $minResponseTime = ($responseTimes | Measure-Object -Minimum).Minimum
    $maxResponseTime = ($responseTimes | Measure-Object -Maximum).Maximum
    
    # Calculate percentiles
    $sortedTimes = $responseTimes | Sort-Object
    $p95Index = [math]::Floor($sortedTimes.Count * 0.95)
    $p99Index = [math]::Floor($sortedTimes.Count * 0.99)
    $p95ResponseTime = $sortedTimes[$p95Index]
    $p99ResponseTime = $sortedTimes[$p99Index]
    
    Write-Host "`nTest Results:" -ForegroundColor Green
    Write-Host "Total Requests: $($results.Count)" -ForegroundColor White
    Write-Host "Successful Requests: $($successfulRequests.Count)" -ForegroundColor White
    Write-Host "Failed Requests: $($failedRequests.Count)" -ForegroundColor White
    Write-Host "Success Rate: $([math]::Round(($successfulRequests.Count / $results.Count) * 100, 2))%" -ForegroundColor White
    Write-Host "Average Response Time: $([math]::Round($avgResponseTime, 2))ms" -ForegroundColor White
    Write-Host "Min Response Time: $([math]::Round($minResponseTime, 2))ms" -ForegroundColor White
    Write-Host "Max Response Time: $([math]::Round($maxResponseTime, 2))ms" -ForegroundColor White
    Write-Host "P95 Response Time: $([math]::Round($p95ResponseTime, 2))ms" -ForegroundColor White
    Write-Host "P99 Response Time: $([math]::Round($p99ResponseTime, 2))ms" -ForegroundColor White
    
    # Check for alerts
    if ($p99ResponseTime -gt 500) {
        Write-Host "`n🚨 PERFORMANCE ALERT: P99 response time ($([math]::Round($p99ResponseTime, 2))ms) exceeded 500ms!" -ForegroundColor Red
    }
    
    $actualRPS = $results.Count / $Duration
    if ($actualRPS -gt 100) {
        Write-Host "`n🚨 DATABASE LOAD ALERT: RPS ($([math]::Round($actualRPS, 2))) exceeded 100!" -ForegroundColor Red
    }
} else {
    Write-Host "No successful requests to calculate statistics" -ForegroundColor Yellow
}

Write-Host "`nLoad test completed!" -ForegroundColor Green 