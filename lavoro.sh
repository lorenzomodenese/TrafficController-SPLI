IN_INTERFACE=wlan0;
OUT_INTERFACE=wlan0;


#elimino eventuali code root già presenti nel sistema
tc qdisc del dev ${OUT_INTERFACE} root

#creo la coda di root con codice 1 tipo di gestione della coda root cbq
tc qdisc add dev ${OUT_INTERFACE} root handle 1 cbq bandwidth 100Mbit avpkt 1000 cell 8

#creo la classe per gestione del ping
tc class add dev ${OUT_INTERFACE} parent 1: classid 1:10 cbq bandwidth 20Mbit rate 3Kbit weight 1Kbit prio 5 allot 1514 avpkt 1000 bounded

#creo la coda associata alla classe sempre per il ping
tc qdisc add dev ${OUT_INTERFACE} parent 1:10 handle 10 netem delay 1000ms 50ms distribution normal loss 5% duplicate 20%

#creo il filtro per ping
tc filter add dev ${OUT_INTERFACE} parent 1:0 protocol ip prio 5 handle 23 fw classid 1:10



#creo la classe per connessioni tcp
tc class add dev ${OUT_INTERFACE} parent 1: classid 1:20 cbq bandwidth 80Mbit rate 12Kbit weight 1Kbit prio 8 allot 1514 avpkt 1000 bounded

#creo la coda associata alla classe per connessioni tcp
tc qdisc add dev ${OUT_INTERFACE} parent 1:20 handle 20 netem delay 500ms 50ms distribution normal loss 5% duplicate 20%

#creo il filtro per connessioni tcp
tc filter add dev ${OUT_INTERFACE} parent 1:0 protocol ip prio 10 handle 24 fw classid 1:20


#mangle per il ping
iptables -t mangle -A POSTROUTING -o ${OUT_INTERFACE} -p icmp -j MARK --set-mark 23

#mangle per connessioni tcp

iptables -t mangle -A POSTROUTING -o ${OUT_INTERFACE} -p tcp -j MARK --set-mark 24

