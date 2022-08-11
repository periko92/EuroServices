

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo de los Services donde se reparten los mensajes entre ellos.  - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Los EuroServices son unos Servicios de Red que gestionan las        - ##
##    funciones que los Services Principales (NickServ, ChanServ...) no   - ##
##    desempeñan.                                                         - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####


sub privados {

	$trozo[3] =~ s/://;
    $trozo[0] =~ s/://;

    $Num_nick = $Nick_Numerico{lc($trozo[0])};
    $origen = lc($trozo[0]);

    if (($origen eq "$Service_nicks") && (uc($trozo[3]) eq "EXPIRA")) {
	    &do_expiranick();
     }
    elsif (-e "anulados/$origen.db") { msg("$trozo[2]", "Usted tiene el servicio Anulado!"); }

    elsif (($origen eq $Service_nicks) || ($origen eq $Service_chan) || ($origen eq $Service_reg) || ($origen eq $Service_oper) || ($origen eq $Service_memo) || ($origen eq $Service_global) || ($origen eq $Service_help) || ($origen eq $Service_sec)) { }


    elsif ($trozo[2] eq $N_nick2) {

	    my $Nick2_cmd_mayus = uc($trozo[3]);
	    my $Nick2_Cmd = $comandos_nick2{"$Nick2_cmd_mayus"};

	    if (!$Nick2_Cmd) {
		   	 msg("$N_nick2", "Comando '12$trozo[3]' desconocido.");
	     }
	    else { &$Nick2_Cmd; }
     }

    elsif ($trozo[2] eq $N_reg) {
	    if (&Nlook("$origen")) { noDB("$N_reg"); }
	    else {
	    	my $Reg_cmd_mayus = uc($trozo[3]);
	    	my $Reg_Cmd = $comandos_reg{"$Reg_cmd_mayus"};

	    	if (!$Reg_Cmd) {
		   	 	msg("$N_reg", "Comando '12$trozo[3]' desconocido.");
	     	 }
	    	else { &$Reg_Cmd; }
    	}
     }

    elsif ($trozo[2] eq $N_help) {

	    help_x();
     }

   elsif ($trozo[2] eq $N_vota) {

	    my $Vota_cmd_mayus = uc($trozo[3]);
	    my $Vota_Cmd = $comandos_vota{"$Vota_cmd_mayus"};

	    if (!$Vota_Cmd) {
		    msg("$N_vota", "Comando '12$trozo[3]' desconocido.");
	     }
	    else { &$Vota_Cmd; }
    }

   elsif ($trozo[2] eq $N_oper) {

	   if (&operador("$origen")) {

		    my $Oper_cmd_mayus = uc($trozo[3]);
	        my $Oper_Cmd = $comandos_oper{"$Oper_cmd_mayus"};

	        if (!$Oper_Cmd) {
		        msg("$N_oper", "Comando '12$trozo[3]' desconocido.");
	         }
	        else { &$Oper_Cmd; }
	    }
	   else { denegado("$N_oper", "$trozo[0]"); }
    }

    elsif ($trozo[2] eq $N_aleto) {

	    if (&preoperador("$origen")) {
		    my $Aleto_cmd_mayus = uc($trozo[3]);
	        my $Aleto_Cmd = $comandos_aleto{"$Aleto_cmd_mayus"};

	        if (!$Aleto_Cmd) {
		        msg("$N_aleto", "Comando '12$trozo[3]' desconocido.");
	         }
	        else { &$Aleto_Cmd; }
	     }
	    else { denegado("$N_aleto", "$trozo[0]"); }
     }
}


return 1;