Configuration Main {

  Import-DscResource -ModuleName PSDesiredStateConfiguration

  Node Localhost
  {
    Script ConfigureSql
    {
      TestScript = {
        $disks = Get-Disk | Where partitionstyle -eq 'raw'
        if ($disks -ne $null) {
          return $false
        }
        else {
          return $true
        }
      }
      SetScript = {
        Write-Output 'Set Script'
      }
      GetScript = {@{Result = $true}}
    }
  }
}
