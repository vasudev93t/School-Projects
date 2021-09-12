
/* STEP 1 */

data tractorsales;
input
sales;
datalines;
293
392
221
147
388
512
287
184
479
640
347
223
581
755
410
266
run;

proc print data=tractorsales;
title "tractorsales";
run;

/* STEP 2 */

Data SalesData_MovingAverage;
Set tractorsales;
Array SalesLag {4} SalesLag0-SalesLag3;
SalesLag{1} = Sales;
do i = 2 to 4;
  SalesLag{i} = Lag(SalesLag{i-1});
end;
MovingAverage = 0;
do i = 1 to 4;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/4;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "data = SalesData_MovingAverage";
run;

/* STEP 3 */

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=2 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set tractorsales;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales/CenteredMV;
proc print data = SalesData_SeasonalIndex;
title "data = SalesData_SeasonalIndex";

/* STEP 4 */

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Retain SeasIndex1-SeasIndex4 0;
Time = _N_;
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 4)= 0 then SeasIndex4 = SeasIndex4 + SeasonalIndexInitial;
/*  Get average on next set of lines */ 
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 4;
     SeasonalIndex{i} = SeasonalIndex{i}/ 3; 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;
/**Only keep last line**/
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex4 ;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex4;
title "Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set tractorsales;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Time = _N_; 
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 4)= 0 then SeasonalEffect  = SeasonalIndex{4};  
DeseasonalizedSales = Sales/SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
title "Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "DeseasonalizedSales regressed on Time";

proc print data = tempfile;
title "Predicted DeseasonalizedSales - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
CyclicalInitial = DeseasonalizedSales /Trend;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {2} CyclicalLag1-CyclicalLag2;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 2;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});/*note Lag is a SAS function*/
end;
CycMovingAverage = 0;
do i = 1 to 2;
  CycMovingAverage = CycMovingAverage + CyclicalLag{i};
end;
CycMovingAverage = CycMovingAverage/2;
Keep CycMovingAverage;
If _N_ = 1 then delete;
Drop i; 

proc print data = Cyclical;
title "data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales/(SeasonalEffect*Trend*CycMovingAverage);

proc print data = Decomposition;
Title "Decomposition";
 Run;


/* STEP 9 */

proc forecast data = DeseasonalizedData lead=7 out=prediction;
var Sales;
run;

proc print data=prediction;
title "Sales forecasts for the next 7 days";
run;
Quit;





data tractorsales_1;
input
time sales;
datalines;
1 245.8652928
2 257.6216993
3 274.9416583
4 303.799546
5 325.5827086
6 336.4854848
7 357.0509318
8 380.2660983
9 401.9436016
10 420.6068561
11 431.6957259
12 460.8659779
13 487.5349322
14 496.1846505
15 510.0727597
16 549.7325117
17 .
18 .
19 .
20 .
run;

proc reg data=tractorsales_1;
model sales = time/clm cli;
run;


data oligopolysales;
input
time sales;
datalines;
1 28.09294126
2 28.59809874
3 31.16172587
4 34.08948201
5 39.33011777
6 33.17379454
7 38.28440607
8 37.18852583
9 33.71152951
10 42.32518613
11 34.72306597
12 43.38661347
13 .
14 .
15 .
16 .
run;

proc reg data=oligopolysales;
model sales = time/clm cli;
run;


FILENAME REFFILE '/home/u54945437/DSCI5340/t6-4 hotel.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.hoteldata;
	GETNAMES=YES;
RUN;

proc print data=hoteldata;
title "data=SalesData";
run;

/* STEP 2 */

Data SalesData_MovingAverage;
Set hoteldata;
Array SalesLag {12} SalesLag0-SalesLag11;
SalesLag{1} = y;
do i = 2 to 12;
  SalesLag{i} = Lag(SalesLag{i-1});/*note Lag is a SAS function*/
end;
MovingAverage = 0;
do i = 1 to 12;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/12;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "data = SalesData_MovingAverage";
run;

/* STEP 3 */

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _n_ <= 4 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set hoteldata;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = y/CenteredMV;
proc print data = SalesData_SeasonalIndex;
title "data = SalesData_SeasonalIndex";

/* STEP 4 */

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Retain SeasIndex1-SeasIndex12 0;
Time = _N_;
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 12)= 0 then SeasIndex12 = SeasIndex12 + SeasonalIndexInitial;
/*  Get average on next set of lines */ 
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 12;
     SeasonalIndex{i} = SeasonalIndex{i}/ 3; 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;
/**Only keep last line**/
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex12 ;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex12;
title "Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set hoteldata;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Time = _N_; 
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 12)= 0 then SeasonalEffect  = SeasonalIndex{12};  
DeseasonalizedSales = y/SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
title "Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "DeseasonalizedSales regressed on Time";

proc print data = tempfile;
title "Predicted DeseasonalizedSales - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
CyclicalInitial = DeseasonalizedSales /Trend;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {2} CyclicalLag1-CyclicalLag2;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 2;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});/*note Lag is a SAS function*/
end;
CycMovingAverage = 0;
do i = 1 to 2;
  CycMovingAverage = CycMovingAverage + CyclicalLag{i};
end;
CycMovingAverage = CycMovingAverage/2;
Keep CycMovingAverage;
If _N_ = 1 then delete;
Drop i; 

proc print data = Cyclical;
title "data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales/(SeasonalEffect*Trend*CycMovingAverage);

proc print data = Decomposition;
Title "Decomposition";
 Run;


/* STEP 9 */

proc forecast data = DeseasonalizedData lead=7 out=prediction;
var y;
run;

proc print data=prediction;
title "Sales forecasts for the next 7 days";
run;
Quit;

data exercise7_5;
set WORK.hoteldata;
time = _n_;


data predcition;
input
time y;
datalines;
169 .
170 .
171 .
172 .
173 .
174 .
175 .
176 .
177 .
178 .
179 .
180 .
run;

data exercise7_5b;
set exercise7_5 predcition;
run;

proc reg data=exercise7_5b;
model y = time/clm cli;
run;


proc forecast data = exercise7_5 lead=12 out=prediction outlimit;
var y;
run;

proc print data=prediction;
run;
