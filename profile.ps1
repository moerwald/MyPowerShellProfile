
# Alias methods
#####
function buildSolution {
    [cmdletbinding()]
    param (
        [string] $pathToSolution
    )

    Process {
        Invoke-MsBuild -Path $pathToSolution  -Params "/target:Clean;Build" -ShowBuildOutputInCurrentWindow
    }
}

function Start-Plantuml {
    docker container run -d --platform=linux --rm -p 8080:8080 plantuml/plantuml-server:tomcat
    start http://localhost:8080
}

function Start-Vim  {
        docker run --platform=linux --rm -it -v c:/:/data moerwald33/alpine_vim
}

function Start-NVimInCurrentDir {
    $location = ((Get-Location | select -ExpandProperty path) -replace "\\", "/") -replace "C:", "/data"
    Write-Host "Starting nvim in location $location"
    Start-NVIM -command "nvim" -args $location
}

function Start-NVim {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)] 
        [string] $command = $null,
        [Parameter(Mandatory = $false, Position = 1)] 
        [string] $args = $null
    )
    
    if (!$command -and !$args){
        docker run --platform=linux --rm -it -v c:/:/data moerwald33/python-nvim
    }
    elseif ($command -and !$args){
        docker run --platform=linux --rm -it -v c:/:/data moerwald33/python-nvim $command
    }
    else{
        docker run --platform=linux --rm -it -v c:/:/data moerwald33/python-nvim $command $args
    }
}

function Start-SpaceVim{
        docker run --platform=linux --rm -it -v "$($(PWD).Path):/home/spacevim/src" spacevim/spacevim
}



# Alias with custom parameters
#####

# Alias without custom parameters
#####
Set-Alias code code-insiders.cmd
Set-Alias push Push-Location
Set-Alias pop  Pop-Location
  
# Imports
#####
Import-Module Subversion
Import-Module posh-git


#####
# Mount message of the day script
.  "C:\Users\mewalda\Documents\WindowsPowerShell\Get-MOTD_v2.ps1"

get-motd


$env:HOMEPATH="C:\users\mewalda"
$env:HOME="C:\users\mewalda"

$orgPrompt = Get-Content -Path Function:\prompt

function prompt{
    
    if (Test-Path .git){
        $gitPrompt = Get-Variable GitPromptScriptBlock -ValueOnly
        if ($gitPrompt) {
            & $gitPrompt
        }
        ">>"
    }
    else{
        & $orgPrompt
    }
}
