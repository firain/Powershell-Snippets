function ConvertTo-Ini {
    <#
    .SYNOPSIS
    Converts a PowerShell object into INI format.

    .DESCRIPTION
    This function takes a PowerShell object and converts it into an INI file formatted string.

    .PARAMETER InputObject
    The PowerShell object to convert to INI format.

    .EXAMPLE
    $psObject = [PSCustomObject]@{
        owner = [PSCustomObject]@{
            name = "John Doe"
            organization = "Acme Widgets Inc."
        }
        database = [PSCustomObject]@{
            server = "192.0.2.62"
            port = 143
            file = "payroll.dat"
        }
    }
    $iniString = ConvertTo-Ini -Object $psObject
    # Output:
    # [owner]
    # name = John Doe
    # organization = Acme Widgets Inc.
    #
    # [database]
    # server = 192.0.2.62
    # port = 143
    # file = "payroll.dat"

    .NOTES
    Limitation: only accept object format in the example
    no error handling for now. will be added in the future
    psObject console output
    owner                                            database
    -----                                            --------
    @{name=John Doe; organization=Acme Widgets Inc.} @{server=192.0.2.62; port=143; file=payroll.dat}
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]$InputObject
    )

    $output = ""
    try {
        foreach ($section in $InputObject.PSObject.Properties) {
            $output += "`n[$($section.Name)]`n"
            foreach ($property in $section.Value.PSObject.Properties) {
                $value = $property.Value
                if ($value -is [string] -and $value.Contains(" ")) {
                    $value = "`"$value`""
                }
                $output +="$($property.Name) = $value`n"
            }
        }
    }catch{
        Write-Host "Not able to process data`nerror: $_"
    }

    return $output.Trim()
}

$psObject = [PSCustomObject]@{
    owner = [PSCustomObject]@{
        name = "John Doe"
        organization = "Acme Widgets Inc."
    }
    database = [PSCustomObject]@{
        server = "192.0.2.62"
        port = 143
        file = "payroll.dat"
    }
}

# Convertto-ini -InputObject $psObject
# $psObject | ConvertTo-Ini
# $null | ConvertTo-Ini
