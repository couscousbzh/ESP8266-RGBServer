# ESP8266-RGBServer

Demo : this video shows how to connect a RGB stip to a RGB Amplifier to a ESP8266 connected to usb (for power only).

ESP8266 board act as a http server which receive http request like http://192.168.1.18/?r=255&g=125&b=125 and display the corresponding color on the rgb strip.

Beside I wrote a Windows Phone app with a color picker and a button. Choose a color in the color picker on the phone and press the button. This will send a GET http request to the IP 192.168.1.18 which is the ESP board server. 

Done !

En Français : cette démo présente la connectique bande led RGB connecté à un amplificateur, connecté à l'esp8266. Ce dernier est programmer pour agir comme un seveur web et répond à des urls comme ceci : http://192.168.1.18/?r=255&g=125&b=125. La couleur RGB est récupérée depuis les paramètres de l'url et transmise à la bande led RGB qui affiche la couleur correspondante (a peu prêt...)

D'un autre coté j'ai créé une application windows phone avec un nuancier pour envoyer une couleur via une requete GET http à mon serveur sur l'IP correpondante (192.168.1.18)
Et voila, je choisi la lumiere que je veux depuis mon smartphone !

Youtube : https://youtu.be/zgZNVRWkRWE

