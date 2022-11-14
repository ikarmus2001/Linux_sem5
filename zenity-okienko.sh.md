```bash
#!/bin/bash

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
	wybor=$(zenity --list  --column="Funkcjonalności" "Sprawdzenie stanu baterii")
	
	case $wybor in
		"Sprawdzenie stanu baterii")
			openList 0;;
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
			done;;
		*)
			echo $1 ;;
	esac

	zenity --list --column="Właściwość" --column="Wartość" \
		$( while read linijka; do echo $linijka; done < tmp.tmp)

	# eval "$(zenity --list --column="Właściwość" --column="Wartość" \
	# 	$( while read linijka; do echo $linijka; done < tmp.tmp) )"
}

export DISPLAY=:0
clear
main

# turn OFF debug mode
# set +x
# ls
```

![[zenity-okienko.sh]]