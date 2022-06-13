<!--INFOS--
{
  "CreateTime": "2022-06-03T22:50:12.2634592+08:00",
  "Title": "Your First Poster!"
}
--INFOS-->

Welcome to Eight Legged Essay.

This a blog framework that powered by the PowerShell.

You can write the build script yourself to control the whole site!

### Install
The Eight Legged Essay isn't stable,so we don't provide binary file.
You need build it by yourself.

To use Eight Legged Essay,you need .net 6 environemtn.

execute:
```shell
> dotnet run -- arguments here...
```
You can also add the executable file to the PATH to use it everywhere.


### Basic Usgae
Use `EightLeggedEssay --help` to get help.

First,new a site:
```shell
> EightLeggedEssay.exe --new EieDemo

> cd EieDemo
```
This will create a new empty site.

But it has a simple command to use:
```shell
> EightLeggedEssay.exe --run new -- HelloWorld.md
```
This will create a new poster in your content directory.

Open `content/HelloWorld.md`:
```markdown
<!--INFOS--
{
  "CreateTime": "2022-06-12T13:35:06.7416156+08:00",
  "Title": null
}
--INFOS-->

#Hello World!


```

In fact, this command means:call `new` command with argument `HelloWorld.md`

Where is the `new` command? Good question:the `new` command is in the `new.ps`,and we tell EightLeggedEssay the command by configuration file.

Open `EightLeggedEssay.json`,it will likes:
```
{
  "RootUrl": "",
  "OutputDirectory": "site",
  "BuildScript": "build-EightLeggedEssay.ps1",
  "ContentDirectory": "content",
  "SourceDirectory": "source",
  "ThemeDirectory": "theme",
  "UserConfiguration": {},
  "Commands": {
    "new": "new.ps1"
  }
}
```
Ah, the `new` command is in the `Commands`!

And out argument will be sent to the `new.ps` file.

In other way,there is a `build-EightLeggedEssay.ps1` file.If not any commands to passed, EightLeggedEssay will execute it without any arguments.


There is also a repl mode to execute command manually!

### Cmdlets
EightLeggedEssay provided some useful cmdlets for you.

The simply list(may not be complete):

 - System Utilities:
 - - Get-EleVariable
 - - Start-HttpServer
 - - Set-ProcessVariable
 - - Get-ProcessVariable
 - Thread Manage:
 - - New-ThreadJobManager
 - - Start-ThreadJob
 - - Wait-ThreadJob
 - - Invoke-ParallelScriptBlock
 - Markdown:
 - - Convert-Markdown
 - - Convert-MarkdownPoster
 - - Convert-MarkdownPosterHelper
 - Template Engine:
 - - Convert-ScribanTemplate
 - - Get-ScribanTable
 - - Convert-Scriban
 - File System Watcher:
 - - New-FileSystemWatcher
 - - Set-FileSystemWatcherSettings
 - - Start-FileSystemWatcher
 - - Stop-FileSystemWatcher
 - Rss:
 - - New-Rss
 - - Add-RssPoster
 - Other utilities:
 - - Convert-URL
 - - ConvertTo-ThreadSafeHashtable
 - - ConvertTo-RedirectPath
 - - Convert-Paginations
 - - Get-NextPageHelper
 - - Get-PreviousPageHelper
 - - Get-CurrentPageHelper

Documentation is under construction...

