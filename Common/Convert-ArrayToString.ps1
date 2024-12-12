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
        The char that use to separate the array element
    .EXAMPLE
        $array = @("i1", "i2", "i3", "i4")
        $formattedString = Convert-ArrayToString -array $array
        Write-Host $formattedString
        Output: i1,i2,i3,i4

    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$array,

        [Parameter(Mandatory = $false)]
        [string]$Delimiter = ",",

        [Parameter(Mandatory = $false)]
        [string]$WrapElementsWith = ""
    )

    begin {
        # Initialize an empty array to collect input elements
        $collectedArray = @()
    }

    process {
        # Collect input elements from the pipeline
        if ($null -ne $array) {
            $collectedArray += $array
        }
    }

    end {
        # Apply wrapping if specified
        if ($WrapElementsWith) {
            $processedArray = $collectedArray | ForEach-Object {
                "$WrapElementsWith$_$WrapElementsWith"
            }
        } else {
            $processedArray = $collectedArray
        }

        # Join the array elements with the specified delimiter
        $result = $processedArray -join $Delimiter

        # Output the result
        Write-Output $result
    }
}
