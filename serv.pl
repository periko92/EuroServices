#!/usr/bin/perl



####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo conexión de los Services.                                    - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Los EuroServices son unos Servicios de Red que gestionan las        - ##
##    funciones que los Services Principales (NickServ, ChanServ...) no   - ##
##    desempeñan.                                                         - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####


use IO::Socket;
use MLDBM 'DB_File';

if (fork()) { exit(-1); }

# Versión actual de los Services.
# Http://sourceforge.net/projects/euro-services

$version = "2.0+ReG1.0";
$numerico = int(rand()*9+1);

# Cargamos las Bases de Datos.

$db_oper = \%operdb;
$db_preoper = \%preoperdb;
$db_stats = \%statsdb;
$db_nicks = \%nicksdb;
$db_vota = \%votadb;

$db_canales = \%canalesdb;
$db_apoyos = \%apoyosdb;
$db_opersreg = \%opersregdb;

expire_channels();
#while (1) {

	&loadconf;

	## Conectamos...
    $socket = IO::Socket::INET->new(Proto => "tcp", PeerAddr => $server, PeerPort => $port)
    or die "No he podido conectar, revisa el .conf de los services o el de ircd.\n";

    &bots();
    &entradas();

	&inicio();
    $socket->autoflush(1);

    #Aquí leemos lo que entra...

    while (<$socket>) {
	    $Linea = $_;
	    @trozo = split(" ", $Linea);

	    if (($trozo[1] eq "PING") or ($trozo[2] eq "G")) {
		    pong("$trozo[2]");
	     }

	    if ($trozo[1] eq "END_OF_BURST") {
		    if (!$EB) {
			    quote("$numerico EB");
                $EB = "hecho";
             }
	     }

	    if ($trozo[1] eq "EOB_ACK") {
		    if (!$EA) {
			    quote("$numerico EA");
                $EA = "hecho";
             }
         }

        if ($trozo[1] eq "DB") {
	        if ($trozo[4] eq "J") {

		        # La tabla 'n' la informa de esta forma:
		        # <Nodo Origen> DB <Nodo Destino> 0 J <Número de serie Local BDD nicks> 2

		        if ($trozo[6] == 2) {
			        $tabla{'n'} = $trozo[5];
		            print $socket "$numerico DB * 0 J $trozo[5] 2\r\n";
		         }

		         # Y las otras:
		         # <Nodo Origen> DB <Nodo Destino> 0 J <Número de serie Local BDD> <BDD>
		         else {
			         $tabla{$trozo[6]} = $trozo[5];
                  }
             }
         }

        if ($trozo[1] eq "NICK") {

	        # Al conectar, el Hub nos enviará los numéricos de cada nick.
	        # La primera letra será el númerico del server donde está ese nick (siempre 1 letra)
	        # y la novena letra es el númerico propio del nick.

            if (length($trozo[0]) == 1) {

		            my $NickEntrada = lc($trozo[2]);

		            $Nick_Numerico{$NickEntrada} = $trozo[9];
                    $Numerico_Nick{$trozo[9]} = $trozo[2];
    				debug("$N_oper", "12$trozo[2] (12 $trozo[6] ) entra a la Red Con La Ident: 2$trozo[5] y los Modos: 5$trozo[7]");
                    &noticia();
                    mira_akill("$trozo[2]", "$trozo[9]");
#                    if ($trozo[7] =~/r/) {
#	                    #Noticia del +r;
#                    }

#               else {
#	                $Nick_Numerico{lc($trozo[2])} = $trozo[8];
#                   $Numerico_Nick{$trozo[8]} = $trozo[2];
#                }

             }

            # Al cambio de nick, la sintaxis será:
            # <numérico del nick> NICK <nuevo nick> <tiempo>

            else {

	            undef $Nick_Numerico{lc($Numerico_Nick{$trozo[0]})};
                $Numerico_Nick{$trozo[0]} = $trozo[2];
                $Nick_Numerico{lc($trozo[2])} = $trozo[0];
                mira_akill("$trozo[2]", "$trozo[0]");

             }
         }

        if ($trozo[1] eq "VERSION") {

	        $trozo[0] =~ s/://;
		    $Num_nick = $Nick_Numerico{lc($trozo[0])};
		    quote("$numerico 351 $Num_nick :EuroServices $version · $servname · lluneta\@irc-euro.org");
         }

        if ($trozo[1] eq "MODE") {
	        if (($trozo[3] =~ /r/) && ($trozo[2] !~ /\#/) && ($trozo[3] =~ /\+/)) {
		        #&welcome2();
		     }
         }

        if ($trozo[1] eq "QUIT") {
			my($kaka, $QuitMsg) = split("$trozo[0] $trozo[1] ", $_);
			$trozo[0] =~ s/://;
			debug("$N_oper", "12$trozo[0] abandona la Red, $QuitMsg");
         }

        if ($trozo[1] eq "WHOIS") {
	        $trozo[0] =~ s/://;
	        $trozo[3] =~ s/://;
            $Num_nick = $Nick_Numerico{lc($trozo[0])};

            # Puede añadir más lineas, pero estas dejalas así. Gracias.

            quote("$numerico 311 $Num_nick EuroServices lluneta irc-euro.org * Para más Información.");
            quote("$numerico 291 $Num_nick Versión $version");
            quote("$numerico 292 $Num_nick $trozo[3] forma parte de EuroServices");
            quote("$numerico 293 $Num_nick Desarrollado por P < lluneta\@irc-euro.org >");
            quote("$numerico 318 $Num_nick $trozo[3] End of /WHOIS list.");

         }

        if ($trozo[1] eq "PRIVMSG") { privados(); }

     } #Fin de la lectura de lo que le entra.
# } #Fin de Todo

sub loadconf {

	require "services.conf";
	$rooty = lc($root);
	require "sys/sub.pm";
	require "sys/nick2.pm";
	require "sys/aleto.pm";
	require "sys/help.pm";
	require "sys/vota.pm";
	require "sys/oper.pm";
	require "sys/entrada.pm";
	require "sys/reg.pm";
	$expire_reg = 86400 * $Reg_Expire;
	return;

 }

sub expire_channels
{
    $SIG{'ALRM'} = \&expirachannels;
    alarm(250);
}