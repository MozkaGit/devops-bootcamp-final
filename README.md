# Projet IC Web App

Ce projet consiste à conteneuriser une application web Python utilisant Flask. L'application web servira de site vitrine pour accéder aux applications Odoo et pgAdmin.

## Étapes de conteneurisation

1. **Image de base :** Utilisation de l'image `python:3.6-alpine`.
2. **Répertoire de travail :** Le répertoire de travail est défini sur `/opt`.
3. **Installation de Flask :** Le module Flask version 1.1.2 est installé à l'aide de la commande `pip install flask==1.1.2`.
4. **Exposition du port 8080 :** Le port 8080 est exposé pour l'application.
5. **Variables d'environnement :** Les variables d'environnement `ODOO_URL` et `PGADMIN_URL` sont créées pour permettre la configuration des URL lors du lancement du conteneur.
6. **Lancement de l'application :** L'application `app.py` est lancée dans l'ENTRYPOINT à l'aide de la commande `python`.

## Dockerfile

Voici le contenu du Dockerfile utilisé pour la conteneurisation de l'application :

```Dockerfile
FROM python:3.6-alpine
LABEL maintainer="mozka@gmail.com"

RUN pip install flask==1.1.2

WORKDIR /opt
COPY app.py .
COPY templates ./templates
COPY static ./static

EXPOSE 8080

ENV ODOO_URL=https://odoo.com
ENV PGADMIN_URL=https://pgadmin.org

ENTRYPOINT ["python"]
CMD ["/opt/app.py"]
```

## Utilisation

Pour construire l'image Docker et lancer le container de test, on exécute les commandes suivantes :

1. Build de l'image:
`docker build -t ic-webapp:1.0 .`

2. Lancer le container de test:
`docker run --name test-ic-webapp -p 80:8080 -d ic-webapp:1.0`

3. Accès au site vitrine
Ouvrez un navigateur et accédez à **http://ip-machine**

![ic-webapp](https://github.com/MozkaGit/devops-bootcamp-final/assets/43102748/2b5d3b92-b813-4e87-9458-7c5b0e7a0a29)

4. Pousser l'image sur votre registre Docker Hub: `docker tag ic-webapp:1.0 <docker_user>/ic-webapp:1.0 && docker push <votre_nom_utilisateur_docker_hub>/ic-webapp:1.0`

## Déploiement sur Kubernetes

### Prérequis
Assurez-vous d'avoir Kubernetes installé et configuré localement.

### Étapes de déploiement

Nous allons déployer les ressources avec [`Kustomize`](https://kustomize.io/) :

1. Voici le contenu du fichier `kustomize.yaml` avec l'ordre de déploiement :

```yaml
resources:
  - namespace.yaml
  - service-clusterip-bdd.yaml
  - service-nodeport-ic.yaml
  - service-nodeport-odoo.yaml
  - service-nodeport-pgadmin.yaml
  - postgres-deploy.yaml
  - pgadmin-deploy.yaml
  - odoo-deploy.yaml
  - ic-deploy.yaml
```

2. Éxécutez le kustomize pour déployer les ressources :

    `kubectl apply -k .`

3. Une fois déployé, vous pouvez accéder à l'application web `ic-webapp` en utilisant le service de type NodePort. Trouvez le port NodePort attribué à `ic-webapp` en exécutant la commande suivante :

    `kubectl get svc ic-webapp -n icgroup`


Utilisez l'adresse IP du cluster et le port NodePort pour accéder à l'application dans votre navigateur.

Veuillez noter que vous devrez adapter les fichiers de configuration YAML en fonction de votre environnement et de vos besoins. Assurez-vous également d'exécuter les commandes dans le contexte approprié (namespace `icgroup` dans cet exemple).


## Lexique

`namespace.yaml`: Déploie le namespace `icgroup` pour isoler les ressources.

`ic-deploy.yaml`: Déploie le site vitrine de redirection `ic-webapp`.

`odoo-deploy.yaml`: Déploie l'ERP `Odoo`.

`pgadmin-deploy.yaml`: Déploie l'interface de gestion des bases de données `pgAdmin`.

`postgres-deploy.yaml`: Déploie la base de données `PostgreSQL`.

`service-clusterip-bdd.yaml`: Crée un service de type ClusterIP pour accéder à la base de données `PostgreSQL`.

`service-nodeport-ic.yaml`: Crée un service de type NodePort pour accéder au site vitrine `ic-webapp` depuis l'extérieur.

`service-nodeport-odoo.yaml`: Crée un service de type NodePort pour accéder à l'ERP `Odoo` depuis l'extérieur.

`service-nodeport-pgadmin.yaml`: Crée un service de type NodePort pour accéder à l'interface de gestion des bases de données `pgAdmin` depuis l'extérieur.

`kustomize`: Outil de configuration Kubernetes open-source qui permet la personnalisation et l’adaptation des fichiers de configuration YAML pour les déploiements applicatifs dans les clusters Kubernetes. En l'occurence nous l'utilisons pour séquencer le déploiements des ressources Kubernetes à l'aide d'un fichier de configuration YAML : `kustomization.yaml`.
