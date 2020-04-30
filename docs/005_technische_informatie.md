# Technische informatie

## Wat is Terraform

[Terraform](https://www.terraform.io/) is een tool die het mogelijk maakt via code
infrastructuur op te zetten bij cloud providers zoals Azure, Google, Digitalocean of AWS. 

De code in **listing \ref{terraformexample}** kan bijvoorbeeld gebruikt worden
om een virtuele machine aan te vragen op Digitalocean.

```{#terraformexample .hcl-terraform caption="Een voorbeeld hoe een VM op Digitalocean aangevraagd kan worden"}
resource "digitalocean_droplet" "voorbeeld" {
  image = "ubuntu-18-04-x64"
  name = "Mijn Virtuele Machine"
  region = "ams3"
  size = "s-1vcpu-1gb"
}
```

Deze repository is zo gebouwd dat VMs aangevraagd kunnen worden via JSON configuratie.

## Wat is Ansible

[Ansible](https://www.ansible.com/) is een tool die het mogelijk maakt via YAML een server
te configureren.
Een compleet nieuwe server opgezet via Terraform heeft geen gebruikers of security configuratie,
Ansible wordt dan bijvoorbeeld ingezet om deze gebruikers aan te maken, security settings goed te zetten en bestanden toe te voegen.

De code in **listing \ref{ansibleexample}** zorgt dat de map /srv/mijn-applicatie bestaat
en dat de code uit `mijn-code` in de /srv/mijn-applicatie komt.

```{#ansibleexample .yaml caption="Voorbeeld Ansible code"}
- name: "Zorg dat /srv/mijn-applicatie bestaat"
  file:
    state: directory
    path: "/srv/mijn-applicatie"

- name: "Kopiëer bestanden uit mijn-code naar /srv/mijn-applicatie"
  copy:
    src: "mijn-code"
    dest: "/srv/mijn-applicatie"
```

Deze repository gebruikt Ansible om gebruikersaccounts aan te maken 
en docker te downloaden op alle machines. 
Daarna draait er ook overal een test nginx container om te controleren
of de server bereikt kan worden via het internet.
