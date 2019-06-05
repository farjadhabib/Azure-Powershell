function Upload-MediaToAZStorage {
    param (
        #storage name
        [Parameter(Mandatory=$true)]
        [string] $StorageName,
        # storage key
        [Parameter(Mandatory=$true)]
        [string] $StorageKey,
        # Container to upload the files to
        [Parameter(Mandatory=$true)]
        [string] $ContainerName,
        # input text file path with list of files to upload
        [Parameter(Mandatory=$true)]
        [string] $TextFilePath,
        # log file path to log all the events
        [Parameter(Mandatory=$true)]
        [string]
        $OutputFilePath
    )
    
    #get contents of file
    $listOfFiles="";
    if(Test-Path $TextFilePath){
        #if file is present get the contents
        $listOfFiles = Get-Content $inputFile
    }else{
        #write error if file is not there
        Log-ToOurPutFile -OutputFile $OutputFilePath -Message "Input file not found. Please check file path and restart." -MessageType "Error"
    }

    #get storage context
    $ctx = New-AzureStorageContext -StorageAccountName $StorageName -StorageAccountKey $StorageKey 
    #get storage container
    $container = Get-AzureStorageContainer -Context $ctx | Where-Object { $_.Name -eq $ContainerName }
    if($container -eq $null){
        # if storage does not exist create one
        Log-ToOurPutFile -OutputFile $OutputFilePath -Message "Container does not exist. Creating new container with name, $ContainerName" -MessageType "Info"
        $container = New-AzureStorageContainer -Name $containerName -Context $ctx -Permission Blob
    }
    
    #Counting the numer of files
    $count = 1

    #Starting the upload
    Log-ToOurPutFile -OutputFile $OutputFilePath -Message "UPLOADING FOR : STORAGE[$StorageName], CONTAINER[$ContainerName]"  -MessageType "Info"
    foreach($filePath in $listOfFiles){
        if(Test-Path $filePath){
            #if file exist on local
            $fileProp = Get-ItemProperty $filePath
            $blobname = $fileProp.Name

            try{
                #check if file already exists in the container
                $fileAlreadyInThere = Get-AzureStorageBlob -Container $ContainerName -Context $ctx | Where-Object { $_.Name -eq $blobname }
                if($fileAlreadyInThere -eq $null){
                    #if file does not exist then upload it
                    Set-AzureStorageBlobContent -Blob $file.Name -Container $containerName -File $filePath -Context $ctx -Force
                    Log-ToOurPutFile -OutputFile $OutputFilePath -Message "File[$count] : [$blobname], Success" -MessageType "Info"
                }else{
                    #log that file already exists
                    Log-ToOurPutFile -OutputFile $OutputFilePath -Message "File[$count] : [$blobname], File already exists" -MessageType "Info"
                }
            }catch{
                #if any error is caught
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                #log the exception
                Log-ToOurPutFile -OutputFile $OutputFilePath -Message "File[$count] : [$blobname], Failed: [$ErrorMessage]" -MessageType "Error"
            }
            $count++
        }
        else{
            #log the error message
            Log-ToOurPutFile -OutputFile $OutputFilePath -Message "File[$count] : [$filePath], File does not exist" -MessageType "Error"
        }
    }
}

#helper function to log the output to files
function Log-ToOurPutFile {
    param (
        # Output file Path
        [Parameter(Mandatory=$true)]
        [string]
        $OutputFile,
        # Message to Log
        [Parameter(Mandatory=$true)]
        [string]
        $Message,
        # type of log
        [Parameter(Mandatory=$true)]
        [string] $MessageType
    )

    #get current time for timekeeping
    $timestamp = Get-Date -f MMddyyyyHHmmss

    if(Test-Path $OutputFile){
        #if file is present write to file
        Add-Content -Path $OutputFile -Value "$timestamp -- $MessageType\: $Message"
    }else{
        #create the file with specified path
        New-Item -Path $OutputFile -ItemType file -Force
        Add-Content -Path $OutputFile -Value "$timestamp -- $MessageType\: $Message"
    }
}

#example function call
Upload-MediaToAZStorage -StorageName "<storage name>" -StorageKey "<storage key>" -ContainerName "<container name>" -TextFilePath "<input file with one file path each line>" -OutputFilePath "<log file path>" -Verbose