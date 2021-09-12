FILENAME REFFILE '/home/u54945437/DSCI5340/t3-2 QHIC.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT5;
	GETNAMES=YES;
RUN;

data transformed;
set work.import5;
transformedx = (1/value);
newy = (Upkeep/value);
run;

data estimate3;
newy =.; transformedx = (1/220); value=220;

data transformed2;
set transformed estimate3;

PROC REG data = transformed2;
 MODEL newy = transformedx value/clb clm cli vif;
RUN;

/*
5.13a. The residual plot holds the constant variance assumption as there if no funneling out or in as x increases.  
5.13b. newy = (Upkeep/value), predicted value of newy = 5.6349 thus yhat = 5.6349*220=1239.7
	   Similary we multiple 220 to both 5.3060<95%CL<5.9638 and 3.9939<95%CLpredict<7.2759	to get mu0 and y0. */
	  
	  
FILENAME REFFILE '/home/u54945437/DSCI5340/t5-5 hospital.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT6;
	GETNAMES=YES;
RUN;

data oldtable5(drop=DL);
set work.import6;

data estimate5;
hours =.; xray = 56194 ; beddays=14077.88; length=6.89; dl=1;

data prediction7;
set work.import6 estimate5;

proc reg data=prediction7;
	model hours = xray beddays length dl/cli clm r influence;
	output out = results predicted=yhat residual=resid;
proc gplot data= results;
plot resid*yhat;


proc reg data=oldtable5;
	model hours = xray beddays length/ r influence;
run;

/* 
5.16a. As the pvalue is lesser than alpha = 0.05, we reject H0 in favour of HA, showing tha B4 has significane. 
5.16b. Yes, it is an outlier, There is an extra independent varialbe used to describe its large values. 
5.16c. Refer to reg data and compare New Cook's D with older. For hospital 17 Cook's D has dropped from 5.033 to 0.738, making it less influential.
5.16d. The model with the shortest prediction interval is model with dummy variable dl.
5.16e. While both are not horizontal, the one with the dummy variable is slightly more horizontal. 
5.16f. Model with dummy variable is the best. IT has the smallest prediction interval, closest to constant variance assumption and reduced influential data too.
 

*/