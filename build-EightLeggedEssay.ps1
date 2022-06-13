
#----------------------------------------------------
# 读取配置文件
$config = Get-EleVariable Configuration | ConvertFrom-Json

# we work on the local host
if(-not([string]::IsNullOrEmpty((Get-EleVariable ServerPath)))){
    $config.RootUrl = "http://localhost:8848/"
    Write-Host "local server is enabled! ignore server path"
    Write-Host "to release the site, rexecute without --server"
}

$CACHE_DIR = $config.UserConfiguration.CacheDirectory

# 创建缓存目录
if(-not(Test-Path $CACHE_DIR)){
    New-Item -Path $CACHE_DIR -ItemType directory
}

#----------------------------------------------------
# compile scss
&"sass" --update --style=compressed "source/sass/main.scss" "${CACHE_DIR}/sass/maim.css"

#----------------------------------------------------
# compile posters to part html

$output = $null

$pages = $null

function Get-NextPage{
    [OutputType([string])]
    param($page)
    
    $value = Get-NextPageHelper $page

    if($null -ne $value){
        return Convert-URL -RootUrl $config.RootURL -RelativeTo $config.OutputDirectory -Target ($config.OutputDirectory + "/" + $value)
    }
    else{
        return $null
    }
}

function Get-PreviousPage{
    [OutputType([string])]
    param($page)
    $value = Get-PreviousPageHelper $page

    if($null -ne $value){
        return Convert-URL -RootUrl $config.RootURL -RelativeTo $config.OutputDirectory -Target ($config.OutputDirectory + "/" + $value)
    }
    else{
        return $null
    }
}

# compile poster.html
# $posterOut = @{}
function CompilePosters {
     $output = Convert-MarkdownPosterHelper -Path $config.ContentDirectory -OutPath $CACHE_DIR | Sort-Object -Property CreateTime -Descending 
     $pages = Convert-Paginations -PostersPerPage 4 -Posters $output

     $pages | Set-ProcessVariable "Paginations"

     foreach($page in $output){
        $table = @{
            Poster = $page
        }

        $outputPath = ConvertTo-RedirectPath -OriginPath $page.CompiledPath -OriginDirectory $CACHE_DIR -TargetDirectory $config.OutputDirectory

        $outputPath += ".html"

        $url = Convert-URL -RootUrl $config.RootURL -RelativeTo $config.OutputDirectory -Target $outputPath

        Write-Host "Compiled ${url}"

        $page.ExtendedData["URL"] = $url

        Convert-ScribanTemplate -TemplateFile "theme/item.scriban-html" -OutputFile $outputPath -Attributes $table
    }
}

# compile index.html
function CompileIndex {

    $pages = Get-ProcessVariable "Paginations"

    foreach($page in $pages.Value){
        $table = @{
            Paginations = $page
        }

        $outputPage = $config.OutputDirectory + "/" + ($page.CurrentPageNumber) + "_index.html"

        if($page["IsFirstPage"]){
            $outputPage = ($config.OutputDirectory + "/index.html")
        }

        $table["NextPageUrl"] = Get-NextPage $page
        $table["PreviousPageUrl"] = Get-PreviousPage $page

        Convert-ScribanTemplate -TemplateFile "theme/main.scriban-html" -OutputFile $outputPage -Attributes $table
    }
}

CompilePosters
CompileIndex

# start server and
# watch file system
if(-not([string]::IsNullOrEmpty((Get-EleVariable ServerPath)))){
    Start-HttpServer $config.OutputDirectory

    New-FileSystemWatcher -Path (Get-Item("./" + $config.ContentDirectory)).ToString() | Set-FileSystemWatcherSettings -OnChanged | Start-FileSystemWatcher
    New-FileSystemWatcher -Path (Get-Item("./" + $config.ThemeDirectory)).ToString() | Set-FileSystemWatcherSettings -OnChanged | Start-FileSystemWatcher

    while($true){
        $e = Wait-Event -SourceIdentifier "FileSystemWatcher.OnChanged"

        CompilePosters
        CompileIndex

        $e | Remove-Event
    }
}