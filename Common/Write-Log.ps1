function Write-Log {
    <#
    .SYNOPSIS
        Writes messages to a log file and optionally includes a timestamp.

    .DESCRIPTION
        The Write-Log function is used to write messages to a specified log file. It accepts messages from the pipeline or as direct input and writes them to the console and the log file. The function includes an option to prepend each message with a timestamp.

    .PARAMETER Message
        The message to be logged. This parameter is mandatory and accepts input from the pipeline.

    .PARAMETER Path
        The file path where the log messages will be written. This parameter is mandatory.

    .PARAMETER OutputToConsole
        The message will also output to console.

    .PARAMETER TimeStamp
        A switch that, if specified, prepends the current date and time to each message.

    .INPUTS
        String. The function accepts strings from the pipeline.

    .OUTPUTS
        String. The function writes the log message to the console.

    .EXAMPLES
        # Example 1: Log a simple message to a log file
        Write-Log -Message "This is a log message" -Path "C:\Logs\log.txt"

        # Example 2: Log a message with a timestamp
        Write-Log -Message "This is a timestamped log message" -Path "C:\Logs\log.txt" -TimeStamp

        # Example 3: Log multiple messages from the pipeline
        "Message 1", "Message 2" | Write-Log -Path "C:\Logs\log.txt"

    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$OutputToConsole,

        [switch]$TimeStamp
    )
    begin {
        # Validate if the log file path is valid
        if (-not (Test-Path -Path $Path -IsValid)) {
            Write-Error "Invalid log file path: $Path"
            return
        }
    }
    # Process each input message from the pipeline
    process {
        # Format message with timestamp if $TimeStamp switch is provided
        if ($TimeStamp) {
            $Message = "$(Get-Date -Format 'yyyy-MMM-dd-hh:mm:ss') : $Message"
        }

        # Write message to console and log file
        if ($OutputToConsole) {
            Write-Output $Message
        }
        $Message | Out-File -FilePath $Path -Append
    }
}
