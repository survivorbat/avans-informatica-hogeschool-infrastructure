# Probleemstelling

## Situatie

Ik ben een student en werk aan mijn Solution Architecture project.
Om het project in de Cloud te kunnen draaien, heb ik een virtuele machine (VM) nodig.

Op het moment moet ik hiervoor mijn docent contacteren om te vragen of
er een VM toegevoegd kan worden op DigitalOcean (DO). Vervolgens moet ik
mijn SSH sleutel opsturen en moet de docent deze manueel toevoegen in
de DO interface.

Uit ervaring blijkt dit proces niet soepel te verlopen en kan het voorkomen
dat er zaken vergeten worden waardoor het lang duurt voordat de student met de VM uit de voeten kan.

Daarnaast is het onduidelijk wanneer en door wie een VM is toegevoegd,
waarom een VM bestaat en voor wie een VM is aangemaakt.

## Oplossing

Infrastructuur definiëren in code.
Nieuwe infrastructuur wordt aangevraagd via Pull Requests en door code toe te voegen of aan te passen.

Hoe IaC binnen de Informatica opleiding op Avans ingezet kan worden, wordt
in dit document verder behandeld.
