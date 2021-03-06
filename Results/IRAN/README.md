IODA_IRAN_report


Iran Internet Shutdown -> 16th Nov - 21st Nov , 2019

Some Useful links ->
Wiki                    : https://en.wikipedia.org/wiki/2019_Internet_blackout_in_Iran
IODA report 2020        : https://ioda.caida.org/ioda/2020-iran-report
IODA report 2019        : https://ooni.org/post/2019-iran-internet-blackout/
IODA                    : https://www.caida.org/projects/ioda/
Google traffic report   : https://transparencyreport.google.com/traffic/overview?fraction_traffic=start:1571788800000;end:1574467200000;product:19;region:IR&lu=fraction_traffic
Tor report              : https://metrics.torproject.org/userstats-relay-country.html?start=2019-11-30&end=2019-12-31&country=in&events=on
Oracle report           : https://map.internetintel.oracle.com/?root=national&country=IR
Netblocks report        : https://netblocks.org/reports/internet-disrupted-in-iran-amid-fuel-protests-in-multiple-cities-pA25L18b


Most Iranians barred from Internet, but had access to Iran’s national Intranet: the domestic
network that hosts Iranian websites and services—all under the government’s watch.

Reason for shutdown:
Protest due to new gov policies -
Increase the price of fuel by 300%
A strict rationing system imposed
etc.

Data sources for shutdown prediction -
1. IODA
2. Google traffic data
3. Tor metrics
4. Oracle’s Internet Intelligence
5. NetBlocks
6. Cloudfare reports

_______________________________________________


IODA data highlights three interesting aspects of Iran’s internet blackout:

1. Cellular operators in Iran were disconnected first
2. Almost all other providers in Iran followed suit over the next 5 hours   (I guess gov ISPs 1st, then followed by private ISPs)
3. Providers appear to have used diverse mechanisms to enforce the blackout (here's where we are stuck, no one talks about these mechanisms)

Metrics used by IODA:
1. Routing (BGP) announcements
2. Active Probing
3. Internet Background Radiation (IBR) traffic

* All 3 of them didn't dropped simultaneously, but at varied time
* At first, BGP dropped, but no change in Active Probing and IBR signals
* Some connectivity continued to persist even during this time (maybe for politicians & higer authority)

Network level differences - (refer to ISPs graphs)
* Timing differences between various ISPs
* Cellular operators in Iran were instructed to shut down the Internet first (before fixed-line operators were instructed).
* These differences in timing suggest that individual operators enforced the blackout independently
(as opposed to a single “kill-switch” that resulted in the simultaneous disconnection of all operators)

* More graphs
* Other data sources
* Manual testing (RST packet is injected at both ends of the connection.)
* Iran’s Intranet - the hidden internet
* We also found that it was possible to connect to the Internet by using virtual private servers (VPS)
  to setup a local proxy in Iran and use that proxy to tunnel traffic to another proxy outside Iran.


-----------------------------------------------------------------------------------------
            IRAN                        |           INDIA                               |
-----------------------------------------------------------------------------------------
* ISPs under gov control                |   * Have private ISPs                         |
* Centralized internet infrastructure   |   * Broken & unorganised, hierarchial model   |
-----------------------------------------------------------------------------------------

+ different mechanisms to impose the shutdown






















