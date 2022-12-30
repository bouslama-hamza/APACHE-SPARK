'''Charger le jeu de données mpg contenu dans le package {ggplot2} en mémoire, puis
consulter la page d’aide du jeu de données pour en prendre connaissance ;'''
library(ggplot2)
?mpg

'''Représenter à l’aide d’un nuage de points la relation entre la consommation sur
autoroute des véhicules de l’échantillon (hwy) et la cylindrée de leur moteur (displ)'''
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

'''Reprendre le code du graphique précédent et modifier la forme des points pour les
changer en symbole + ; modifier la couleur des + de manière à la faire dépendre du
nombre de cylindres (cyl) ;'''
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = factor(cyl)), shape = 21)

'''À présent, représenter par des boîtes à moustaches la distribution de la
consommation sur autoroute des véhicules (hwy) pour chacune des valeurs
possibles du nombre de cylindres (cyl) ;'''
ggplot(data = mpg) + geom_boxplot(mapping = aes(x = factor(cyl), y = hwy))

'''Charger le jeu de données economics contenu dans le package {ggplot2} en
mémoire, puis consulter la page d’aide du jeu de données pour en prendre
connaissance. Ensuite, ajouter au tableau (les créer) les variables u_rate et e_rate,
respectivement le taux de chômage et le taux d’emploi (on définira le taux de
chômage de manière très grossière ici : nombre de personnes non employées sur la
population totale) ;'''
library(ggplot2)
?economics
economics$u_rate <- 1 - economics$pop / economics$uempmed
economics$e_rate <- 1 - economics$u_rate

'''Représenter à l’aide de barres l’évolution dans le temps du taux de chômage, et
remplir les barres avec la couleur rouge'''
ggplot(data = economics) + geom_bar(mapping = aes(x = date, fill = u_rate , y = value), stat = "identity", color = "red")

'''Reprendre le code du graphique précédent et ajouter une couche permettant de
modifier les limites de l’axe des abscisses pour afficher les valeurs uniquement sur
la période “2012-01-01” à “2015-01-01” (utiliser la fonction coord_cartesian()).
Stocker le graphique dans un objet que l’on appellera p ;'''
p <- ggplot(data = economics) + geom_bar(mapping = aes(x = date, fill = u_rate , y= e_rate), stat = "identity", color = "red") + coord_cartesian(xlim = c("2012-01-01", "2015-01-01"))

'''Dans le tableau de données economics, sélectionner les variables date, u_rate et
e_rate, puis utiliser la fonction pivot_longer() pour obtenir un tableau dans lequel
chaque ligne correspond à la valeur d’une des variables (taux de chômage ou taux
d’emploi) à une date donnée. Stocker le résultat dans un objet que l’on appellera
df_3 ;'''
df_3 <- pivot_longer(economics, cols = c(u_rate, e_rate), names_to = "rate", values_to = "value")

'''Utiliser le tableau de données df_3 pour représenter graphiquement à l’aide de
barres les taux de chômage et taux d’emploi par mois sur la période “2012-01-01” à
“2015-01-01”. Sur le graphique, les barres représentant le taux de chômage et celles
représentant le taux d’emploi devront être superposées.'''
ggplot(data = df_3) + geom_bar(mapping = aes(x = date, fill = rate, y = value), stat = "identity", color = "red") + coord_cartesian(xlim = c("2012-01-01", "2015-01-01"))

'''Note : il s’agit de modifier légèrement le code ayant permis de réaliser le graphique
p.'''
p + geom_bar(mapping = aes(x = date, fill = rate, y = value), stat = "identity", color = "red")

'''Charger le package {WDI} (l’installer si nécessaire), puis en utilisant la fonction
WDI(), récupérer les données de PIB par tête (NY.GDP.PCAP.PP.KD, PPP, constant
2005 international $) et de taux de chômage (SL.UEM.TOTL.ZS, total, % of total labor pour la France, l’Allemagne et le Royaume Uni, pour la période allant de 1990
à 2015. Ces données doivent être stockées dans un tableau que l’on appellera df ;'''

library(WDI)
df <- WDI(country = c("FRA", "DEU", "GBR"), indicator = c("NY.GDP.PCAP.PP.KD", "SL.UEM.TOTL.ZS"), start = 1990, end = 2015)

'''Transformer le tableau df afin que chaque ligne indique : l’état (country), l’année
(year), le nom de la variable (variable) et la valeur (valeur) (utiliser la fonction
pivot_longer()). Puis, modifier la colonne variable afin qu’elle soit de type factor, et
que les étiquettes des niveaux NY.GDP.PCAP.PP.KD et deviennent GDP et
Unemployment respectivement ;'''

df <- pivot_longer(df, cols = c(NY.GDP.PCAP.PP.KD, SL.UEM.TOTL.ZS), names_to = "variable", values_to = "value")
df$variable <- factor(df$variable, levels = c("NY.GDP.PCAP.PP.KD", "SL.UEM.TOTL.ZS"), labels = c("GDP", "Unemployment"))

'''Représenter graphiquement l’évolution du PIB et du taux de chômage pour les trois
pays. Utiliser la fonction facet_wrap() afin de regrouper les variables par type : les
observations des valeurs du PIB d’un côté du “tableau” de graphiques, et celles du
taux de chômage de l’autre. Utiliser une représentation en ligne, en faisant
dépendre la couleur du pays ;'''

ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = country)) + facet_wrap(~variable, nrow = 2)

'''Reprendre le code du graphique précédent en le modifiant légèrement afin de
libérer les axes des ordonnées ;'''
ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = country)) + facet_wrap(~variable, nrow = 2) + coord_cartesian(ylim = c(0, NA))

'''Modifier les arguments esthétiques du graphique afin de faire dépendre le type de
ligne des pays de la manière suivante : des points pour la France, des tirets pour
l’Allemagne, des tirets longs pour le Royaume Uni. Définir l’épaisseur des lignes à
1.5 ;'''

ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = country, linetype = country), size = 1.5) + facet_wrap(~variable, nrow = 2) + coord_cartesian(ylim = c(0, NA))

'''Modifier légèrement le code ayant permis de réaliser le graphique de la question
précédente pour que la direction ne soit non plus horizontale (par défaut), mais
verticale (argument dir, ou à défaut, ncol dans ce cas précis) ;'''

ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = country, linetype = country), size = 1.5) + facet_wrap(~variable, ncol = 2) + coord_cartesian(ylim = c(0, NA))

''' En utilisant la fonction facet_wrap(), créer une grille de graphiques, de sorte que
chaque pannel représente l’évolution d’une seule série pour un pays donné ;'''

ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = variable)) + facet_wrap(~country, nrow = 3)

'''À présent, utiliser la fonction facet_grid() pour créer une grille de graphiques dans
laquelle les lignes correspondent aux pays et les colonnes aux variables. Prendre
soin de libérer les échelles ;'''

ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = variable)) + facet_grid(country ~ variable) + coord_cartesian(ylim = c(0, NA))

'''Reprendre la question précédente en faisant cette fois une girlle dans laquelle les
lignes correspondent aux variables et les colonnes aux pays.'''
ggplot(data = df) + geom_line(mapping = aes(x = year, y = value, color = variable)) + facet_grid(variable ~ country) + coord_cartesian(ylim = c(0, NA))