function ConvertFrom-Ini {
    <#
    .SYNOPSIS
    Converts INI file content into a PowerShell object.
    
    .DESCRIPTION
    This function takes a string containing INI file content and converts it into a PowerShell object for easy access to the data.
    
    .PARAMETER InputObject
    The content of the INI file as a string or string array.
    
    .EXAMPLE
    # Data from ini Wikipedia
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
        [Parameter(ValuefromPipeline = $True)]
        $InputObject
    )
    begin {
        $script:output = [PSCustomObject]@{}
        $script:section = $null
        $script:ProcessString = [System.Collections.Arraylist]@()
    }
    process {
        $script:ProcessString.add($InputObject) | Out-Null
    }
    end {
        #handles if the string is a raw content format ex: `cat file -raw`
        if($script:ProcessString.Count -eq 1) {$script:ProcessString = $script:ProcessString[0] -split "`n"}
        
        $script:ProcessString | ForEach-Object {
            $_ = $_.Trim()
            if ($_ -match "^\s*;") { return }  # Ignore comments
            if ($_ -match "^\[(.+?)\]") {
                $script:section = $matches[1]
                $script:output | Add-Member -MemberType NoteProperty -Name $script:section -Value ([PSCustomObject]@{})
            }
            elseif ($script:section -and ($_ -match "^(.*?)\s*=\s*(.*)")) {
                $key, $value = $matches[1].Trim(), $matches[2].Trim('"')
                $script:output.$script:section | Add-Member -MemberType NoteProperty -Name $key -Value $value
            }
        }

        return $script:output
    }
}


# $iniString = @"
# ; last modified 1 April 2001 by John Doe
# [owner]
# name = John Doe
# organization = Acme Widgets Inc.

# [database]
# server = 192.0.2.62
# port = 143
# file = "payroll.dat"
# "@

# cat .\test.ini | ConvertFrom-Ini
# $iniString | ConvertFrom-Ini
