﻿$packageName = 'MakeMKV'
$installerType = 'EXE' 
$url = 'http://www.makemkv.com/download/Setup_MakeMKV_v1.10.5.exe' # download url
$url64 = 'http://www.makemkv.com/download/Setup_MakeMKV_v1.10.5.exe' # 64bit URL uses the same as $url
$silentArgs = '/S' # NSIS installar uses /S 
$validExitCodes = @(0) 
$is64bit = Get-ProcessorBits 64
if ($is64bit) {
	$unpath = "${Env:ProgramFiles(x86)}\$packageName\uninst.exe"
} else {
	$unpath = "${Env:ProgramFiles}\$packageName\uninst.exe"
}

if (Test-Path $unpath ) {
	try {
		# Prompt to uninstall a previous version, as installing on top of the current version is not supported, the uninstaller runs async and removes the new version.
		Start-ChocolateyProcessAsAdmin "$silentArgs" "$unpath" -validExitCodes $validExitCodes
	}
	catch {
		# Silently swallow errors on uninstall.
	}
	Write-ChocolateyFailure $packageName "A previous version is installed. As MakeMKV does not currently offer a silent uninstaller, please manually uninstall the program and run the installer again."
}
else {
	# installer, will assert administrative rights
	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
}