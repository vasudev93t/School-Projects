
FILENAME REFFILE '/home/u54945437/DSCI5340/t8-1 themostat.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.SALES;
	GETNAMES=YES;
RUN;

data example8_8;
set work.sales;
time = _n_;
run;

data sale53;
y=330; time=53;

data example8_9;
set example8_8 sale53;

*Exercise 8.9;
title "Exercise 8.9a Holts method";
proc forecast data = example8_9 method=expo trend=2 lead=4 outlimit out=forecast;
var y;
run;

proc print data=forecast;

data sale54;
y=320; time=54;

data example8_9b;
set example8_9 sale54;

title "Exercise 8.9b Holts method";
proc forecast data = example8_9b method=expo trend=2 lead=4 outlimit out=forecast2;
var y;
run;

proc print data=forecast2;


title "Exercise 8.21 ";

FILENAME REFFILE '/home/u54945437/DSCI5340/t7-1 cola.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.cola;
	GETNAMES=YES;
RUN;

data example8_21;
set work.cola;
time = _n_;
run;

proc print data = example8_21;


* Holt multiplicative exponential time smoothing;
proc forecast data = example8_21 method=addwinters seasons=12 trend=1 lead=6 outlimit out=forecast_cola;
var y;
id time;
run;

proc print data = forecast_cola;
run;

data cola_sales2;
format date monyy5. ;
input date:monyy5. sales;
cards;
jan65 189
feb65 229
mar65 249
apr65 289
may65 260
jun65 431
jul65 660
aug65 777
sep65 915
oct65 613
nov65 485
dec65 277
jan66 244
feb66 296
mar66 319
apr66 370
may66 313
jun66 556
jul66 831
aug66 960
sep66 1152
oct66 759
nov66 607
dec66 371
jan67 298
feb67 378
mar67 373
apr67 443
may67 374
jun67 660
jul67 1004
aug67 1153
sep67 1388
oct67 904
nov67 715
dec67 441
;
run;

proc esm data=cola_sales2 outfor=final lead=6 
plot = (modelforecasts forecastsonly)
print = (estimates forecasts statistics performance);
id date interval=month;
forecast sales / model= winters;
run;