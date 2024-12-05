function Convert-ArrayToString {
    <#
    .SYNOPSIS
        Converts an array of strings into a single formatted string.

    .DESCRIPTION
        The Convert-ArrayToString function takes an array of strings and returns a single string with each array element
        enclosed in single quotes and separated by commas.

    .PARAMETER array
        The array of strings to be converted into a formatted string.

    .PARAMETER Delimiter
        The char that use to spaperate the array element
    .EXAMPLE
        $array = @("i1", "i2", "i3", "i4")
        $formattedString = Convert-ArrayToString -array $array
        Write-Host $formattedString
        Output: i1,i2,i3,i4

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $array,
        [char]$Delimiter = ',',
        [char]$WrapElementsWith=''
    )

    if ($array.Count -eq 0) {
        Write-Host "The array is empty."
        return ""
    }

    $formattedArray = $array | ForEach-Object { "$WrapElementsWith{0}$WrapElementsWith" -f $_ }

    $result = $formattedArray -join $Delimiter
    return $result
}

# Example usage:
# $array = @("i1", "i2", "i3", "i4")
# $formattedString = Convert-ArrayToString -array $array
# Write-Host $formattedString