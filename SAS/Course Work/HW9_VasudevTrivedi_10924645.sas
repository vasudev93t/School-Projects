FILENAME REFFILE '/home/u54945437/DSCI5340/t9-9 viscosity XR-22.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.HW9_6;
	GETNAMES=YES;
RUN;

data viscosity_xr22;
set WORK.HW9_6;
time = _n_;
z = dif1(y);
run;

proc print data=work.viscosity_xr22;
run;


/*We will use the following lines of code to check if if our original time series is stationary or 
if we need to use the first or second difference for our model*/
symbol value=none interpol=L width=1;
proc gplot data=viscosity_xr22;
plot y*time;
plot z*time; 
proc arima data=viscosity_xr22; 
identify var=y; 
identify var=y(1);  
identify var=y(1,1); 
run;

/* From the plot we can see that our time series does not have any so any positive or negative trend. When we look at the SAC for the 
original time series, it dies down fairly quickly in a damped sin-wave fashion hence it is stationary. 
Thus we will use the original time series for our analysis.*/

/*Next we will assume different model and which is best. 
From the results we can see SAC spikes at 1 & 2 and cuts off after lag 2 while SPAC dies down fairly quickly. 
So we can assume MA(2) model.

Also, we can assume AR model as SPAC spikes at Lag 1,3,5 and SAC dies down fairly quickly. We take the smallest spike at lag 5 
and will check AR(5) model.


Lastly, we will check the different models with constant and no constant and observe the pvalues to determine if constant is needed.
Models will be decided based on the statistical signifance and also square error value.*/

/* MA2 Model with Constant */
proc arima data=viscosity_xr22; /*PROC ARIMA*/
identify var=y; 
estimate q = (1,2) printall plot;
run;

/* MA2 Model with no Constant */
proc arima data=viscosity_xr22; /*PROC ARIMA*/
identify var=y; 
estimate q = (1,2) noconstant printall plot; 
run;

/* AR Model with Constant */
proc arima data=viscosity_xr22; /*PROC ARIMA*/
identify var=y; 
estimate p = (1,5) printall plot;
run;

/* AR Model with no Constant */
proc arima data=viscosity_xr22; /*PROC ARIMA*/
identify var=y; 
estimate p = (1,5) noconstant printall plot;
run;


/* From all the models, we see that MA2 model with constant has the smallest standard error=2.573028 and AIC=713.1522 values. 
So we can use the MA2 model with constant. */