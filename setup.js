/* This script is just an initial runner that uses JavaScript to call the OS specific
 * setup scripts as both Windows and macOS ship with a JavaScript runtime.
 * ==================================================================================
 *
 * Windows
 * -------
 *      On Windows JavaScript is executed via wscript.exe or cscript.exe
 *      the runtime is JScript which is pretty undocumented.
 * 
 * macOS
 * -------
 *      On macOS JavaScript is executed via osascript -l JavaScript or compiling it and running it normally
 *      the runtime is JXA
 *
 * 
 * ==================================================================================
 * This script calls PowerShell 5 on Windows
 * This script calls zsh & ruby on macOS
 */

var isWindows = typeof Application === 'function' ? false : true;

if (isWindows) {
    WScript.Echo('Setting up windows...');
    var shell = WScript.CreateObject('WScript.Shell');
    shell.run('powershell.exe -File %UserProfile%/.dotfiles/setup.ps1');
    WScript.Quit(0);
} else {
    console.log('Setting up macOS....');
    app = Application.currentApplication()
    app.includeStandardAdditions = true;
    app.doShellScript('/bin/zsh ~/.dotfiles/setup.sh');
}
