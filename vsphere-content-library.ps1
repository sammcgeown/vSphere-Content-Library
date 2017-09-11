
$vCenter = "192.168.7.10"
$admin = "administrator@vsphere.local"  
$password = ConvertTo-SecureString -String "VMware1!" -AsPlainText -Force

$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $admin, $password

# SSL prompt disregard
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback=@"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public class ServerCertificateValidationCallback
{
public static void Ignore()
{
if(ServicePointManager.ServerCertificateValidationCallback ==null)
{
ServicePointManager.ServerCertificateValidationCallback +=
delegate
(
Object obj,
X509Certificate certificate,
X509Chain chain,
SslPolicyErrors errors
)
{
return true;
};
}
}
}
"@
Add-Type $certCallback
}
[ServerCertificateValidationCallback]::Ignore();



$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Credential.UserName+':'+$Credential.GetNetworkCredential().Password))
$head = @{
'Authorization' = "Basic $auth"
}

$authuri = "https://$($vCenter)/rest/com/vmware/cis/session"

#Authenticate against vCenter
$r = Invoke-WebRequest -Uri $authuri -Method Post -Headers $head
$token = (ConvertFrom-Json $r.Content).value
Write-Host $token
$session = @{'vmware-api-session-id' = $token}