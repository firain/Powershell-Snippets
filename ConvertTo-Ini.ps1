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
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [psobject]$InputObject
    )

    $output = ""

    foreach ($section in $InputObject.PSObject.Properties) {
        $output += "`n[$($section.Name)]`n"
        foreach ($property in $section.Value.PSObject.Properties) {
            $value = $property.Value
            if ($value -is [string] -and $value.Contains(" ")) {
                $value = "`"$value`""
            }
            $output += "$($property.Name) = $value`n"
        }
    }

    return $output.Trim()
}