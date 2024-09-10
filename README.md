# Exploration des données Démarches Simplifiées

Créé avec `ruby 3.0.2p107`

Le json de données est disponible [sur data.gouf.fr](https://www.data.gouv.fr/fr/datasets/descriptif-des-demarches-publiees/)

La description des champs est disponible [ici](https://www.demarches-simplifiees.fr/graphql/schema/index.html#definition-ChampDescriptor)


## Usage

Il faut avoir le jeu de données dézippé à côté du dossier `hackaton-ds-exploration` et lancer les commandes depuis le dossier `hackaton-ds-exploration` pour qu'elles fonctionnent.


## Rechercher parmi les labels et descriptions des pièces jointes

```sh
ruby search.rb "quotient familial"
```

[→ Voir les résultats](https://github.com/betagouv/hackaton-ds-exploration/tree/main/search_attachments)

Produit un fichier `search_attachments/{query}.json`
Accepte des regex en argument.

## Compter les combinaisons de N mots parmi les labels et descriptions des pièces jointes

```sh
ruby get_ngrams.rb
```

[→ Voir les résultats](https://github.com/betagouv/hackaton-ds-exploration/tree/main/words_analysis)

Produit 4 fichiers :
- `words_analysis/sequences_of_1_words.json` Compte tous les mots un par un
- `words_analysis/sequences_of_1_words.json` Compte toutes les paires de mots
- `words_analysis/sequences_of_1_words.json` Compte tous les paquets de 3 mots
- `words_analysis/sequences_of_1_words.json` Compte tous les paquets de 4 mots

On ignore les mots "inutiles" de la liste contenue dans [app/french_stop_words.yml](https://github.com/betagouv/hackaton-ds-exploration/blob/main/app/french_stop_words.yml)

On ignore aussi un max de caractères de ponctuations, ainsi que les chiffres (voir `Ngrams::SPLIT_REGEX`)