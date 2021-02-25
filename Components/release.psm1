function Publish-PSUModule {
    param(
        $SourceDirectory,
        $ModuleName
    )

    $Folder = Join-Path ([IO.Path]::GetTempPath()) $ModuleName
    Remove-Item $Folder -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item $SourceDirectory $Folder -Container -Recurse

    $Module = Import-Module "$Folder" -PassThru -Scope Global -ErrorAction Continue 

    if (-not $Module)
    {
        throw "Failed to load: $ModuleName"
    }

    $ExistingModule = Find-Module -Name $Module.Name -RequiredVersion $Module.Version -ErrorAction SilentlyContinue
    if (-not $ExistingModule)
    {
        Publish-Module -Path "$Folder" -NuGetApiKey $Env:PowerShellGalleryKey
    }
}