function Switch-AzureAppServiceSlot {

    param (
        [Parameter(Mandatory=$true)]
        [string] $ResourceGroup, #resource groupname to create slot
		[Parameter(Mandatory=$true)]
        [string] $webappName, #appservice name 
        [Parameter(Mandatory=$true)] 
        [string] $SlotName, #slot name to check
        [Parameter(Mandatory=$true)] 
        [string] $From, #the source slot
        [Parameter(Mandatory=$true)] 
        [string] $To #the destination slot
    
    )

    #get the slot
    $Resource = Get-AzureRMResource -ResourceGroupName $ResourceGroup -ResourceType "Microsoft.Web/sites/slots" | Where-Object {$_.Name -eq $webappName + "/" + $slotName}
        
    if($Resource){
        #if the slot exists
        $Start = [System.DateTime]::Now 
        "Starting: " + $Start + $now #.ToString("HH:mm:ss.ffffzzz")
        Switch-AzureRmWebAppSlot -ResourceGroupName $ResourceGroup -Name $webappName -SourceSlotName $From -DestinationSlotName $To -verbose 
        $Finish = [System.DateTime]::Now 
        "Finished " + $Finish.ToString("HH:mm:ss.ffffzzz") 
        $Total = $Finish - $Start
        Write-output "Total Swap time " $Total
    }else{
        #if slot does not exist
        Write-Error -Message "$SlotName does not exist"
    }
    
} Swap-AzureSlot -ResourceGroup "<MyResourceGroup>" -WebappName "<MyAppServiceName>" -SlotName "<MySlotName>" -From "<from slot>" -To "<to slot>" -Verbose