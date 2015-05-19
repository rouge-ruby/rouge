#requires -version 2.0
function Test-Highlighting
{
<#
.Synopsis
Testing powershell highlighting
.Description
Tests powershell highlighting
.Example
Test-Highlighting
#>
param(
[Parameter(Mandatory=$true,
ValueFromPipelineByPropertyName=$true)]
[Alias('Name')]
[String]$Things

# Multi
# Line
# Comment

<#
Second
Multi
Line
Comment
#>

Write-output "Hello" # Adding end-of-line comment

process {
$var1 = $var2
$var3 = get-host | Select-Object -First 1

if ($var1 -eq $var2)
{
    do-something
    return $false
}



"@
Heredoc string
continues on for a bit
"@

}

<#

things 

#>


try {
    write-output "something"
} catch {
    write-output "something else"
}
