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
