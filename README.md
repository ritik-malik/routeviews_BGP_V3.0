# Bash pipeline for routeviews
Backup scripts for project, **NOT AN OFFICIAL REPO**<br>
**TO-DO : UPDATE THE DOC<br>
ADD ISPs for BRITAIN**

## Overview
This repo contains backup scripts from the server, used in the internet shutdown project<br>
The pipeline consist of 5 bash & 3 python scripts, 18 files with ISP & thier respective prefixes, a pipeline flow.txt which was initially made as a changelog from prevoius version but now more of a todo<br>

## The idea
The main idea of the project is to establish a relationship between internet shutdowns & geopolitical events in India<br>
Dataset used : [University of Oregon Route Views Archive Project](http://archive.routeviews.org/)

## Flow of the pipeline
The flow of the pipeline is based on the specifications of the server provided -<br>
* 1 TB HDD
* 50 GB RAM
* 20 vCPU
<br>
<b>The flow -</b> <br>

<b>1. pipeline.sh :</b>

* The initial script to start the pipeline
* Stores all the required inputs in an array
* Initiates a log file with all necessary info
* Calls master.sh with nohup & exits with success message
<br>

<b>2. master.sh :</b>

* Receives CLI args from pipeline.sh
* Downloads 1 month data from routeview in batches of 3
* Use [bgpscanner](https://labs.ripe.net/Members/lorenzo_cogotti/new-mrt-bgp-reader-six-times-faster-than-its-predecessors) to parse the dumps
* Trim them & add headers
* Import the data in mongoDB
* Call the next scripts in order, with correct args

<b>3. add_index.sh :</b>

* Add indexing in mongoDB based on the prefixes

<b>4. mongo_CSV.sh :</b>

* Use mongoDB to make CSVs for all prefixes from all ISP

<b>5. make_graphs.sh :</b>

* Calls bokeh_graphs.py for making graphs

<b>6. bokeh_graphs.py :</b>

* Make bokeh graphs based on the LIMIT given
* Separate false positives in a new dir

<b>7. mail.py :</b>

* The whole process is divided in 5 steps, email notification is send after every iteration, since each script run for hours

<b>8. routeviews.py :</b>

* Script to download data for a month from routeviews


<b>Each of the script can be run separately for each step & has comments for refrence to CLI args to be given.</b><br>
The average overall runtime for the pipeline for 1 iteration is about 1 day & 6 hours (to be improved)

# Inferences
* The results folder contains the pipeline output for 4 timestamps used as of now
* `EXTRA` folder contains the graphs of the prefixes that have been stopped/started their advertisement
* `GRAPHS` folder contains :
   * CSV files with all the prefixes & their frequency in the DB
   * Graphs, with each ISP having its own individual dir


#### Some stats

| DATASET       | EXTRA        | GRAPHS  |
| ------------- |:------------:| -------:|
| 201807        | 296          | 277     |
| 201911        | 277          | 482     |
| 201912        | 173          | 268     |
| 202006        | 122          | 352     |
| 202008        | 287          | 239     |









