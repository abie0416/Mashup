@echo off
del ABLD.BAT
del bld.inf
del *.pkg
del *.mmp
del *.rss
del *.loc
del Makefile*
del .make.cache

if exist ui/ (
	echo Deleting ui...
	cd ui
	del *.*	
	if exist tmp/ (rd tmp)
	cd ..
	rd ui
)

if exist moc/ (
	echo Deleting moc...
	cd moc
	del *.*
	if exist tmp/ (rd tmp)
	cd ..
	rd moc
)

if exist rcc/ (
	echo Deleting rcc...
	cd rcc
	del *.*
	if exist tmp/ (rd tmp)
	cd ..
	rd rcc
)