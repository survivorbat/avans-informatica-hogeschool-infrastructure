# Avans Informatica Infrastructure

Deze repository bevat de configuratie voor de huidige infrastructuur van het Avans Informatica Breda applicatielandschap.
Ideaal zou zijn om _alle_ draaiende systemen van docenten automatisch via deze repository te kunnen deployen. Alle documentatie omtrent Infrastructuur als Code is te vinden in de docs/ map. De bestanden in deze map worden automatisch gecompileerd naar een PDF in een pipeline.

De pipelines kun je hier vinden: [dev.azure.com/MaartenVanDerHeijdenProjecten/Projects/\_build](https://dev.azure.com/MaartenVanDerHeijdenProjecten/Projects/_build)

![Workflow diagram](docs/img/high-level.png)

## Opmerkingen/Verbeterpunten

Deze twee bugs worden z.s.m. verholpen.

## Avans Informatica Infrastructuur

Deze servers zijn 'speciaal' geconfigureerd via Ansible.

### Entrypoint

De entrypoint server is de reverse proxy die draait onder het domein [avans-informatica-breda.nl](https://avans-informatica-breda.nl).
Deze proxy handelt HTTPS af en voegt enkele security headers toe, dit zorgt ervoor
dat andere backends (bijvoorbeeld SonarQube of de CurriculumViewer) geen eigen https
afhandeling nodig hebben.

Gebaseerd op het request van een gebruiker stuurt de reverse proxy
de gebruiker door naar een backend. Een student die
sonarqube.avans-informatica.breda.nl bezoekt wordt bijvoorbeeld doorgestuurd naar de SonarQube backend
zonder hier iets van te merken.

De configuratie van deze proxy bevindt zich in `ansible/roles/avans-entrypoint/templates/etc/avans-informatica-breda/nginx`.
De webroot van deze entrypoint server is te vinden in de map `ansible/roles/avans-entrypoint/files/srv/app/www`.

Indien een ontwikkelaar wenst een server toe te voegen aan deze configuratie kan er een `.conf` bestand toegevoegd worden.

## Workflow

### Infrastructuur aanvragen

Alle informatie over Infrastructuur als Code is te vinden in de `docs/` folder.

### CI/CD

Dit project maakt gebruik van Azure Pipelines om continuous integration en continuous delivery
mogelijk te maken. Dit betekent dat **alle** commits op de master branch direct
gedeployed worden en dat productie servers geüpdate worden op basis van de
nieuwe configuratie.

Om deze reden zal er voornamelijk gewerkt worden op de **develop** branch en wordt er aan
contributors gevraagd of deze pull requests willen aanmaken indien zij klaar zijn
met het aanpassen of toevoegen van nieuwe code.

### SSH Sleutels

Een SSH sleutel kan makkelijk gegenereerd worden met het commando `ssh-keygen`.
