

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo del Service que Ayuda al Usuario.                            - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Este Service y módulo de los EuroServices tiene la función de       - ##
##    ayudar a los usuarios de la red. Informarle de cómo es la red       - ##
##    y plantear las dudas de los a la Administración.                    - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####


sub help_x {

	my $Comprueba_Ayuda = lc($trozo[3]);
	if ($Comprueba_Ayuda eq "ayuda") { help_help(); }
	elsif ($Comprueba_Ayuda eq "creditos") { do_creditos(); }
	else {
		my $Comprueba_Dir = "sys/help/help/$Comprueba_Ayuda";
		if (-e $Comprueba_Dir) { ayuda("$N_help", "$Comprueba_Dir", "$helpserv"); }
		else { msg("$N_help", "Comando '12$trozo[3]' desconocido."); }
	 }
 }

sub help_help {

	my ($kaka, $AYUDA) = split(":$trozo[3] ", $_);

	if (!$AYUDA) { sintaxis("$N_help", "AYUDA <consulta>"); }
	else {

		canalopers("$N_help", "4CONSULTA!! 6<2$trozo[0]6> $AYUDA");
		msg("$N_help", "Su duda ha sido enviada al canal de los Operadores, en breve dispondrá de la ayuda necesaria.");
	 }
 }

sub do_creditos {

	# - Por favor, usted se ha bajado estos Servicios con lo que no han sido hechos por usted.
	# - Puede añadir más lineas pero no borre las que hay.
	# - Puedo ser pesado pero no es lógico que estemos trabajando muchas horas y con mucha
	#	ilusión para que una persona en 1 minuto nos haga perder todo ese trabajo, siendo
	#	además un trabajo que se distribuye gratuitamente.
	# - Si se detectan muchos plagios de los EuroServices se procederá a la eliminación del
	#	trabajo en la página web y sus desarrollos próximos serán privados.
	# - Repito: puede añadir todas las lineas que quieras pero no borres las que están.
	#
	# - Muchas gracias por usar estos Servicios de Red.
	# - Es así como pagas el trabajo realizado, dejando los créditos.
	#
	# Si quieres poner más info la sintaxis es:
	#      msg("$trozo[2]", "Aqui el texto");
	#       ^      ^            ^
	#       |      |            |
	#  SUBrutina.  |            |
	#              |            |
	#         Numérico del Bot. |
	#                           |
	#                      Texto a añadir.
	#
	#						    		Gracias.

	msg("$trozo[2]", "Euro12Services4! v. $version");
	msg("$trozo[2]", "");
	msg("$trozo[2]", "Desarrollador Principal:");
	msg("$trozo[2]", " - 6P <12lluneta\@irc-euro.org>");
	msg("$trozo[2]", "Colaboradores:");
	msg("$trozo[2]", " - 6JeRcO <12jerco\@irc-euro.org>");
	msg("$trozo[2]", "Página web del proyecto:");
	msg("$trozo[2]", " - 12Http://sourceforge.net/projects/euro-services");
	msg("$trozo[2]", " - 12Http://www.irc-services.tk Http://irc-euro.org/irc-services/");
	msg("$trozo[2]", "Agradecimientos especiales:");
	msg("$trozo[2]", " - Administración de 3IRC-Euro.org, sois muchos para nombraros aquí.");
	msg("$trozo[2]", " - A los BetaTester, por las críticas, consejos y sugerencias.");
	msg("$trozo[2]", " - |^RiCkY^| : Por estar siempre apoyandome y por la web irc-services.tk.");
	msg("$trozo[2]", " - PrOmEtEo^ : Por que este ReG está hecho como él queria.");
	msg("$trozo[2]", " - ivi14 : si te lo propones llegarás lejos ;)");
	msg("$trozo[2]", " - SuBnE[t] : Por prestar ayuda.");
	msg("$trozo[2]", " - En especial a los usuarios de 3IRC-Euro.org por aportar ideas y críticas.");
	msg("$trozo[2]", "");
	msg("$trozo[2]", "Sobre Reg v1.0");
	msg("$trozo[2]", " Es un módulo de registro de canales pensado originalmente como un cliente");
	msg("$trozo[2]", " separado de los Services, pero luego unido a estos.");
	msg("$trozo[2]", " Gracias al equipo de Comisión de Canales de IRC-Euro.org por las sugerencias, críticas,...");
	msg("$trozo[2]", " que me han dado en este proyecto. Es un ReG hecho a molde con lo que decían.");
	msg("$trozo[2]", "");
	msg("$trozo[2]", "Y con esto me despido del IRC, dar las gracias a todos los que");
	msg("$trozo[2]", "me han soportado, al principio en Terra y luego en IRC-Euro.org");
	msg("$trozo[2]", "12Pyrator van por ti!");
	msg("$trozo[2]", "A la administración de 3$mired por usar los Euro12Services4!");
 }


return 1;