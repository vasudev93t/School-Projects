FILENAME REFFILE '/home/u54945437/DSCI5340/t11-4 trade employees.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT11;
	GETNAMES=YES;
RUN;

data employee;
set WORK.IMPORT11;
time = _n_;
run;

symbol1 interpol=join value=DOT;
proc gplot data = employee; 
plot y*Time;

ods graphics off;
proc arima data=employee; 
identify var=y; 
identify var=y(1);  
identify var=y(12); 
identify var=y(1,12); 
run;

/* 
11.1 SAC dies down very slowly so not stationary
11.2 Since the SAC does not cut off or die down quickly at botht the seasonal and non-seasonal portion, it is not stationary.
11.3 SAC dies down very slowly so not stationary
11.4 Yes, as the SAC dies down quickly for both the seasonal and non-seasonal portions, the data is stationary.*/

proc arima data=employee;  
identify var=y(1,12); 
run;

/*
11.5 
Step 1 - Look at SAC and SPAC for snon-seasonal portion
SAC cuts off after lag 1 and SPAC dies down. Thus q=1 for MA model

Step 2 - Look at SAC and SPAC for seasonal portion
SAC cuts off after lag 12 and SPAC dies down. Thus q=12 for MA model

Step 3. Before we combine the we also need to include the interaction term.
 */

proc arima data=employee;  
identify var=y(1,12);
estimate q=(1)(12) printall;
forecast lead =12;
run;

proc arima data=employee;  
identify var=y(1,12);
estimate q=(1)(12) noconstant printall;
forecast lead =12 alpha=0.01;
run;

/* 
11.6 Refer to output. MA1,1= -0.18157and MA2,1=0.38802
11.7. As both the absolute t-value is greater than 2 we can retain them.
11.8. From Ljung box test we can observe p-values greater than alhpa of 0.05 so model is adequate
11.9 we can calculate using the following values, n=178, alpha = 0.01, s=1.3508 and y149 = 404.1921. ALso refer to output
 */


FILENAME REFFILE '/home/u54945437/DSCI5340/t11-5 sporting goods.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT12;
	GETNAMES=YES;
RUN;

data goods;
set WORK.IMPORT12;
time = _n_;
lny = log(y);
run;

symbol1 interpol=join value=DOT;
proc gplot data = goods; 
plot y*Time;
plot lny*Time;

ods graphics off;
proc arima data=goods;   
identify var=lny(12); 
run;


/* 
11.10a. We see that after the predifferencing transformation the plot has a constant seasonal vairance.
11.10b. The SAC is dies down fairly quickly at the seasonal and cuts off for non-seasonal level therefore it is can be considered 
stationary. 
11.10c. From the equation in the question we know that this is an AR model. thus,

Step 1 - For non-seasonal portion
From the SPAC we see that there are spikes at lag 1 and 3 and cutss off after lag 3 while SAC dies down. 
Thus AR model with p=1,3
Step 2 - For Seasonal portion
From the SPAC we see that it cutss off after lag 12 while SAC dies down.
Thus AR model with p=12
Step 3. Before we combine the we also need to include the interaction term.
*/

/* Validate the model - Model with constant has smaller standard error estimate thus better.*/
proc arima data=goods;   
identify var=lny(12); 
estimate p=(1,3)(12) printall;
forecast lead =12;
run;

proc arima data=goods;   
identify var=lny(12); 
estimate p=(1,3)(12) printall noconstant;
run;


proc arima data=goods;   
identify var=lny(12); 
estimate p=(1,3)(12) printall;
forecast lead =12 out=fcast1;
run;

data fcast2;
set fcast1;
Forecasty = exp(Forecast);
L95CI = exp(L95);
U95CI = exp(U95);
proc print data = work.fcast2;
var Forecasty L95CI U95CI;
run;

/* 
11.11a. Refer to output
11.11b. Since absolute value of all parameers is greater than 2, all should stay. 
11.11c.From Ljung box test we can observe p-values greater than alhpa of 0.05 so model is adequate
11.11d. Refer to output
 */

FILENAME REFFILE '/home/u54945437/DSCI5340/e11-12 MW housing starts.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT13;
	GETNAMES=YES;
RUN;

data housing;
set WORK.IMPORT13;
time = _n_;
run;

symbol1 interpol=join value=DOT;
proc gplot data = housing; 
plot y*Time;


proc arima data=housing;   
identify var=y(12); 
run;


/*  
11.12a. We can see that the variance appears to be fairly constant thus there is no need for pre differencing transformation .  
11.12b. Since the SAC dies down fairly quickly for the non-seasonal level and the SAC cuts off for the seasonal level we can
consider it to be stationary. 
11.12c. From SPAC we see that seasonal level cuts of after lag 1,2,3 while SAC dies down. For Seasonal level we see that SAC 
cuts off after lag 12 while SPAC dies down. 
*/

proc arima data=housing;   
identify var=y(12); 
estimate p=(1,2,3) q=(12) noconstant printall;
forecast lead=12;
run;


/* 
11.13a. Refer to output.
11.13b. All parameters except AR1,3 have absolute t-value greater than 2. Thus keep all except AR1,3.
11.13c. From Ljung box test we can observe p-values greater than alhpa of 0.05 so model is adequate
11.13d. Refer to output
 */


FILENAME REFFILE '/home/u54945437/DSCI5340/t11-3 airline.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT16;
	GETNAMES=YES;
RUN;

data passanger;
set WORK.IMPORT16;
time = _n_;
lny = log(y);
run;

proc arima data=passanger;  
identify var=lny(1,12); 
estimate q=(1,3)(12) noconstant printall;
run;

/*
11.14a. We can see that figure 11.35 for minitab has parameter MA2 with p-value greater than alpha while figure 11.17 all the
parameters are significant as p-values is lesser than alpha.
11.14b. 
Step1 -For non-seasonal level, SAC spikes at 1,3 then cuts off after 3 while SPAC dies down. MA model with p=1,3
Step 2 -For seasonal, SAC cuts off after lag 12 while SPAC dies down. MA Model with p=12
Step 3 -Also include interaction term
For the model given to analyse we can see that MA1,2 has pvalue greather than alhpa.
  */

FILENAME REFFILE '/home/u54945437/DSCI5340/t11-5 sporting goods.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT12;
	GETNAMES=YES;
RUN;

data goods;
set WORK.IMPORT12;
time = _n_;
lny = log(y);
run;

data future;
input y lny time;
datalines;
. . 145
. . 146
. . 147
. . 148
. . 149
. . 150
. . 151
. . 152
. . 153
. . 154
. . 155
. . 156
run;
data goods2;
update goods future;
by time;
run;


data goods3;
set goods2;
if mod(Time,12)=1 then M1=1; else M1=0;
if mod(Time,12)=2 then M2=1; else M2=0;
if mod(Time,12)=3 then M3=1; else M3=0;
if mod(Time,12)=4 then M4=1; else M4=0;
if mod(Time,12)=5 then M5=1; else M5=0;
if mod(Time,12)=6 then M6=1; else M6=0;
if mod(Time,12)=7 then M7=1; else M7=0;
if mod(Time,12)=8 then M8=1; else M8=0;
if mod(Time,12)=9 then M9=1; else M9=0;
if mod(Time,12)=10 then M10=1; else M10=0;
if mod(Time,12)=11 then M11=1; else M11=0;


proc arima data = goods3;
identify var = lny
crosscorr=(Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
noprint;
estimate input = (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
printall plot;
run;

/* 
11.15a. 
Ste1 - For non-Seasosnal level, we see that RSPAC spikes at lag 1 and 3 
then cuts off while RSAC dies down slowly. AR model p=(1,3)
Step 2 - For Seasonal level, we see that RSPAC cuts off at lag 12 
while RSAC dies down slowly. AR model p=(12)
Step 3 - Include interaction terms also. 
 */

proc arima data = goods3;
identify var = lny
crosscorr= (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
noprint;
estimate input = (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
p=(1,3)(12) printall plot;
forecast lead = 12 out = work.fcast3;
run;

/* 
11.15b. 
Model has parameters pvalues lesser than 0.005 and ljung box test has values greater than 0.05 thus model is adequate. 
Furthermore the residual SAC and SPAC die down very quickly too.
 */

data fcast4;
set fcast3;
Forecasty = exp(Forecast);
L95CI = exp(L95);
U95CI = exp(U95);
proc print data = work.fcast4;
var Forecasty L95CI U95CI;
run;

/* 
11.15cModel is part 11.15b has a smaller prediction interval. 
 */


FILENAME REFFILE '/home/u54945437/DSCI5340/t11-3 airline.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT20;
	GETNAMES=YES;
RUN;

data airline;
set WORK.IMPORT20;
time = _n_;
lny = log(y);
run;

symbol1 interpol=join value=DOT;
proc gplot data = airline; 
plot y*Time;
plot lny*Time;

data future_p;
input y lny time;
datalines;
. . 133
. . 134
. . 135
. . 136
. . 137
. . 138
. . 139
. . 140
. . 141
. . 142
. . 143
. . 144
run;

data airline2;
update airline future_p;
by time;
run;


data airline3;
set airline2;
if mod(Time,12)=1 then M1=1; else M1=0;
if mod(Time,12)=2 then M2=1; else M2=0;
if mod(Time,12)=3 then M3=1; else M3=0;
if mod(Time,12)=4 then M4=1; else M4=0;
if mod(Time,12)=5 then M5=1; else M5=0;
if mod(Time,12)=6 then M6=1; else M6=0;
if mod(Time,12)=7 then M7=1; else M7=0;
if mod(Time,12)=8 then M8=1; else M8=0;
if mod(Time,12)=9 then M9=1; else M9=0;
if mod(Time,12)=10 then M10=1; else M10=0;
if mod(Time,12)=11 then M11=1; else M11=0;


proc arima data = airline3;
identify var = lny
crosscorr=(Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
noprint;
estimate input = (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
printall plot;
run;


proc arima data = airline3;
identify var = lny
crosscorr= (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
noprint;
estimate input = (Time M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11)
p=(1)(12) printall plot;
forecast lead = 12 out = work.fcast6;
run;

data fcast7;
set fcast6;
Forecasty = exp(Forecast);
L95CI = exp(L95);
U95CI = exp(U95);
proc print data = work.fcast7;
var Forecasty L95CI U95CI;
run;


