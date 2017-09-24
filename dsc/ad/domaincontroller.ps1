Configuration DscConfDomainController {
  Import-DscResource -ModuleName xActiveDirectory, xStorage, PSDesiredStateConfiguration, xDSCDomainjoin
  $dscDomainAdmin = Get-AutomationPSCredential -Name 'addcDomainAdmin'
  $dscDomainName = Get-AutomationVariable -Name 'addcDomainName'
  $dscDomainNetbiosName = Get-AutomationVariable -Name 'addcDomainNetbiosName'
  $dscSafeModePassword = $dscDomainAdmin
  $DomainRoot = "DC=$($dscDomainAdmin -replace '\.',',DC=')"
  $dscDomainJoinAdminUsername = $dscDomainAdmin.UserName
  $dscDomainJoinAdmin = new-object -typename System.Management.Automation.PSCredential -argumentlist "$dscDomainName\$dscDomainJoinAdminUsername", $dscDomainAdmin.Password

  node FirstDC
  {

    WindowsFeature DNS
    {
      Ensure = "Present"
      Name = "DNS"
    }

    WindowsFeature DnsTools
    {
      Ensure = "Present"
      Name = "RSAT-DNS-Server"
      DependsOn = "[WindowsFeature]DNS"
    }

    xWaitforDisk Disk2
    {
      DiskNumber = 2
      RetryIntervalSec = 20
      RetryCount = 30
    }

    xDisk ADDataDisk {
      DiskNumber = 2
      DriveLetter = "F"
      DependsOn = "[xWaitForDisk]Disk2"
    }

    WindowsFeature ADDSInstall
    {
      Ensure = "Present"
      Name = "AD-Domain-Services"
      DependsOn="[WindowsFeature]DNS"
    }

    WindowsFeature ADDSTools
    {
      Ensure = "Present"
      Name = "RSAT-ADDS-Tools"
      DependsOn = "[WindowsFeature]ADDSInstall"
    }

    WindowsFeature ADAdminCenter
    {
      Ensure = "Present"
      Name = "RSAT-AD-AdminCenter"
      DependsOn = "[WindowsFeature]ADDSInstall"
    }

    xADDomain FirstDS
    {
      DomainName = $dscDomainName
      DomainAdministratorCredential = $dscDomainAdmin
      SafemodeAdministratorPassword = $dscSafeModePassword
      DomainNetBIOSName = $dscDomainNetbiosName
      DatabasePath = "F:\NTDS"
      LogPath = "F:\NTDS"
      SysvolPath = "F:\SYSVOL"
      DependsOn = "[xDisk]ADDataDisk"
    }

    xADUser FirstUser
    {
      DomainName = $dscDomainName
      UserName = $dscDomainAdmin.Username
      Password = $dscDomainAdmin
      PasswordNeverExpires = $true
      Ensure = "Present"
      DependsOn = "[xADDomain]FirstDS"
    }

    xADGroup DomainAdmins
    {
      GroupName = 'Domain Admins'
      MembersToInclude = $dscDomainAdmin.Username
      DependsOn = "[xADUser]FirstUser"
    }
  }


  node AdditionalDC
  {

    WindowsFeature DNS
    {
      Ensure = "Present"
      Name = "DNS"
    }

    WindowsFeature DnsTools
    {
      Ensure = "Present"
      Name = "RSAT-DNS-Server"
      DependsOn = "[WindowsFeature]DNS"
    }

    xWaitforDisk Disk2
    {
      DiskNumber = 2
      RetryIntervalSec = 20
      RetryCount = 30
      DependsOn = "[WindowsFeature]ADAdminCenter"
    }

    xDisk ADDataDisk {
      DiskNumber = 2
      DriveLetter = "F"
      DependsOn = "[xWaitForDisk]Disk2"
    }

    WindowsFeature ADDSInstall
    {
      Ensure = "Present"
      Name = "AD-Domain-Services"
      DependsOn="[WindowsFeature]DNS"
    }

    WindowsFeature ADDSTools
    {
      Ensure = "Present"
      Name = "RSAT-ADDS-Tools"
      DependsOn = "[WindowsFeature]ADDSInstall"
    }

    WindowsFeature ADAdminCenter
    {
      Ensure = "Present"
      Name = "RSAT-AD-AdminCenter"
      DependsOn = "[WindowsFeature]ADDSInstall"
    }

    xWaitForADDomain DscForestWait
    {
      DomainName = $dscDomainName
      DomainUserCredential = $dscDomainAdmin
      RetryCount = 15
      RetryIntervalSec = 60
      DependsOn = "[xDisk]ADDataDisk"
    }

    xADDomainController SecondDC
    {
      DomainName = $dscDomainName
      DomainAdministratorCredential = $dscDomainJoinAdmin
      SafemodeAdministratorPassword = $dscDomainJoinAdmin
      DatabasePath = "F:\NTDS"
      LogPath = "F:\NTDS"
      SysvolPath = "F:\SYSVOL"
      DependsOn = "[xWaitForADDomain]DscForestWait"
    }
  }
}
