#!/bin/bash

# turn on debug mode
# set -x
# for f in *
# do
#    file $f
# done


main()
{
	openProgressBar
}
	

openProgressBar()
{
	(
		echo "0"; echo "# Przetestuj funkcję!"; attachChoice;
		echo "100"; echo "# Udało się!";
	) |
	zenity --progress --title="Progress"
}

attachChoice()
{
	# parentWindow=xwininfo -tree -root -d "$DISPLAY" | grep Progress | awk '{split($1,tmparray , " "); print tmparray[1]}'
	#--attach="$parentWindow"
	wybor=$(zenity --list  --column="Funkcjonalności" "Sprawdzenie stanu baterii" "Backup")
	
	case $wybor in
		"Sprawdzenie stanu baterii")
			openList 0;;
		"Backup")
			backup ;;
	esac
}
	
openList()
{
	touch tmp.tmp
	> tmp.tmp
	case $1 in
		0)
			for file in /sys/class/power_supply/battery/*; do
			echo "${file##*/} $(sudo cat $file) \\ " >> tmp.tmp
			done
			
			zenity --list --column="Właściwość" --column="Wartość" \
			$( while read linijka; do echo $linijka; done < tmp.tmp);;
		*)
			echo $1 ;;
	esac

	# eval "$(zenity --list --column="Właściwość" --column="Wartość" \
	# 	$( while read linijka; do echo $linijka; done < tmp.tmp) )"
}

backup()
{
	# Deciding if directory is local or remote
	# TODO

	# Selecting source directory
	source_directory="$(zenity --file-selection \
	--title="Wskaż katalog źródłowy" \
	--filename="./sync_test" \
	--directory)/"

	echo $source_directory >&2

	# Deciding if directory is local or remote
	# TODO

	# Selecting destination directory
	destination_directory="$(zenity --file-selection \
	--title="Wskaż katalog wyjściowy" \
	--filename="./destination" \
	--directory)/"

	echo $destination_directory >&2

	# Running dry-run
	zenity --question --width=400 --title="Schemat działania" \
		--text="$( rsync -avrhn --info=progress2 $source_directory $destination_directory) \n Czy chcesz zastosować zmiany?"
			# rsync --archive --verbose --recursive --human-readable --dry-run --info=progress2 $s $d
	# dialog commit/abort
	# TODO
	decyzja=$?
	
	if [ "$decyzja" = 0 ]; then
		(
			echo "0"; echo "# Synchronizowanie w toku"; 
			# without --dry-run
			wynik=$(rsync -avrh --info=progress2 $source_directory $destination_directory);
			echo "100"; echo "# $wynik";
		)
		zenity --progress --title="Synchronizowanie"
	fi
}

export DISPLAY=:0
clear
main

# turn OFF debug mode
# set +x
# ls