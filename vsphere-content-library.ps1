
# Variables
$vCenter = "192.168.7.10"
$admin = "administrator@vsphere.local"  
$password = ConvertTo-SecureString -String "VMware1!" -AsPlainText -Force
$Content_Library = "Content-Library"
$Item_Name = "VMware-NSX-Manager-6.3.3-6276725"
$Folder_Name = "NSX_Test"


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

# Get library GUID
$request = invoke-WebRequest -Uri "https://$($vCenter)/rest/com/vmware/content/library" -Method Get -Headers $session
$libraries = (ConvertFrom-Json $request.Content).value

ForEach ($library in $libraries) {
    $request = invoke-WebRequest -Uri "https://$($vCenter)/rest/com/vmware/content/library/id:$($library)" -Method Get -Headers $session
    $libraryObject = (ConvertFrom-Json $request.Content).value
    write-host "Library name: $($libraryObject.name)"
    If ($libraryObject.name -eq $Content_Library) {
        $LibraryID = $libraryObject.id
    }
    #break
}


# Get library items
$request = invoke-WebRequest -Uri "https://$($vCenter)/rest/com/vmware/content/library/item?library_id=$($LibraryID)" -Method Get -Headers $session
$items = (ConvertFrom-Json $request.Content).value

ForEach ($item in $items) {
    $request = invoke-WebRequest -Uri "https://$($vCenter)/rest/com/vmware/content/library/item/id:$($item)" -Method Get -Headers $session
    $itemObject = (ConvertFrom-Json $request.Content).value
    write-host "Item name: $($itemObject.name)"
    If ($itemObject.name -eq $Item_Name) {
        $NSX_ID = $item
    }
    #break

}



# Get library items
$request = invoke-WebRequest -Uri "https://$($vCenter)/rest/vcenter/folder" -Method Get -Headers $session
$Folders = (ConvertFrom-Json $request.Content).value
ForEach ($folder in $Folders){
    If ($folder.name -eq $Folder_Name){
        write "Folder ID: $($folder.folder)"
        $Folder_ID = $folder.folder
    }
}

# Get library items
#$request = invoke-WebRequest -Uri "https://$($vCenter)/rest/com/vmware/vcenter/ovf/library-item/id:$($NSX_ID)?~action=filter" -Method Post -Headers $session

#$NSXOvfTemplate = (ConvertFrom-Json $request.Content).value
#write-host "NSX Ovf config: $($NSXOvfTemplate)"


