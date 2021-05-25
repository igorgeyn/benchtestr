 DESCRIPTION OF FILES ON THE NEWWS FIVE-YEAR FULL IMPACT SAMPLE PUBLIC USE FILE

                                  CD #1


The Full Impact Sample data file and documentation include:

NOTE: All files are in ASCII.

\F5PCOVER.TXT  provides an introduction to the data and documentation on this CD
and offers suggestions on how to use the files.


\F5README.TXT [this file] describes the files stored on this CD.


\NPBCOVER.TXT  provides a general introduction to the data and documentation
of the 6-CD set and offers suggestions on how to use the files.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\DATA\N5PI1809.TXT

This is the ASCII data file with: UI earnings, welfare payments, Food Stamps,
combined income, and sample flags for all sample members (N=44,569). Each
sample member has 5 records of data.  The file is sorted by each sample
member's randomly generated IDNUMBER and record number.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\CODEBOOK\N5PI_CBK.TXT

This file contains the data codebook, a comprehensive description of
N5PI1809.TXT. For each variable on the data file the codebook provides the
following information:  The name of the variable and its starting and ending
columns on the ASCII file, the variable's SAS informat (5.0 is the default),
the variable label, a brief description of the variable and any issues with
the variable.

(Note: The data are stored in ASCII, so informats can be changed to conform
to any statistical or econometric software package.)

The codebook also displays the N, NMISS, MEAN, Standard Deviation, Minimum, and
Maximum for each variable.  For variables with 51 values or less, a frequency
distribution is listed.  The frequencies show the value labels. These may be
copied and, if necessary, modified to be read into SAS or any other statistical
or econometric software package.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\LAYOUT\N5PIIPUT.TXT

This file contains the body of a SAS input statement (variable name, starting
column, length, informat) which will read N5PI1809.TXT.  To run this input
statement in SAS you must add the words input to the top line and a semicolon to
the bottom line.  This statement can be modified to input the data into any
statistical or econometric software package.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\MEANS\N5PIMEAN.TXT

SAS PROC MEANS output contains the following information for all variables
by site:

N,Nmiss, Mean, Std Dev, Minimum, Maximum


\NEWWS\PUBLIC\5YEAR\FULLSAMP\LABELS\N5PILABL.TXT

SAS variable label statements for each variable of the data file.
Labels can be modified to conform to syntax rules of any statistical or
econometric software package.

\NEWWS\PUBLIC\5YEAR\FULLSAMP\TABLES\TWOYEAR

   \SAM2TBL1.TXT:  Displays sample sizes for full impact sample, 2-year Client
                   Survey respondents, 2-year Child Outcomes Study survey
                   respondents, Private Opinion Survey respondents, and
                   sample members who completed literacy and math tests at
                   baseline.  The table also shows random assignment dates.

   \AR2_TBL1.TXT:  These are annotated impact tables of key outcomes calculated
   \AR2_TBL2.TXT:  with administrative data.  Variable names are listed on
   \AR2_TBL3.TXT:  the right side of the tables.
   \AR2_TBL4.TXT:

   \DEM2TBL1.TXT:  Annotated table that displays background characteristics of
                   sample members.  Variable names are listed on the
                   left side.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\TABLES\FIVEYEAR

Outcome      Table Number

            \SMP5TBL1.TXT   Displays sample sizes for keys subsamples. Variable
                            names are included in table headers.


Earnings    \AR5TBL1.TXT    These are annotated impact tables of key outcomes
Earnings    \AR5TBL2.TXT    calculated with administrative data.  Variable
Earnings    \AR5TBL3.TXT    names are listed on the right side of the tables.
Earnings    \AR5TBL4.TXT
Earnings    \AR5TBL5.TXT
Earnings    \AR5TBL6.TXT
Earnings    \AR5TBL7.TXT


Welfare     \AR5TBL8.TXT
Welfare     \AR5TBL9.TXT
Welfare     \AR5TBL10.TXT
Welfare     \AR5TBL11.TXT

Food Stamps \AR5TBL12.TXT
Food Stamps \AR5TBL13.TXT
Food Stamps \AR5TBL14.TXT

Income      \AR5TBL15.TXT
Income      \AR5TBL16.TXT
Income      \AR5TBL17.TXT
Income      \AR5TBL18.TXT
Income      \AR5TBL19.TXT


            \DEMOTBL1.TXT:  Annotated table that displays background characteristics of
                            sample members.  Variable names are listed on the
                            the left side.


\NEWWS\PUBLIC\5YEAR\FULLSAMP\MEMOS


   \RES_MEMO.TXT:  Background information on the research design for the NEWWS
                   Evaluation, the research groups in each site, and the
                   random assignment design.

   \N5PIVARS.TXT:  Background information on administrative records source data
                   and additional outcome measures created from administrative
                   data.

   \IMP_MEMO.TXT:  Background information on estimating program impacts.


   \N5PITEST.TXT:  Background information on literacy and math tests that were
                   administered at study entry.


