$vCenter = 192.168.7.10
$admin = administrator@vsphere.local   
$password = 

$Credential = Get-Credential
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Credential.UserName+':'+$Credential.GetNetworkCredential().Password))
$head = @{
'Authorization' = "Basic $auth"
}

#Authenticate against vCenter
$r = Invoke-WebRequest -Uri https://$($vCenter)/rest/com/vmware/cis/session -Method Post -Headers $head
$token = (ConvertFrom-Json $r.Content).value
$session = @{'vmware-api-session-id' = $token}