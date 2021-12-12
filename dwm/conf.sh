#! /bin/bash

if [[ -z $1 ]]; then
	picture="/home/wojnstup/Pictures/Wallpapers/$(ls -1 $HOME/Pictures/Wallpapers | fzf)"
	echo $picture > $HOME/Github/dwm/prevWallpaper
else
	if [[ $1 = /*  ]] || [[$1 = ~/* ]]; then
		echo $1 > $HOME/Github/dwm/prevWallpaper
	else
		echo "$(pwd)/$1" > $HOME/Github/dwm/prevWallpaper
	fi
	picture=$1
fi

wal -i $picture

echo $picture | awk -F/ '{print $NF}' | figlet
cd $HOME/Github/dwm
lead='^\/\/COLOR-CONFIG-START$'
tail='^\/\/COLOR-CONFIG-END$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r $HOME/.cache/wal/colors-wal-dwm.h
        }; /$tail/p; d }"  CONFIG > config.h

make

sel_bg=$(cat $HOME/.cache/wal/colors-wal-dwm.h | grep "sel_bg\[" | awk -F\" '{print $2}')
norm_bg=$(cat $HOME/.cache/wal/colors-wal-dwm.h | grep "norm_bg\[" | awk -F\" '{print $2}')

cat $HOME/.config/pipecat_turbo.template | sed "s/sel_bg/$sel_bg/g" | sed "s/norm_bg/$norm_bg/g" > $HOME/.config/pipecat_turbo.conf

$HOME/.local/bin/pywalfox update
pkill dwm
