#logging in to Azure Account
Login-AzureRmAccount

#get list of azure subscriptions
$subs = Get-AzureRmSubscription
$i=1;
foreach($sub in $subs){

	#Print each subscription
    Write-Host "$i": $sub.SubscriptionName $sub.CurrentStorageAccountName
    $i++
}
$i--
$slctSub = Read-Host "Please select the subscription(1 - $i)"

#select azure subscription from the list
$slctSub = $slctSub-1
Select-AzureRmSubscription -SubscriptionId $subs[$slctSub].SubscriptionId

#options to choose from create/modify
Write-Host "1 Create New App Service Plan"
Write-Host "2 Modify Existing App Service Plan"
$new = Read-Host "Please select option(1 - 2)"

#if the option is to modify
if($new -eq 2){

	#listing the AppServicePlans
    $plans = Get-AzureRmAppServicePlan
    $i=1;
    foreach($plan in $plans){
        Write-Host "$i": $plan.Name
        $i++
    }
    $i--
    $slctSub = Read-Host "Please select the App Service Plan(1 - $i)"
    $slctSub = $slctSub-1
	
	#selecting the AppServicePlan
    $pln = Get-AzureRmAppServicePlan -Name $plans[$slctSub].Name
	
	#selecting the ResourceGroup
    $rg = $pln.ResourceGroup
}else{

#if the option is to create new service plan
    $plnName = Read-Host "Please enter new app service plan"
    $rgName = Read-Host "Please enter resource group name"
    $rgFull = Get-AzureRmResourceGroup -Name $rgName
    $loc = $rgFull[0].Location
}

#list of AppServicePlan tiers
$tiers = @(Basic, Free, Shared, Standard, Premium)
$i=1;
foreach($tier in $tiers){
    Write-Host "$i": $tier
    $i++
}
$i--
$slctSub = Read-Host "Please select the App Service Plan Tier(1 - 3)"
$slctSub = $slctSub-1

#selecting the AppServicePlan tier
$tier = $tiers[$slctSub]

#listing the AppServicePlan sizes
$sizes = @("Small", "Medium", "Large", "ExtraLarge")
$i=1;
foreach($size in $sizes){
    Write-Host "$i": $size
    $i++
}
$slctSub = Read-Host "Please select the App Service Size(1 - 4)"
$slctSub = $slctSub-1

#selecting the AppServicePlan size
$size = $sizes[$slctSub]

#listing the workers based on AppServicePlan tier
$workers = Read-Host "Please select the App Service Instances(Basic:1-3, Standard:1-10, Premium:1-20)"

if($new -eq 2){

	#modifying existing app service plan
    Write-Host "Modifying App Service Plan"$pln.Name
    if($workers > 0){
        Set-AzureRmAppServicePlan -Name $pln.Name -WorkerSize $size -Tier $tier -ResourceGroupName $rg -NumberofWorkers $workers
    }else{
        Set-AzureRmAppServicePlan -Name $pln.Name -WorkerSize $size -Tier $tier -ResourceGroupName $rg
    }
}else{

	#creating new AppServicePlan
    Write-Host "Creating App Service Plan $plnName"
    New-AzureRmAppServicePlan -Name $plnName -WorkerSize $size -Tier $tier -ResourceGroupName $rgName -Location $loc
}

Write-Host "Done."
