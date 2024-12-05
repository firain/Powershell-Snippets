function Expand-CBZ {
    <#
    .SYNOPSIS
    Extracts files from a CBZ (Comic Book ZIP) file.

    .DESCRIPTION
    This function extracts the contents of a CBZ file into a specified destination folder.

    .PARAMETER Path
    Specifies the path to the CBZ file to be extracted.

    .PARAMETER DestinationPath
    Specifies the destination directory where the contents of the CBZ file will be extracted.
    If not specified, files will be extracted to a folder with the same name as the CBZ file.

    .EXAMPLE
    Expand-CBZ -Path "C:\Comics\Comic1.cbz" -DestinationPath "C:\Comics\ExtractedComic1"

    Extracts the contents of "Comic1.cbz" into the "ExtractedComic1" folder.

    .EXAMPLE
    Expand-CBZ -Path "C:\Comics\Pages.cbz"

    # Extract to current location
    Expand-CBZ -Path "C:\Comics\Pages.cbz" -DestinationPath ./

    Extracts the contents of "Pages.cbz" into a folder named "Pages" in the current directory.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [string]$DestinationPath
    )

    process {
        # Check if the file exists and has the .cbz extension
        if (-not (Test-Path -Path $Path)) {
            throw "The specified CBZ file does not exist: $Path"
        }
        if (-not ($Path -match "\.cbz$")) {
            throw "The specified file is not a CBZ file: $Path"
        }

        # Determine destination path if not specified
        if (-not $DestinationPath) {
            $DestinationPath = Join-Path -Path (Get-Location) -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        }

        # Rename .cbz to .zip temporarily
        $tempZipPath = [System.IO.Path]::ChangeExtension($Path, "zip")
        Copy-Item -Path $Path -Destination $tempZipPath -Force

        # Expand the ZIP archive
        Expand-Archive -Path $tempZipPath -DestinationPath $DestinationPath -Force

        # Remove the temporary ZIP file
        Remove-Item -Path $tempZipPath -Force
    }
}