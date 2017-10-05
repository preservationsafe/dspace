#!/bin/sh

useradd -m -G docker,sudo,buildmeister -c "Jeff Turman" turmanj
useradd -m -G docker,sudo,buildmeister -c "Brittany Rothengatter" BrittanyRothengatter
useradd -m -G docker,sudo,buildmeister -c "Mike Hagedon" mhagedonm
useradd -m -G docker,sudo,buildmeister -c "William Simpson" simpsonw
useradd -m -G docker,sudo,buildmeister -c "Elia Nazarenko" enazar
useradd -m -G docker,sudo,buildmeister -c "Andy Osborne" cao89

for USER in turmanj BrittanyRothengatter mhagedonm simpsonw enazar cao89; do

echo "asdf\nasdf" | passwd $USER

done

