

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo de SUBrutinas Elementales de los Services.                   - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Los EuroServices son unos Servicios de Red que gestionan las        - ##
##    funciones que los Services Principales (NickServ, ChanServ...) no   - ##
##    desempeñan.                                                         - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org#########################################GNU/GPL######



sub bots {

	server("PASS $pass");
	my $tiempo = time();
	$N_nick2 = "${numerico}AA";
	$N_oper = "${numerico}AB";
	$N_aleto = "${numerico}AC";
	$N_help = "${numerico}AD";
	$N_vota = "${numerico}AE";
	$N_reg = "${numerico}AF";

	server("SERVER $servname 1 $tiempo $tiempo P10 ${numerico}P] :$servdesc");

	server("$numerico N $nick2 1 $tiempo $IdentName $HostName +dirhoBXk EuServ $N_nick2 :$nick2_desc");
	server("$numerico N $regserv 1 $tiempo $IdentName $HostName +dirhoBXk EuServ $N_reg :$reg_desc");
	server("$numerico N $operserv 1 $tiempo $IdentName $HostName +dirhoBXk EuServ $N_oper :$oper_desc");
	server("$numerico N $aletoserv 1 $tiempo $IdentName $HostName +dirBXk EuServ $N_aleto :$aleto_desc");
	server("$numerico N $helpserv 1 $tiempo $IdentName $HostName +dirBXk EuServ $N_help :$help_desc");
	server("$numerico N $votaserv 1 $tiempo $IdentName $HostName +dirBXk EuServ $N_vota :$vota_desc");

	$i=0; open(CONNECT, "news.db");
	my @connect = <CONNECT>;
	foreach (@connect) {
		chomp; split(/"/);
		$i++;
		if ($_[0] eq "Nicks") {
			if ($_[1]) {
				$N_news = "${numerico}BC";
				server("$numerico N $_[1] 1 $tiempo - -Noticia- +doirBXk EuServ $N_news :Noticias de la RED");
	            quote("${numerico}BC J $canaldebug");
			 }
			close(CONNECT);
		 }
	 }
	return;
 }

sub entradas {

	server("$N_nick2 J $canaldebug,$canalopers,$canalRed");
	server("$N_help J $canalopers,$canalRed");
	server("$N_vota J $canalRed,$canalEncuesta");
	server("$N_oper M $canalRed +vvv $N_nick2 $N_help $N_vota");
	server("$N_vota M $canalEncuesta +o $N_vota");
    server("$N_oper J $canaldebug,$canalopers,$canaladmins");
    server("$N_aleto J $canalopers");
    server("$N_oper M $canaldebug +vv $N_oper $N_nick2");
    server("$N_oper M $canalopers +vvvv $N_oper $N_aleto $N_nick2 $N_help");
    entra_reg();
 }

sub entra_reg {

	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	foreach $lista (keys (%canalesdb)) {
		if ($canalesdb{$lista}->{ESTADO} eq "PENDIENTE") {
			quote("$N_reg J $lista");
			quote("$numerico M $lista +o $N_reg");
			quote("$numerico T $lista :$TopicReg");
	 	 }
		if ($canalesdb{$lista}->{ESTADO} eq "COMPLETO") {
			quote("$N_reg J $lista");
			quote("$numerico M $lista +o $N_reg");
			quote("$numerico T $lista :El canal ha conseguido los apoyos necesarios, ahora será evaluado.");
	 	 }
 	 }
	undef($lista);
	untie(%CANALES);
 }

sub server
{
	my $to_server = shift;
	print $socket "$to_server\r\n";
	return;
}

sub pong {
	my $pongg = shift;
	print $socket ":$numerico Z $pongg\r\n";
 }

sub quote
{
	my $q_quote = shift;
	print $socket "$q_quote\n";
	return;
 }

sub log {

	my $LOCALtime = localtime();
	my $to_log = shift;
    open(LOG,">>logs/server.log");
    print LOG "\[$LOCALtime\] $to_log\n";
    close(LOG);
    return;
 }

sub denegado {

	my ($boto, $nick_log) = (shift, shift);
	msg("$boto","Acceso Denegado4!!");
	&log("acceso denegado $nick_log");
	return;
 }

sub msg {

	my($nicb, $my_msg) = (shift, shift);
	print $socket "$nicb P $Num_nick :$my_msg\n";
	return;
 }

sub mensaje {

	my($nicb, $nicc, $my_mssg) = (shift, shift, shift);
	my $nick_msj = $Nick_Numerico{lc($nicc)};
	print $socket "$nicb P $nick_msj :$my_mssg\n";
	return;
 }

sub debug {

	my($botd, $my_debug) = (shift, shift);
	print $socket "$botd P $canaldebug :$my_debug\n";
	return;
 }

sub canalopers {

	my($boto, $OPERmensaje) = (shift, shift);
	print $socket "$boto P $canalopers :$OPERmensaje\n";
	return;
 }

sub canalreg {

	my($botr, $REGmensaje) = (shift, shift);
	print $socket "$botr P $canalreg :$REGmensaje\n";
	return;
 }

sub canaladmins {

	my($bota, $ADMmensaje) = (shift, shift);
	print $socket "$bota P $canaladmins :$ADMmensaje\n";
	return;
 }


sub Nlook {

	my $Registered = shift;

    tie(%NICK2,'MLDBM', "lista.db");
    %nicksdb = %NICK2;
	untie(%NICK2);

	my $buscaregistro = $nicksdb{"$Registered"};
	if (!$buscaregistro) {
		return 1;
	 }
	else { return 0; }
 }

sub operador {

	my $Opera = shift;

    tie(%OPER,'MLDBM', "oper.db");
    %operdb = %OPER;
	untie(%OPER);

	my $buscaoper = $operdb{"$Opera"};
	if (($Opera eq $rooty) || ($buscaoper)) {
		return 1;
	 }
    else {
		return 0;
	 }
 }

sub oper_reg {

	my $Opera = shift;

    tie(%REG,'MLDBM', "operreg.db");
    %opersregdb = %REG;
	untie(%REG);

	$buscaoper = $opersregdb{"$Opera"};
	if (($Opera eq lc($RootReg)) || ($buscaoper)) {
		return 1;
	 }
    else {
		return 0;
	 }
 }

sub admin_reg {

	my $Adminrmin = shift;

    tie(%REG,'MLDBM', "operreg.db");
    %opersregdbdb = %REG;
	untie(%REG);

	if (($Adminrmin eq lc($RootReg)) || ($opersregdb{$Adminrmin}->{LEVEL} == 2)) {
		return 1;
	 }
	else { return 0; }
 }

sub preoperador {
	my $preoper = shift;

    tie(%PREOPER,'MLDBM', "preoper.db");
    %preoperdb = %PREOPER;
	untie(%PREOPER);

	my $buscapreoper = $preoperdb{"$preoper"};
	if (($buscapreoper) or (&operador("$_[0]"))) {
		return 1;
	 }
    else {
		return 0;
	 }
 }

sub administrador {

	my $Adminrmin = shift;

    tie(%ADMINS,'MLDBM', "oper.db");
    %operdb = %ADMINS;
	untie(%ADMINS);

	if (($Adminrmin eq $rooty) || ($operdb{$Adminrmin}->{LEVEL} == 2)) {
		return 1;
	 }
	else { return 0; }
 }

sub NR {

	my $bot_nicks = $Nick_Numerico{lc($Service_nicks)};
	quote("$N_nick2 P $bot_nicks :status $_[0]");
	defined ($RN = <$socket>);
	if ($RN =~ (Identificado)) {
		return 0;
	 }
	else {
		return 1;
	 }
 }

sub noDB {
	print $socket "$_[0] P $Num_nick :Para usar este servicio tiene que tener el Nickname registrado en 12$nick2.\n";
 }

sub noNR {
	print $socket "$_[0] P $Num_nick :Para usar este servicio tienes que tener el Nick Identificado.\n";
 }

sub siDB {
	print $socket "$_[0] P $Num_nick :Usted ya tiene el Nick Registrado4!\n";
 }

sub topic {

	my ($TopicBot, $TopicChannel, $TopicText) = (shift, shift, shift);

	print $socket "$TopicBot T $TopicChannel :$TopicText\n";
 }

sub sintaxis
{
	my($bots, $my_sintaxis) = (shift, shift);
	print $socket "$bots P $Num_nick :Sintaxis: 12$my_sintaxis\n";
}

sub ayuda {

	open(AYUDA, "$_[1]");
	my @ayuda = <AYUDA>;
	foreach $ayuda (@ayuda) {
		$ayuda =~ s/\%s/$_[2]/;
		print $socket "$_[0] P $Num_nick :$ayuda\n";
	 }
	close(AYUDA);
 }

sub noticia {

	if ($N_news) {
		$Num_nick = $trozo[9];
		$i = 0; open(MSGN, "news.db");
		my @not = <MSGN>;
		foreach (@not) {
			chomp; split(/"/);
			$i++;
			if ($_[0] eq "Noticia") {
				my $noticia = $_[1];
				$noticia =~ s/\Ç/\"/g;
				msg("$N_news", "$noticia");
			 }
			close(MSGN);
		 }
	 }
 }

sub fecha {

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year += 1900;
	$mon++;
	return;
 }
sub inicio {
	&fecha();

	my %meses = (
		"1" => "Enero",
		"2" => "Febrero",
		"3" => "Marzo",
		"4" => "Abril",
		"5" => "Mayo",
		"6" => "Junio",
		"7" => "Julio",
		"8" => "Agosto",
		"9" => "Septiembre",
		"10" => "Octubre",
		"11" => "Noviembre",
		"0" => "Diciembre",
	 );
	my %dia = (
		"1" => "Lunes",
		"2" => "Martes",
		"3" => "Miércoles",
		"4" => "Jueves",
		"5" => "Viernes",
		"6" => "Sábado",
		"0" => "Domingo",
	 );

	if ($hour < 10) { $hour = "0$hour"; }
	if ($min < 10) { $min = "0$min"; }
    if ($sec < 10) { $sec = "0$sec"; }

    open(INICIO, ">services.db");
    print INICIO "Inicio\"Iniciado a las12 $hour:$min:$sec del $dia{$wday} $mday de $meses{$mon}.\n";
  	close(INICIO);

	return;
 }

sub mira_akill {

	my $mira_Anick = lc($_[0]);
	my $ip_kill = $_[1];


	open(MIRAA, "akill.db");
	my @lakill = <MIRAA>;
	foreach (@lakill) {
		chomp; split(/"/);

		if ($_[0] eq "$mira_Anick") {

			my $razonA = $_[1];
			$razonA =~ s/\Ê/\"/g;

			quote("$numerico D $ip_kill :$razonA");
			close(MIRAA);

		 }
	 }
 }

sub stats {

	my $StatsBot = $_[0];
	my $StatsCmd = $_[1];
	my $StatsDIR = "stats/$StatsBot.db";

	tie(%ESTATS,'MLDBM', "$StatsDIR");
	%statsdb = %ESTATS;

	my $Count_Stats = $statsdb{$StatsCmd}->{STATS};
	if (!$Count_Stats) { $Count_Stats = "0"; }
	$Count_Stats++;

	$db_stats -> {$StatsCmd} = {"STATS" => $Count_Stats};

	%ESTATS = %statsdb;
	untie(%ESTATS);
 }

return 1;