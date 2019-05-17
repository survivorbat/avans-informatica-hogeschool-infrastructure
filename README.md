# Avans Informatica Infrastructure

Deze repository bevat alle configuratie benodigd voor de huidige infrastructuur van
het Avans Informatica Breda netwerk. Ansible is een tool die gebruikt wordt om de servers
aangemaakt door Informatica op te zetten zonder daarbij programma's te hoeven downloaden
op de servers die in gebruik zijn.

De scripts in deze repository zorgen er bijvoorbeeld voor dat de benodigde services
draaien, dat Docker geïnstalleerd, dat de juiste gebruikers zijn aangemaakt is of dat de juiste configuratie in een
map geplaatst wordt.

## Avans Informatica Infrastructuur

### Basis instellingen

Momenteel worden er op elke server gedefiniëerd in het `inventories/production/hosts`
bestand de volgende stappen ondernomen:
- Verzeker dat de users (bv. rschellius, pvangastel) aangemaakt worden met de public keys beschikbaar
- Verzeker dat er alleen via SSH kan ingelogd worden met public keys en dat SSh goed ingesteld staat
- Verzeker dat er zekere instellingen goed staan i.v.m. security

Dit houdt in dat elke server in het netwerk deze instellingen krijgt doorgevoerd.

### Entrypoint Server

De entrypoint server is de reverse proxy die draait onder het domein [avans-informatica-breda.nl](https://avans-informatica-breda.nl).
Deze proxy handelt HTTPS af en voegt enkele security headers toe, dit zorgt ervoor
dat andere backends (bijvoorbeeld SonarQube of de CurriculumViewer) geen eigen https
afhandeling nodig hebben.

Gebaseerd op het subdomein dat een gebruiker benut via de browser stuurt de reverse proxy
de request door naar een bepaalde backend. Een student die 
sonarqube.avans-informatica.breda.nl bezoekt wordt bijvoorbeeld doorgestuurd naar de SonarQube backend
zonder hier iets van te merken. 

De configuratie van deze proxy bevindt zich in `roles/avans-entrypoint/files/etc/avans-informatica-breda/nginx`.
De webroot van deze entrypoint server is te vinden in de map `roles/avans-entrypoint/files/srv/app/www`.
Alle waarden uit de pipeline kunnen in deze templates gebruikt worden indien gewenst.

Indien een ontwikkelaar wenst een server toe te voegen aan deze configuratie kan er een configuratie bestand
toegevoegd worden en kan het domein gedefiniëerd worden in de group_vars.

## Workflow

### CI/CD

Dit project maakt gebruik van Travis om continious intergration en continious delivery
mogelijk te maken. Dit betekent dat **alle** commits op de master branch direct
gedeployed worden en dat productie servers geüpdate worden op basis van de
nieuwe configuratie.

Om deze reden zal er voornamelijk gewerkt worden op de Develop branch en wordt er aan
contributors gevraagd of deze pull requests willen aanmaken indien zij klaar zijn
met het aanpassen of toevoegen van nieuwe code.

### Gevoelige waarden in de repository

Alle waarden die mogelijk confidentieel zijn of privé dienen te blijven (Oauth secret, private keys) worden
geëncrypt met behulp van het programma ansible-vault. Deze secrets zijn versleuteld met een wachtwoord,
dit wachtwoord kan opgevraagd worden bij een van de administrators van de repository.

Ansible-vault is een programma dat meegeleverd wordt met Ansible, een python
programma dat geïnstalleerd kan worden via de Pip package manager van Python.

Om een waarde  te versleutelen kan er gebruik gemaakt worden van het commando:
`ansible-vault encrypt_string '<waarde>'`. Hierna zal het programma vragen om het 
vault wachtwoord, dit wachtwoord dient hetzelfde wachtwoord te zijn als het wachtwoord
van alle andere secrets. Vraag voorafgaand aan het gebruiken van deze commando dus
het wachtwoord aan een administrator.

#### Linux wachtwoorden encrypten

Om een gebruikersaccount wachtwoord toe te voegen moet eerst het wachtwoord gehasht worden
met het commando:

`openssl passwd -1`

Hieruit volgt een hash, deze hash moet vervolgend encrypted worden met de ansible-vault
en kan vervolgens toegevoegd worden aan.

#### SSH Sleutels

Vanwege het feit dat wachtwoorden in SSH gebrute-forced kunnen worden wordt er gebruik
gemaakt van SSh sleutels om te communiceren met servers. Een sleutel kan makkelijk
gegenereerd worden met het commando `ssh-keygen -t ed25519`, dit levert een sleutel op
gemaakt aan de hand van het ed25519 algoritme i.p.v. SSH.

Deze publieke sleutel kan vervolgens in het /home/(gebruiker)/.ssh/authorized_keys bestand
geplaatst worden van een server om toegang te krijgen via ssh.