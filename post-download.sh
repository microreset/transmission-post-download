#!/bin/bash

CONFIGFILE="post-download.conf"

if [ -f $CONFIGFILE ]
then
  . $CONFIGFILE
  echo
else
  echo "Config file $CONFIGFILE not found"
  exit -1
fi

if [ -f $REMOTEBIN ]
then
  REMOTE="$REMOTEBIN -n $USER:$PASSWORD"
  echo
else
  echo "$REMOTEBIN not found"
  exit -1
fi

if [ ! -f $LOG ]
then
  touch $LOG
fi

TORRENT_NAME=$TR_TORRENT_NAME
echo `date` " Processing: " $TORRENT_NAME >> $LOG;

if [ $# -gt 0 ]
then
        # Option -i? (Interactif)
	if [ $1 = "-i" ]
	then
		shift;
		echo "Usage: $0 [id torrent]";
                # Affichage de la liste des torrents:
		$REMOTE -l | tail -n100 | egrep -iv '^$|sum';
		echo -n "Please select torrent ID: "; read TORRENT_ID;
		TORRENT_NAME=`$REMOTE -t $TORRENT_ID  -i | grep Name: | sed 's/.*Name: //'`;
	else
		TORRENT_NAME=$1;
		TORRENT_ID=`$REMOTE -l | grep $TORRENT_NAME | awk '{print $1 }'`;

	fi
elif [ $TORRENT_NAME ]
then
	TORRENT_ID=`$REMOTE -l | grep $TORRENT_NAME | awk '{print $1 }'`;
	echo "Torrent id:"$TORRENT_ID >>$LOG;
else
	TORRENT_NAME=`$REMOTE -l | grep 100% | tail -n1 | awk '{ print $10 }'`;
	TORRENT_ID=`$REMOTE -l | grep $TORRENT_NAME | awk '{print $1 }'`;
fi

echo "Torrent name:"$TORRENT_NAME;
echo "Torrent id:"$TORRENT_ID;

TORRENT_NAME=`$REMOTE -t $TORRENT_ID -i |grep Name |cut -d ":" -f2`

echo Torrent: $TORRENT_NAME >> $LOG;

case $TORRENT_NAME in
        # TV Shows
	$(echo "${TORRENT_NAME}" | egrep -i 'S[0-9][0-9]|saison *[0-9]+|season *[0-9]+'))
		DEST="$TVSHOWPATH";
		echo `date` "Directory of $TORRENT_NAME: $DEST" >> $LOG;
		;;
        # Movies
	$(echo "${TORRENT_NAME}" |egrep -i 'DVDR|HDTV|XVID|BDRIP|BRRIP|HDRIP|WEBRIP|BRRIP|Blueray|bluray|720p|1080p|NTSC|*.avi$|*.mkv$'))
		DEST="$MOVIEPATH";
		echo `date` "Directory of $TORRENT_NAME: $DEST" >> $LOG;
		;;
        # Music
	$(echo "${TORRENT_NAME}" | egrep -i 'flac|mp3'))
		DEST="$MUSICPATH";
		echo `date` "Directory of $TORRENT_NAME: $DEST" >> $LOG;
		;;
        # eBooks
        $(echo "${TORRENT_NAME}" | egrep -i 'epub'))
		DEST="$EBOOKPATH";
		echo `date` "Directory of $TORRENT_NAME: $DEST" >> $LOG;
		;;

        # Default
	*) DEST="$DEFAULT";
		echo `date` "$TORRENT_NAME does not match! Sent in $DEST" >> $LOG
		;;
esac

$REMOTE -t $TORRENT_ID --move "$DEST"
