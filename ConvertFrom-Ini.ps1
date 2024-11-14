function ConvertFrom-Ini {
    <#
    .SYNOPSIS
    Converts INI file content into a PowerShell object.
    
    .DESCRIPTION
    This function takes a string containing INI file content and converts it into a PowerShell object for easy access to the data.
    
    .PARAMETER InputObject
    The content of the INI file as a string.
    
    .EXAMPLE
    $iniString = @"
    ; last modified 1 April 2001 by John Doe
    [owner]
    name = John Doe
    organization = Acme Widgets Inc.

    [database]
    server = 192.0.2.62
    port = 143
    file = "payroll.dat"
    "@
    $result = ConvertFrom-Ini -InputObject $iniString
    $result.owner.name
    # Output: John Doe
    
    $result.database.port
    # Output: 143
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string]$InputObject
    )

    $output = [PSCustomObject]@{}
    $section = $null

    $InputObject -split "`n" | ForEach-Object {
        $_ = $_.Trim()
        if ($_ -match "^\s*;") { return }  # Ignore comments
        if ($_ -match "^\[(.+?)\]") {
            $section = $matches[1]
            $output | Add-Member -MemberType NoteProperty -Name $section -Value ([PSCustomObject]@{})
        }
        elseif ($section -and ($_ -match "^(.*?)\s*=\s*(.*)")) {
            $key, $value = $matches[1].Trim(), $matches[2].Trim('"')
            $output.$section | Add-Member -MemberType NoteProperty -Name $key -Value $value
        }
    }

    return $output
}
