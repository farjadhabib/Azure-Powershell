function New-AzureSlot {
	param (
        [Parameter(Mandatory=$true)]
        [string] $ResourceGroup, #resource groupname to create slot
		[Parameter(Mandatory=$true)]
        [string] $webappName, #appservice name 
        [Parameter(Mandatory=$true)] 
        [string] $SlotName #new slot name
    )

    #get slots in the given resource group
    $Resource = Get-AzureRMResource -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.Web/sites/slots"
    foreach ($item in $Resource)
    {
        if ($item.ResourceType -Match "Microsoft.Web/sites/slots" -and ($item.Name -eq $webappName + "/" + $slotName))
        {
            #if the slot already exists
            Write-Output $slotName" slot is already exist"
        }
        else
        {
            #create new slot otherwise
            Write-Output "Creating the slot: " $SlotName
            New-AzureRmWebAppSlot -Name $webappname -ResourceGroupName $ResourceGroup -Slot $SlotName
            Write-Output "Created slot: $SlotName successfully"
        }

    }

} 

#example command to execute function
Create-AzureSlot -ResourceGroup "<MyResourceGroup>" -WebappName "<MyAppServiceName>" -SlotName "<MySlotName>" -Verbose