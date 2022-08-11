

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo del Service que da apoyo a la Administración.                - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Este Service y módulo de los EuroServices tiene la función de       - ##
##    gestionar la Red, haciendo el trabajo de los OPERadores de la       - ##
##    Red más fácil, mejor y más cómodo.                                  - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####



$Ocomando = \%comandos_oper;


		#OPERadores & ADMINistradores.
$Ocomando -> {"HELP"} = "do_Ohelp";
$Ocomando -> {"AYUDA"} = "do_Ohelp";
$Ocomando -> {"GLOBAL"} = "do_global";
$Ocomando -> {"NGLOBAL"} = "do_nglobal";
$Ocomando -> {"OP"} = "do_opeada";
$Ocomando -> {"CREDITOS"} = "do_creditos";
$Ocomando -> {"DEOP"} = "do_deopeada";
$Ocomando -> {"VOICE"} = "do_voiceada";
$Ocomando -> {"DEVOICE"} = "do_devoiceada";
$Ocomando -> {"MODE"} = "do_mode";
$Ocomando -> {"MODO"} = "do_mode";
$Ocomando -> {"KICK"} = "do_kick";
$Ocomando -> {"KILL"} = "do_killea";
$Ocomando -> {"GLINE"} = "do_gline";
$Ocomando -> {"UNGLINE"} = "do_ungline";
$Ocomando -> {"NEWS"} = "do_news";
$Ocomando -> {"DELNEWS"} = "do_delnews";
$Ocomando -> {"RESTART"} = "do_restart";
$Ocomando -> {"SAY"} = "do_say";
$Ocomando -> {"VIEWIP"} = "look_ip";
$Ocomando -> {"ONLINE"} = "muestra_online";
$Ocomando -> {"SET"} = "do_set";
$Ocomando -> {"AKILL"} = "do_setakill";
$Ocomando -> {"ANULA"} = "do_anula";
$Ocomando -> {"PERMITE"} = "do_permite";
$Ocomando -> {"LISTA"} = "do_listanul";


		#ADMINinstradores
$Ocomando -> {"SHUTDOWN"} = "finaliza";
$Ocomando -> {"DIE"} = "finaliza";
$Ocomando -> {"RAW"} = "do_raw";
$Ocomando -> {"OPER"} = "cmd_oper";
$Ocomando -> {"ADMIN"} = "cmd_admin";


sub do_set {

	if (uc($trozo[4]) eq "CLONES") { &db_clones(); }
	elsif (uc($trozo[4]) eq "CLAVECIFRADO") { &db_cifrado(); }
	elsif (uc($trozo[4]) eq "ADMIN") {
		if (&administrador("$origen")) {

			if (uc($trozo[5]) eq "ADD") { &db_addadmin(); }
			elsif (uc($trozo[5]) eq "DEL") { &db_deladmin(); }
			else { sintaxis("$N_oper", "SET ADMIN <opción> [parámetros]"); }

		 }
		else { denegado("$N_oper", "$trozo[0]"); }
	 }
	elsif (uc($trozo[4]) eq "OPER") {
		if (&administrador("$origen")) {

			if (uc($trozo[5]) eq "ADD") { &db_addoper(); }
			elsif (uc($trozo[5]) eq "DEL") { &db_deloper(); }
			else { sintaxis("$N_oper", "SET OPER <opción> [parámetros]"); }

		 }
		else { denegado("$N_oper", "$trozo[0]"); }

	 }
	elsif (uc($trozo[4]) eq "SOCKSCHANNEL") { &db_channel(); }
	elsif (uc($trozo[4]) eq "MAXCLONES") { &db_maxclones(); }
	elsif (uc($trozo[4]) eq "NICKREG") {

		if (uc($trozo[5]) eq "ADD") { &db_addnickreg(); }
		elsif (uc($trozo[5]) eq "DEL") { &db_delnickreg(); }
		else { sintaxis("$N_oper", "SET NICKREG <opción> [parámetros]"); }
	 }
	elsif (uc($trozo[4]) eq "VHOST") {

		if (uc($trozo[5]) eq "ADD") { &db_addvhost(); }
		elsif (uc($trozo[5]) eq "DEL") { &db_delvhost(); }
		else { sintaxis("$N_oper", "SET VHOST <opción> [parámetros]"); }
	 }

	#Si es IRC-Euro.org FASE Pruebas.
	elsif ($mired =~/irc-euro.org/i) {
		if (uc($trozo[4]) eq "DEVEL") {
			if (&administrador("$origen")) {

				if (uc($trozo[5]) eq "ADD") { &db_adddevel(); }
				elsif (uc($trozo[5]) eq "DEL") { &db_deldevel(); }
				else { sintaxis("$N_oper", "SET DEVEL <opción> [parámetros]"); }

		 	 }
			else { denegado("$N_oper", "$trozo[0]"); }

	 	 }
	 	elsif (uc($trozo[4]) eq "BOT") {
		 	if (uc($trozo[5]) eq "ADD") { &db_addbot(); }
			elsif (uc($trozo[5]) eq "DEL") { &db_delbot(); }
			else { sintaxis("$N_oper", "SET BOT <opción> [parámetros]"); }
	 	 }
	 	else { sintaxis("$N_oper", "SET <opción> [parámetros]"); msg("$N_oper", "Más información 12HELP SET."); }
	 }
	#Fin.

	else { sintaxis("$N_oper", "SET <opción> [parámetros]"); msg("$N_oper", "Más información 12HELP SET."); }
 }

sub do_setakill {

	if (uc($trozo[4]) eq "ADD") { &do_akill(); }
	elsif (uc($trozo[4]) eq "DEL") { &do_delkill(); }
	elsif (uc($trozo[4]) eq "LIST") { &do_listakill(); }
	else { sintaxis("$N_oper", "AKILL <add/del/list> [parámetros]"); }
 }


#Empecemos a procesar los comandos....


sub do_Ohelp {

	my $primera_letra = lc($trozo[4]);
	if (!$primera_letra) { my $rutina = "sys/help/netserv/help"; ayuda("$N_oper", "$rutina", "$operserv"); }
	elsif ($primera_letra eq "set") {

		my $segunda_letra = lc($trozo[5]);
		if (!$segunda_letra) { my $rutina = "sys/help/netserv/set"; ayuda("$N_oper", "$rutina", "$operserv"); }
		elsif (-e "sys/help/netserv/set_$segunda_letra") { my $rutina = "sys/help/netserv/set_$segunda_letra"; ayuda("$N_oper", "$rutina", "$operserv"); }
		else { msg("$N_oper", "No existe ayuda para12 $trozo[4] $trozo[5]."); }
	 }
	elsif (-e "sys/help/netserv/$primera_letra") { my $rutina = "sys/help/netserv/$primera_letra"; ayuda("$N_oper", "$rutina", "$operserv"); }
	else { msg("$N_oper", "No existe ayuda para12 $trozo[4]."); }
 }

sub do_global {

		my $nick_global = $trozo[4];
		my $comprueba_numerico = $Nick_Numerico{lc($trozo[4])};
		my($kaka, $mensajee) = split(":$trozo[3] $trozo[4] ", $_);

		if ((!$nick_global) or (!$mensajee)) { sintaxis("$N_oper", "GLOBAL <nick> <mensaje>"); }
		elsif ($comprueba_numerico) { msg("$N_oper", "El nick12 $nick_globall está siendo usado en estos momentos"); }

		elsif (length($nick_global) > 9) { msg("$N_oper", "Su Nick no puede ser mayor de4 9 carácteres."); }
		elsif ($nick_global =~/€/) { msg("$N_oper", "El nick no puede llevar 4€."); }
		elsif ($nick_global =~/\¿/) { msg("$N_oper", "El nick no puede llevar 4¿."); }
		elsif ($nick_global =~/\?/) { msg("$N_oper", "El nick no puede llevar 4?."); }
		elsif ($nick_global =~/\$/) { msg("$N_oper", "El nick no puede llevar 4$."); }
		elsif ($nick_global =~/\!/) { msg("$N_oper", "El nick no puede llevar 4!."); }
		elsif ($nick_global =~/\¡/) { msg("$N_oper", "El nick no puede llevar 4¡."); }
		elsif ($nick_global =~/\·/) { msg("$N_oper", "El nick no puede llevar 4·."); }
		elsif ($nick_global =~/\@/) { msg("$N_oper", "El nick no puede llevar 4@."); }
		elsif ($nick_global =~/\º/) { msg("$N_oper", "El nick no puede llevar 4º."); }
		elsif ($nick_global =~/\ª/) { msg("$N_oper", "El nick no puede llevar 4ª."); }
		elsif ($nick_global =~/ñ/i) { msg("$N_oper", "El nick no puede llevar 4ñ."); }
		elsif ($nick_global =~/\¨/) { msg("$N_oper", "El nick no puede llevar 4¨."); }
		elsif ($nick_global =~/\`/) { msg("$N_oper", "El nick no puede llevar 4`."); }
		elsif ($nick_global =~/\´/) { msg("$N_oper", "El nick no puede llevar 4´."); }
		elsif ($nick_global =~/ç/i) { msg("$N_oper", "El nick no puede llevar 4ç."); }
		elsif ($nick_global =~/\;/) { msg("$N_oper", "El nick no puede llevar 4;."); }
		elsif ($nick_global =~/\:/) { msg("$N_oper", "El nick no puede llevar 4:."); }
		elsif ($nick_global =~/\+/) { msg("$N_oper", "El nick no puede llevar 4+."); }
		elsif ($nick_global =~/\*/) { msg("$N_oper", "El nick no puede llevar 4*."); }
		elsif ($nick_global =~/\#/) { msg("$N_oper", "El nick no puede llevar 4#."); }
		elsif ($nick_global =~/\(/) { msg("$N_oper", "El nick no puede llevar 4(."); }
		elsif ($nick_global =~/\)/) { msg("$N_oper", "El nick no puede llevar 4)."); }

		else {

			my $tiempoG = time();

			server("$numerico N $nick_global 1 $tiempoG - -global- +dorBhXk EuServ ${numerico}BA :Mensajería Global.");
			quote("${numerico}BA P \$*.$mired :$mensajee");
			quote("${numerico}BA Q :Global Services for my NET");
			canalopers("$N_oper", "Mensaje GLOBAL enviado por 12$trozo[0].");

		 }
 }

sub do_nglobal {


		my $nick_global = $trozo[4];
		my $comprueba_numerico = $Nick_Numerico{lc($trozo[4])};
		my($kaka, $mensajeee) = split(":$trozo[3] $trozo[4] ", $_);

		if ((!$nick_global) or (!$mensajeee)) { sintaxis("$N_oper", "NGLOBAL <nick> <mensaje>"); }
		elsif ($comprueba_numerico) { msg("$N_oper", "El nick12 $nick_global está siendo usado en estos momentos"); }

		elsif (length($nick_global) > 9) { msg("$N_oper", "Su Nick no puede ser mayor de4 9 carácteres."); }
		elsif ($nick_global =~/€/) { msg("$N_oper", "El nick no puede llevar 4€."); }
		elsif ($nick_global =~/\¿/) { msg("$N_oper", "El nick no puede llevar 4¿."); }
		elsif ($nick_global =~/\?/) { msg("$N_oper", "El nick no puede llevar 4?."); }
		elsif ($nick_global =~/\$/) { msg("$N_oper", "El nick no puede llevar 4$."); }
		elsif ($nick_global =~/\!/) { msg("$N_oper", "El nick no puede llevar 4!."); }
		elsif ($nick_global =~/\¡/) { msg("$N_oper", "El nick no puede llevar 4¡."); }
		elsif ($nick_global =~/\·/) { msg("$N_oper", "El nick no puede llevar 4·."); }
		elsif ($nick_global =~/\@/) { msg("$N_oper", "El nick no puede llevar 4@."); }
		elsif ($nick_global =~/\º/) { msg("$N_oper", "El nick no puede llevar 4º."); }
		elsif ($nick_global =~/\ª/) { msg("$N_oper", "El nick no puede llevar 4ª."); }
		elsif ($nick_global =~/ñ/i) { msg("$N_oper", "El nick no puede llevar 4ñ."); }
		elsif ($nick_global =~/\¨/) { msg("$N_oper", "El nick no puede llevar 4¨."); }
		elsif ($nick_global =~/\`/) { msg("$N_oper", "El nick no puede llevar 4`."); }
		elsif ($nick_global =~/\´/) { msg("$N_oper", "El nick no puede llevar 4´."); }
		elsif ($nick_global =~/ç/i) { msg("$N_oper", "El nick no puede llevar 4ç."); }
		elsif ($nick_global =~/\;/) { msg("$N_oper", "El nick no puede llevar 4;."); }
		elsif ($nick_global =~/\:/) { msg("$N_oper", "El nick no puede llevar 4:."); }
		elsif ($nick_global =~/\+/) { msg("$N_oper", "El nick no puede llevar 4+."); }
		elsif ($nick_global =~/\*/) { msg("$N_oper", "El nick no puede llevar 4*."); }
		elsif ($nick_global =~/\#/) { msg("$N_oper", "El nick no puede llevar 4#."); }
		elsif ($nick_global =~/\(/) { msg("$N_oper", "El nick no puede llevar 4(."); }
		elsif ($nick_global =~/\)/) { msg("$N_oper", "El nick no puede llevar 4)."); }

		else {

			my $tiempoG = time();

			server("$numerico N $nick_global 1 $tiempoG - -global- +doirBhXk EuServ ${numerico}BB :Mensajería Global.");
			quote("${numerico}BB O \$*.$mired :$mensajeee");
			quote("${numerico}BB Q :Global Services for my NET");
			canalopers("$N_oper", "Noticia GLOBAL enviada por 12$trozo[0].");

		 }
 }


sub do_killea {


		my $killnick = lc($trozo[4]);
		my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] ", $_);
		if ((!$killnick) or (!$mensaje)) { sintaxis("$N_oper", "KILL <nick> <mensaje>"); }

		else {

			my $NumKill = $Nick_Numerico{$killnick};
			if (!$NumKill) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }

			elsif (($Service_nicks eq "$killnick") or ($Service_chan eq "$killnick") or ($Service_reg eq "$killnick") or ($Service_oper eq "$killnick") or ($Service_memo eq "$killnick") or ($Service_global eq "$killnick") or ($Service_help eq "$killnick") or ($Service_sec eq "$killnick")) {
				msg("$N_oper", "NO puedes hacer un Kill a un Service de la Red4!!");
			 }

			elsif ($killnick eq "$origen") { msg("$N_oper", "No es de mucha lógica hacerse un Kill a si mismo..."); }
			else {

				quote("$N_oper D $NumKill :$mensaje");
				msg("$N_oper", "Usuario 12$trozo[4] ha sido Killeado.");
				canalopers("$N_oper", "Usuario 12$trozo[4] 12KILLeado por 12$trozo[0]");

			 }
		 }
 }

sub do_opeada {

		my $nickOP = lc($trozo[5]);
		my $canalOP = $trozo[4];
		if ((!$nickOP) or (!$canalOP)) { sintaxis("$N_oper", "OP <#canal> <nick>"); }

		elsif ($canalOP !~ /\#/) { msg("$N_oper", "El canal tiene que contener 4\#."); }
		else {

			my $nickOP = $Nick_Numerico{$nickOP};
			if (!$nickOP) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }
			else {

				quote("$N_oper M $canalOP +o $nickOP");

			 }
		 }
 }

sub do_deopeada {

		my $nickOP = lc($trozo[5]); my $canalOP = $trozo[4];
		if ((!$nickOP) or (!$canalOP)) { sintaxis("$N_oper", "DEOP <#canal> <nick>"); }

		elsif ($canalOP !~ /\#/) { msg("$N_oper", "El canal tiene que contener 4\#"); }
		else {

			my $nickOP = $Nick_Numerico{$nickOP};
			if (!$nickOP) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }
			else {

				quote("$N_oper M $canalOP -o $nickOP");

			 }
		 }
 }

sub do_devoiceada {

		my $nickOP = lc($trozo[5]); my $canalOP = $trozo[4];
		if ((!$nickOP) or (!$canalOP)) { sintaxis("$N_oper", "DEVOICE <#canal> <nick>"); }

		elsif ($canalOP !~ /\#/) { msg("$N_oper", "El canal tiene que contener 4\#"); }
		else {

			my $nickOP = $Nick_Numerico{$nickOP};
			if (!$nickOP) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }
			else {

				quote("$N_oper M $canalOP -v $nickOP");

			 }
		 }
 }

sub do_voiceada {

		my $nickOP = lc($trozo[5]);
		my $canalOP = $trozo[4];
		if ((!$nickOP) or (!$canalOP)) { sintaxis("$N_oper", "VOICE <#canal> <nick>"); }

		elsif ($canalOP !~ /\#/) { msg("$N_oper", "El canal tiene que contener 4\#"); }
		else {

			my $nickOP = $Nick_Numerico{$nickOP};
			if (!$nickOP) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }
			else {

				quote("$N_oper M $canalOP +v $nickOP");

			 }
		 }
 }

sub do_mode {

		my($kaka, $modo) = split(":$trozo[3] $trozo[4] ", $_);
		if ((!$trozo[4]) or (!$modo)) { sintaxis("$N_oper", "MODE <#canal> <modos>"); }

		elsif ($trozo[4] !~/\#/) { msg("$N_oper", "El canal tiene que contener 4\#"); }
		elsif (($modo =~ /o/i) or ($modo =~ /v/i)) { msg("$N_oper", "Para dar o quitar VOZ o \@ usa sus respectivos comandos."); }
		else {

			quote("$numerico M $trozo[4] $modo");
			canalopers("$N_oper", "12$trozo[0] cambia 12MODO de 12$trozo[4] a5 $modo");

		 }
 }

sub do_news {

	my $comprueba_numerico = $Nick_Numerico{lc($trozo[4])};

		if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_oper", "NEWS <nick> <mensaje>"); }
		elsif ($comprueba_numerico) { msg("$N_oper", "El nick12 $trozo[4] está siendo usado en estos momentos"); }

		elsif (length($trozo[4]) > 9) { msg("$N_oper", "Su Nick no puede ser mayor de4 9 carácteres."); }
		elsif ($trozo[4] =~/€/) { msg("$N_oper", "El nick no puede llevar 4€."); }
		elsif ($trozo[4] =~/\¿/) { msg("$N_oper", "El nick no puede llevar 4¿."); }
		elsif ($trozo[4] =~/\?/) { msg("$N_oper", "El nick no puede llevar 4?."); }
		elsif ($trozo[4] =~/\$/) { msg("$N_oper", "El nick no puede llevar 4$."); }
		elsif ($trozo[4] =~/\!/) { msg("$N_oper", "El nick no puede llevar 4!."); }
		elsif ($trozo[4] =~/\¡/) { msg("$N_oper", "El nick no puede llevar 4¡."); }
		elsif ($trozo[4] =~/\·/) { msg("$N_oper", "El nick no puede llevar 4·."); }
		elsif ($trozo[4] =~/\@/) { msg("$N_oper", "El nick no puede llevar 4@."); }
		elsif ($trozo[4] =~/\º/) { msg("$N_oper", "El nick no puede llevar 4º."); }
		elsif ($trozo[4] =~/\ª/) { msg("$N_oper", "El nick no puede llevar 4ª."); }
		elsif ($trozo[4] =~/ñ/i) { msg("$N_oper", "El nick no puede llevar 4ñ."); }
		elsif ($trozo[4] =~/\¨/) { msg("$N_oper", "El nick no puede llevar 4¨."); }
		elsif ($trozo[4] =~/\`/) { msg("$N_oper", "El nick no puede llevar 4`."); }
		elsif ($trozo[4] =~/\´/) { msg("$N_oper", "El nick no puede llevar 4´."); }
		elsif ($trozo[4] =~/ç/i) { msg("$N_oper", "El nick no puede llevar 4ç."); }
		elsif ($trozo[4] =~/\;/) { msg("$N_oper", "El nick no puede llevar 4;."); }
		elsif ($trozo[4] =~/\:/) { msg("$N_oper", "El nick no puede llevar 4:."); }
		elsif ($trozo[4] =~/\+/) { msg("$N_oper", "El nick no puede llevar 4+."); }
		elsif ($trozo[4] =~/\*/) { msg("$N_oper", "El nick no puede llevar 4*."); }
		elsif ($trozo[4] =~/\#/) { msg("$N_oper", "El nick no puede llevar 4#."); }
		elsif ($trozo[4] =~/\(/) { msg("$N_oper", "El nick no puede llevar 4(."); }
		elsif ($trozo[4] =~/\)/) { msg("$N_oper", "El nick no puede llevar 4)."); }
		else {

			if (!$N_news) {
				&do_news2();
			 }

			else {
				quote("$N_news Q :Reemplazando noticia...");
			    undef $N_news;
			    msg("$N_oper", "La anterior noticia con el roBOT 12$num_news ha sido eliminada.");
			    &do_news2();

			 }
		 }
 }

sub do_news2 {

	my $NickNEWS = $trozo[4]; my($kaka, $noticia) = split(":$trozo[3] $trozo[4] ", $_);
	$noticia =~ s/\"/\Ç/g;

	open(NEWS, ">news.db");
	print NEWS "Nicks\"$NickNEWS\n";
	print NEWS "Noticia\"$noticia\n";
	close(NEWS);

	my $tiempoNE = time();
	$N_news = "${numerico}BC";

	server("$numerico N $NickNEWS 1 $tiempoNE - -Noticia- +doirBhXk EuServ $N_news :Noticias de la RED");
	quote("${numerico}BC J $canaldebug GOD");

	msg("$N_oper", "3Noticia añadida con el Nick12 $NickNEWS.");
	msg("$N_oper", "Se enviará al usuario cuando conecte.");
	canalopers("$N_oper", "Añadida noticia 12ONCONNECT con el nick12 $trozo[4].");

 }

sub do_delnews {

		if (!$N_news) { msg("$N_oper", "No hay ninguna Noticia en este momento"); }
		else {

			quote("$N_news Q :Eliminando Noticia.");
			open(BORRA, ">news.db");
			print BORRA "\n";
			close(BORRA);
			msg("$N_oper", "Noticia borrada.");
			canalopers("$N_oper", "Borrrada noticia 12ONCONNECT.");

		 }
 }

sub do_kick {

		if ((!$trozo[4]) or (!$trozo[5]) or (!$trozo[6])) { sintaxis("$N_oper", "KICK <#canal> <nick> <razón>"); }
		elsif ($trozo[4] !~/\#/) { msg("$N_oper", "El nombre del canal tiene que contener 4#"); }
		else {

			my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] $trozo[5] ", $_);
			my $nickOP = $Nick_Numerico{lc($trozo[5])};

			if (!$nickOP) { msg("$N_oper", "El usuario12 $trozo[4] no está conectado en este momento."); }
			else {

				quote("$numerico K $trozo[4] $nickOP :$mensaje");

			 }
	 	}
 }

sub do_restart {

		canalopers("$N_oper", "Orden de 12REINICIO utilizada por 12$trozo[0]");
		quote("$N_nick2 Q :Euro12Services4!");
		quote("$N_oper Q :Euro12Services4!");
		quote("$N_aleto Q :Euro12Services4!");
		quote("$N_help Q :Euro12Services4!");
		quote("$N_vota Q :Euro12Services4!");
		quote("$N_reg Q :Euro12Services4!");

		if ($N_news) { quote("$N_news Q :Euro12Services4!"); }
		quote("$numerico SQ :Euro12Services4!");

 }

sub do_say {

		if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_oper", "SAY <#canal> <mensaje>"); }
		elsif ($trozo[4] !~/\#/) { msg("$N_oper", "El nombre del canal tiene que contener 4#"); }
		else {

			my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] ", $_);
			quote("$N_oper P $trozo[4] :$mensaje");
			msg("$N_oper", "Ale!! ya he dicho una tontería... estás bien?? xD");
			canalopers("$N_oper", "Comando 12SAY usado en 12$trozo[4] por 12$trozo[0]");

		 }
 }

sub finaliza {

	if (&administrador("$origen")) {

		canalopers("$N_oper", "Orden de 12DESCONEXIÓN utilizada por 12$trozo[0]");
		quote("$N_nick2 Q :Euro12Services4!");
		quote("$N_oper Q :Euro12Services4!");
		quote("$N_aleto Q :Euro12Services4!");
		quote("$N_help Q :Euro12Services4!");
		quote("$N_vota Q :Euro12Services4!");
		quote("$N_reg Q :Euro12Services4!");

		if ($N_news) { quote("$N_news Q :Euro12Services4!"); }
		quote("$numerico SQ :Euro12Services4!");
		exit;

	 }
	else { denegado("$N_oper", "$trozo[0]"); }
 }

sub do_raw {

	if (&administrador("$origen")) {

		if (!$trozo[4]) {
			sintaxis("$N_oper", "RAW <texto>");
			msg("$N_oper", "Este comando puede causar daños al Servidor, usalo con cuidado.");
		 }
		else {

			my($kaka, $mensaje) = split(":$trozo[3] ", $_);
			quote("$mensaje");
			canaladmins("$N_oper", "12$trozo[0] usa 12RAW: $raw");

		 }

	 }
	else { denegado("$N_oper", "$trozo[0]"); }

 }

sub look_ip {

		if (!$trozo[4]) { sintaxis("$N_oper", "VIEWIP <nick>"); }
		else {

			quote("$N_oper USERIP $trozo[4]");
	        defined(my $agh = <$socket>);
 	        my @recibeIP = split(" ", $agh);

	        if ($recibeIP[1] eq "340") {

		        my($kaka, $NickIP) = split(/\@/,$recibeIP[3]);
		        msg("$N_oper", "La IP de 12$trozo[4] es: $NickIP");

	         }

	        else { msg("$N_oper", "El Nick12 $trozo[4] no está actualmente conectado."); }

		 }
 }

sub do_gline {

		if ((!$trozo[4]) or ($trozo[5] eq "") or (!$trozo[6])) { sintaxis("$N_oper", "GLINE <nick> <tiempo> <motivo>"); }
		elsif (($trozo[5] =~/[A-Z]/i) or ($trozo[5] =~/\+/) or ($trozo[5] =~/\-/)) { msg("$N_oper", "El tiempo del GLINE tiene que ser en números y en segundos."); }
		else {

			quote("$N_oper USERIP $trozo[4]");
			my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] $trozo[5] ", $_);
			defined(my $ahh = <$socket>);
			my @recibeIPL = split(" ", $ahh);

	        if ($recibeIPL[1] eq "340") {

		        ($kaka, $NickIPL) = split(/\@/,$recibeIPL[3]);
		        quote("$numerico GLINE * +*\@$NickIPL $trozo[5] :$mensaje");
		        canalopers("$N_oper", "12$trozo[0] añade 12GLINE sobre 12$trozo[4],5 $NickIPL");

	         }

	        else { msg("$N_oper", "El Nick12 $trozo[4] no está actualmente conectado."); }


		 }
 }

sub do_ungline {

	if (!$trozo[4]) { sintaxis("$N_oper", "UNGLINE <IP>"); }
	else {

		if ($trozo[4] !~/\@/) {

			quote("$numerico GLINE * -*\@$trozo[4]");
			canalopers("$N_oper", "12$trozo[0] usa 12UNGLINE para 12$trozo[4]");

		 }
		else {

			quote("$numerico GLINE * -$trozo[4]");
			canalopers("$N_oper", "12$trozo[0] usa 12UNGLINE para 12$trozo[4]");

		 }
	 }
 }

sub muestra_online {

	open(ONLINE,"services.db");
	my @online = <ONLINE>;
	foreach (@online) {
		chomp;
		split(/"/);
		$i++;

		if ($_[0] eq "Inicio") {
			msg("$N_oper", "$_[1]");
			close(ONLINE);
		 }
	 }

 }

sub cmd_oper {

	if (!$trozo[4]) { sintaxis("$N_oper", "OPER <add/del/list> [nick]"); }

	elsif (lc($trozo[4]) eq "list") {

        tie(%OPERS,'MLDBM', "oper.db");
        %operdb = %OPERS;

		my $comprueba_opers = 0;
		msg("$N_oper", "Lista de 12Operadores:");

        while(($list_oper,$nivel) = each (%operdb)) {
	        if($operdb{$list_oper}->{LEVEL} == 1) {
		        msg("$N_oper", "12$list_oper");
				$comprueba_opers++;
             }
         }
		if($comprueba_opers == 0) {
			msg("$N_oper", "Lista de 12Operadores vacía.");
		}
	   untie(%OPERS);
	 }

	elsif (lc($trozo[4]) eq "add") {
		if (&administrador("$origen")) {

			if (!$trozo[5]) { sintaxis("$N_oper", "OPER <add/del/list> [nick]"); }
			else {

				my $add_oper = lc($trozo[5]);
				tie(%OPERS,'MLDBM', "oper.db");
				%operdb = %OPERS;
				my $sera_oper = $operdb{$add_oper};

				if ($sera_oper) { msg("$N_oper", "El usuario 12$trozo[5] ya es OPERador."); }
				else {

					my $nickDB = lc($trozo[5]);
			    	$nickDB =~ s/\^/\~/g;
					$nickDB =~ s/\[/\{/g;
					$nickDB =~ s/\]/\}/g;
					$tabla{'o'}++;

					#Primero lo añadimos en la tabla O con el nivel 5, de OPERador.
					quote("$numerico DB * $tabla{'o'} o $nickDB 5");

					#Luego lo añadimos en nuestros archivos, opers/su_nick_en_minúsculas.db

					$db_oper -> {$add_oper} = {"LEVEL" => 1};
					%OPERS = %operdb;


					#Si el bot OperServ es el admin de los Services...
					if ($oper_es_admin eq "SI") {
						mensaje("$N_oper", "$Service_oper", "OPER add $add_oper");
					 }

					#Por último, le asignamos una Vhost.
					$tabla{'v'}++;

			    	$add_oper =~ s/\^//g;
		        	$add_oper =~ s/\[//g;
		        	$add_oper =~ s/\]//g;
		        	$add_oper =~ s/\|//g;
		        	my $oper_vhost = "$add_oper.oper.$mired";
		        	quote("$numerico DB * $tabla{'v'} v $nickDB $oper_vhost");

		        	msg("$N_oper", "añadido como Operador a12 $trozo[5]");
		        	canalopers("$N_oper", "12$trozo[0] añade 12OPER a 12$trozo[5]");

				 }
			 }
			untie(%OPERS);
		 }
		else { denegado("$N_oper", "$trozo[0]"); }
	 }

	elsif (lc($trozo[4]) eq "del") {
		if (&administrador("$origen")) {

			if (!$trozo[5]) { sintaxis("$N_oper", "OPER <add/del/list> [nick]"); }
			else {

				my $del_oper = lc($trozo[5]);
				tie(%OPERS,'MLDBM', "oper.db");
                %operdb = %OPERS;
                my $sera_oper = $operdb{$del_oper};

				if ($sera_oper) {

					my $nickDB = lc($trozo[5]);
			    	$nickDB =~ s/\^/\~/g;
					$nickDB =~ s/\[/\{/g;
					$nickDB =~ s/\]/\}/g;
					$tabla{'o'}++;

					#Le borramos de la tabla O.
					quote("$numerico DB * $tabla{'o'} o $nickDB");

					#Ahora de nuestros archivos...
					delete($operdb{$del_oper});
                    %OPERS = %operdb;

					#Si el bot OperServ es ADMIN de los Servies...
					if ($oper_es_admin eq "SI") {
						mensaje("$N_oper", "$Service_oper", "OPER del $del_oper");
					 }

					#Por último le borramos la Vhost de OPERador.
					$tabla{'v'}++;
					quote("$numerico DB * $tabla{'v'} v $nickDB");
		        	msg("$N_oper", "Borrado como Operador a12 $trozo[5]");
		        	canalopers("$N_oper", "12$trozo[0] borra 12OPER a 12$trozo[5]");

				 }
				else { msg("$N_oper", "El usuario 12$trozo[5] no es OPERador."); }
				untie(%OPERS);
			 }
		 }

		else { denegado("$N_oper", "$trozo[0]"); }
	 }
	else { sintaxis("$N_oper", "OPER <add/del/list> [nick]"); }

 }


sub cmd_admin {

	if (!$trozo[4]) { sintaxis("$N_oper", "ADMIN <add/del/list> [nick]"); }

	elsif (lc($trozo[4]) eq "list") {

		tie(%ADMINS,'MLDBM', "oper.db");
        %operdb = %ADMINS;

		my $comprueba_admins = 0;
		msg("$N_oper", "Lista de 12Administradores:");

        while(($list_admin,$nivel) = each (%operdb)) {
	        if($operdb{$list_admin}->{LEVEL} == 2) {
		        msg("$N_oper", "12$list_admin");
				$comprueba_admins++;
             }
         }
		if($comprueba_admins == 0) {
			msg("$N_oper", "Lista de 12Administradores vacía.");
		}
	   untie(%ADMINS);
	 }

	elsif (lc($trozo[4]) eq "add") {
		if (&administrador("$origen")) {

			if (!$trozo[5]) { sintaxis("$N_oper", "ADMIN <add/del/list> [nick]"); }
			else {

				my $add_admin = lc($trozo[5]);
				tie(%ADMINS,'MLDBM', "oper.db");
				%operdb = %ADMINS;

				if ($operdb{$add_admin}->{LEVEL} == 2) { msg("$N_oper", "El usuario 12$trozo[5] ya es ADMINistrador."); }
				else {

					my $nickDB = lc($trozo[5]);
			    	$nickDB =~ s/\^/\~/g;
					$nickDB =~ s/\[/\{/g;
					$nickDB =~ s/\]/\}/g;
					$tabla{'o'}++;

					#Primero lo añadimos en la tabla O con el nivel 10.
					quote("$numerico DB * $tabla{'o'} o $nickDB 10");

					#Luego lo añadimos en nuestros archivos, admins/su_nick_en_minúsculas.db
					$db_oper -> {$add_admin} = {"LEVEL" => 2};
					%ADMINS = %operdb;


					#Si el bot OperServ es el ROOT de los Services...
					if ($oper_es_root eq "SI") {
						mensaje("$N_oper", "$Service_oper", "ADMIN add $add_admin");
					 }

					#Por último, le asignamos una Vhost.
					$tabla{'v'}++;

			    	$add_admin =~ s/\^//g;
		        	$add_admin =~ s/\[//g;
		        	$add_admin =~ s/\]//g;
		        	$add_admin =~ s/\|//g;
		        	my $admin_vhost = "$add_admin.admin.$mired";

		        	quote("$numerico DB * $tabla{'v'} v $nickDB $admin_vhost");
		        	msg("$N_oper", "Añadido como Administrador a12 $trozo[5]");
		        	canaladmins("$N_oper", "12$trozo[0] añade 12ADMIN a 12$trozo[5]");

				 }
			 }
			untie(%ADMINS);
		 }
		else { denegado("$N_oper", "$trozo[0]"); }
	 }

	elsif (lc($trozo[4]) eq "del") {
		if (&administrador("$origen")) {

			if (!$trozo[5]) { sintaxis("$N_oper", "ADMIN <add/del/list> [nick]"); }
			else {

				my $del_admin = lc($trozo[5]);
				tie(%ADMINS,'MLDBM', "oper.db");
                %operdb = %ADMINS;

				if ($operdb{$del_admin}->{LEVEL} == 2) {

					my $nickDB = lc($trozo[5]);
			    	$nickDB =~ s/\^/\~/g;
					$nickDB =~ s/\[/\{/g;
					$nickDB =~ s/\]/\}/g;
					$tabla{'o'}++;

					#Le borramos de la tabla O.
					quote("$numerico DB * $tabla{'o'} o $nickDB");

					#Ahora de nuestros archivos...
					delete($operdb{$del_admin});
                    %ADMINS = %operdb;

					#Si el bot OperServ es ROOT de los Servies...
					if ($oper_es_root eq "SI") {
						mensaje("$N_oper", "$Service_oper", "ADMIN del $del_admin");
					 }

					#Por último le borramos la Vhost de OPERador.
					$tabla{'v'}++;
					quote("$numerico DB * $tabla{'v'} v $nickDB");
		        	msg("$N_oper", "Borrado como Administrador a12 $trozo[5]");
		        	canaladmins("$N_oper", "12$trozo[0] borra 12ADMIN a 12$trozo[5]");

				 }
				else { msg("$N_oper", "El usuario 12$trozo[5] no es ADMINistrador."); }
				untie(%ADMINS);
			 }
		 }

		else { denegado("$N_oper", "$trozo[0]"); }
	 }
	else { sintaxis("$N_oper", "ADMIN <add/del/list> [nick]"); }

 }

sub do_akill {

	if ((!$trozo[5]) or (!$trozo[6])) { sintaxis("$N_oper", "AKILL ADD <nick> <motivo>"); }
	else {

		my $nick_akill = lc($trozo[5]);

		open(LEEA, "akill.db");
		my @lakill = <LEEA>;
		foreach (@lakill) {
			chomp; split(/"/);
			$i++;

			if($_[0] eq "$nick_akill") {
				msg("$N_oper", "El nick12 $trozo[5] ya estaba en la lista de Akill.");
				return;
				close(LEEA);
			 }

		 }
		my($kaka, $razon) = split(":$trozo[3] $trozo[4] $trozo[5] ", $_);
		$razon =~ s/\"/\Ê/g;

		open(ADDA, ">>akill.db");

		print ADDA "$nick_akill\"$razon\n";
		msg("$N_oper", "El nick12 $trozo[5] ha sido añadido a la lista de Akills.");
		canalopers("$N_oper", "12$trozo[0] añade un 12AKILL sobre12 $trozo[5].");

		close(ADDA);
		close(LEEA);
	 }
 }

sub do_delkill {

	if (!$trozo[5]) { sintaxis("$N_oper", "AKILL DEL <nick>"); }
	else {

		my $nick_akill = lc($trozo[5]);

		$i = 0; open(LEEAA, "akill.db");
		my @lakill = <LEEAA>;
		foreach (@lakill) {

			chomp; split(/"/);
			$i++;
			if ($_[0] eq "$nick_akill") {

				my $j = $i - 1;
				splice(@lakill,$j,1);

				open(LEEAA2, ">akill.db");
				foreach (@lakill) {

					print LEEAA2 "$_\n";

				 }

				msg("$N_oper", "El usuario12 $trozo[5] ha sido borrado de la lista de Akills.");
				canalopers("$N_oper", "12$trozo[0] borra el 12AKILL de12 $trozo[5].");

				close(LEEAA2);
				close(LEEAA);
				return;
			 }
		 }
		msg("$N_oper", "El usuario12 $trozo[5] no tiene ningún Akill.");

	 }
 }

sub do_listakill {
	msg("$N_oper", "Lista actual de 12AKILLS:");

	open(LEEA, "akill.db");
	$i = 0;
	my @lakill = <LEEA>;
	foreach (@lakill) {
		chomp; split(/"/);
		$i++;
		if ($_[0]) {
			msg("$N_oper", "5 $_[0]");
		 }
		close(LEEA);
	 }

 }

sub do_anula {

	my $anula_nick = lc($trozo[4]);

	if (!$trozo[4]) { sintaxis("$N_oper", "ANULA <nick>"); }
	elsif (-e "anulados/$anula_nick.db") { msg("$N_oper", "El usuario12 $trozo[4] ya tiene el servicio anulado."); }
	else {

		open(ANULA, ">>anulados/$anula_nick.db");
		print ANULA "Anulado por $trozo[0]\n";
		close(ANULA);

		msg("$N_aleto", "Se le ha anulado el servicio a12 $trozo[4].");
		canalopers("$N_aleto", "12$trozo[0] 12ANULA el servicio a12 $trozo[4].");

	 }
 }

sub do_permite {

	my $anula_nick = lc($trozo[4]);

	if (!$trozo[4]) { sintaxis("$N_oper", "PERMITE <nick>"); }
	elsif (-e "anulados/$anula_nick.db") {

		system("rm -rf anulados/$anula_nick.db");
		msg("$N_oper", "Se le ha dado de alta el servicio a12 $trozo[4].");
		canalopers("$N_oper", "12$trozo[0] 12PERMITE el servicio a12 $trozo[4].");

	 }
	else { msg("$N_oper", "El usuario12 $trozo[4] no tiene el servicio anulado."); }
 }

sub do_listanul {

	my @anulados;
	opendir(VANUL,anulados);

    while ($anulnick = readdir(VANUL)) {
	    push @anulados, $anulnick;
     }

    close(VANUL);
    msg("$N_oper", "Lista de usuarios 12ANULADOS:");

    foreach (@anulados) {
	    if ($_ =~ /.db/) {
		    $_ =~ s/.db//g;
		     msg("$N_oper", "5 $_");
         }
     }

 }


#Aquí los comandos especiales de las Tablas del IrcuHispano.
#Web de desarrollo: Http://www.irc-dev.net · Http://www.argo.es/~jcea/irc
#Explicación de las Tablas: Http://www.irc-euro.org/devel/tabla.doc


sub db_clones {

	if ((!$trozo[5]) or (!$trozo[6])) { sintaxis("$N_oper", "SET CLONES <ip> <máximo de clones>"); }
	elsif ($trozo[6] =~/[A-Z]/i) { msg("$N_oper", "El máximo de conexiones sólo puede contener números."); }
	else {

		$tabla{'i'}++;
		quote("$numerico DB * $tabla{'i'} i $trozo[5] $trozo[6]");
		msg("$N_oper", "La Ip12 $trozo[5] pasa a tener el límite de conexiones a12 $trozo[6].");
		canalopers("$N_oper", "12$trozo[0] aumenta el máximo de 12CLONES a12 $trozo[5] hasta12 $trozo[6].");

	 }
 }

sub db_cifrado {

	if (!$trozo[5]) { sintaxis("$N_oper", "SET CLAVECIFRADO <clave>"); }
	else {

		$tabla{'v'}++;
		quote("$numerico DB * $tabla{'v'} v . $trozo[5]");
		msg("$N_oper", "Clave de Cifrado de las IP's Virtuales cambiada a12 $trozo[5]");
		canalopers("$N_oper", "12$trozo[0] cambia la 12CLAVE DE CIFRADO de las IP's Virtuales.");

	 }
 }

sub db_maxclones {

	if (!$trozo[5]) { sintaxis("$N_oper", "SET MAXCLONES <numero>"); }
	elsif ($trozo[5] =~/[A-Z]/i) { msg("$N_oper", "El límite de clones tiene que estar expresado en números!"); }
	else {

		$tabla{'i'}++;
		quote("$numerico DB * $tabla{'i'} i . $trozo[5]");
		msg("$N_oper", "El número permitidos ha cambiado a12 $trozo[5].");
		canalopers("$N_oper", "Cambiado el 12MÁXIMO DE CLONES permitidos a12 $trozo[5].");

	 }
 }

sub db_channel {

	if (!$trozo[5]) { sintaxis("$N_oper", "SET SOCKSCHANNEL <numero>"); }
	elsif ($trozo[5] !~/\#/) { msg("$N_oper", "EL nombre del canal tiene que contener 12#."); }
	else {

		$tabla{'b'}++;
		quote("$numerico DB * $tabla{'b'} b sockschannel $trozo[5]");
		msg("$N_oper", "El canal donde el servidor mostrará los \"Insecures Wingates\" pasa a ser 12$trozo[5]");
		canalopers("$N_oper", "Cambiado el canal donde se mostrarán los Insecures Wingates, pasa a ser 12$trozo[5]");

	 }
 }

sub db_addadmin {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET ADMIN ADD <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'o'}++;

		quote("$numerico DB * $tabla{'o'} o $nickDB 10");
		msg("$N_oper", "Añadido el usuario12 $trozo[6] en las BDD como ADMINistrador.");
		canalopers("$N_oper", "12$trozo[0] AÑADE en 12BDD ADMIN a12 $trozo[6].");

	 }
 }

sub db_deladmin {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET ADMIN DEL <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
		if (&administrador("$nickDB")) {

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'o'}++;

		quote("$numerico DB * $tabla{'o'} o $nickDB");
		msg("$N_oper", "Borrado el usuario12 $trozo[6] en las BDD como ADMINistrador.");
		canalopers("$N_oper", "12$trozo[0] BORRA en 12BDD ADMIN a12 $trozo[6].");

		 }
		else { msg("$N_oper", "El usuario12 $trozo[6] no está en las BDD como ADMINistrador."); }
	 }
 }

sub db_addoper {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET OPER ADD <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'o'}++;

		quote("$numerico DB * $tabla{'o'} o $nickDB 5");
		msg("$N_oper", "Añadido el usuario12 $trozo[6] en las BDD como OPERador.");
		canalopers("$N_oper", "12$trozo[0] AÑADE en 12BDD OPER a12 $trozo[6].");

	 }
 }

sub db_deloper {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET OPER DEL <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
		if (&operador("$nickDB")) {

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'o'}++;

		quote("$numerico DB * $tabla{'o'} o $nickDB");
		msg("$N_oper", "Borrado el usuario12 $trozo[6] en las BDD como OPERador.");
		canalopers("$N_oper", "12$trozo[0] BORRA en 12BDD OPER a12 $trozo[6].");

		 }
		else { msg("$N_oper", "El usuario12 $trozo[6] no está en las BDD como OPERador."); }
	 }
 }

sub db_adddevel {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET DEVEL ADD <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'d'}++;

		quote("$numerico DB * $tabla{'d'} d $nickDB devel");
		msg("$N_oper", "Añadido el usuario12 $trozo[6] en las BDD como DEVELoper.");
		canalopers("$N_oper", "12$trozo[0] AÑADE en 12BDD DEVEL a12 $trozo[6].");

	 }
 }

sub db_deldevel {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET DEVEL DEL <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'d'}++;

		quote("$numerico DB * $tabla{'d'} d $nickDB");
		msg("$N_oper", "Borrado el usuario12 $trozo[6] en las BDD como DEVELoper.");
		canalopers("$N_oper", "12$trozo[0] BORRA en 12BDD DEVEL a12 $trozo[6].");

	 }
 }

sub db_addbot {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET BOT ADD <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);
	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'e'}++;

		quote("$numerico DB * $tabla{'e'} d $nickDB Bot");
		msg("$N_oper", "Añadido el usuario12 $trozo[6] en las BDD como Services Bot.");
		canalopers("$N_oper", "12$trozo[0] AÑADE en 12BDD BOT a12 $trozo[6].");

	 }
 }

sub db_delbot {

	if (!$trozo[6]) { sintaxis("$N_oper", "SET BOT DEL <nick>"); }
	else {

		my $nickDB = lc($trozo[6]);

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'e'}++;

		quote("$numerico DB * $tabla{'e'} d $nickDB");
		msg("$N_oper", "Borrado el usuario12 $trozo[6] en las BDD como Services Bot.");
		canalopers("$N_oper", "12$trozo[0] BORRA en 12BDD BOT a12 $trozo[6].");

	 }
 }

sub db_addnickreg {

	if ((!$trozo[6]) or (!$trozo[7])) { sintaxis("$N_oper", "SET NICKREG ADD <nick> <clave>"); }
	else {

		my $nickDB = lc($trozo[6]);

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'n'}++;

		open(NICKREG, "./tea \"$nickDB\" $trozo[7]|");
		my @nickreg = split(/ /, <NICKREG>);
		close(NICKREG);

		quote("$numerico DB * $tabla{'n'} n @nickreg");
		msg("$N_oper", "Añadido en la BDD de Nicks a12 $trozo[6] con la clave6 $trozo[7]");
		canalopers("$N_oper", "12$trozo[0] AÑADE en la 12BDD NICK a12 $trozo[6].");
	 }
 }

sub db_delnickreg {

	my $nickdelreg = lc($trozo[6]);
	if (!$nickdelreg) { sintaxis("$N_oper", "SET NICKREG DEL <nick>"); }
	elsif (&Nlook("$nickdelreg")) { msg("$N_oper", "El nick12 $trozo[6] no está registrado."); }
	else {

		my $nickDB = $nickdelreg;

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'n'}++;

		quote("$numerico DB * $tabla{'n'} n $nickDB");
		msg("$N_oper", "Borrado de la BDD de Nicks a12 $trozo[6].");
		canalopers("$N_oper", "12$trozo[0] BORRA en la 12BDD NICK a12 $trozo[6].");
	 }
 }

sub db_addvhost {

	my $nick_vhost = lc($trozo[6]);
	if ((!$trozo[6]) or (!$trozo[7])) { sintaxis("$N_oper", "SET VHOST ADD <nick> <vhost>"); }
	elsif (&Nlook("$nick_vhost")) { msg("$N_oper", "El nick12 $trozo[6] no está registrado."); }
	else {

		my $nickDB = $nick_vhost;

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'v'}++;

		quote("$numerico DB * $tabla{'v'} v $nickDB $trozo[7]");
		msg("$N_oper", "Añadida vhost a12 $trozo[6].");
		canalopers("$N_oper", "12$trozo[0] AÑADE en la 12BDD VHOST a12 $trozo[6],5 $trozo[7]");
	 }
 }

sub db_delvhost {

	my $nick_delvhost = lc($trozo[6]);
	if (!$trozo[6]) { sintaxis("$N_oper", "SET VHOST DEL <nick>"); }
	elsif (&Nlook("$nick_delvhost")) {

		my $nickDB = $nick_delvhost;

	    $nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;
		$tabla{'v'}++;

		quote("$numerico DB * $tabla{'v'} v $nickDB");
		msg("$N_oper", "Borrada vhost a12 $trozo[6].");
		canalopers("$N_oper", "12$trozo[0] BORRA en la 12BDD VHOST a12 $trozo[6]");

	 }
	else { msg("$N_oper", "El nick12 $trozo[6] no está registrado."); }
 }


return 1;