# City Hunter

## Fonctionnalités

City Hunter est un jeu mobile dans lequel le joueur doit placer une ville sur une carte vierge de France. Le joueur gagne des points en fonction de la distance entre le point qu'il a placé et la ville recherchée. Plus la distance est faible, plus le joueur gagne de points. Chaque partie dure 10 tours. Le joueur peut choisir la difficulté au début de chaque partie, cette dernière dépendant du nombre d'habitants des villes.
Le joueur a accès à l'historique de ses meilleurs scores pour chaque niveau de difficulté.


## Versions utilisées

Version de Flutter : 3.24.5
<br>
Version de Dart : 3.5.4


## API utilisées

Nous avons utilisé l'API du gouvernement concernant le découpage administratif des communes, dont voici la documentation : https://geo.api.gouv.fr/decoupage-administratif/communes.

De plus, pour afficher la carte sans les labels, nous avons utilisé l'API de CartoDB, dont voici le template de l'url : https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png
