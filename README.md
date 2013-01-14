libkoca
=======

Small library for shell scripting.
Including :
- cleanOnExit : remove a file upon script exiting (those who use mktemp will appreciate)
- getColor : assign color code to a variable (for sexy logs messages).
- lockMe : procide a lock mechanism to your script, preventing it for being launched more than once.
- getConfValue : read a key and return a value from a file .properties-like. Useful to provide a configuration file to your script.
- dieIfNotRoot : exit if the script is not run as root.

Et quelques autres, utiles mais moins souvent : vérifier qu'une chaine est une adresse IP, convertir des secondes en jour:heure:minutes:secondes, et vice versa, renvoyer le chemin où le script réside, ...

- TU, avec shunit2
- Construction dynamique : si une fonction ne passe pas les tests, elle n'est pas incluse dans le fichier final.
- Biblio exécutable : sh libkoca.sh vous fournit l'aide. sh libkoca.sh list vous donne la liste des fonctions contenues dans la biblio
- Vous ne vous voulez que la fonction lockMe ? faites eval "$(libkoca.sh lockMe)" et vous n'aurez que cette fonction dans l'espace de nom de votre script.
- fclone : duplique n'importe quelle fonction sous un autre nom
