# Analyse des données du Hackaton DS

En vue de leur [Hackaton](https://pad.numerique.gouv.fr/ciXNcg5ZRKqOExJnaVQJ2A?both#) de fin septembre 2024, Démarches Simplifiées a mis à disposition [des données](https://www.data.gouv.fr/fr/datasets/descriptif-des-demarches-publiees/) sur ses démarches et leur contenus.

## Notre Objectif

Creuser les labels des champs de ces démarches pour en ressortir

*   Les informations les plus demandées aux usagers afin de voir celles qui pourraient ou devraient être récupérées automatiquement
*   Les informations demandées que l'on sait être déjà exister dans des API sur [api.gouv.fr](https://api.gouv.fr/rechercher-api)

## Méthode

### -> [Le code](https://github.com/betagouv/hackaton-ds-exploration/tree/main)

Nous avons concentré notre recherche sur les **champs de pièces jointes**, c'est à dire avec `__typename = PieceJustificativeChampDescriptor`

Il a aussi fallu aller chercher ces champs lorsqu'ils étaient imbriqués dans un champ multiple, avec `__typename = RepetitionChampDescriptor`

Nous avons ensuite retiré les [mots courants de la langue française](https://github.com/betagouv/hackaton-ds-exploration/blob/main/app/french_stop_words.yml) afin de simplifier la recherche.

Deux scripts ont été réalisés pour aggréger des données :

*   Un script qui compte des groupes de mots, et les trie par nombre d'occurences, pondéré par le nombre de dossiers
*   Un script qui permet d'effectuer une recherche et de sortir les démarches qui correspondent, triées par nombre de dossiers

## Les mots les plus utilisés

Définition rapide de "N-grams" : mots, paires de mots, triplets de mots, quadruplets (ça existe ?) de mots, etc...

Nous avons compté les N-grams pour N allant de 1 à 4, avec et sans pondération par nombre de dossiers.

Les résultats les plus intéressants ont été obtenus en comptant les paires de mots pondérées par nombre de dossiers.

### -> [Résultats bruts](https://raw.githubusercontent.com/betagouv/hackaton-ds-exploration/refs/heads/main/words_analysis/sequences_of_2_words_-_weighted.json)

On y distingue au milieu des paires de mots les plus récurrentes deux besoins prédominants (rappel : on a retiré les mots courants tels que *de* ou *d' *) :

*   Justifier son identité

    *   "pièce identité": 3,063,387 dossiers
    *   "titre séjour": 1,502,243 dossiers
    *   "carte identité": 1,015,904 dossiers
    *   "identité passeport": 845,452 dossiers
    *   "nationale identité": 631,381 dossiers
    *   "carte séjour": 557,631 dossiers

*   Justifier son adresse

    *   "justificatif domicile": 1,736,575 dossiers
    *   "attestation hébergement": 916,895 dossiers
    *   "quittance loyer": 908,440 dossiers
    *   "domicile hébergeant": 327,713
    *   "adresse domicile": 320,640

## Les recherches effecuées

Nous avons déjà simplment commencé par chercher les mots les plus courants qui remontaient lors de l'analyse des n-grams, pour obtenir le détail des dossiers concernés.

Puis nous avons cherché des termes qui nous intéressaient, pour lesquels nous savions qu'il pouvait exister des API.

### [-> Résultats bruts](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_summary.csv)

Chaque résultat de recherche contient un lien vers le détail du résultat de recherche, avec toutes les démarches et les champs complets qui ont été trouvés : [Exemple](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/passeport.json)

Chaque fichier de détail du résultat de recherche contient des liens vers les données complètes de chaque démarche trouvée : [Exemple](https://github.com/betagouv/hackaton-ds-exploration/blob/main/demarches/47865.json)

Les termes de recherche ont été transformés en [regex](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet) pour pouvoir match un maximum d'occurences. Parfois il y a des faux positifs, il faut donc aller voir le détail des résultats pour se rendre compte si le gros du volume n'est pas dû à un match absurde (par exemple "**extrait.+rne**" trouve "**extrait** blabla par inte**rne**t")

## Analyse des résultats de recherche

De manière générale, il faudrait éviter de demander aux usagers des données qui sont déjà accessibles aux administrations, que ce soit via API ou via des sites webs :

*   Pour simplifier la démarche pour l'usager
*   Pour s'assurer de la justesse et de la fraicheur des données
*   Pour s'assurer de l'authenticité des données et éviter la fraude
*   Parce que c'est ce qui est demandé par la loi (TODO Ajouter contexte juridique)

### Identité de l'usager

*   [pièce ou carte d'identité](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/_pi_e_ce_carte_identit_e_.json) : 3871 démarches, 3,669,474 dossiers
*   [passeport](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/passeport.json): 2290 démarches, 1,962,173 dossiers
*   [titre de séjour](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/titre_s_e_jour.json) : 1093 démarches, 1,518,936 dossiers
*   [photo d'identité](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/photo_identit_e_.json) : 1364 démarches, 1,401,989 dossiers

-> Une partie de ces besoins d'identification est sûrement adressable via une connexion FranceConnect de la part de l'usager, qui je crois est déjà disponible sur Démarches Simplifiées.\
-> Pour le titre de séjour et le passeport, c'est à creuser.

### Adresse de l'usager

*   [justificatif de domicile](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/justificatif_domicile.json) : 1,792 démarches, 1,748,133 dossiers
*   [quittance de loyer](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/quittance_loyer.json) : 718 démarches, 1,058,146 dossiers

-> On perçoit bien ici le besoin d'avoir une API pouvant donner (et garantir) simplement l'adresse d'un usager.

-> [Justif'Adresse](https://ants.gouv.fr/nos-missions/les-solutions-numeriques/justif-adresse)

### Identité d'étudiant

*   [certificat de scolarité](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/certificat_scolarit_e_.json) : 591 démarches, 273,635 dossiers
*   [carte étudiant](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/carte_e_tudiant.json) : 320 démarches, 50,644 dossiers
*   [numéro INE](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/num_e_ro_ine.json) : 22 démarches, 9,065 dossiers.

-> Il existe sur [API Particulier](https://particulier.api.gouv.fr/catalogue) l'API [Statut étudiant](https://api.gouv.fr/les-api/api-statut-etudiant)

### Données d'entreprises

*   [KBIS](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/_kbis_.json) : 524 démarches, 116,899 dossiers
*   [dirigeants](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/_dirigeants_.json) : 133 démarches, 8479 dossiers. (Il y a quelques faux positifs mais ça reste pertinent)

*Note : Nous avions aussi cherché "Extrait RNE" mais obtenu que des faux positifs.*

-> Ces informations sont disponibles sur [l'API Extrait RCS](https://entreprise.api.gouv.fr/catalogue/infogreffe/rcs/extrait) (qui fait partie d'[API Entreprises](https://entreprise.api.gouv.fr/)), ou sur [l'annuaire des entreprises](https://annuaire-entreprises.data.gouv.fr/)\
-> Le KBIS fait partie des documents que l'administration n'a légalement plus le droit de demander (TODO ajouter contexte juridique)

### Données d'associations

*   [statuts de l'association](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/_statuts_.json) : 2129 démarches, 168,533 dossiers
*   [PV d'assemblée générale](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/assembl_e_e_g_e_n_e_rale.json) : 596 démarches, 92,077 dossiers
*   [membres du bureau](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/membres_bureau.json) : 314 démarches, 22,650 dossiers

-> Les donnée d'association sont disponibles [en Open data](https://entreprise.api.gouv.fr/catalogue/djepva/associations_open_data), ainsi que [sur API Entreprises](https://entreprise.api.gouv.fr/catalogue/djepva/associations) avec des données supplémentaires pour les administrations

### Quotient Familial

*   [attestation CAF](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/attestation_caf.json) : 330 démarches, 92,959 dossiers
*   [quotient familial](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/quotient_familial.json) : 217 démarches, 67,027 dossiers
*   [attestation MSA](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/attestation_msa.json) : 94 démarches, 16,027 dossiers

-> Le quotient familial, ainsi que les allocataires et enfants concernés sont disponibles [sur API particulier](https://api.gouv.fr/les-api/api_quotient_familial_msa_caf).

### Signaux faibles : Nouveaux cas d'usage

Nous avons certaines APIs dont nous ne connaissions pas bien les cas d'usages. Mêmes si les volumes sont faibles, ces résultats sont l'occasion d'explorer l'usage et de nourrir notre bizdev.

*   [attestation RSA](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/attestation_rsa.json) : 17 démarches, 23,056 dossiers
*   [allocation adulte handicapé](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/allocation_adulte_handicap_e_.json) : 22 démarches, 4,905 dossiers
*   [allocation soutien familial](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/allocation_soutien_familial.json) : 5 démarches, 6076 dossiers
*   [prime d'activité](https://github.com/betagouv/hackaton-ds-exploration/blob/main/search_attachments/prime_activit_e_.json) : 2 démarches, 594 dossiers

-> API particulier

# Prolonger l'analyse

Il reste encore *beaucoup* de pièces jointes dont on n'a pas cherché si elles pouvaient être simplifiées : Plan cadastral, certificat médical, RIB, permis de conduire, etc...

Et nous ne nous sommes pas non plus plongés dans le détail de ces démarches, de qui les propose, ou de leurs différents cas d'usage.\
Il faudrait aussi regarder les autres champs que les pièces jointes, et les descriptions des démarches, bref ceci n'est que le début !

**A vous de jouer pour essayer de trouver ce qui pourraît (ou devrait) être automatisé !**
