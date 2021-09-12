FILENAME REFFILE '/home/u54945437/DSCI5340/t9-7 tooth.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.E10_1;
	GETNAMES=YES;
RUN;

data tooth;
set WORK.E10_1;
time = _n_;
run;

/* From the question we already know the model is AR(1) using first diff as per the equation but we can use code below to verify */
proc arima data=tooth; 
identify var=y; 
identify var=y(1);  
identify var=y(1,1); 
run;

proc arima data=tooth;
identify var=y(1) nlag=14;
estimate p=(1) printall plot;
forecast lead=10 alpha=0.01;
run;

/*10.2. AR1,1 = 0.64774<1 thus it satisfies the stationary condition.*/

FILENAME REFFILE '/home/u54945437/DSCI5340/t9-10 shampoo.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.E10_11;
	GETNAMES=YES;
RUN;

data shampoo;
set WORK.E10_11;
time = _n_;
run;

/*From question equation we know Model 1 is using original time series and AR(2) with constant from given equation*/
proc arima data=shampoo;
identify var=y nlag=14;
estimate p=(1,2) printall plot;
run;

/* 
10.11
1st Problem. For AR(2) models [(AR1,1) + (AR1,2)<1] and in this model, (AR1,1) + (AR1,2) = 0.35879+0.64121=1 thus fails stationary condition
2nd Problem. From correlation matrix we see that AR1,1 and AR1,2 have corr of -0.934, hence they are highly correlated.
*/


/*From question equation we know Model 2 is using first difference time series and AR(1) with no constant from given equation*/
proc arima data=shampoo;
identify var=y(1) nlag=14;
estimate p=(1) noconstant printall plot;
run;

/* 
10.12
Stationary condition for AR(1) model AR(1)<1 is satisfied and preliminary point estimate<1.
Other statistical test also satisfied. Refer to p-value and correlation matrix
*/

FILENAME REFFILE '/home/u54945437/DSCI5340/t8-1 themostat.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.E10_13;
	GETNAMES=YES;
RUN;

data thermostat;
set WORK.E10_13;
time = _n_;
run;

proc arima data=thermostat; 
identify var=y; 
identify var=y(1);  
identify var=y(1,1); 
run;

/*  
Based on SAC and SPAC we will assume and check 4 models.
MA(1) with constant
MA(1) without constant
AR(1) without constant
AR(1) with constant
*/

/*MA(1) with constant  */
proc arima data=thermostat;
identify var=y(1) nlag=14; 
estimate q=(1) printall plot;
run;
/* MA(1) model with constant has p-value greater than 0.05. */

/* MA(1) without constant */
proc arima data=thermostat;
identify var=y(1) nlag=14;
estimate q=(1) noconstant printall plot;
run;

/* AR(1) without constant */
proc arima data=thermostat;
identify var=y(1) nlag=14;
estimate p=(1) noconstant printall plot;
run;

/* AR(1) with constant */
proc arima data=thermostat;
identify var=y(1) nlag=14;
estimate p=(1) printall plot;
run;

/*MA(1) without constant is the most adequate model*/


/* 
One of the main advantages of using the box-jenkis models is the different level of diagnostics check from p-values of estimates to 
ljung box test to check for the adequacy of the model. 

A con that can be pro for Holtz trend corrected model is that the additional parameter in the Holt formulation gives a better fit to 
many kinds of series. For example, when a series has a negligible trend, the Holt trend parameter can be set near zero. 
For series subject to sudden changes in level or trend, the corresponding Holt parameter can be increased, while holding the other
parameter at a lower, more stable level.
 */