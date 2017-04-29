# transmission-post-download
Post download script to automatically parse and move torrents downloaded with transmission

## Installation
  - Edit /etc/transmission-daemon/settings.json (or ~/.config/transmission/settings.json) and specify the following parameters according to your configuration:
> "script-torrent-done-filename": "~/Scripts/post-download.sh",
> "rpc-enabled": true,
> "rpc-username": "user",
> "rpc-password": "password",

  - Edit post-download.conf to match your needs:
> REMOTEBIN="/usr/bin/transmission-remote"
> USER="user"
> PASSWORD="password"
> BASE="~/Downloads"
> LOG="~/Downloads/transmission-post-download.log"
> MOVIEPATH="Films"
> MUSICPATH="Musique"
> TVSHOWPATH="Series"                                                                                      
> EBOOKPATH="eBooks"                                                                                       
> DEFAULT="torrent"

  - Make the script executable:
> chmod +x ~/Scripts/post-download.sh

## Usage
You can run the script interactively to try the regexp by specifying the option -i :
> ./post-download.sh -i
