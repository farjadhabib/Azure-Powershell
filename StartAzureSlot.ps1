function Start-AzureAppServiceSlot {
	param (
        [Parameter(Mandatory=$true)]
        [string] $ResourceGroup, #resource groupname to create slot
		[Parameter(Mandatory=$true)]
        [string] $webappName, #appservice name 
        [Parameter(Mandatory=$true)] 
        [string] $SlotName #slot name to start
    )

    #get the slot
    $Resource = Get-AzureRMResource -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.Web/sites/slots" | Where-Object {$_.Name -eq $webappName + "/" + $slotName}
        
    if($Resource){
        #if slot exists
        Start-AzureRmWebAppSlot -ResourceGroupName $ResourceGroup -Name $webappName -Slot $SlotName

        #wait for the slot to start - 10 seconds
        Start-Sleep -s 10
        if (Get-AzureRmWebAppSlot -ResourceGroupName $ResourceGroup -Name $webappName | where {$_.State -eq "Running"})
        {
            #if the slot is started
            Write-Output  ($SlotName + " Slot status is Started")
        }
        else 
        {
            #if the slot does not start
            Write-Error -Message "Staging slot status is stopped"
            Write-Output  ($SlotName + "Slot status is Stopped")
        }
    }else{
        #if slot does not exist
        Write-Error -Message "$SlotName does not exist"
    }
} 
#example of function call
Start-AzureAppServiceSlot -ResourceGroup "<MyResourceGroup>" -WebappName "<MyAppServiceName>" -SlotName "<MySlotName>" -Verbose