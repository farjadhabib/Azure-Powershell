function Stop-AzureAppServiceSlot {
	param (
        [Parameter(Mandatory=$true)]
        [string] $ResourceGroup, #resource groupname to create slot
		[Parameter(Mandatory=$true)]
        [string] $webappName, #appservice name 
        [Parameter(Mandatory=$true)] 
        [string] $SlotName #slot name to stop
    )

    #get the slot
    $Resource = Get-AzureRMResource -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.Web/sites/slots" | Where-Object {$_.Name -eq $webappName + "/" + $slotName}
    if($Resource){
        #if slot exists
        Stop-AzureRmWebAppSlot -ResourceGroupName $ResourceGroup -Name $webappName -Slot $SlotName
        Start-Sleep -s 10 #give slot 10 sec to stop
        if (Get-AzureRmWebAppSlot -ResourceGroupName $ResourceGroup -Name $webappName | where {$_.State -eq "Stopped"})
        {
        Write-Output  ($SlotName + " Slot status is Stopped")
        }
        else 
        {
        Write-Error -Message "Staging slot status is Started"
        #Write-Output  ($SlotName + "Slot status is Started")
        }
    }else{
        #if slot does not exist
        Write-Error -Message "$SlotName does not exist"
    }
} 

#example function call
Stop-AzureAppServiceSlot -ResourceGroup "<MyResourceGroup>" -WebappName "<MyAppServiceName>" -SlotName "<MySlotName>" -Verbose