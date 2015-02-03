#!/usr/bin/python

import glob

# Copy new licensing information
License = open('LICENSE','r')
LicenseCopy = License.readlines()

# Loop over every file in Files/
FileList = glob.glob('Files/*')
print "Updated Files:"
for i in range(len(FileList)):

    # Check if file already has a license statement
    #   if YES - DELETE OLD LICENSE
    #   if NO  - do nothing
    Begin = LicenseCopy[0] # licenses start with this
    End   = LicenseCopy[-1] # licenses end with this
    j = 0
    tmpFile = open(FileList[i],'r+')
    tmpFirstLine = tmpFile.readline()
    if tmpFirstLine == Begin:
        tmpLines = tmpFile.readlines()
        while tmpLines[j] != End:
            j += 1
    Old = tmpFile.readlines()
    New = Old[j:]

    #   ADD LICENSE TO BEGINNING OF FILE
    tmpFile.seek(0)
    # print New
    tmpFile.writelines(LicenseCopy + New)

    print FileList[i]
