# ivbinary_maker

Converts raw source data into *.ivbinary files for use in I, Voyager.

**This is a work in progress! It doesn't actually do anything yet...**

Download raw data files into folders described below:

### source_asteroids
Source: Asteroids - Dynamic Site, https://newton.spacedys.com/astdys/   
(comments mostly pasted from source)   
Proper elements:
* all.syn	-	Numbered and multiopposition asteroids; the catalog contains the Main Belt and Hungaria asteroids.
* tno.syn	-	Trans Neptunian Objects; the catalog contains TNO's.
* tro.syn	-	Trojan asteroids
* secres.syn -	Main Belt asteroids locked in secular resonance. Please note that in this file the proper eccentricity is replaced by Delta e, the amplitude of resonant libration in the eccentricity. Thus the values in that column cannot be compared with those of the other files. In the visualizer the resonant objects are placed in an empty region with e between 0.7 and 0.8. with the convention e=Delta e + 0.7.

Ephemeride elements:
* allnum.cat	- Numbered asteroids orbital elements, one line format, epoch near present time.
* ufitobs.cat	- Multiopposition asteroids orbital elements, one line format, epoch near present time.

Family data:
* all_tro.members	- Individual asteroid family membership. Note only asteroids belonging to some family are listed in this file; Trojans are included.
* all_tro.famtab	- Asteroid families summary table for each family. Trojan and Griqua families are included.
* all_tro.famrec	- Family status for each asteroid with synthetic proper elements. Status=0 indicates the asteroid is not in any family, according to the current classification. Trojans are included.

http://newton.dm.unipi.it/neodys
* neodys.cat	- Keplerian elements without covariance matrices
* neodys.ctc	- Equinoctial elements with covariance matrices
* catalog.tot	- Proper elements and encounter conditions
			
https://sbn.psi.edu/pds/resource/discover.html
* discover.tab	- Has name and discoverer for numbered asteroids as of 2008. File from EAR-A-5-DDR-ASTNAMES-DISCOVERY-V12.0/data.



### source_comets
Source: https://minorplanetcenter.net/iau/Ephemerides/EphemOrbEls.html   
File format: https://minorplanetcenter.net/iau/info/CometOrbitFormat.html

### source_rings
Source: Björn Jónsson, https://bjj.mmedia.is/data/s_rings
* backscattered.txt
* forwardscattered.txt
* unlitside.txt
* transparency.txt
* sat_rings_color.txt
