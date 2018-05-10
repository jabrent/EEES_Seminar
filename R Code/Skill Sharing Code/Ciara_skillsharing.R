#Ciara Kernan
#SeminaRRRRR skill sharing
#3 May 2018

#Sound analysis and manipulation with seewave package

install.packages("seewave")
library(seewave)
library(tuneR)
library(dplyr)

#creating spectrograms - here's a recording of a sheep bleat
data(sheep)
spectro(sheep) #2D spectrogram showing freq over time with amplitude contour
oscillo(sheep,f=22050)

data(peewit)
spectro(peewit)
spectro(peewit, colbg="black", collab = "white", colaxis = "white", collevels = seq(-20,0)) #mess with display settings etc
spectro3D(peewit) #can also make these in 3 dimensions if you can bypass all the errors, I think there are some defunct packages
oscillo(peewit)

#Katydid vibs - comparing substrate vibrations produced by a tremulation vs a stridulation
#Probably better done in traditional sound analysis software, but this gives nicer output

Balboana_tib <- readWave("Station3_Balboana_tibialis.wav", from = 3859, to = 3889, units = "seconds")
#reads in wave file where two types of vibration occur in close succession
oscillo(Balboana_tib,zoom=TRUE, title = "Vibrations produced by Balboana tibialis") #btw does anyone know easiest way to italicize species name in this title?
oscillo(Balboana_tib, from=5, to=25, title = "Vibrations produced by Balboana tibialis",identify=TRUE)
#lets you look at specific points on the oscillogram and returns amp and time
oscillo(Balboana_tib, from=7, to=15, title = "Vibration produced by Balboana tibialis")
#a closer look at just the tremulation
spectro(Balboana_tib)
#all of these vibrations are quite low frequency, so it can be tricky to analyse them


Balb_spec <- spec(Balboana_tib) #gets and plots power spectrum
fpeaks(Balb_spec,f=44100)

spec(sheep)

#Hey, I wonder what the speed of sound of a 4kHz sound wave in near-freezing seawater is...
#Seewave can tell you! Use function wasp ("WAvelength and SPeed of sound")

wasp(4000,t=1.0,c=NULL,s=23,d=1000,medium="sea") 
#gives you wavelength ($l) in meters and speed ($c) in meters per second

#Or figure out what's going on with ye olde Doppler effect: 
fdoppler(f=20000,c=340,vs=6,vo=0,movs="away")
#returns altered frequency of a source emitting a 20kHz wave moving at 6m/s away from a stationary observer

#other functions that can let you look at soundscape complexity or compare two sounds using different indices. 
#filters, etc. can be applied to get rid of noise or specific frequencies - useful for cleaning up audio recordigns
#
