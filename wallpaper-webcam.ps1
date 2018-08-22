$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

. ("$ScriptDirectory\config.ps1")

$maxIdx = $urlList.Length

$idx = Get-Random -Minimum 0 -Maximum $maxIdx

$url = $urlList[$idx]

echo $url

Function Set-Wallpaper ($wallpaper)
{
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $wallpaper
    # SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
    Add-Type @”
    using System;
    using System.Runtime.InteropServices;
    using Microsoft.Win32;

    namespace Wallpaper
    {
        public class UpdateImage
        {
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]

            private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);

            public static void Refresh(string path) 
            {
                SystemParametersInfo( 20, 0, path, 0x01 | 0x02 ); 
            }
        }
    }
“@
    [Wallpaper.UpdateImage]::Refresh($wallpaper)
}

Invoke-WebRequest $url -OutFile $output

Set-Wallpaper -wallpaper $output