

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo del roBOT que controla el preregistro de canales.            - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  La función principal de este roBOT es la de registrar               - ##
##    por medio de X apoyos un canal, y luego, la administración          - ##
##    decidirá si es apto o no.                                           - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####



sub expirachannels
{
	my ($chann, $time_ahora, $canali);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	tie(%APOYOS,'MLDBM', "apoyos.db");
	%apoyosdb = %APOYOS;
	$time_ahora = time();

	foreach $chann (keys (%canalesdb))
	{
		if ($canalesdb{$chann}->{ESTADO} eq "PENDIENTE")
		{
			if (($canalesdb{$chann}->{EXPIRE} <= $time_ahora) && ($canalesdb{$chann}->{EXPIRE}))
			{
				canalreg("$N_reg", "Expirando canal 12$chann, fundador 12$canalesdb{$chann}->{FUNDADOR}.");
				delete($canalesdb{$chann});
				delete($apoyosdb{$chann});
			}
		}
	}

	%CANALES = %canalesdb;
	untie(%CANALES);
	%APOYOS = %apoyosdb;
	untie(%APOYOS);
    $SIG{'ALRM'} = \&expirachannels;
    alarm(250);
}



$Rcomando = \%comandos_reg;
		# Comandos Users & OPERadores.
$Rcomando -> {"AYUDA"} = "reg_help";
$Rcomando -> {"HELP"} = "reg_help";
$Rcomando -> {"REGISTER"} = "reg_register";
$Rcomando -> {"REGISTRA"} = "reg_register";
$Rcomando -> {"APOYOS"} = "reg_apoyos";
$Rcomando -> {"APOYA"} = "reg_apoya";
$Rcomando -> {"ESTADO"} = "reg_estado";
$Rcomando -> {"OP"} = "reg_op";
$Rcomando -> {"CREDITOS"} = "do_creditos";

		# Comandos OPERadores de Reg.
$Rcomando -> {"PROHIBE"} = "reg_prohibe";
$Rcomando -> {"LIBERA"} = "reg_libera";
$Rcomando -> {"LISTA"} = "reg_lista";
$Rcomando -> {"LIST"} = "reg_lista";
$Rcomando -> {"COMERCIAL"} = "reg_comercial";
$Rcomando -> {"OFICIAL"} = "reg_oficial";
$Rcomando -> {"DENIEGA"} = "reg_deniega";
$Rcomando -> {"ACTIVA"} = "reg_activa";
$Rcomando -> {"DROP"} = "reg_drop";
$Rcomando -> {"JOIN"} = "reg_join";
$Rcomando -> {"PART"} = "reg_part";
$Rcomando -> {"OPER"} = "reg_oper";
$Rcomando -> {"ADMIN"} = "reg_admin";
$Rcomando -> {"INFO"} = "reg_info";
$Rcomando -> {"ACEPTA"} = "reg_acepta";

# Estados: PENDIENTE COMPLETO REGISTRADO    DENEGADO CANCELADO

sub reg_help
{
	msg("$N_reg", "4$regserv Servicio de preregistros de canales.");
	msg("$N_reg", "Permite poner registrar un canal por medio de12 $ApoyosNecesarios apoyos.");
	msg("$N_reg", "Para cualquier duda 12/msg HeLP AYUDA <comando> o acuda a 12#registros_Help");
	msg("$N_reg", "");
	msg("$N_reg", "12REGISTRA Entra en periodo de preregistro a un canal.");
	msg("$N_reg", "12APOYA Apoya el registro de un canal.");
	msg("$N_reg", "12APOYOS Muestra los apoyos de su canal.");
	msg("$N_reg", "12ESTADO Informa del estado de un canal.");
	msg("$N_reg", "12OP Da op en su canal.");
	msg("$N_reg", "");
	msg("$N_reg", "4AVISO: Si su canal no recibe los apoyos necesarios en4 $Reg_Expire días será borrado.");
	if (&oper_reg("$origen"))
	{
		msg("$N_reg", "");
		msg("$N_reg", "Comandos disponibles para 12Operadores:");
		msg("$N_reg", "");
		msg("$N_reg", "12INFO Muestra toda la información de un canal.");
		msg("$N_reg", "12ACEPTA Acepta el registro de un canal.");
		msg("$N_reg", "12DENIEGA Deniega el registro de un canal.");
		msg("$N_reg", "12ACTIVA Activa un canal denegado, borrando los apoyos.");
		msg("$N_reg", "12PROHIBE Prohibe que un canal sea registrado.");
		msg("$N_reg", "12LIBERA Libera a un canal de la prohibición.");
		msg("$N_reg", "12LISTA Lista canales de un determinado rango.");
		msg("$N_reg", "12COMERCIAL Registra comercialmente un canal.");
		msg("$N_reg", "12OFICIAL Registra oficialmente un canal.");
		msg("$N_reg", "12DROP Borra todo lo relacionado a un canal.");
		msg("$N_reg", "12JOIN Entra a un canal.");
		msg("$N_reg", "12PART Sale de un canal.");
		msg("$N_reg", "12OPER Modifica la lista de Operadores de $regserv.");
		msg("$N_reg", "12ADMIN Modifica la lista de Administradores de $regserv.");
	}
}

sub reg_lista {

	if (&oper_reg("$origen"))
	{
	if (uc($trozo[4]) eq "CANCELADOS") { &reg_lista_cancelados(); }
	elsif (uc($trozo[4]) eq "COMPLETOS") { &reg_lista_completos(); }
	elsif (uc($trozo[4]) eq "REGISTRADOS") { &reg_lista_registrados(); }
	elsif (uc($trozo[4]) eq "PENDIENTES") { &reg_lista_pendientes(); }
	elsif (uc($trozo[4]) eq "DENEGADOS") { &reg_lista_denegados(); }
	else {
		sintaxis("$N_reg", "LISTA <opción>");
		msg("$N_reg", "Opciones: CANCELADOS, COMPLETOS, REGISTRADOS, PENDIENTES y DENEGADOS.");
	 }
 	}
 	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_oper
{
	if (&oper_reg("$origen"))
	{
		if (uc($trozo[4]) eq "ADD") { &reg_oper_add(); }
		elsif (uc($trozo[4]) eq "DEL") { &reg_oper_del(); }
		elsif (uc($trozo[4]) eq "LIST") { &reg_oper_list(); }
		else { sintaxis("$N_reg", "OPER <add/del/list>"); }
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_oper_list
{
	tie(%REG,'MLDBM', "operreg.db");
    %opersregdb = %REG;
    my $comprueba_opers = 0;
	msg("$N_reg", "Lista de 12Operadores:");
	while(($list_oper,$nivel) = each (%opersregdb))
	{
		if($opersregdb{$list_oper}->{LEVEL} == 1)
		{
			msg("$N_reg", "12$list_oper");
			$comprueba_opers++;
        }
    }
    if(!$comprueba_opers)
    {
	    msg("$N_reg", "Lista de 12Operadores vacía.");
	}
	untie(%REG);
}

sub reg_oper_add
{
	if (!$trozo[5]) { sintaxis("$N_reg", "OPER ADD <nick>"); }
	elsif (!&admin_reg("$origen")) { denegado("$N_reg", "$trozo[0]"); }
	else
	{
		my $add_oper = lc($trozo[5]);
		tie(%REG,'MLDBM', "operreg.db");
		%opersregdb = %REG;
		my $sera_oper = $opersregdb{$add_oper};
		if ($sera_oper)
		{
			untie(%REG);
			msg("$N_reg", "El usuario 12$trozo[5] ya es Operador.");
		}
		else
		{
			$db_opersreg -> {$add_oper} = {"LEVEL" => 1};
			%REG = %opersregdb;
			untie(%REG);
			msg("$N_reg", "Añadido como Operador a 12$trozo[5].");
			canalreg("$N_reg", "12$trozo[0] añade como 4OPERador a 12$trozo[5].");
		}
	}
}

sub reg_oper_del
{
	if (!$trozo[5]) { sintaxis("$N_reg", "OPER DEL <nick>"); }
	elsif (!&admin_reg("$origen")) { denegado("$N_reg", "$trozo[0]"); }
	else
	{
		my $add_oper = lc($trozo[5]);
		tie(%REG,'MLDBM', "operreg.db");
		%opersregdb = %REG;
		my $sera_oper = $opersregdb{$add_oper};
		if ($sera_oper)
		{
			delete($opersregdb{$add_oper});
			%REG = %opersregdb;
			untie(%REG);
			msg("$N_reg", "Borrado de los Operadores a 12$trozo[5].");
			canalreg("$N_reg", "12$trozo[0] borra de los 4OPERadores a 12$trozo[5].");
		}
		else
		{
			untie(%REG);
			msg("$N_reg", "El usuario 12$trozo[5] no es Operador.");
		}
	}
}
# $db_opersreg = \%opersregdb; $RootReg
sub reg_admin
{
	if (&oper_reg("$origen"))
	{
		if (uc($trozo[4]) eq "ADD") { &reg_admin_add(); }
		elsif (uc($trozo[4]) eq "DEL") { &reg_admin_del(); }
		elsif (uc($trozo[4]) eq "LIST") { &reg_admin_list(); }
		else { sintaxis("$N_reg", "ADMIN <add/del/list>"); }
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_admin_list
{
	tie(%REG,'MLDBM', "operreg.db");
    %opersregdb = %REG;
    my $comprueba_opers = 0;
	msg("$N_reg", "Lista de 12Administradores:");
	while(($list_oper,$nivel) = each (%opersregdb))
	{
		if($opersregdb{$list_oper}->{LEVEL} == 2)
		{
			msg("$N_reg", "12$list_oper");
			$comprueba_opers++;
        }
    }
    if(!$comprueba_opers)
    {
	    msg("$N_reg", "Lista de 12Administradores vacía.");
	}
	untie(%REG);
}

sub reg_admin_add
{
	if (!$trozo[5]) { sintaxis("$N_reg", "ADMIN ADD <nick>"); }
	elsif ($origen ne lc($RootReg)) { denegado("$N_reg", "$trozo[0]"); }
	else
	{
		my $add_oper = lc($trozo[5]);
		tie(%REG,'MLDBM', "operreg.db");
		%opersregdb = %REG;
		my $sera_oper = $opersregdb{$add_oper}->{LEVEL};
		if ($sera_oper == 2)
		{
			untie(%REG);
			msg("$N_reg", "El usuario 12$trozo[5] ya es Administrador.");
		}
		else
		{
			$db_opersreg -> {$add_oper} = {"LEVEL" => 2};
			%REG = %opersregdb;
			untie(%REG);
			msg("$N_reg", "Añadido como Administrador a 12$trozo[5].");
			canalreg("$N_reg", "12$trozo[0] añade como 4ADMINistrador a 12$trozo[5].");
		}
	}
}

sub reg_admin_del
{
	if (!$trozo[5]) { msg("$N_reg", "ADMIN DEL <nick>"); }
	elsif ($origen ne lc($RootReg)) { denegado("$N_reg", "$trozo[0]"); }
	else
	{
		my $add_oper = lc($trozo[5]);
		tie(%REG,'MLDBM', "operreg.db");
		%opersregdb = %REG;
		my $sera_oper = $opersregdb{$add_oper}->{LEVEL};
		if ($sera_oper == 2)
		{
			delete($opersregdb{$add_oper});
			%REG = %opersregdb;
			untie(%REG);
			msg("$N_reg", "Borrado de los Administradores a 12$trozo[5].");
			canalreg("$N_reg", "12$trozo[0] borra de los 4ADMINistradores a 12$trozo[5].");
		}
		else
		{
			untie(%REG);
			msg("$N_reg", "El usuario 12$trozo[5] no es Administrador.");
		}
	}
}

sub reg_lista_denegados
{
	my ($chann, $numi, $numii);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	msg("$N_reg", "Lista de canales 4DENEGADOS:");
	foreach $chann (keys (%canalesdb))
	{
		$numii++;
		if ($canalesdb{$chann}->{ESTADO} eq "DENEGADO")
		{
			$numi++;
			msg("$N_reg", "$numi 12$chann (5$canalesdb{$chann}->{FUNDADOR})");
		}
	}
	if (!$numi) { $numi = "0"; }
	if (!$numii) { $numii = "0"; }
	msg("$N_reg", "Total de Denegados:4 $numi.");
	msg("$N_reg", "Total de Canales:4 $numii.");
	untie(%CANALES);
}

sub reg_lista_cancelados
{
	my ($chann, $numi, $numii);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	msg("$N_reg", "Lista de canales 4CANCELADOS:");
	foreach $chann (keys (%canalesdb))
	{
		$numii++;
		if ($canalesdb{$chann}->{ESTADO} eq "CANCELADO")
		{
			$numi++;
			msg("$N_reg", "$numi 12$chann (5$canalesdb{$chann}->{FUNDADOR})");
		}
	}
	if (!$numi) { $numi = "0"; }
	if (!$numii) { $numii = "0"; }
	msg("$N_reg", "Total de Cancelados:4 $numi.");
	msg("$N_reg", "Total de Canales:4 $numii.");
	untie(%CANALES);
}

sub reg_lista_completos
{
	my ($chann, $numi, $numii);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	msg("$N_reg", "Lista de canales 4COMPLETOS:");
	foreach $chann (keys (%canalesdb))
	{
		$numii++;
		if ($canalesdb{$chann}->{ESTADO} eq "COMPLETO")
		{
			$numi++;
			msg("$N_reg", "$numi 12$chann (5$canalesdb{$chann}->{FUNDADOR})");
		}
	}
	if (!$numi) { $numi = "0"; }
	if (!$numii) { $numii = "0"; }
	msg("$N_reg", "Total de Completos:4 $numi.");
	msg("$N_reg", "Total de Canales:4 $numii.");
	untie(%CANALES);
}

sub reg_lista_registrados
{
	my ($chann, $numi, $numii);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	msg("$N_reg", "Lista de canales 4REGISTRADOS:");
	foreach $chann (keys (%canalesdb))
	{
		$numii++;
		if ($canalesdb{$chann}->{ESTADO} eq "REGISTRADO")
		{
			$numi++;
			msg("$N_reg", "$numi 12$chann (5$canalesdb{$chann}->{FUNDADOR})");
		}
	}
	if (!$numi) { $numi = "0"; }
	if (!$numii) { $numii = "0"; }
	msg("$N_reg", "Total de Registrados:4 $numi.");
	msg("$N_reg", "Total de Canales:4 $numii.");
	untie(%CANALES);
}

sub reg_lista_pendientes
{
	my ($chann, $numi, $numii);
	tie(%CANALES,'MLDBM', "canales.db");
	%canalesdb = %CANALES;
	msg("$N_reg", "Lista de canales 4PENDIENTES:");
	foreach $chann (keys (%canalesdb))
	{
		$numii++;
		if ($canalesdb{$chann}->{ESTADO} eq "PENDIENTE")
		{
			$numi++;
			msg("$N_reg", "$numi 12$chann (5$canalesdb{$chann}->{FUNDADOR})");
		}
	}
	if (!$numi) { $numi = "0"; }
	if (!$numii) { $numii = "0"; }
	msg("$N_reg", "Total de Pendientes:4 $numi.");
	msg("$N_reg", "Total de Canales:4 $numii.");
	untie(%CANALES);
}


sub reg_join
{
	if (!$trozo[4]) { sintaxis("$N_reg", "JOIN <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif (&admin_reg("$origen"))
	{
		quote("$N_reg J $trozo[4]");
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_part
{
	if (!$trozo[4]) { sintaxis("$N_reg", "PART <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif (&admin_reg("$origen"))
	{
		quote("$N_reg L $trozo[4]");
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_deniega
{
	if ((!$trozo[4]) || (!$trozo[5])) { sintaxis("$N_reg", "DENIEGA <#canal> <razón>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/H/) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/J/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&oper_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $status = $canalesdb{$canal}->{ESTADO};

		if (!$status)
		{
			untie(%CANALES);
			msg("$N_reg", "El canal no está en fase de preregistro.");
		}
		elsif (($status eq "PENDIENTE") or ($status eq "COMPLETO"))
		{
			my $fund = $canalesdb{$canal}->{FUNDADOR};
			$canalesdb{$canal}->{ESTADO} = "DENEGADO";
			my $razon_de = $Linea;
			$razon_de =~ /^\S+ \S+ \S+ \S+ \S+ (.*)$/;
			$razon_de = $1;
			$canalesdb{$canal}->{RAZON} = $razon_de;
			%CANALES = %canalesdb;
			untie(%CANALES);

			msg("$N_reg", "Canal denegado.");
			quote("$N_reg J $trozo[4]");
			quote("$numerico M $trozo[4] +o $N_reg");
			topic("$N_reg", "$trozo[4]", "Canal Denegado.");
			quote("$N_reg L $trozo[4] :Canal Denegado.");
			canalreg("$N_reg", "12$trozo[0] 4DENIEGA el canal 12$trozo[4] ($fund).");
			mensaje("$N_reg", "$Service_memo", "SEND $fund Su canal ha sido DENEGADO, razón: $razon_de");
		}
		else
		{
			untie(%CANALES);
			msg("$N_reg", "El canal no está en fase de preregistro.");
		}
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_activa
{
	if (!$trozo[4]) { sintaxis("$N_reg", "ACTIVA <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/H/) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/J/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&oper_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $status = $canalesdb{$canal}->{ESTADO};

		if ($status eq "DENEGADO")
		{
			my $fund = $canalesdb{$canal}->{FUNDADOR};
			$canalesdb{$canal}-> {ESTADO} = "PENDIENTE";
			$canalesdb{$canal}-> {RAZON} = 0;
			%CANALES = %canalesdb;
			untie(%CANALES);

			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;
			delete($apoyosdb{$canal});
			%APOYOS = %apoyosdb;
			untie(%APOYOS);
			msg("$N_reg", "El canal ha sido reactivado, los apoyos han sido borrados.");
			quote("$N_reg J $canal");
			topic("$N_reg", "$canal", "El canal ha vuelto a ser ACTIVADO.");
			canalreg("$N_reg", "12$trozo[0] 4ACTIVA el canal 12$trozo[4] ($fund).");
			mensaje("$N_reg", "$Service_memo", "SEND $fund Su canal a sido ACTIVADO.");
		}
		else
		{
			untie(%CANALES);
			msg("$N_reg", "El canal no está denegado.");
		}
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_drop
{
	if (!$trozo[4]) { sintaxis("$N_reg", "DROP <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&oper_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;

		if ($canalesdb{$canal}->{ESTADO})
		{
			if ($canalesdb{$canal}->{ESTADO} eq "REGISTRADO")
			{
				mensaje("$N_reg", "$Service_chan", "DROP $trozo[4]");
			}

			delete($canalesdb{$canal});
			%CANALES = %canalesdb;
			untie(%CANALES);

			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;
			delete($apoyosdb{$canal});
			%APOYOS = %apoyosdb;
			untie(%APOYOS);

			msg("$N_reg", "El canal ha sido dropeado.");
			quote("$N_reg J $canal");
			topic("$N_reg", "$canal", "El canal ha sido DROPado.");
			quote("$N_reg L $canal :El canal ha sido dropado.");
			canalreg("$N_reg", "12$trozo[0] 4DROPea el canal 12$trozo[4].");
		}
		else
		{
			untie(%CANALES);
			msg("$N_reg", "El canal no se encuentra en mi base de datos.");
		}
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_prohibe
{
	if ((!$trozo[4]) || (!$trozo[5])) { sintaxis("$N_reg", "PROHIBE <#canal> <razón>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&admin_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;

		if ($canalesdb{$canal}->{ESTADO})
		{
			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;
			delete($apoyosdb{$canal});
			%APOYOS = %apoyosdb;
			untie(%APOYOS);
		}
		if ($canalesdb{$canal}->{ESTADO} eq "REGISTRADO")
		{
			mensaje("$N_reg", "$Service_chan", "DROP $trozo[4]");
		}

		my $time_canal = localtime();
		my $razon_pr = $Linea;
		$razon_pr =~ /^\S+ \S+ \S+ \S+ \S+ (.*)$/;
		$razon_pr = $1;

		$db_canales -> {$canal} = {
			"FUNDADOR" => $trozo[0],
			"RAZON" => $razon_pr,
			"ESTADO" => 'CANCELADO',
			"TIEMPO" => $time_canal
		};
		%CANALES = %canalesdb;
		untie(%CANALES);

		msg("$N_reg", "Ha sido prohibido el registro de este canal.");
		quote("$N_reg J $trozo[4]");
		quote("$numerico M $trozo[4] +o $N_reg");
		topic("$N_reg", "$trozo[4]", "Canal Cancelado.");
		quote("$N_reg L $trozo[4] :Canal Cancelado.");
		canalreg("$N_reg", "12$trozo[0] 4PROHIBE el canal 12$trozo[4].");
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_libera
{
	if (!$trozo[4]) { sintaxis("$N_reg", "LIBERA <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&admin_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		if ($canalesdb{$canal}->{ESTADO} eq "CANCELADO")
		{
			delete($canalesdb{$canal});
			%CANALES = %canalesdb;
			untie(%CANALES);
			msg("$N_reg", "El canal ha sido liberado.");
			canalreg("$N_reg", "12$trozo[0] 4LIBERA el canal 12$trozo[4].");
		}
		else
		{
			untie(%CANALES);
			msg("$N_reg", "El canal no está prohibido.");
		}
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_comercial
{
	if ((!$trozo[4]) || (!$trozo[5])) { sintaxis("$N_reg", "COMERCIAL <#canal> <password>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&admin_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $time_canal = localtime();

		tie(%NICK2,'MLDBM',"lista.db");
		%nicksdb = %NICK2;
		my $email_nick = $nicksdb{$origen} -> {"EMAIL"};
		untie(%NICK2);

		$db_canales -> {$canal} = {
			"FUNDADOR" => $trozo[0],
			"EMAIL" => $email_nick,
			"CLAVE" => $trozo[5],
			"DESCRIPCION" => "Canal Comecial",
			"ESTADO" => 'REGISTRADO',
			"TIEMPO" => $time_canal
		};
		%CANALES = %canalesdb;
		untie(%CANALES);

		msg("$N_reg", "Canal registrado comercialmente.");
		quote("$N_reg J $trozo[4]");
		quote("$numerico M $trozo[4] +o $N_reg");
		topic("$N_reg", "$trozo[4]", "Canal Registrado como Comercial.");
		mensaje("$N_reg", "$Service_chan", "REGISTER $trozo[4] $trozo[5] Canal Comercial.");
		mensaje("$N_reg", "$Service_chan", "SET $trozo[4] FOUNDER $trozo[0]");
		quote("$N_reg L $trozo[4] :Canal Registrado Comercialmente.");
		canalreg("$N_reg", "12$trozo[0] registra el canal 12$trozo[4] como 4COMERCIAL.");
#		reg_mail("$trozo[0]", "$trozo[4]", "COMERCIAL", "$trozo[0]");
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_oficial
{
	if ((!$trozo[4]) || (!$trozo[5])) { sintaxis("$N_reg", "OFICIAL <#canal> <password>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&admin_reg("$origen"))
	{
		my $canal = lc($trozo[4]);
		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $time_canal = localtime();

		tie(%NICK2,'MLDBM',"lista.db");
		%nicksdb = %NICK2;
		my $email_nick = $nicksdb{$origen} -> {"EMAIL"};
		untie(%NICK2);

		$db_canales -> {$canal} = {
			"FUNDADOR" => $trozo[0],
			"EMAIL" => $email_nick,
			"CLAVE" => $trozo[5],
			"DESCRIPCION" => "Canal Oficial de la Red.",
			"ESTADO" => 'REGISTRADO',
			"TIEMPO" => $time_canal
		};
		%CANALES = %canalesdb;
		untie(%CANALES);

		msg("$N_reg", "Canal registrado como oficial.");
		quote("$N_reg J $trozo[4]");
		quote("$numerico M $trozo[4] +o $N_reg");
		topic("$N_reg", "$trozo[4]", "Canal Registrado como Oficial de la Red.");
		mensaje("$N_reg", "$Service_chan", "REGISTER $trozo[4] $trozo[5] Canal Oficial de la Red.");
		mensaje("$N_reg", "$Service_chan", "SET $trozo[4] FOUNDER $trozo[0]");
		quote("$N_reg L $trozo[4] :Canal Registrado como Oficial.");
		canalreg("$N_reg", "12$trozo[0] registra el canal 12$trozo[4] como 4OFICIAL.");
#		reg_mail("$trozo[0]", "$trozo[4]", "OFICIAL", "$trozo[0]");
	}
	else { denegado("$N_reg", "$trozo[0]"); }
}

sub reg_register {

	if ((!$trozo[4]) || (!$trozo[5]) || (!$trozo[6])) { sintaxis("$N_reg", "REGISTRA <#canal> <password> <descripción>"); }
	elsif (length($trozo[5]) < 5) { msg("$N_reg", "La clave tiene que ser mayor de5 5 letras."); }
	elsif (!$trozo[8]) { msg("$N_reg", "La descripción tiene que ser más larga."); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (length($trozo[4]) > 15) { msg("$N_reg", "El nombre del canal no puede superar las 15 letras."); }
	else {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $DenegadoCanal= $canalesdb{$canal} -> {"ESTADO"};
		untie(%CANALES);

		if (($DenegadoCanal eq "PENDIENTE") || ($DenegadoCanal eq "REGISTRADO") || ($DenegadoCanal eq "COMPLETO")) {
			msg("$N_reg", "El canal ya está registrado o en fase de preregistro.");
		 }
		elsif (($DenegadoCanal eq "DENEGADO") || ($DenegadoCanal eq "CANCELADO")) {
			msg("$N_reg", "El canal está denegado o cancelado.");
		 }
		else {

			tie(%CANALES,'MLDBM', "canales.db");
			%canalesdb = %CANALES;
			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;
			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;
			my $email_nick = $nicksdb{$origen} -> {"EMAIL"};
			untie(%NICK2);

			my $time_canal = localtime();
			my $expires = time() + $expire_reg;
			my $descripcion = $Linea;
			$descripcion =~ /\S+ \S+ \S+ \S+ \S+ \S+ (.*)$/;
			$descripcion = $1;

			$db_canales -> {$canal} = {
				"FUNDADOR" => $trozo[0],
				"EMAIL" => $email_nick,
				"CLAVE" => $trozo[5],
				"DESCRIPCION" => $descripcion,
				"ESTADO" => 'PENDIENTE',
				"TIEMPO" => $time_canal,
				"EXPIRE" => $expires
			};

			$db_apoyos -> {$canal} = { "TOTAL" => 0 };

			%CANALES = %canalesdb;
			untie(%CANALES);
			%APOYOS = %apoyosdb;
			untie(%APOYOS);

			msg("$N_reg", "El canal12 $trozo[4] ha entrado en fase de preregistro.");
			msg("$N_reg", "Necesitas12 $ApoyosNecesarios apoyos para que tu canal quede finalmente registrado.");
			quote("$N_reg J $trozo[4]");
			quote("$numerico M $trozo[4] +o $N_reg");
			topic("$N_reg", "$trozo[4]", "$TopicReg");
			canalreg("$N_reg", "Canal12 $trozo[4] entra en fase de PreRegistro por12 $trozo[0].");
		 }
	 }
 }

sub reg_apoya {

	if (!$trozo[4]) { sintaxis("$N_reg", "APOYA <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	else {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $EstadoCanal = $canalesdb{$canal} -> {"ESTADO"};
		my $FounderCanal = $canalesdb{$canal} -> {"EMAIL"};
		my $FounderNickCanal = $canalesdb{$canal} -> {"FUNDADOR"};
		untie(%CANALES);

		if ($EstadoCanal eq "COMPLETO") { msg("$N_reg", "El canal ya ha completado los apoyos necesarios."); }
		elsif ($EstadoCanal eq "DENEGADO") { msg("$N_reg", "El canal está denegado."); }
		elsif ($EstadoCanal eq "CANCELADO") { msg("$N_reg", "El canal está cancelado."); }
		elsif ($EstadoCanal eq "REGISTRADO") { msg("$N_reg", "El canal está registrado."); }
		elsif ($EstadoCanal eq "PENDIENTE") {

			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;

			tie(%NICK2,'MLDBM',"lista.db");
			%nicksdb = %NICK2;
			$nick_email = $nicksdb{$origen}->{EMAIL};
			untie(%NICK2);

	 		for ($counter = 1; $counter <= $apoyosdb{$canal}->{TOTAL}; $counter++) {
				my $email_apoyos = $apoyosdb{$canal}->{$counter}->{EMAIL};
				my $nick_apoyo = $apoyosdb{$canal}->{$counter}->{NICK};

				if (($email_apoyos eq $nick_email) || ($nick_apoyo eq $origen)) {
					msg("$N_reg", "Sólo se puede apoyar una vez, ya sea por email o por nick.");
					untie(%APOYOS);
					return;
				 }
	 		 }
	 		if (($FounderCanal eq $nick_email) || (lc($FounderNickCanal) eq $origen)) {
		 		msg("$N_reg", "No se puede apoyar con el mismo email que el fundador.");
		 		untie(%APOYOS);
		 		undef($counter);
	 		 }
	 		else {
		 		undef($counter);
		 		undef($channel);
				my $apoyoscanal = $apoyosdb{$canal}->{TOTAL};
				$apoyoscanal++;
				$apoyosdb{$canal} -> {$apoyoscanal} -> {NICK} = "$origen";
				$apoyosdb{$canal} -> {$apoyoscanal} -> {EMAIL} = "$nick_email";
				$apoyosdb{$canal} -> {TOTAL} = "$apoyoscanal";
				undef($nick_email);

				if ($apoyoscanal == $ApoyosNecesarios) {
					tie(%CANALES,'MLDBM',"canales.db");
					%canalesdb = %CANALES;

					$canalesdb{$canal}->{ESTADO} = "COMPLETO";
					canalreg("$N_reg", "El canal $trozo[4] ha completado los apoyos necesarios.");
					topic("$N_reg", "$trozo[4]", "El canal ha conseguido los apoyos necesarios, ahora será evaluado.");
					%CANALES = %canalesdb;
					untie(%CANALES);
		 		 }
				msg("$N_reg", "Su apoyo ha sido anotado, número de apoyo $apoyoscanal");
				%APOYOS = %apoyosdb;
				untie(%APOYOS);
	 		 }
		 }
		else { msg("$N_reg", "El canal no está en fase de Preregistro."); }
	 }
 }

sub reg_apoyos {

	if (!$trozo[4]) { sintaxis("$N_reg", "APOYOS <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	else {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $EstadoCanal = $canalesdb{$canal} -> {"ESTADO"};
		my $fundador = $canalesdb{$canal} -> {"FUNDADOR"};
		untie(%CANALES);

		if (!$EstadoCanal) { msg("$N_reg", "El canal no está registrado."); }
		elsif ((lc($fundador) eq $origen) || (&oper_reg("$origen"))) {

			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;

			if (&oper_reg("$origen")) {
				msg("$N_reg", "Lista de apoyos de 12$trozo[4]:");
		 		for (my $counter = 1; $counter <= $apoyosdb{$canal}->{TOTAL}; $counter++) {
					my $email_apoyos = $apoyosdb{$canal}->{$counter}->{EMAIL};
					my $nick_apoyo = $apoyosdb{$canal}->{$counter}->{NICK};
					msg("$N_reg", "$counter 12$nick_apoyo ·5 $email_apoyos");
		 		 }
		 		msg("$N_reg", "Para más información use 12INFO.");
		 		msg("$N_reg", "Fin de la lista de apoyos.");
		 		untie(%APOYOS);
			 }
			else {
				msg("$N_reg", "Lista de apoyos de 12$trozo[4]:");
		 		for (my $counter = 1; $counter <= $apoyosdb{$canal}->{TOTAL}; $counter++) {
					my $nick_apoyo = $apoyosdb{$canal}->{$counter}->{NICK};
					msg("$N_reg", "$counter 12$nick_apoyo");
		 		 }
		 		msg("$N_reg", "Fin de la lista de apoyos.");
		 		untie(%APOYOS);
			 }
		 }
		else { denegado("$N_reg", "$trozo[0]"); }
	 }
 }

sub reg_estado {

	if (!$trozo[4]) { sintaxis("$N_reg", "ESTADO <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	else {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $EstadoCanal = $canalesdb{$canal} -> {"ESTADO"};
		my $RazonCanal = $canalesdb{$canal} -> {"RAZON"};
		untie(%CANALES);

		if ($EstadoCanal) {
			msg("$N_reg", "Estado de 12$trozo[4]: 4$EstadoCanal.");

			if ((($EstadoCanal eq "DENEGADO") or ($EstadoCanal eq "CANCELADO")) && (&oper_reg("$origen"))) {
				my $RazonCanal = $canalesdb{$canal} -> {"RAZON"};
				msg("$N_reg", "Razón: $RazonCanal");
		 	 }
		 }
		else { msg("$N_reg", "El canal no está registrado."); }
	 }
 }

sub reg_op {

	if (!$trozo[4]) { sintaxis("$N_reg", "OP <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	else {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $FundadorCanal = $canalesdb{$canal} -> {"FUNDADOR"};
		my $EstadoCanal = $canalesdb{$canal} -> {"ESTADO"};
		untie(%CANALES);

		if ($EstadoCanal) {
			if ((lc($FundadorCanal) eq $origen) || (&oper_reg("$origen"))) {
				quote("$N_reg M $trozo[4] +o $Num_nick");
		 	 }
			else { denegado("$N_reg", "$trozo[0]"); }
		 }
		else { msg("$N_reg", "El canal no está registrado."); }
	 }
 }

sub reg_info {

	if (!$trozo[4]) { sintaxis("$N_reg", "INFO <#canal>"); }
	elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
	elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
	elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
	elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
	elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
	elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
	elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
	elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
	elsif (&oper_reg("$origen")) {

		tie(%CANALES,'MLDBM', "canales.db");
		%canalesdb = %CANALES;
		my $canal = lc($trozo[4]);
		my $EstadoCanal = $canalesdb{$canal} -> {ESTADO};

		if (!$EstadoCanal) {
			msg("$N_reg", "El canal 12$trozo[4] no está registrado.");
			untie(%CANALES);
		 }
		elsif ($EstadoCanal eq "CANCELADO")
		{
			msg("$N_reg", "Información sobre el canal 12$trozo[4]:");
			msg("$N_reg", "Estado: 4$EstadoCanal.");
			msg("$N_reg", "Nick que lo ha cancelado:12 $canalesdb{$canal}->{FUNDADOR}.");
			msg("$N_reg", "Razón: $canalesdb{$canal}->{RAZON}");
			msg("$N_reg", "Hora:12 $canalesdb{$canal}->{TIEMPO}");
			msg("$N_reg", "Fin de información sobre 12$trozo[4].");
			untie(%CANALES);
		}
		else {

			tie(%APOYOS,'MLDBM', "apoyos.db");
			%apoyosdb = %APOYOS;

			msg("$N_reg", "Información sobre el canal 12$trozo[4]:");
			msg("$N_reg", "Fundador:12 $canalesdb{$canal}->{FUNDADOR} ·5 $canalesdb{$canal}->{EMAIL} ");
			msg("$N_reg", "Descripción: $canalesdb{$canal}->{DESCRIPCION}");
			msg("$N_reg", "Hora registro:12 $canalesdb{$canal}->{TIEMPO}");
			msg("$N_reg", "Estado:4 $canalesdb{$canal}->{ESTADO}");
			if ((($canalesdb{$canal}->{ESTADO} eq "DENEGADO") or
			($canalesdb{$canal}->{ESTADO} eq "CANCELADO"))) {
				msg("$N_reg", "Razón: $canalesdb{$canal}->{RAZON}");
		 	 }
			msg("$N_reg", "");
			msg("$N_reg", "Lista de Apoyos:");
			untie(%CANALES);

		 	for (my $counter = 1; $counter <= $apoyosdb{$canal}->{TOTAL}; $counter++) {
				my $email_apoyos = $apoyosdb{$canal}->{$counter}->{EMAIL};
				my $nick_apoyo = $apoyosdb{$canal}->{$counter}->{NICK};
				msg("$N_reg", "$counter 12$nick_apoyo ·5 $email_apoyos");
		 	 }
		 	msg("$N_reg", "Fin de apoyos.");
		 }
	 }
	else { denegado("$N_reg", "$trozo[0]"); }
 }

sub reg_acepta {

	if (&oper_reg("$origen")) {
		if (!$trozo[4]) { sintaxis("$N_reg", "ACEPTA <#canal>"); }
		elsif ($trozo[4] !~/^\#/) { msg("$N_reg", "El canal debe de ir precedido de #."); }
		elsif ($trozo[4] =~/\./) { msg("$N_reg", "Nombre de canal no válido '.'"); }
		elsif ($trozo[4] =~/\,/) { msg("$N_reg", "Nombre de canal no válido ','"); }
		elsif ($trozo[4] =~/\:/) { msg("$N_reg", "Nombre de canal no válido ':'"); }
		elsif ($trozo[4] =~/\;/) { msg("$N_reg", "Nombre de canal no válido ';'"); }
		elsif ($trozo[4] =~/\*/) { msg("$N_reg", "Nombre de canal no válido '*'"); }
		elsif ($trozo[4] =~/\?/) { msg("$N_reg", "Nombre de canal no válido '?'"); }
		elsif ($trozo[4] =~/\¿/) { msg("$N_reg", "Nombre de canal no válido '¿'"); }
		else {

			tie(%CANALES,'MLDBM', "canales.db");
			%canalesdb = %CANALES;
			my $canal = lc($trozo[4]);
			my $EstadoCanal= $canalesdb{$canal} -> {ESTADO};
			untie(%CANALES);

			if ($EstadoCanal eq "DENEGADO") { msg("$N_reg", "El canal está denegado."); }
			elsif ($EstadoCanal eq "CANCELADO") { msg("$N_reg", "El canal está cancelado."); }
			elsif ($EstadoCanal eq "REGISTRADO") { msg("$N_reg", "El canal está registrado."); }
			elsif ($EstadoCanal eq "PENDIENTE") {
				if (&admin_reg("$origen")) {

					tie(%CANALES,'MLDBM', "canales.db");
					%canalesdb = %CANALES;
					my $DescCanal = $canalesdb{$canal} -> {DESCRIPCION};
					my $ClaveCanal = $canalesdb{$canal} -> {CLAVE};
					my $FundadorCanal = $canalesdb{$canal} -> {FUNDADOR};

					mensaje("$N_reg", "$Service_chan", "REGISTER $canal $ClaveCanal $DescCanal");
					mensaje("$N_reg", "$Service_chan", "SET $canal FOUNDER $FundadorCanal");
					$canalesdb{$canal}->{ESTADO} = "REGISTRADO";
					$canalesdb{$canal}->{EXPIRE} = 0;
					%CANALES = %canalesdb;
					untie(%CANALES);

					msg("$N_reg", "El canal 12$trozo[4] ha sido registrado, fundador 12$FundadorCanal.");
					canalreg("$N_reg", "Canal 12$trozo[4] ha sido 4REGISTRADO por 12$trozo[0], fundador 12$FundadorCanal. No tiene los apoyos suficientes.");
					topic("$N_reg", "$trozo[4]", "El canal ha sido Registrado por cumplir las normas de la Red.");
					quote("$N_reg L $trozo[4] :Canal Registrado.");

#					reg_mail("$trozo[0]", "$canal", "PENDIENTE", "$FundadorCanal");
				 }
				else { msg("$N_reg", "No puedes aceptar un canal que esté PENDIENTE de apoyos."); }
			 }
			elsif ($EstadoCanal eq "COMPLETO") {

					tie(%CANALES,'MLDBM', "canales.db");
					%canalesdb = %CANALES;
					my $DescCanal = $canalesdb{$canal} -> {DESCRIPCION};
					my $ClaveCanal = $canalesdb{$canal} -> {CLAVE};
					my $FundadorCanal = $canalesdb{$canal} -> {FUNDADOR};

					mensaje("$N_reg", "$Service_chan", "REGISTER $canal $ClaveCanal $DescCanal");
					mensaje("$N_reg", "$Service_chan", "SET $canal FOUNDER $FundadorCanal");
					$canalesdb{$canal}->{ESTADO} = "REGISTRADO";
					$canalesdb{$canal}->{EXPIRE} = 0;
					%CANALES = %canalesdb;
					untie(%CANALES);

					msg("$N_reg", "El canal 12$trozo[4] ha sido registrado, fundador 12$FundadorCanal.");
					canalreg("$N_reg", "Canal 12$trozo[4] ha sido 4REGISTRADO por 12$trozo[0], fundador 12$FundadorCanal.");
					topic("$N_reg", "$canal", "El canal ha sido Registrado por cumplir las normas de la Red.");
					quote("$N_reg L $canal :Canal Registrado.");

#					reg_mail("$trozo[0]", "$canal", "COMPLETO", "$FundadorCanal");
			 }
			else { msg("$N_reg", "El canal no está en fase de Preregistro."); }
		 }
	 }
	else { denegado("$N_reg", "$trozo[0]"); }
 }

# Envío de registro de un canal a la comisión de canales de IRC-Euro.org
#  a petición de Prometeo^
# Si lo queréis usar para un uso fututo, poner delante de @ un \
#		P · <lluneta@irc-euro.org>
sub reg_mail
{
	my($nickacepta, $canal_mail, $mail_estado, $mail_founder) = (shift, shift, shift, shift);
	open(MAIL, "|/usr/sbin/sendmail xx\@xx.com"); # se ha borrado el mail ;)
	print MAIL "From: reg\@irc-euro.org\n";
	print MAIL "Subject: Nuevo canal ACEPTADO.\n";
	print MAIL "Canal Aceptado: $canal_mail\n";
	print MAIL "Fundador: $mail_founder\n";
	print MAIL "Estado del canal: $mail_estado\n";
	print MAIL "\n";
	print MAIL "Operador que ha aceptado: $nickacepta\n";
	print MAIL "\n";
	print MAIL "Comisión de Registro de Canales, IRC-Euro.org\n";
	print MAIL "Http://www.irc-euro.org\n";
	close(MAIL);
	return;
}

return 1;
