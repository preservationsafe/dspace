#!/bin/sh

useradd -m --shell /bin/bash -G docker -c "Build Meister" buildmeister
useradd -m --shell /bin/bash -G docker,sudo -c "Jeff Turman" turmanj
useradd -m --shell /bin/bash -G docker,sudo -c "Brittany Rothengatter" BrittanyRothengatter
useradd -m --shell /bin/bash -G docker,sudo -c "Mike Hagedon" hagedonm
useradd -m --shell /bin/bash -G docker,sudo -c "William Simpson" simpsonw
useradd -m --shell /bin/bash -G docker,sudo -c "Elia Nazarenko" enazar
useradd -m --shell /bin/bash -G docker,sudo -c "Andy Osborne" cao89

for USER in buildmeister turmanj BrittanyRothengatter mhagedon simpsonw enazar cao89; do

echo "asdf\nasdf" | passwd $USER

done
