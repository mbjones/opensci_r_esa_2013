ESA 2013 Workshop 
=================
Conducting Open Science using R and DataONE: A Hands-on Primer
============================================================== 

Venue: ESA 2013, Minneapolis, MN  
Proposed Date: August 4, 2013  
Status: Accepted Workshop  

Synopsis 
--------

Through hands-on activities, workshop participants at [[http://www.esa.org/minneapolis/ | ESA 2013]] will explore open science practices by using the R statistical system and libraries for data access from DataONE and rOpenSci to build analytical scripts to access data, learn basic data manipulation, and publish derived data and results in a manner that is open and citable.

Description
-----------
The inherent variability in ecological systems has placed a premium on well-designed studies that employ sophisticated analysis and modeling approaches. These analytical approaches are critically important to understanding and verifying conclusions from these experiments.  Although students learn how to acquire and analyze data, recently there has been increasing emphasis on doing so in an open manner that allows for full reproducibility of ecological science.  In this workshop, we will examine the convergence of open data and open source tools and their ability to jointly facilitate open science.

The purpose of this workshop is to highlight the use of open software tools for conducting open science in ecology.  Through a series of hands-on activities (see http://help.nceas.ucsb.edu/r), participants will explore approaches to accessing data from the [[http://www.dataone.org|DataONE]] federation in the [[http://www.r-project.org/|R analytical system]], and then conduct basic data assessment, summarization, and visualization using that data.  We will also expose students to various R libraries available from the rOpenSci project for accessing data, and to the use of R for generating data documentation and archiving data in DataONE-compatible data repositories.

We are targeting early-career scientists, including students, postdocs, and faculty that would benefit from new techniques for open science and educators who want to incorporate open science concepts in curricula. Participants should have a basic understanding of data analysis and statistics, and preferably basic exposure to the R system.  Participants must bring their own laptop to participate in hands-on activities, and must have the ability to install new software. 

Speakers
--------
  * Matthew Jones, [[http://www.nceas.ucsb.edu|NCEAS]]
  * Mark Schildhauer, [[http://www.nceas.ucsb.edu|NCEAS]]
  * Jim Regetz, [[http://www.nceas.ucsb.edu|NCEAS]]
  * Karthik Ram, UC Berkeley
  * Carl Boettiger, UC Santa Cruz

Prerequisites
-------------
- Install the R and neccessary package dependencies on your laptop

  - [R 3.0.1 for Mac OS X][RMac]
  - [R 3.0.1 for Windows][RWin]
  - [R Studio][RStudio]

[RMac]: http://cran.r-project.org/bin/macosx/
[RWin]: http://cran.r-project.org/bin/windows/
[RStudio]: http://www.rstudio.com/ide/download/desktop

Agenda
------

- 12:00 Introduction (30 minutes) (Mark)

  - Goals of the workshop
  - Open science, reproducibility, and open data
  - Conceptual overview of data management in R and DataONE (Mark)

- 12:30 Primer on Data Management in R (1 hour)

  - 12:30 Wrangling messy data into R (Karthik)
  - 1:00 Data manipulation (aggregate, merge, etc.) (Carl?)

- 1:30 DataONE access to open data (45 minutes) (Matt)

  - Reading data
  - Writing data

- 2:15 Break

- 2:45 Accessing databases via R (Matt)

- 3:15 rOpenSci (90 minutes) (Carl and Karthik)

  - rgbif, rfisheries, taxize, rfigshare
  - EML library

- Self-guided activities or overflow
