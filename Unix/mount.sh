#!/bin/bash

#Map Seapine servers to /mnt
mkdir /mnt/QAonDevfiles
mkdir /mnt/UpcomingReleasesonCamelot
echo "QA on devfiles"
mount -t cifs //devfiles/QA /mnt/QAonDevfiles -o username=stumpffk,domain=SEAPINE
echo "UpcomingReleases on camelot"
mount -t cifs //camelot/UpcomingReleases /mnt/UpcomingReleasesonCamelot -o username=stumpffk,domain=SEAPINE