# Runs every read-only request file in requests/ and prints its output.
# Skips *.example.yml (templates, not meant to be run directly) and
# create-issue.yml (the real, gitignored, token-filled copy -- opt in to
# that one explicitly, since it writes a real issue).
Get-ChildItem requests -Filter "*.yml" |
    Where-Object { $_.Name -notlike "*.example.yml" -and $_.Name -ne "create-issue.yml" } |
    ForEach-Object {
        Write-Host "`n=== $($_.Name) ===" -ForegroundColor Cyan
        bettercurl -f $_.FullName -c
    }
