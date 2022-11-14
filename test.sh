touch wlasciwosci_baterii.tmp
> wlasciwosci_baterii.tmp


for file in /sys/class/power_supply/battery/*; do
    echo "${file##*/} $(sudo cat $file) \\ " >> wlasciwosci_baterii.tmp
done

eval "$(zenity --list --column="Właściwość" --column="Wartość" \
    $( while read linijka; do echo $linijka; done < wlasciwosci_baterii.tmp) )"
