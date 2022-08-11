

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo del roBOT que controla los registros en las DB's.            - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  La función principal de este roBOT es la de controlar y gestionar   - ##
##    los registros en las Bases de Datos Distribuídas, desarrolladas en  - ##
##    el protocolo DBH.                                                   - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####



$Ncomando = \%comandos_nick2;
		#Comandos Users & OPERadores.
$Ncomando -> {"AYUDA"} = "do_Nhelp";
$Ncomando -> {"HELP"} = "do_Nhelp";
$Ncomando -> {"REGISTER"} = "do_register";
$Ncomando -> {"REGISTRA"} = "do_register";
$Ncomando -> {"SET"} = "do_nick_set";
$Ncomando -> {"INFO"} = "do_Ninfo";
$Ncomando -> {"VHOST"} = "do_Nvhost";
$Ncomando -> {"CREDITOS"} = "do_creditos";
		#Comandos OPERadores.
$Ncomando -> {"DROP"} = "do_Ndrop";
$Ncomando -> {"OFICIAL"} = "do_Noficial";
$Ncomando -> {"SENDPASS"} = "do_Ngetpass";
$Ncomando -> {"ADDVHOST"} = "do_Naddvhost";
$Ncomando -> {"DELVHOST"} = "do_Ndelvhost";
$Ncomando -> {"OPER"} = "do_vhostoper";
$Ncomando -> {"STATS"} = "do_Nstats";
$Ncomando -> {"GETPASS"} = "do_getpass";

sub do_nick_set {

	if (uc($trozo[4]) eq "EMAIL") { &do_setemail(); }
	elsif (uc($trozo[4]) eq "PASS") { &do_setpass(); }
	elsif (uc($trozo[4]) eq "EDAD") { &do_set_edad(); }
	else { msg("$N_nick2", "SET <opción> [parámetros]"); msg("$N_nick2", "Para más información 12HELP SET."); }
 }

# Comando de migración de un nick que anteriormente esté registrado en otro roBOT como este
$Ncomando -> {"ACTUALIZA"} = "do_actualiza";

# este INFO hay que mejorarlo xD

sub do_Ninfo {

	if (&Nlook("$origen")) { noDB("$N_nick2"); }

	else {

		my $nick_info = lc($trozo[4]);

		if (!$nick_info) { sintaxis("$N_nick2", "INFO <nick>"); }
		else {

			if (&Nlook("$nick_info")) {
				msg("$N_nick2", "El nick 12$trozo[4] 4NO ha migrado el nick.");
			 }
			else {
				msg("$N_nick2", "El nick 12$trozo[4] 4SI que ha migrado el nick.");
				stats("Nick2", "INFO");

				#Si un nick se hace un INFO a el mismo le mostrará el E-mail y su clave.
				if ($nick_info eq $origen) {

					tie(%NICK2,'MLDBM',"lista.db");
					%nicksdb = %NICK2;

					my $hora_registro = $nicksdb{$nick_info} -> {"HORA"};
					my $email_registro = $nicksdb{$nick_info} -> {"EMAIL"};
					my $clave_registro = $nicksdb{$nick_info} -> {"CLAVE"};
					my $edad_registro = $nicksdb{$nick_info} -> {"EDAD"};

					msg("$N_nick2", "Registro:12 $hora_registro");
					if ($edad_registro) { msg("$N_nick2", "Edad:12 $edad_registro"); }
					msg("$N_nick2", "E-mail:12 $email_registro");
					msg("$N_nick2", "Clave:12 $clave_registro");

					%NICK2 = %nicksdb;
					untie(%NICK2);
				 }

				#Si el que hace el INFO es un Operador le devolverá su E-mail.
				elsif (&operador("$origen")) {

					tie(%NICK2,'MLDBM',"lista.db");
					%nicksdb = %NICK2;

					my $hora_registro = $nicksdb{$nick_info} -> {"HORA"};
					my $email_registro = $nicksdb{$nick_info} -> {"EMAIL"};
					my $edad_registro = $nicksdb{$nick_info} -> {"EDAD"};

					msg("$N_nick2", "Registro:12 $hora_registro");
					if ($edad_registro) { msg("$N_nick2", "Edad:12 $edad_registro"); }
					msg("$N_nick2", "E-mail:12 $email_registro");

					%NICK2 = %nicksdb;
					untie(%NICK2);
				 }

				#Si es una persona normal...
				else {

					tie(%NICK2,'MLDBM',"lista.db");
					%nicksdb = %NICK2;

					my $hora_registro = $nicksdb{$nick_info} -> {"HORA"};
					my $edad_registro = $nicksdb{$nick_info} -> {"EDAD"};

					msg("$N_nick2", "Registro:12 $hora_registro");
					if ($edad_registro) { msg("$N_nick2", "Edad:12 $edad_registro"); }

					%NICK2 = %nicksdb;
					untie(%NICK2);
				 }
			 }
		 }
	 }
 }


sub do_Nhelp {

	if (&operador("$origen")) {

		my $lcayuda = lc($trozo[4]);
		if (!$lcayuda) { my $rutina = "sys/help/nick2/oper/help"; ayuda("$N_nick2", "$rutina", "$nick2"); }

		elsif ($lcayuda eq "set") {
			my $HelpSet = lc($trozo[5]);
			if (!$HelpSet) { my $rutina = "sys/help/nick2/oper/set"; ayuda("$N_nick2", "$rutina", "$nick2"); }
			elsif (-e "sys/help/nick2/oper/set_$HelpSet") { my $rutina = "sys/help/nick2/oper/set_$HelpSet"; ayuda("$N_nick2", "$rutina", "$nick2"); }
			else { msg("$N_nick2", "No existe ayuda para12 $trozo[4] $trozo[5]."); }
		 }

		elsif (-e "sys/help/nick2/oper/$lcayuda") { my $rutina = "sys/help/nick2/oper/$lcayuda"; ayuda("$N_nick2", "$rutina", "$nick2"); }
		else { msg("$N_nick2", "No existe ayuda para12 $trozo[4]."); }
	 }
	else {

		my $lcayuda = lc($trozo[4]);
		if (!$lcayuda) { my $rutina = "sys/help/nick2/user/help"; ayuda("$N_nick2", "$rutina", "$nick2"); }

		elsif ($lcayuda eq "set") {
			my $HelpSet = lc($trozo[5]);
			if (!$HelpSet) { my $rutina = "sys/help/nick2/user/set"; ayuda("$N_nick2", "$rutina", "$nick2"); }
			elsif (-e "sys/help/nick2/user/set_$HelpSet") { my $rutina = "sys/help/nick2/user/set_$HelpSet"; ayuda("$N_nick2", "$rutina", "$nick2"); }
			else { msg("$N_nick2", "No existe ayuda para12 $trozo[4] $trozo[5]."); }
		 }

		elsif (-e "sys/help/nick2/user/$lcayuda") { my $rutina = "sys/help/nick2/user/$lcayuda"; ayuda("$N_nick2", "$rutina", "$nick2"); }
		else { msg("$N_nick2", "No existe ayuda para12 $trozo[4]."); }
	 }
}

sub do_register {
	if (&NR("$trozo[0]")) { noNR("$N_nick2"); }
	else {
		if (&Nlook("$origen")) {

			my $clave_nick = $trozo[4]; my $mail_nick = $trozo[5];

			# Comprobamos que todo esté correcto...

			if ((!$clave_nick) or (!$mail_nick)) { sintaxis("$N_nick2", "REGISTER <password> <email>"); }
			elsif ($clave_nick =~/\"/) { msg("$N_nick2", "El caracter \" no es válido."); }
		    elsif (length($clave_nick) > 15) { msg("$N_nick2", "En la clave sólo se permiten hasta3 15 carácteres"); }
			elsif ($mail_nick !~/\@/) { msg("$N_nick2", "El mail no es válido."); }
			elsif ($mail_nick !~/\./) { msg("$N_nick2", "El mail no es válido."); }

			# Y si es así, pues proseguiremos al registro del nick...

			else {
				my $time_registro = localtime();
				tie(%NICK2,'MLDBM',"lista.db");
				%nicksdb = %NICK2;

				# Modificamos el nick cambiando (si contiene) los carácteres para su
				# posterior registro en las DBs

				my $nickDB = lc($trozo[0]);
			    $nickDB =~ s/\^/\~/g;
				$nickDB =~ s/\[/\{/g;
				$nickDB =~ s/\]/\}/g;

                # Abrimos el TEA para pillar cifrar la clave del nick a registrar

				open(TEA,"./tea \"$nickDB\" $clave_nick|");
				my @tea = split(/ /, <TEA>);
				$tabla{'n'}++;
				quote("$numerico DB * $tabla{'n'} n @tea");
				$tabla{'v'}++;
				quote("$numerico DB * $tabla{'v'} v $nickDB $trozo[0].$mivhost");
				close(TEA);

				# Aquí escribimos en "lista.db" el nick, la clave y su mail para
				# posteriores modificaciones y perdidas de clave...

				$db_nicks -> {$origen} = { "EMAIL" => $mail_nick, "CLAVE" => $clave_nick, "HORA" => $time_registro, "EDAD" => 0};

				msg("$N_nick2", "Ha sido registrado en las Bases De Datos");
				stats("Nick2", "REGISTER");
				debug("$N_nick2", "12$trozo[0] se registra en las Bases De Datos (+r)");

				%NICK2 = %nicksdb;
				untie(%NICK2);

			 }
		 }
		else {
			siDB("$N_nick2");
		 }
	 }
 }

sub do_setpass {
	if (&Nlook("$origen")) { noDB("$N_nick2"); }
	else {

		my $clave_nueva = $trozo[5];
		my $nick_setpass = lc($trozo[0]);

		if (!$clave_nueva) { sintaxis("$N_nick2", "SET PASS <password>"); }
		elsif ($clave_nueva =~/\"/) { msg("$N_nick2", "El caracter \" no es válido"); }
		elsif (length($clave_nueva) > 15) { msg("$N_nick2", "En la clave sólo se permiten hasta3 15 carácteres"); }
		else {

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;

			my $nickDB = lc($trozo[0]);
			$nickDB =~ s/\^/\~/g;
		    $nickDB =~ s/\[/\{/g;
		    $nickDB =~ s/\]/\}/g;

		    open(TEA,"./tea \"$nickDB\" $clave_nueva|");
		    my @tea = split(/ /, <TEA>);
			$tabla{'n'}++; quote("$numerico DB * $tabla{'n'} n @tea");
			close(TEA);

			my $set_email = $nicksdb{$nick_setpass} -> {"EMAIL"};
			my $set_horas = $nicksdb{$nick_setpass} -> {"HORA"};
			my $set_edad = $nicksdb{$nick_setpass} -> {"EDAD"};

			$db_nicks -> {$nick_setpass} = {"EMAIL" => $set_email, "CLAVE" => $clave_nueva, "HORA" => $set_horas, "EDAD" => $set_edad };


			msg("$N_nick2", "Su clave ha sido cambiada a12 $clave_nueva");
			stats("Nick2", "SETPASS");
			msg("$N_nick2", "Para que tenga efecto cambiese el nick y vuelva a ponerselo.");

			%NICK2 = %nicksdb;
			untie(%NICK2);
		 }
	 }
 }

sub do_set_edad {

	if (&Nlook("$origen")) { noDB("$N_nick2"); }
	else {

		my $SetEdad = $trozo[5];
		my $set_nick = lc($trozo[0]);

		if (!$SetEdad) {

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;

			my $set_email = $nicksdb{$set_nick} -> {"EMAIL"};
			my $set_horas = $nicksdb{$set_nick} -> {"HORA"};
			my $set_clave = $nicksdb{$set_nick} -> {"CLAVE"};

			$db_nicks -> {$set_nick} = {"EMAIL" => $set_email, "CLAVE" => $set_clave, "HORA" => $set_horas, "EDAD" => 0};

			%NICK2 = %nicksdb;
			untie(%NICK2);
			msg("$N_nick2", "Borrada información sobre su edad.");
			stats("Nick2", "SETEDAD");
		 }
		else {

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;

			my $set_email = $nicksdb{$set_nick} -> {"EMAIL"};
			my $set_horas = $nicksdb{$set_nick} -> {"HORA"};
			my $set_clave = $nicksdb{$set_nick} -> {"CLAVE"};

			$db_nicks -> {$set_nick} = {"EMAIL" => $set_email, "CLAVE" => $set_clave, "HORA" => $set_horas, "EDAD" => $SetEdad };

			msg("$N_nick2", "La información de su edad ha sido cambiada a12 $SetEdad.");
			stats("Nick2", "SETEDAD");

			%NICK2 = %nicksdb;
			untie(%NICK2);
		 }
	 }
 }

sub do_setemail {
	if (&Nlook("$origen")) { noDB("$N_nick2"); }
	else {

		my $mail_nuevo = $trozo[5];
		my $nick_setemail = lc($trozo[0]);

		if (!$mail_nuevo) { sintaxis("$N_nick2", "SET EMAIL <email>"); }
		elsif ($mail_nuevo =~/\"/) { msg("$N_nick2", "El caracter \" no es válido"); }
		elsif ($mail_nuevo !~/\@/) { msg("$N_nick2", "El mail no es válido."); }
		elsif ($mail_nuevo !~/\./) { msg("$N_nick2", "El mail no es válido."); }
		else {

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;

			my $set_hora = $nicksdb{$nick_setemail} -> {"HORA"};
			my $set_clave = $nicksdb{$nick_setemail} -> {"CLAVE"};
			my $set_edad = $nicksdb{$nick_setpass} -> {"EDAD"};

			$db_nicks -> {$nick_setemail} = {"EMAIL" => $mail_nuevo, "CLAVE" => $set_clave, "HORA" => $set_hora, "EDAD" => $set_edad };

			stats("Nick2", "SETEMAIL");
			msg("$N_nick2", "Su Email ha sido cambiado de $mail_viejo a12 $mail_nuevo");

			%NICK2 = %nicksdb;
			untie(%NICK2);

		 }
	 }
 }


sub do_Nvhost {

	if (&Nlook("$origen")) { noDB("$N_nick2"); }
	else {

		my $Nvhost1 = $trozo[4];

		if (!$Nvhost1) { sintaxis("$N_nick2", "VHOST <vhost>"); }
		elsif (($Nvhost1 =~//) or ($Nvhost1 =~//) or ($Nvhost1 =~//)) { msg("$N_nick2", "La vhost no puede contener colores, el carácter negrita ni subrayado."); }
		elsif (length($Nvhost1) > 10) { msg("$N_nick2", "La vhost no puede ser superior a4 10 letras."); }
		else {

			my $nickDB = lc($trozo[0]);
			$nickDB =~ s/\^/\~/g;
		    $nickDB =~ s/\[/\{/g;
		    $nickDB =~ s/\]/\}/g;

			$tabla{'v'}++;
			my $Nvhost = "$Nvhost1.$mivhost";


			quote("$numerico DB * $tabla{'v'} v $nickDB $Nvhost");

			stats("Nick2", "VHOST");
			msg("$N_nick2", "Su vhost ha sido actualizada, para que tenga efecto cambiase el nick y ponselo de nuevo.");
			debug("$N_nick2", "$trozo[0] cambia su VHOST a12 $Nvhost");

		 }
	 }
 }

sub do_expiranick {

	server("$N_nick2 DBQ * n $trozo[4]");
	defined (my $exnick = <$socket>);
	my @Nexpira = split(" ", $exnick);
	if (@Nexpira[7] eq "REGISTRO_NO_ENCONTRADO") {
		canalopers("$N_nick2", "12$trozo[4] NO está registrado con el modo +r.");
	 }
	else {

		tie(%EXPIRA,'MLDBM',"lista.db");
		%nicksdb = %EXPIRA;

		my $nick_expire_min = lc($trozo[4]);

		my $nickDB = lc($trozo[4]);
		$nickDB =~ s/\^/\~/g;
		$nickDB =~ s/\[/\{/g;
		$nickDB =~ s/\]/\}/g;

		$tabla{'n'}++;
		$tabla{'v'}++;

		quote("$numerico DB * $tabla{'n'} n $nickDB");
		quote("$numerico DB * $tabla{'v'} v $nickDB");

		#Expiración en lista.db...

		delete($nicksdb{$nick_expire_min});

		canalopers("$N_nick2", "Expirando de las DBs a 12$trozo[4].");

		%EXPIRA = %nicksdb;
		untie(%EXPIRA);

	 }
 }

sub do_Ndrop {

	if (&operador("$origen")) {

		my $nick_drop = $trozo[4];
		($kaka, $motivo) = split(":$trozo[3] $trozo[4] ", $_);

		if ((!$nick_drop) or (!$motivo)) { sintaxis("$N_nick2", "DROP <nick> <motivo>"); }
		else {

			server("$N_nick2 DBQ * n $nick_drop");
	        defined (my $resp = <$socket>);
	        my @recibido = split(" ", $resp);

	        if (@recibido[7] eq "REGISTRO_NO_ENCONTRADO") {
		        msg("$N_nick2", "El usuario12 $nick_drop no está registrado.");
	         }
	        else {

		        tie(%EXPIRA,'MLDBM',"lista.db");
				%nicksdb = %EXPIRA;

		        my $nick_drop_min = lc($nick_drop);
		        my $nickDB = lc($nick_drop);
			    $nickDB =~ s/\^/\~/g;
		        $nickDB =~ s/\[/\{/g;
		        $nickDB =~ s/\]/\}/g;

		        $tabla{'n'}++;
		        $tabla{'v'}++;

		        quote("$numerico DB * $tabla{'n'} n $nickDB");
		        quote("$numerico DB * $tabla{'v'} v $nickDB");

				delete($nicksdb{$nick_expire_min});

			    msg("$N_nick2", "El usuario12 $trozo[4] ha sido DROPeado de las Bases De Datos.");
			    stats("Nick2", "DROP");
	            canalopers("$N_nick2", "3$trozo[0] 12DROPea a 4$trozo[4].");
	            debug("$N_nick2","12$trozo[4] DROPado de las Bases De Datos.");

				%EXPIRA = %nicksdb;
				untie(%EXPIRA);

	         }
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub do_Noficial {

	if (&operador("$origen")) {

		my $nickOF = $trozo[4];
		my $vhostOF = $trozo[5];

		if ((!$nickOF) or (!$vhostOF)) { sintaxis("$N_nick2", "OFICIAL <nick> <vhost>.$mired"); }
		else {

			server("$N_nick2 DBQ * n $nickOF");
	        defined (my $resp = <$socket>);
	        my @recibido = split(" ", $resp);

	        if (@recibido[7] eq "REGISTRO_NO_ENCONTRADO") {
		        msg("$N_nick2", "El usuario12 $nickOF no está registrado.");
	         }
	        else {

		        my $nickDB = lc($nickOF);
			    $nickDB =~ s/\^/\~/g;
		        $nickDB =~ s/\[/\{/g;
		        $nickDB =~ s/\]/\}/g;
		        my $vhost = "$vhostOF.$mired";

		        $tabla{'v'}++; quote("$numerico DB * $tabla{'v'} v $nickDB $vhost");

		        msg("$N_nick2", "Vhost Oficial añadida para 12$nickOF,5 $vhost");
		        debug("$N_nick2", "Cambio de Vhost (Oficial) a 12$nickOF.");
		        stats("Nick2", "OFICIAL");
		        canalopers("$N_nick2", "Añadida VHOST Oficial sobre 12$nickOF,5 $vhost");

	         }
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub do_Naddvhost {

	if (&operador("$origen")) {

		my $nick_addvhost = $trozo[4]; my $vhost_addvhost = $trozo[5];

		if ((!$nick_addvhost) or (!$vhost_addvhost)) { sintaxis("$N_nick2", "ADDVHOST <nick> <vhost>.$mivhost"); }
		else {

			server("$N_nick2 DBQ * n $nick_addvhost");
	        defined (my $resp = <$socket>);
	        my @recibido = split(" ", $resp);

	        if (@recibido[7] eq "REGISTRO_NO_ENCONTRADO") {
		        msg("$N_nick2", "El usuario12 $nick_addvhost no está registrado.");
	         }
	        else {

		        my $nickDB = lc($nick_addvhost);
			    $nickDB =~ s/\^/\~/g;
		        $nickDB =~ s/\[/\{/g;
		        $nickDB =~ s/\]/\}/g;
		        my $vhost = "$vhost_addvhost.$mivhost";

		        $tabla{'v'}++; quote("$numerico DB * $tabla{'v'} v $nickDB $vhost");

		        stats("Nick2", "ADDVHOST");
		        msg("$N_nick2", "Vhost añadida para 12$nick_addvhost,5 $vhost");

	         }
		 }
	 }
	else { denegado("$N_nick2", "trozo[0]"); }
 }

sub do_vhostoper {

	if (&operador("$origen")) {

		my $nick_vhost = $trozo[4];

		if (!$nick_vhost) { sintaxis("$N_nick2", "OPER <nick>"); }
		else {

			server("$N_nick2 DBQ * n $nick_vhost");
	        defined ($resp = <$socket>);
	        my @recibido = split(" ", $resp);

	        if (@recibido[7] eq "REGISTRO_NO_ENCONTRADO") {
		        msg("$N_nick2", "El usuario12 $nick_vhost no está registrado.");
	         }
	        else {

		        my $nick_vhostMIN = lc($nick_vhost);
			    $nick_vhostMIN =~ s/\^//g;
		        $nick_vhostMIN =~ s/\[//g;
		        $nick_vhostMIN =~ s/\]//g;
		        $nick_vhostMIN =~ s/\|//g;

		        my $nickDB = lc($nick_vhost);
			    $nickDB =~ s/\^/\~/g;
		        $nickDB =~ s/\[/\{/g;
		        $nickDB =~ s/\]/\}/g;

		        my $vhost = "$nick_vhostMIN.oper.$mired";
		        $tabla{'v'}++;
		        quote("$numerico DB * $tabla{'v'} v $nickDB $vhost");

		        msg("$N_nick2", "Vhost OPERador añadida para 12$nick_vhost,5 $vhost");
		        debug("$N_nick2", "Cambio de Vhost (OPERador) a 12$nick_vhostF.");
		        stats("Nick2", "OPER");
		        canalopers("$N_nick2", "Añadida VHOST OPERador sobre 12$nick_vhost,5 $vhost");

	         }
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub do_Ndelvhost {

	if (&operador("$origen")) {

		my $nick_delvhost = $trozo[4];

		if (!$nick_delvhost) { sintaxis("$N_nick2", "DELVHOST <nick>"); }
		else {

			server("$N_nick2 DBQ * n $nick_delvhost");
	        defined (my $resp = <$socket>);
	        my @recibido = split(" ", $resp);

	        if (@recibido[7] eq "REGISTRO_NO_ENCONTRADO") {
		        msg("$N_nick2", "El usuario12 $nick_delvhost no está registrado.");
	         }
	        else {

		        my $nickDB = lc($nick_delvhost);
			    $nickDB =~ s/\^/\~/g;
		        $nickDB =~ s/\[/\{/g;
		        $nickDB =~ s/\]/\}/g;

		        $tabla{'v'}++; quote("$numerico DB * $tabla{'v'} v $nickDB");

		        msg("$N_nick2", "Vhost borrada a 12$nick_delvhost");
		        stats("Nick2", "DELVHOST");
		        debug("$N_nick2", "Borrada Vhost a 12$nick_delvhost.");
	         }
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub do_getpass {

	if (&administrador("$origen")) {

		tie(%NICK2,'MLDBM',"lista.db");
		%nicksdb = %NICK2;

		my $GetNick = lc($trozo[4]);

		if (!$GetNick) { sintaxis("$N_nick2", "GETPASS <nick>"); untie(%NICK2); }
		elsif (&operador("$GetNick")) { msg("$N_nick2", "No puede usar GETPASS sobre la adminsitración."); untie(%NICK2); }
		elsif (!$nicksdb{$GetNick}->{CLAVE}) { msg("$N_nick2", "El nick12 $trozo[4] no está registrado."); untie(%NICK2); }
		else {

			my $SuClave = $nicksdb{$GetNick} -> {CLAVE};

			msg("$N_nick2", "La clave de 12$trozo[4] es12 $SuClave");
			stats("Nick2", "GETPASS");
			untie(%NICK2);
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub do_Ngetpass {
	if (&operador("$origen")) {
		if ($protmail eq "si") { msg("$N_nick2", "Hace menos de4 5 minutos que se ha mandado un mail."); }
		else {
			my $nick_send = lc($trozo[4]);
			if (!$nick_send) { sintaxis("$N_nick2", "SENDPASS <nick>"); }
			else {

				tie(%NICK2,'MLDBM',"lista.db");
				%nicksdb = %NICK2;

				my $mail_send = $nicksdb{$nick_send} -> {"EMAIL"};
				my $clave_send = $nicksdb{$nick_send} -> {"CLAVE"};

				&sendmail("$mail_send", "$clave_send");

				%NICK2 = %nicksdb;
				untie(%NICK2);
		 	 }
		 }
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }
 }

sub sendmail {

	my $envia_mail = $_[0];
	my $envia_mail_clave = $_[1];

	open(MAIL, "|$rutamail $envia_mail");
	print MAIL "From: $nickserv_mail\n";
	print MAIL "Subject: Envio de CLAVE de $nick2 (+r)\n";
	print MAIL "Nick Registrado (+r): $trozo[4]\n";
	print MAIL "Clave del nick: $envia_mail_clave\n";
	print MAIL "\n";
	print MAIL "Para cambiarte ponerte el nickname -> /nick $trozo[4]:$envia_mail_clave\n";
	print MAIL "Para cambiarte de clave -> /msg $nick2 SET PASS <clave>\n";
	print MAIL "\n";
	print MAIL "Más Información: $web_info\n";
	print MAIL "Gracias por confiar en nosotros.\n";
	close(MAIL);

	$protmail = "si";
    $SIG{'ALRM'} = \&prot1;
    alarm(300);

	msg("$N_nick2", "El mail con su clave ha sido enviado.");
	msg("$N_nick2", "Dentro de unos minutos le llegará...");
	stats("Nick2", "SENDPASS");
	canalopers("$N_nick2", "12$trozo[0] usa 4SENDPASS sobre 12$trozo[4],5 $envia_mail");

 }

sub prot1 {
	$protmail = "no";
	return;
 }

sub do_actualiza {

	if (&Nlook("$origen")) { noDB("$N_nick2"); }
	else {

		if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_nick2", "ACTUALIZA <clave> <email>"); }
		else {

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;

			my $info_actual = $nicksdb{$origen} -> {"EMAIL"};

			%NICK2 = %nicksdb;
			untie(%NICK2);

			if ($info_actual) { msg("$N_nick2", "Usted ya está registrado en mi base de datos."); }
			else {

				my $tiempoA = localtime();
		    	actualiza("$origen", "$trozo[4]", "$trozo[5]", "$tiempoA");
			 }
		 }
	 }
 }

sub actualiza {

	tie(%NICK2,'MLDBM',"lista.db");
	%nicksdb = %NICK2;

	$db_nicks -> {$_[0]} = {"EMAIL" => $_[2], "CLAVE" => $_[1], "HORA" => $_[3], "EDAD" => 0};

	msg("$N_nick2", "Su nick ha sido actualizado en mi Base de Datos...");
	stats("Nick2", "ACTUALIZA");
	msg("$N_nick2", "Cambiase el nick y ponselo otra vez para ver si hay algún fallo.");

	%NICK2 = %nicksdb;
	untie(%NICK2);
 }

sub do_Nstats {

	if (&operador("$origen")) {
		tie(%ESTATS,'MLDBM',"stats/Nick2.db");
		%statsdb = %ESTATS;

		#Comandos de Usuarios.
		my $Nick_Stats_registra = $statsdb{REGISTER}->{STATS};
		 if (!$Nick_Stats_registra) { $Nick_Stats_registra = "0"; }
		my $Nick_Stats_info = $statsdb{INFO}->{STATS};
		 if (!$Nick_Stats_info) { $Nick_Stats_info = "0"; }
		my $Nick_Stats_actualiza = $statsdb{ACTUALIZA}->{STATS};
		 if (!$Nick_Stats_actualiza) { $Nick_Stats_actualiza = "0"; }
		my $Nick_Stats_setpass = $statsdb{SETPASS}->{STATS};
		 if (!$Nick_Stats_setpass) { $Nick_Stats_setpass = "0"; }
		my $Nick_Stats_setemail = $statsdb{SETEMAIL}->{STATS};
		 if (!$Nick_Stats_setemail) { $Nick_Stats_setemail = "0"; }
		my $Nick_Stats_setedad = $statsdb{SETEDAD}->{STATS};
		 if (!$Nick_Stats_setedad) { $Nick_Stats_setedad = "0"; }
		my $Nick_Stats_vhost = $statsdb{VHOST}->{STATS};
		 if (!$Nick_Stats_vhost) { $Nick_Stats_vhost = "0"; }

		#Comandos de Operadores.
		my $Nick_Stats_drop = $statsdb{DROP}->{STATS};
		 if (!$Nick_Stats_drop) { $Nick_Stats_drop = "0"; }
		my $Nick_Stats_oficial = $statsdb{OFICIAL}->{STATS};
		 if (!$Nick_Stats_oficial) { $Nick_Stats_oficial = "0"; }
		my $Nick_Stats_sendpass = $statsdb{SENDPASS}->{STATS};
		 if (!$Nick_Stats_sendpass) { $Nick_Stats_sendpass = "0"; }
		my $Nick_Stats_getpass = $statsdb{GETPASS}->{STATS};
		 if (!$Nick_Stats_getpass) { $Nick_Stats_getpass = "0"; }
		my $Nick_Stats_addvhost = $statsdb{ADDVHOST}->{STATS};
		 if (!$Nick_Stats_addvhost) { $Nick_Stats_addvhost = "0"; }
		my $Nick_Stats_delvhost = $statsdb{DELVHOST}->{STATS};
		 if (!$Nick_Stats_delvhost) { $Nick_Stats_delvhost = "0"; }
		my $Nick_Stats_oper = $statsdb{OPER}->{STATS};
		 if (!$Nick_Stats_oper) { $Nick_Stats_oper = "0"; }

		msg("$N_nick2", "Estadísticas del Servicio de Protección de nicks y vhost.");
		msg("$N_nick2", "Comandos de Usuarios:");
		msg("$N_nick2", "");
		msg("$N_nick2", "Comando REGISTER usado12 $Nick_Stats_registra veces.");
		msg("$N_nick2", "Comando INFO usado12 $Nick_Stats_info veces.");
		msg("$N_nick2", "Comando ACTUALIZA usado12 $Nick_Stats_actualiza veces.");
		msg("$N_nick2", "Comando SET PASS usado12 $Nick_Stats_setpass veces.");
		msg("$N_nick2", "Comando SET EMAIL usado12 $Nick_Stats_setemail veces.");
		msg("$N_nick2", "Comando SET EDAD usado12 $Nick_Stats_setedad veces.");
		msg("$N_nick2", "Comando VHOST usado12 $Nick_Stats_vhost veces.");
		msg("$N_nick2", "");
		msg("$N_nick2", "Comandos de Operadores:");
		msg("$N_nick2", "");
		msg("$N_nick2", "Comando DROP usado12 $Nick_Stats_drop veces.");
		msg("$N_nick2", "Comando OFICIAL usado12 $Nick_Stats_oficial veces.");
		msg("$N_nick2", "Comando SENDPASS usado12 $Nick_Stats_sendpass veces.");
		msg("$N_nick2", "Comando GETDPASS usado12 $Nick_Stats_getpass veces.");
		msg("$N_nick2", "Comando ADDVHOST usado12 $Nick_Stats_addvhost veces.");
		msg("$N_nick2", "Comando DELVHOST usado12 $Nick_Stats_delvhost veces.");
		msg("$N_nick2", "Comando OPER usado12 $Nick_Stats_oper veces.");
		msg("$N_nick2", "");
		msg("$N_nick2", "Fin de las estadísticas de 4$nick2");

		%ESTATS = %statsdb;
		untie(%ESTATS);
	 }
	else { denegado("$N_nick2", "$trozo[0]"); }

 }

sub nick2 {
	$i=0;
	open(FP, "lista.db");
	@jop=<FP>;
	foreach (@jop) {
		chomp;
		split(/"/);
		$i++;
		if ($_[0] eq "$origen") {
			msg("$N_nick2", "es: $_[1]");
			my $j = $i - 1;
			msg("$N_nick2", "es: $i");
			splice(@jop,$j,1);
			&jiji();
			close(FP);
			return;
		 }
	 }
	 msg("$N_nick2", "No estás en la lista.");

 }
sub jiji {
		open(YOP, ">lista.db");
	foreach (@jop) {
		print YOP "$_\n";
	 }
	close(YOP);

 }
return 1;
