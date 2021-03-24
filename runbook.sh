$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "

    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

    "Logging in to Azure..."
    $connectionResult =  Connect-AzAccount -Tenant $servicePrincipalConnection.TenantID `
                             -ApplicationId $servicePrincipalConnection.ApplicationID   `
                             -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
                             -ServicePrincipal
    "Logged in."

    "Expanding udacity-vmss instances...."
    # Get current scale set
    $vmss = Get-AzVmss -ResourceGroupName "acdnd-c4-project" -VMScaleSetName "udacity-vmss"

    "Increasing to 3 instances..."
    # Set and update the capacity of the scale set to 3
    $vmss.sku.capacity = 3
    Update-AzVmss -ResourceGroupName "acdnd-c4-project" -Name "udacity-vmss" -VirtualMachineScaleSet $vmss

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}