/*Q2.1*/
data mileage;
input
miles;
datalines;
32.3
30.5
31.7
31.6
31.4
32.6
run;

Title 'Question 2.1';
proc univariate vardef=n data = mileage;
run;

/* 
2.1a: Sample Mean = 31.6833333
2.1b: Sample Variance = 0.45138889
2.1c: Sample STD = 0.67185481  
*/


/*Q2.2*/
data owed;
input
amount;
datalines;
99
123
75
138
105
65
116
run;

Title 'Question 2.2';
proc univariate vardef=n data = owed;
run;

/* 
2.2a: Sample Mean = 103
2.2b: Sample Variance = 577.428571
2.2c: Sample STD = 24.0297435 
*/

/*Q2.3*/
data berrypercent;
input
percent;
datalines;
65.4
64.9
65.2
65.7
65.0
65.7
65.3
64.7
run;

Title 'Question 2.3';
proc univariate vardef=n data =berrypercent;
run;

/* 
2.3a: Sample Mean = 65.2375
2.3b: Sample Variance = 0.11484375
2.3c: Sample STD = 0.33888604 
*/

/*Q2.4*/
data pollution;
input
matter;
datalines;
72
74
75
75
79
81
70
77
85
run;

Title 'Question 2.4';
proc univariate vardef=n data =pollution;
run;

/* 
2.4a: Sample Mean = 76.4444444
2.4b: Sample Variance = 19.1358025
2.4c: Sample STD = 4.37444882	
*/

/*Q2.5*/
data gasoline;
input
miles;
datalines;
30.8
31.7
30.1
31.6
32.1
33.3
31.3
31.0
32.0
32.0
30.9
30.4
32.5
30.3
31.3
32.1
32.5
31.8
30.4
30.5
32.0
31.4
30.8
32.8
30.6
31.5
32.4
31.0
29.8
31.1
run;

Title 'Question 2.5';
proc univariate vardef=n data =gasoline;
histogram miles;
run;

ods listing;
ods graphics off;
proc univariate data = gasoline plot ;
var miles ;
run;


/* 
2.5a: Sample Mean = 31.4
2.5b: Sample Variance = 0.72200
2.5c: Sample STD = 0.84971
*/

/*Q2.6*/
data bagweights;
input
weight;
datalines;
50.6
50.6
50.8
50.8
50.8
49.8
49.8
51.4
50.8
50.6
50.6
50.8
50.8
50.4
50.6
50.7
49.1
49.0
50.5
50.3
50.8
50.6
51.2
51.1
50.2
49.9
52.2
50.3
50.2
46.8
50.4
50.1
50.7
49.8
52.0
50.5
run;

Title 'Question 2.6';
proc univariate vardef=n data =bagweights;
histogram weight;
run;

ods listing;
ods graphics off;
proc univariate data =bagweights plot ;
var weight ;
run;


/* 
2.6a: Sample Mean = 50.4333333
2.6b: Sample Variance = 0.788
2.6c: Sample STD = 0.88769364
*/

Title 'Question 2.7';
data gasolinemileage;
a = probnorm((32.3-31.5)/0.8) - probnorm((30.7-31.5)/0.8);
b = probnorm((33.9-31.5)/0.8) - probnorm((29.1-31.5)/0.8);
c = probnorm((32.3-31.5)/0.8) - probnorm((29.7-31.5)/0.8);
d = probnorm((31.3-31.5)/0.8) - probnorm((31.0-31.5)/0.8);
e = probnorm((29.5-31.5)/0.8);
f = 1 - probnorm((29.5-31.5)/0.8);
g = 1- probnorm((33.4-31.5)/0.8);
h = probnorm((33.4-31.5)/0.8);
run;

proc print data=gasolinemileage;
title 'Question 2.7';
run;

 
/* Question 2.8
a. 0.5-0.05=0.45
Using table, z=1.645

b. 0.5-0.02 = 0.48
Using table z=2.054

c. 0.5-0.01=0.49
Using table z=2.326

d. 0.5-0.005=0.495
Using table z=2.575 */


/* Question 2.9
Using table, 
a = 1.895
b = 2.998
c = 3.499
*/

/* Question 2.10
Using table, 
a = 5.79
b = 19.30
*/

/* Question 2.11
Using table, 
a = 7.81473
b = 11.3449
*/

Title 'Question 2.12';
data waterconsumption;
a = probnorm((250000-300000)/20000);
b = probnorm((330000-300000)/20000) - probnorm((260000-300000)/20000);
c = 1 -probnorm((346000-300000)/20000);
proc print data=waterconsumption;
title 'Question 2.12';
run;

Title 'Question 2.13';
data hawk;
input
mileage;
datalines;
32.3
30.5
31.7
31.4
32.6
run;

Title '2.13 - 90% Interval';
proc ttest data=hawk alpha= 0.10;
var mileage;
run;

Title '2.13 - 95% Interval';
proc ttest data=hawk alpha= 0.05;
var mileage;
run;

Title '2.13 - 98% Interval';
proc ttest data=hawk alpha= 0.02;
var mileage;
run;

Title '2.13 - 99% Interval';
proc ttest data=hawk alpha= 0.01;
var mileage;
run;

/* Answer
90% - (30.9167 ,32.48337)
95% - (30.6799 ,32.7201)
98% - (30.3233 ,33.0767)
99% - (30.0083 ,33.3917)*/

Title 'Question 2.14';
data samples;
input
A B C;
datalines;
30.7 32.2 33.7
31.8 30.6 31.6
30.2 31.7 33.3
32.0 31.3 32.3
31.3 32.7 32.6
run;

Title '2.14 - Sample A';
proc ttest data=samples alpha= 0.01;
var A;
run;

Title '2.14 - Sample B';
proc ttest data=samples alpha= 0.01;
var B;
run;

Title '2.14 - Sample C';
proc ttest data=samples alpha= 0.01;
var C;
run;

/* Answer 2.14A
A - (29.6523 ,32.7477)
B - (30.0336 ,33.3664)
C- (30.9959 ,34.4041)

Answer 2.14B
All three intervals. 100%

Answer 2.14C
99% confidence means that only 1 time out of the 100 times, the true mean will not lie within the calculated interval
*/

Title '2.15';
data SummaryStats;
  infile datalines dsd truncover;
  input _STAT_:$8. X;
datalines;
N, 6
MEAN, 14.29
STD, 2.19
;
 
proc ttest data=SummaryStats alpha=0.01;
   var X;
run;
/*
a. (10.6850 ,17.8950) 
b. As the high end interval is lesser than 20, Zenex can be 99% confident its true mean will be lesser than20 */

Title '2.16';
data breakingdist;
  infile datalines dsd truncover;
  input _STAT_:$8. X;
datalines;
N, 81
MEAN, 57.8
STD, 6.02
;

Title '2.16 - 90% CI'; 
proc ttest data=breakingdist alpha=0.1;
   var X;
run;

Title '2.16 - 95% CI'; 
proc ttest data=breakingdist alpha=0.05;
   var X;
run;

Title '2.16 - 98% CI';
proc ttest data=breakingdist alpha=0.02;
   var X;
run;

Title '2.16 - 99% CI';
proc ttest data=breakingdist alpha=0.01;
   var X;
run;

/*
a. 
(56.6869 ,58.9131) 
(56.4689 ,59.1311) 
(56.2121 ,59.3879) 
(56.0350 ,59.5650) 

b. As the high end interval is lesser than 60ft, National Motors can be 95% confident its true mean will be lesser than 60ft 
c. As the high end interval is lesser than 60ft, National Motors can be 98% confident its true mean will be lesser than 60ft */


Title '2.17';
data shampoo;
  infile datalines dsd truncover;
  input _STAT_:$8. X;
datalines;
N, 6
MEAN, 15.7665
STD, 0.1524
;

Title '2.17a - 95% CI'; 
proc ttest data=shampoo sides=2 alpha=0.05 h0=16;
   var X;
run;

/* As P-value is 0.0133, which is lesser than alpha, we reject null hypothesis. 
Therefore, process should not be readjusted at the 0.05 level of significance */

Title '2.17b - 99% CI'; 
proc ttest data=shampoo sides=2 alpha=0.01 h0=16;
   var X;
run;

/* As P-value is 0.0133, which is greater than alpha, we will not reject null hypothesis. 
Therefore, process should be readjusted at the 0.01 level of significance */


Title '2.18 - Same data as 2.15'; 
proc ttest data=summarystats sides=l alpha=0.05 h0=20;
   var X;
run;
/* As P-value is 0.0007, which is lesser than alpha, we reject null hypothesis in favour of alternative.. 
As current mean is 14.29, which is below 20, a type 1 error has occured as we are readjusting 
the process when the mean is at the correct range */

Title '2.19 - Same data as 2.16'; 
proc ttest data=breakingdist sides=l alpha=0.05 h0=60;
   var X;
run;
/* As P-value is 0.0007, which is lesser than alpha, we reject null hypothesis in favour of alternative.. 
As current mean is 57.8, which is below 60, a type 1 error has occured as we are readjusting 
the process when the mean is at the correct range */

Title '2.20'; 
data banks;
input
debtratio;
datalines;
7
4
6
7
5
4
9
run;

proc ttest data=banks sides=u alpha=0.01 h0=3.5;
   var debtratio;
run;

/* 
a. Test Ho:u=3.5 versus Ha:u>3.5 to determine if the true mean of Ohio banks is higher 3.5% 
b. As P-value is 0.0055, which is lesser than alpha of 0.01, we will reject null hypothesis in favour 
of alternative 
*/
