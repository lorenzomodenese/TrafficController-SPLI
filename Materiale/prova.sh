#elimino eventuali code root già presenti nel sistema
tc qdisc del dev wlan0 root

#creo la coda di root con codice 1 tipo di gestione della coda root cbq
tc qdisc add dev wlan0 root handle 1 cbq bandwidth 100Mbit avpkt 1000 cell 8

#creo la classe
tc class add dev wlan0 parent 1: classid 1:10 cbq bandwidth 100Mbit rate 15Kbit weight 1Kbit prio 5 allot 1514 avpkt 1000 bounded

#creo la coda associata alla classe
tc qdisc add dev wlan0 parent 1:10 handle 10 netem delay 500ms 50ms distribution normal loss 5% duplicate 20%

#creo il filtro
tc filter add dev wlan0 parent 1:0 protocol ip prio 100 u32 match ip dst 192.168.1.1/32 classid 1:10

