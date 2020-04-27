<#
.SYNOPSIS
This will provide a detailed table of all the containers created within your Docker

.LINK
https://hub.docker.com/editions/community/docker-ce-desktop-windows/

.REQUIEREMENTS 
Have Docker for Windows 10 Installed and properly configured
PowerShell v5 or v7

.Author
ivanjrt @ gmail.com
#>

Clear-host
$repotTable = New-Object System.Collections.Generic.List[System.Object]
$containers =  $(docker ps -qa)
foreach ($container in $containers){
	$repotTable.Add([pscustomobject]@{
		ContainerName =  $((docker inspect --format '{{ .Name }}' $container).trim('/'))
		DockerID = docker inspect --format '{{ .Config.Hostname }}' $container
		Image = docker inspect --format '{{ .Config.Image }}' $container
		IpAddress = docker inspect $container --format '{{ .NetworkSettings.IPAddress }}'
		GateWay = docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' $container
		MacAddress = docker inspect -f '{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $container
		Status = $stat = docker inspect --format '{{ .State.Status }}' $container 
		Started = (($(docker inspect --format '{{ .State.StartedAt}}' $container)) -as [datetime]).toLocalTime()
		RunningAge = if($stat -eq 'running'){(get-date) - (($(docker inspect --format '{{ .State.StartedAt}}' $container)) -as [datetime]).toLocalTime()}
	})
}
$repotTable | sort-object Status|  ft
