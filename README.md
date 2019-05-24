# Avans Informatica Infrastructure

Deze repository bevat de configuratie voor de huidige infrastructuur van het Avans Informatica Breda 
applicatielandschap. De scripts in deze repository zorgen ervoor dat een lege droplet (server)
zonder handmatig ingrijpen volledig wordt ingericht tot een draaiend systeem. Momenteel wordt
bijvoorbeeld de reverse-proxy server via de pipeline volledig opgezet met configuratie
en https certificaten.

Ideaal zou zijn om _alle_ draaiende systemen van docenten automatisch via deze repository
te kunnen deployen.

![Infrastructuur diagram](docs/Avans_Infrastructure_Diagram.png?raw=true "Infrastructuur Diagram")

## Avans Informatica Infrastructuur

### Algemeen

Momenteel worden er op **alle** servers de volgende stappen genomen:
- Verzeker dat de users (bv. rschellius, pvangastel) aangemaakt worden met de public keys beschikbaar
- Verzeker dat er alleen via SSH kan ingelogd worden met public keys en dat SSH goed ingesteld staat
- Verzeker dat de kernel extra security instellingen bevat

### Entrypoint

De entrypoint server is de reverse proxy die draait onder het domein [avans-informatica-breda.nl](https://avans-informatica-breda.nl).
Deze proxy handelt HTTPS af en voegt enkele security headers toe, dit zorgt ervoor
dat andere backends (bijvoorbeeld SonarQube of de CurriculumViewer) geen eigen https
afhandeling nodig hebben.

Gebaseerd op het request van een gebruiker stuurt de reverse proxy
de gebruiker door naar een backend. Een student die 
sonarqube.avans-informatica.breda.nl bezoekt wordt bijvoorbeeld doorgestuurd naar de SonarQube backend
zonder hier iets van te merken. 

De configuratie van deze proxy bevindt zich in `roles/avans-entrypoint/files/etc/avans-informatica-breda/nginx`.
De webroot van deze entrypoint server is te vinden in de map `roles/avans-entrypoint/files/srv/app/www`.

Indien een ontwikkelaar wenst een server toe te voegen aan deze configuratie kan er een configuratie bestand
toegevoegd worden.

## Workflow

### CI/CD

Dit project maakt gebruik van Travis om continuous integration en continuous delivery
mogelijk te maken. Dit betekent dat **alle** commits op de master branch direct
gedeployed worden en dat productie servers geüpdate worden op basis van de
nieuwe configuratie.

Om deze reden zal er voornamelijk gewerkt worden op de **develop** branch en wordt er aan
contributors gevraagd of deze pull requests willen aanmaken indien zij klaar zijn
met het aanpassen of toevoegen van nieuwe code.

Er is ook een **test** branch beschikbaar, deze is zo ingesteld dat alle commits hierop
gedeployed worden naar de tijdelijke **test.maarten.dev** server. Deze kan gebruikt
worden om een deployment te testen voor de reverse proxy, dit is echter tijdelijk
en er zal spoedig gewerkt moeten worden aan een testserver of ander
soort proefmiddel om de deployments uit te testen.

### Gevoelige waarden in de repository

Alle waarden die privé dienen te blijven (Oauth secrets, private keys) worden
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

Een SSH sleutel kan makkelijk gegenereerd worden met het commando `ssh-keygen -t ed25519`.

Deze publieke sleutel kan vervolgens in de `all.yml` geplaatst worden in de `inventories/production/group_vars`
om een sleutel aan een gebruiker te koppelen. Om manueel toegang te krijgen tot een server
kan de sleutel toegevoegd worden aan `/home/<gebruiker>/.ssh/authorized_keys` op de server.
