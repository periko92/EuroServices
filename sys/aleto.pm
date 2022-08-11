

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo de los Services que examina a los futuros OPERadores.        - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Este Service y módulo de los EuroServices tiene la función de       - ##
##    preparar a los futuros OPERadores, para que sepan como se           - ##
##    gestiona la Red y que tengan un level superior para ayudar.         - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####



$Pcomando = \%comandos_aleto;

$Pcomando -> {"HELP"} = "pre_help";
$Pcomando -> {"AYUDA"} = "pre_help";
$Pcomando -> {"CREDITOS"} = "do_creditos";
$Pcomando -> {"OP"} = "pre_op";
$Pcomando -> {"DEOP"} = "pre_deop";
$Pcomando -> {"VOICE"} = "pre_voice";
$Pcomando -> {"DEVOICE"} = "pre_devoice";
$Pcomando -> {"MODE"} = "pre_mode";
$Pcomando -> {"INVITE"} = "pre_invite";
$Pcomando -> {"KILL"} = "pre_kill";
$Pcomando -> {"KICK"} = "pre_kick";
$Pcomando -> {"PREOPER"} = "preoper";
$Pcomando -> {"CONSULTA"} = "pre_operhelp";


sub pre_help {

	my $layuda = lc($trozo[4]);
	if (!$trozo[4]) { my $rutina = "sys/help/aleto/help"; ayuda("$N_aleto", "$rutina", "$aletoserv"); }
	elsif (-e "sys/help/aleto/$layuda") { my $rutina = "sys/help/aleto/$layuda"; ayuda("$N_aleto", "$rutina", "$aletoserv"); }
	else { msg("$N_aleto", "No existe ayuda para12 $trozo[4]."); }
}

sub pre_operhelp {

	my($kaka, $consulta) = split(":$trozo[3] ", $_);
	if (!$consulta) { sintaxis("$N_aleto", "CONSULTA <consulta>"); }
	else {

		canalopers("$N_aleto", "4CONSULTA!! 6<2$trozo[0]6> $consulta");
		msg("$N_aleto", "Su consulta ha sido realizada, en breve un OPERador le ayudará.");
	 }
 }

sub pre_op {

	if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_aleto", "OP <#canal> <nick>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#."); }
	else {

		my $nickOP = $Nick_Numerico{lc($trozo[5])};
		if (!$nickOP) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }
		else {

			quote("$numerico M $trozo[4] +o $nickOP");
		 }
	 }
 }

sub pre_deop {

	if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_aleto", "DEOP <#canal> <nick>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#."); }
	else {

		my $nickOP = $Nick_Numerico{lc($trozo[5])};
		if (!$nickOP) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }
		else {

			quote("$numerico M $trozo[4] -o $nickOP");
		 }
	 }
 }

sub pre_voice {

	if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_aleto", "VOICE <#canal> <nick>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#."); }
	else {

		my $nickOP = $Nick_Numerico{lc($trozo[5])};
		if (!$nickOP) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }
		else {

			quote("$numerico M $trozo[4] +v $nickOP");
		 }
	 }
 }

sub pre_devoice {

	if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_aleto", "DEVOICE <#canal> <nick>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#."); }
	else {

		my $nickOP = $Nick_Numerico{lc($trozo[5])};
		if (!$nickOP) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }
		else {

			quote("$numerico M $trozo[4] -v $nickOP");
		 }
	 }
 }

sub pre_mode {

	my($kaka, $modo) = split(":$trozo[3] $trozo[4] ", $_);
	my $MINopers = lc($canalopers);
	my $MINadmins = lc($canaladmins);
	my $MINdebug = lc($canaldebug);

	if ((!$trozo[4]) or (!$modo)) { sintaxis("$N_aleto", "MODE <#canal> <modos>"); }

	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#"); }
	elsif (lc($trozo[4]) eq "$MINopers") { msg("$N_aleto", "No puedes cambiar los modos de 12$trozo[4]"); }
	elsif (lc($trozo[4]) eq "$MINadmins") { msg("$N_aleto", "No puedes cambiar los modos de 12$trozo[4]"); }
	elsif (lc($trozo[4]) eq "$MINdebug") { msg("$N_aleto", "No puedes cambiar los modos de 12$trozo[4]"); }
	elsif (($modo =~ /o/i) or ($modo =~ /v/i)) { msg("$N_aleto", "Para dar o quitar VOZ o \@ usa sus respectivos comandos."); }
	else {

		quote("$numerico M $trozo[4] $modo");
		canalopers("$N_aleto", "12$trozo[0] cambia 12MODO de 12$trozo[4] a5 $modo");

	 }
 }

sub pre_invite {

	my $MINopers = lc($canalopers);
	my $MINadmins = lc($canaladmins);
	my $MINdebug = lc($canaldebug);

	if (!$trozo[4]) { sintaxis("$N_aleto", "INVITE <#canal>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El canal tiene que contener 4\#."); }
	elsif (lc($trozo[4]) eq "$MINopers") { msg("$N_aleto", "No te puedes invitar en 12$trozo[4]"); }
	elsif (lc($trozo[4]) eq "$MINadmins") { msg("$N_aleto", "No te puedes invitar en 12$trozo[4]"); }
	elsif (lc($trozo[4]) eq "$MINdebug") { msg("$N_aleto", "No te puedes invitar en 12$trozo[4]"); }
	else {

		quote("$N_aleto I $trozo[0] $trozo[4]");
		canalopers("$N_aleto", "12$trozo[0] usa 12INVITE en 12$trozo[4]");
	 }
 }

sub pre_kick {

	if ((!$trozo[4]) or (!$trozo[5]) or (!$trozo[6])) { sintaxis("$N_aleto", "KICK <#canal> <nick> <razón>"); }
	elsif ($trozo[4] !~/\#/) { msg("$N_aleto", "El nombre del canal tiene que contener 4#"); }
	else {

		my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] $trozo[5] ", $_);
		my $nickOP = $Nick_Numerico{lc($trozo[5])};

		if (!$nickOP) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }
		else {

			quote("$numerico K $trozo[4] $nickOP :$mensaje");
			canalopers("$N_aleto", "12$trozo[0] usa 12KICK en 12$trozo[4], $mensaje");
		 }
	 }
 }

sub pre_kill {

	my($kaka, $mensaje) = split(":$trozo[3] $trozo[4] ", $_);
	if ((!$trozo[4]) or (!$mensaje)) { sintaxis("$N_aleto", "KILL <nick> <mensaje>"); }

	else {

		my $Pkillnick = lc($trozo[4]);
		my $PNumKill = $Nick_Numerico{lc($trozo[4])};
		if (!$PNumKill) { msg("$N_aleto", "El usuario12 $trozo[4] no está conectado en este momento."); }

		elsif (($Service_nicks eq "$Pkillnick") or ($Service_chan eq "$Pkillnick") or ($Service_reg eq "$Pkillnick") or ($Service_oper eq "$Pkillnick") or ($Service_memo eq "$Pkillnick") or ($Service_global eq "$Pkillnick") or ($Service_help eq "$Pkillnick") or ($Service_sec eq "$Pkillnick")) {
			msg("$N_aleto", "NO puedes hacer un Kill a un Service de la Red4!!");
		 }

		elsif ($Pkillnick eq "$origen") { msg("$N_aleto", "No es de mucha lógica hacerse un Kill a si mismo..."); }
		else {

			quote("$N_aleto D $PNumKill :$mensaje");
			msg("$N_aleto", "Usuario 12$trozo[4] ha sido Killeado.");
			canalopers("$N_aleto", "Usuario 12$trozo[4] 12KILLeado por 12$trozo[0]");

		 }
	 }
 }

sub preoper {

	my $lcpreoper = lc($trozo[4]);
	if (!$lcpreoper) { sintaxis("$N_aleto", "PREOPER <add/del/list> [parámetros]"); }

	elsif ($lcpreoper eq "list") { &listpreoper; }

	elsif ($lcpreoper eq "add") {
		if (&operador("$origen")) { &addpreoper; }
		else { denegado("$N_aleto", "$trozo[0]"); }
	 }

	elsif ($lcpreoper eq "del") {
		if (&operador("$origen")) { &delpreoper; }
		else { denegado("$N_aleto", "$trozo[0]"); }
	 }
	else { msg("$N_aleto", "Comando '12$trozo[3] $trozo[4]' desconocido."); sintaxis("$N_aleto", "PREOPER <add/del/list> [parámetros]"); }
 }

sub addpreoper {

	my $addpreoper = lc($trozo[5]);
	if (!$addpreoper) { sintaxis("$N_aleto", "PREOPER ADD <nick>"); }
	elsif (&preoperador("$addpreoper")) { msg("$N_aleto", "El usuario12 $trozo[5] ya es PreOperador.");  }
	else {
		if (&Nlook("$addpreoper")) { msg("$N_aleto", "El usuario 12$trozo[5] no tiene el nick registrado en las BDDs."); }
		else {


			tie(%PREOPER,'MLDBM', "preoper.db");
			%preoperdb = %PREOPER;
			$db_preoper -> {$addpreoper} = {"LEVEL" => 1};
			%PREOPER = %preoperdb;
			untie(%PREOPER);

			my $addpre = lc($trozo[5]);
			$addpre =~ s/\^/\~/g;
			$addpre =~ s/\[/\{/g;
			$addpre =~ s/\]/\}/g;

			$addpreoper =~ s/\^//g;
			$addpreoper =~ s/\[//g;
			$addpreoper =~ s/\]//g;
			$addpreoper =~ s/\|//g;

			my $vhostpreoper = "$addpreoper.pre-oper.$mired";
			$tabla{'v'}++;

			quote("$numerico DB * $tabla{'v'} v $addpre $vhostpreoper");
			msg("$N_aleto", "Añadido como PreOperado a 12$trozo[5].");
			canalopers("$N_aleto", "12$trozo[0] Añade como 12PREOPERador a 12$trozo[5].");

		 }
	 }
 }

sub delpreoper {

	my $delpreoper = lc($trozo[5]);
	if (!$delpreoper) { sintaxis("$N_aleto", "PREOPER DEL <nick>"); }
	elsif (&preoperador("$delpreoper")) {

		tie(%PREOPER,'MLDBM', "preoper.db");
		%preoperdb = %PREOPER;
		delete($preoperdb{$delpreoper});
		%PREOPER = %preoperdb;
		untie(%PREOPER);

		my $delpre = lc($trozo[5]);
		$delpre =~ s/\^/\~/g;
		$delpre =~ s/\[/\{/g;
		$delpre =~ s/\]/\}/g;
		$tabla{'v'}++;

		quote("$numerico DB * $tabla{'v'} v $delpre");
		msg("$N_aleto", "Borrado al PreOperado 12$trozo[5].");
		canalopers("$N_aleto", "12$trozo[0] Borra de 12PREOPERador a 12$trozo[5].");

	 }
	else { msg("$N_aleto", "El usuario12 $trozo[5] no es un PreOperador."); }
 }

sub listpreoper {

	tie(%PREOPER,'MLDBM', "preoper.db");
    %preoperdb = %PREOPER;

	my $comprueba_preopers = 0;
	msg("$N_aleto", "Lista de 12PreOperadores:");

    while(($list_preoper,$nivel) = each (%preoperdb)) {
	    if($preoperdb{$list_preoper}->{LEVEL} == 1) {
			msg("$N_aleto", "12$list_preoper");
			$comprueba_preopers++;
         }
     }
    if($comprueba_preopers == 0) {
	    msg("$N_aleto", "Lista de 12PreOperadores vacía.");
	 }
	undef($comprueba_preopers);
	untie(%PREOPER);
 }


return 1;