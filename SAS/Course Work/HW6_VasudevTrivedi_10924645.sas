FILENAME REFFILE '/home/u54945437/DSCI5340/t6-6 lumber.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT6_1;
	GETNAMES=YES;
RUN;


DATA example6_1;
SET WORK.IMPORT6_1;
Time = _n_;
run;

proc means data=example6_1;
run;

symbol1 interpol=join
        value=DOT;
proc gplot data = example6_1; 
plot y*Time / VREF=35651;

/*
6.1a. The trend model of yt = β0 + et is a reasonable  model as the data points are fluctuating randomly 
around a constant average level as seen in the plot.  
*/


data estimate_1;
y =.; Time = 31;

data example6_1_predict;
set example6_1 estimate_1;

data example6_1_predict2;
set example6_1_predict;
one =1;
run;

proc reg data =example6_1_predict2;
model y =one/noint clm cli;
output out=results_1 predicted=yhat residual=resid;
run;

symbol1 interpol=join
        value=DOT;
proc gplot data = results_1; 
plot resid*Time;



/* 
6.1b. The point prediction is 35652 and the 95% prediction interval is (31416,39888). 
     The point prediction is calculated based on the mean of the 30 observations. Refer to proc mean output.
     Prediction interval is calculated using prediction interval formula and relevants inputs of the 
     mean = 35652, s = 2037.36 , t= 2.045 with a d.f=29 and alpha =0.05.
6.1c. The residula plot shows a random pattern. Therefore, there is little or no autocorrelation. 
 */


FILENAME REFFILE '/home/u54945437/DSCI5340/t6-9 energy bills.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT6_4;
	GETNAMES=YES;
RUN;


DATA example6_4;
SET WORK.IMPORT6_4;
Time = _n_;
run;

proc means data=example6_4;
run;


symbol1 interpol=join
        value=DOT;
proc gplot data = example6_4; 
plot y*Time / VREF=265.5457500;

/*
6.4a. From the plot we can see that the relationship presents a quadratic trend as the energy bill seems to decrease 
and then increase as time increases. 
6.4b. As stated in Section6.3, a tranformation is not required if the magnitude of the seasonal swing does not depend on the level of the time series and 
the time series exhbits constant seasonal variation. 
From our plot we can see that our variation does not become much larger as the time increase but remain relatively constant. 
Therefore no transformation is required.
*/




data estimate_2;
input y Time;
datalines;
. 41
. 42
. 43
. 44
run;

data example6_4_predict;
set example6_4 estimate_2;
run;

data example6_4_predict2;
set example6_4_predict;
Timesq = time**2;
run;

/*6.4.C1 AS BELOW*/
data example6_4_predict3;
set example6_4_predict2;
if mod(Time,4)=1 then Q1=1; else Q1=0;
if mod(Time,4)=2 then Q2=1; else Q2=0;
if mod(Time,4)=3 then Q3=1; else Q3=0;
run;

proc reg data = example6_4_predict3;
model y=Time Timesq Q1 Q2 Q3/ clm cli dw;
run;

/*  
6.4.C2 All except Q2 is not important as Q2 is p-value=0.1713 > alpha=0.05. 
6.4.C3 Prediction equation using parameter as below 
yt = 276.63631 + (-7.45825)t + 0.30123t^2 + 65.77065Q1 + (-37.87011)Q2 + (-127.61132)Q3
Intercept	276.63631	
Time	 	-7.45825	
Timesq	 	0.30123	
Q1	 	65.77065	
Q2	 	-37.87011	
Q3	 	-127.61132

When y(41), t=41 which is in Q1. Q2 and Q3 equals to 0.
When y(42), t=42 which is in Q2. Q1 and Q3 equals to 0.
Solve above equation for y41=542.9878 and y42 = 456.8910 

6.4.C4. Refer to results for forecast and intervals

6.4.C5. 
H0: There is no positive autocorrelation 
Ha: There is positive autocorrelation 
From DW Table, with k =2 and N=40 dL = 1.39 and dU = 1.60.
From result DW = 0.840. Since 0.840(DW)<1.39(dL ) we reject H0 in favour of Ha: There is positive autocorrelation. 
*/

proc arima data = example6_4_predict3;
identify var = y
crosscorr= (Time Timesq Q1 Q2 Q3)
noprint;
estimate input = (Time Timesq Q1 Q2 Q3)
p=(1) printall plot;
forecast lead = 4 out = work.fcast1;
proc print data = work.fcast1;
var forecast L95 U95;
run;


/*  
6.3.d1 Φ = 0.59408. Since p-value=0.0003<alpha=0.05, Φ is statistically significant from 0.
6.3.d2 Only time and Q2 have p-values greater than alpha=0.05,thus this 2 are not important.
6.3.d3. Refer to forecast output 
*/