function Compress-CBZ {
    <#
    .SYNOPSIS
    Compresses files and folders into a CBZ (Comic Book ZIP) file.

    .DESCRIPTION
    This function compresses a single file, multiple files, or folders into a CBZ file, which is a ZIP file with a .cbz extension.

    .PARAMETER Path
    Specifies the path to the file(s) or folder(s) to be compressed. Accepts a single path or a list of paths.

    .PARAMETER DestinationPath
    Specifies the path for the output CBZ file. If not specified, the CBZ file will be created in the current directory with the name of the first item in Path.

    .EXAMPLE
    Compress-CBZ -Path "C:\Images\Comic1" -DestinationPath "C:\Comics\Comic1.cbz"

    Compresses the "Comic1" folder into "Comic1.cbz" in the C:\Comics directory.

    .EXAMPLE
    Compress-CBZ -Path "C:\Images\Page1.jpg","C:\Images\Page2.jpg" -DestinationPath "C:\Comics\Pages.cbz"

    Compresses "Page1.jpg" and "Page2.jpg" into "Pages.cbz" in the C:\Comics directory.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$Path,

        [Parameter(Mandatory=$false)]
        [string]$DestinationPath
    )

    process {
        # Determine destination path if not specified
        if (-not $DestinationPath) {
            $firstItemName = [System.IO.Path]::GetFileNameWithoutExtension($Path[0])
            $DestinationPath = Join-Path -Path (Get-Location) -ChildPath "$firstItemName.cbz"
        } elseif (-not ($DestinationPath -match "\.cbz$")) {
            $DestinationPath = "$DestinationPath.cbz"
        }

        # Create a temporary zip file
        $tempZipPath = [System.IO.Path]::ChangeExtension($DestinationPath, "zip")
        Compress-Archive -Path $Path -DestinationPath $tempZipPath -Force

        # Rename the .zip file to .cbz
        Rename-Item -Path $tempZipPath -NewName $DestinationPath -Force
    }
}
