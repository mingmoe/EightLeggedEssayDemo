
# create a new poster
if($args.Length -ne 1){
    Write-Error "input a argument as poster relative path to create a new poster"
    return
}

$config = Get-EleVariable Configuration | ConvertFrom-Json

$File = [System.IO.Path]::GetFullPath(($config.ContentDirectory) + "/" + ($args[0]))

$NewPosterHeader = @{ }

$NewPosterHeader["Title"] = $args[0]
$NewPosterHeader["CreateTime"] = Get-Date

New-Item -Path $File -ItemType file

("<!--INFOS--`n{0}`n--INFOS-->`n`n#Hello World!`n" -f ($NewPosterHeader | ConvertTo-Json)) | Out-File -FilePath $File -Encoding "UTF-8"
