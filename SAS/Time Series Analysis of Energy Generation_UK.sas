FILENAME REFFILE '/home/u54945437/DSCI5340/Project 2/GB_ActualLoad_Final.csv';

/* 
We import the clean data set from python. 
 */

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.GBACTUAL;
	GETNAMES=YES;
RUN;


PROC PRINT DATA=GBACTUAL; RUN;

/* 
Create the time varaible using _n_ and change the column name to y for easier reference. 
 */
DATA test1;
Rename GB_GBN_load_actual_entsoe_transp = y;
SET WORK.GBACTUAL;
Time = _n_;
run;

/* 
See the mean value for the y varaible to plot as reference in the y*time plot/
 */
proc means data=test1;
run;

PROC PRINT DATA=test1; RUN;

symbol1 interpol=join
        value=DOT;
proc gplot data = test1; 
title "Total Load vs Time";
plot y*Time / VREF=25504384.52;
/* 
Overerall we notice that there is a negative linear trend with almost constant seasonal variation.
 */


/* We will test out Time Series regression to see if it will be suitable to help us predict the future production values */
data future;
input 'year and month'n	y Time;
datalines;
. . 70
. . 71
. . 72
. . 73
. . 74
. . 75
. . 76
. . 77
. . 78
. . 79
. . 80
. . 81
;
run;
data test2;
update test1 future;
by Time;
run;

PROC PRINT DATA=test2; RUN;

/* As we are dealing with a time series that is exhibiting constant seasonal variation, we can express the seasonal factor 
using dummy variables. A transformation is not required as the seasonal variation is somewhat constant */
Data test3;
Set test2;
JAN = 0; Feb = 0; Mar = 0; Apr = 0; May = 0; Jun = 0; Jul=0; Aug = 0; Sep= 0;
Oct=0; Nov=0;
If Mod(Time, 12) = 1 then Jan = 1;
If Mod(Time, 12) = 2 then Feb = 1;
If Mod(Time, 12) = 3 then Mar = 1;
If Mod(Time, 12) = 4 then Apr = 1;
If Mod(Time, 12) = 5 then May = 1;
If Mod(Time, 12) = 6 then Jun = 1;
If Mod(Time, 12) = 7 then Jul = 1;
If Mod(Time, 12) = 8 then Aug = 1;
If Mod(Time, 12) = 9 then Sep = 1;
If Mod(Time, 12) = 10 then Oct = 1;
If Mod(Time, 12) = 11 then Nov = 1;


proc print data = test3;
run;

/* Check for auto-correlation */
Proc Reg data=test3;
model y = Time JAN Feb Mar Apr May Jun Jul Aug Sep Oct Nov/cli clm DW;
output out=tempfile r=residual;
plot r.*time;
run;
/* 

Since the DW is 0.811 which is lesser than dL = 1.27 we can say first order positive autocorrelation is present. 
We also see that the months of February, March and November have p-values greater than 0.05 so 
they are not significant in the model*/

/*Check for regressionn assumption for residuals*/
proc univariate data=tempfile normal plot;
var residual;
RUN;
/* The mean of the residuals is 0, they are normally distributed and based on the residual plot since there is not much
fanning in or out we can assume normal varaince.

However, as there is first order positive autocorrelation is present, independence assumption fails.  */



/* Using ARIMA models to handle auto-correlation and ensure stationary condition of time series  */


/* First we consider the trend and seasonal nature to be deterministic, i.e. they do not change over time.  */
proc arima data = test3;
identify var = y
crosscorr=(Time JAN Feb Mar Apr May Jun Jul Aug Sep Oct Nov)
noprint;
estimate input = (Time JAN Feb Mar Apr May Jun Jul Aug Sep Oct Nov)
printall plot;
run;


proc arima data = test3;
identify var = y
crosscorr= (Time JAN Feb Mar Apr May Jun Jul Aug Sep Oct Nov)
noprint;
estimate input = (Time JAN Feb Mar Apr May Jun Jul Aug Sep Oct Nov)
q=(1)printall plot;
forecast lead = 12 out = work.fcast6;
run;


/*Using stochastic appraoch - the seasonal variation is somewhat constant but not well-defined*/
/* We see that using a difference of y(1,12) makes the overall time series stationary  */
proc arima data=test3; 
identify var=y nlag=24; 
identify var=y(1) nlag=24; 
identify var=y(12) nlag=24; 
identify var=y(1,12) nlag=24;  
run;

/* We further use the ADF test to check if the model is stationary and since all the p-value for the Tau are smaller than 
alpha of 0.05, y(1,12) is stationary.*/
proc arima data = test3;
identify var = y(1,12) nlag=15 stationarity = (adf = 2);
title "ARIMA Stationarity Analysis";
run;

/* 
Step 1 - Look at SAC and SPAC for non-seasonal portion 
SAC cuts off after lag 2 and SPAC dies down. Thus q=2 for MA model

Step 2 - Look at SAC and SPAC for seasonal portion. Result can be interpreted as following
a. SAC cuts off after lag 12 and SPAC dies down. Thus q=12 for MA model
b. SPAC cuts off after lag 12 and SAC dies down. Thus p=12 for AR model

Step 3. Combines the models in step 1 and 2, we will have the following models
MA q=(2) for non-seasonal component and MA q = (12) for seasonal component together with interaction term
MA p= (2) for non-seasonal component and AR p= (12) for seasonal component
*/

proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2)(12) plot;
title "ARIMA q=(1)(12) with constant Analysis";
run;

proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2)(12) noconstant plot; 
title "ARIMA q=(1)(12) without constant Analysis";
run;

proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2) p=(12) plot;
title "ARIMA q=(2) p=(12)  with constant Analysis";
run;


proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2) p=(12) noconstant plot;
title "ARIMA q=(2) p=(12) without constant Analysis";
run;

/*  
ARIMA q=(1)(12) without constant is the best model amongst the 4 thus we will be using this model. 
*/

proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2)(12) noconstant plot; 
forecast lead=12 out=work.fcast1;
title "ARIMA q=(1)(12) without constant prediction";
run;

proc print data = work.fcast1;
var y Forecast L95 U95;
run;

/* Solar Energy Generation */

FILENAME REFFILE '/home/u54945437/DSCI5340/Project 2/GB_SolarGeneration_Final.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.GBSOLAR;
	GETNAMES=YES;
RUN;

PROC PRINT DATA=GBSOLAR; RUN;

/* 
Create the time varaible using _n_ and change the column name to y for easier reference. 
 */
DATA stest1;
Rename GB_GBN_solar_generation_actual = y;
SET WORK.GBSOLAR;
Time = _n_;
run;

/* 
See the mean value for the y varaible to plot as reference in the y*time plot/
 */
proc means data=stest1;
run;

PROC PRINT DATA=stest1; RUN;

symbol1 interpol=join
        value=DOT;
proc gplot data = stest1; 
title "Solar Energy Generation vs Time";
plot y*Time / VREF=864545.84;

/* We notice a small positive linear trend accompanied with an increasing seasonal variation.
Thus we will use pre-differencing transformation. */

data stest2;
set stest1;
logy = log(y);
Sqrty = y**0.5;
QtRooty = y**0.25;
run;

/* Identifying what pre-differencing to use */
symbol1 interpol=join value=DOT;
proc gplot data = stest2; 
plot y*Time;
plot logy*Time; /*Logy gives the best result*/
plot Sqrty*Time;
plot QtRooty*Time;

/* Identifying what differencing to use */
proc arima data=stest2;
identify var=logy nlag=24; 
identify var=logy(1) nlag=24;  
identify var=logy(12) nlag=24; 
identify var=logy(1,12) nlag=24;  /*Time series with a differencing of logy(1,12) gives a stationary series as SAC cuts off and SPAC
dies down*/
run;


/* We further use the ADF test to check if the model is stationary and since all the p-value for the Tau are smaller than 
alpha of 0.05, logy(1,12) is stationary.*/
proc arima data = stest2;
identify var = logy(1,12) nlag=24 stationarity = (adf = 2);
title "ARIMA Stationarity Analysis";
run;

/* 
Step 1 - Look at SAC and SPAC for non-seasonal portion.
There are a few options we will validate
a. SAC cuts off after spikes at lag1 and  lag2 and SPAC dies down. Thus q=1,2 for MA model
b. SAC cuts off after spikes at lag2 and SPAC dies down. Thus q=1,2 for MA model

Step 2 - Look at SAC and SPAC for seasonal portion. Result can be interpreted as following
a. SAC cuts off after lag 12 and SPAC dies down. Thus q=12 for MA model
b. SPAC cuts off after lag 12 and SAC dies down. Thus p=12 for AR model

Step 3. Combines the models in step 1 and 2, we will have the following models
MA q=(1,2) for non-seasonal component and MA q = (12) for seasonal component together with interaction term
MA q=(2) for non-seasonal component and MA q = (12) for seasonal component together with interaction term
MA q=(2) for non-seasonal component and AR p= (12) for seasonal component
MA q= (1,2) for non-seasonal component and AR p= (12) for seasonal component
 
*/

/* Test Which model is the best */
proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(1,2)(12) noconstant plot;
title "ARIMA q=(1,2)(12) without constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(1,2)(12) plot;
title "ARIMA q=(1,2)(12) with constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2)(12) noconstant plot; 
title "ARIMA q=(2)(12) without constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2)(12) plot; 
title "ARIMA q=(2)(12) with constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2) p=(12) noconstant plot;
title "ARIMA q=(2) p=(12)  without constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2) p=(12) plot;
title "ARIMA q=(2) p=(12) with constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(1,2) p=(12) noconstant plot;
title "ARIMA q=(1,2) p=(12)  without constant Analysis";
run;

proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(1,2) p=(12) plot;
title "ARIMA q=(1,2) p=(12) with constant Analysis";
run;

/*Out of all the models, ARIMA q=(2)(12) without constant Analysis is the most adequate model based on, parameters estimate, 
smallest AIC and SE values and adequate Ljung box test result.  */



proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2)(12) plot;
forecast lead =12 out=sfcast1;
run;

data sfcast2;
set sfcast1;
y = exp(logy);
Forecasty = exp(Forecast);
L95CI = exp(L95);
U95CI = exp(U95);
proc print data = work.sfcast2;
var y Forecasty L95CI U95CI;
run;

/* Wind Energy Generation */

FILENAME REFFILE '/home/u54945437/DSCI5340/Project 2/GB_WindGeneration_Final.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.GBWIND;
	GETNAMES=YES;
RUN;

PROC PRINT DATA=GBWIND; RUN;

/* 
Create the time varaible using _n_ and change the column name to y for easier reference. 
 */
DATA wtest1;
Rename GB_GBN_wind_generation_actual = y;
SET WORK.GBWIND;
Time = _n_;
run;

/* 
See the mean value for the y varaible to plot as reference in the y*time plot/
 */
proc means data=wtest1;
run;

PROC PRINT DATA=wtest1; RUN;

symbol1 interpol=join
        value=DOT;
proc gplot data = wtest1; 
title "Wind Energy Generation vs Time";
plot y*Time / VREF=3293707.97;

/* We notice a positive linear trend accompanied with almost constant seasonal variation.
Thus we will use not be using pre-differencing transformation. */


/* Identifying what differencing to use */
proc arima data=wtest1;
identify var=y nlag=24; 
identify var=y(1) nlag=24; 
identify var=y(1,1) nlag=24;  
identify var=y(12) nlag=24; 
identify var=y(1,12) nlag=24;  /* Autocorrelation of white noise has p-value greater than 0.05, thus the model is stationary and has no atuocorrelation. 
run;


/* Test Which model is the best */
proc arima data = wtest1;
identify var = y(1,12) nlag=24;
estimate q=(12) noconstant plot;
title "ARIMA q=(12) without constant Analysis";
run;

proc arima data = wtest1;
identify var = y(1,12) nlag=24;
estimate q=(1)(12) noconstant plot;
title "ARIMA q=(1)(12) without constant Analysis";
run;

proc arima data = wtest1;
identify var = y(1,12) nlag=24;
estimate q=(12) noconstant plot;
forecast lead =12 out=wfcast1;
run;

/*Final Models  */

/* Total */
proc arima data = test3;
identify var = y(1,12) nlag=24;
estimate q=(2)(12) noconstant plot; 
forecast lead=12 out=work.fcast1;
title "ARIMA q=(1)(12) without constant prediction";
run;

DATA fcast2;
SET fcast1;
Time = _n_;
run;


/*Solar  */
proc arima data = stest2;
identify var = logy(1,12) nlag=24;
estimate q=(2)(12) plot;
forecast lead =12 out=sfcast1;
run;

data sfcast2;
set sfcast1;
y = exp(logy);
Forecasty = exp(Forecast);
L95CI = exp(L95);
U95CI = exp(U95);
proc print data = work.sfcast2;
var y Forecasty L95CI U95CI;
run;

DATA sfcast3;
SET sfcast2;
Time = _n_;
run;

/* Wind */
proc arima data = wtest1;
identify var = y(1,12) nlag=24;
estimate q=(12) noconstant plot;
forecast lead =12 out=wfcast1;
run;

DATA wfcast2;
SET wfcast1;
Time = _n_;
run;


legend1 across=1
           cborder=black
           position=(top inside right)
           offset=(-40,0)
           value=(tick=1 'Predicted'
                  tick=2 'Original ')
           shape=symbol(5,.7)
           mode=share ;

Symbol1 v=diamond I=Join c=red ;
Symbol2 v=circle I=Join c=black ;

proc gplot data = fcast2;
 plot FORECAST*Time y*Time/overlay legend=legend1;
 title "Plot Total Load with Predicted";

proc gplot data = sfcast3;
 plot Forecasty*Time y*Time/overlay legend=legend1;
 title "Plot Total Solar Generation with Predicted";

proc gplot data = wfcast2;
 plot FORECAST*Time y*Time/overlay legend=legend1;
 title "Plot Total Wind Generation with Predicted";
run; 