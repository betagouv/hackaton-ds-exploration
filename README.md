# Exploration des données Démarches Simplifiées

Créé avec `ruby 3.0.2p107`

Le json de données est disponible [sur data.gouf.fr](https://www.data.gouv.fr/fr/datasets/descriptif-des-demarches-publiees/)

La description des champs est disponible [ici](https://www.demarches-simplifiees.fr/graphql/schema/index.html#definition-ChampDescriptor)

## Usage

### Recherche parmi les labels et descriptions de champs
```sh
# Produit un fichier search_quotient_famililal.json
# Accepte des regex en entrée
ruby search.rb "quotient familial"
```

### Recherche parmi les labels et descriptions de champs uniquement des pièces jointes
```sh
# Produit un fichier de search_attachments_quotient_famililal.json
# Accepte des regex en entrée
ruby search_attachments.rb "quotient familial"
```