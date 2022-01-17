[parm]:saveHTML = 0
[parm]:title    = 'CodeBrowser Release Notes'

# Release Notes 2.0.0

Note that with version 2.0.0 CodeBrowser has its own installer which does perform two tasks:

1. It installs all Tatin packages required by CodeBrowser into a standard folder designated to host Tatin packages required by any Dyalog user command

2. It copies the script that is the real thing into a folder where any compatiable version of Dyalog will find it


The script wil check whether the code has already been loaded into `⎕SE`. If not it will load the CodeBrowser package and all its dependencies into `⎕SE._tatin`.

From then on the user command will remain available.