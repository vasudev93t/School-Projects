FILENAME REFFILE '/home/u54945437/DSCI5340/t4-11 hospital.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

Title"Question 4.2";
proc gplot data = work.import; 
plot hours*Xray; 

proc gplot data = work.import; 
plot hours*BedDays; 

proc gplot data = work.import; 
plot hours*Length; 

PROC REG data = work.import ;
 MODEL Hours = Xray	BedDays	Length/clb clm cli;
RUN;

/* The error could account for other types of services offered by the hospital  */

Title"Question 4.4";

data estimate;
Hours=.; Xray=56194; BedDays=14077.88; Length=6.89;

data predict;
set work.import estimate;

PROC REG data = predict ;
 MODEL Hours = Xray	BedDays	Length/clb clm cli;
RUN;

PROC REG data = predict ;
 MODEL Hours = Xray	BedDays	Length/clb clm cli alpha=0.01;
RUN;
/* 
4.4a. We can calculate the value by solving the our regression eqn with the values provided for the dependent variables.
4.4c. Actual y=17207.31 is greater than yhat = 16065. The hospital would have been severly understaffed 
during this period then.
*/

/*
4.6a. SSE=4913399,  s^2 = SSE/(n-k-1) = 4913399/(17-3-1) = 377954	 s = 614.77942  
4.6b. From result, Total Vairance = 494712540 , Explained Variance = 489799142 , Unexplained Variance = 4913399
4.6c. R-Square= Explained Variance/Total Variance = 0.9901,   Adj R-Sq = 0.9878
4.6d. From result, Total Vairance = 494712540 , Explained Variance = 489799142 , Unexplained Variance = 4913399 
	  for F test , k =3 and d.f = 13 thus F-test = 106.30
4.6e/f/g . p-value <.0001 which is lesser than alpha =0.05, 0.01, 0.001. Rejected H0 in favor of alternate. 

4.8a. Parameter Estimate/StandardError=t Value. Refer to results to explain 
4.8b. T-value at alpha = 0.05 from T-table = 2.160. T-test for parameters must be greater than 2.160 to reject H0
4.8c. T-value at alpha = 0.01 from T-table = 3.055 T-test for parameters must be greater than 3.055 to reject H0
4.8d. Refer to p-value. p-vlaue<alpha to reject h0.
4.8e/f. Refer to confidence intervals for respective parameters. 

4.10. 17207.31 lies on the higher end within the prediction interval of 14511<95%CLpredict<1761. As it is within the interval it is
not unusually high or low. 
*/

/* 
4.19. THe positive 5059 for promo*daygame indicates that promo during daygames result in higher attendance. A pratical reason could be 
universities or schools promoting sports and taking advantage of this promotions during the day. 
The negative 4690 indicates that promotions are not working extremely during the weekends. One reason could be games in the weekends are held in the 
night and people who favour day games might not be as attracted to it.   */

FILENAME REFFILE '/home/u54945437/DSCI5340/t4-16 insurance.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;

data stockfirm;
set work.import1;
if DS =1;

data mutualfirm;
set work.import1;
if DS =0;

Title"Stock Firm";
proc sgplot data = stockfirm;
reg x=X y=Y/clm;

Title"Mutual Firm";
proc sgplot data = mutualfirm;
reg x=X y=Y/clm;

PROC REG data = work.import1 ;
 MODEL y = x DS/clb clm cli;
RUN;

data interaction;
set work.import1;
xDS = x*DS;
run;

PROC REG data = work.import1 ;
 MODEL y = x DS/clb clm cli;
RUN;

PROC REG data = interaction ;
 MODEL y = x DS xDS/clb clm cli;
RUN;

/* 
4.20aThe data for stocks fits the linear trend better than the data for the mutual firms.  
4.20b. From the results we can see the value of the DS(dummy variable for stock firms). Beta2 will be how much longer stock firms will take
in general as compared to mutual firms in adopting the new innovation. 
4.20c. As the p-value is lesser than alpha = 0.01, we reject H0 in favour of alternate, signifying beta2. 
       4.97703<95%CL(beta2)<11.13391. It is important to consider firm type when predicting adoption speeds as stocks firms take a longer time
       than mutual firms. 
4.20d. As the p-value is much greater than 0.05, we can conclude that interaction of x and DS is not significantly affecting y. 
*/

FILENAME REFFILE '/home/u54945437/DSCI5340/t4-18 fresh detergent 3.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT3;
	GETNAMES=YES;
RUN;

data interaction2;
set work.import3;
x4x3 = x3*x4;
x3sq = x3*x3; 
run;

data estimate2;
y=.; x4=0.2; x3=6.50; x4x3=(0.2*6.50); x3sq=(6.50*6.50); DA=0; DB=0; DC=1;

data predict3;
set interaction2 estimate2;

PROC REG data = predict3;
 MODEL y = x4 x3 x3sq x4x3 DB DC/clb clm cli;
RUN;

PROC REG data = predict3;
 MODEL y = x4 x3 x3sq x4x3 DA DC/clb clm cli;
RUN;

/* 
4.22a. 
B5 = 0.21369
B6 = 0.38178
B6-B5 = 0.16809

4.22b. The 8.2132<95%CLPredict<8.7881	
4.22c. 0.03630<95%CL(B6)<0.29988 and it is significant as pvalue=0.0147	<0.05.

 */