

####################################################Http://www.irc-euro.org###
##################### - Euro Services - ######################################
##                                                                        - ##
## -  Módulo del Service de encuestas.                                    - ##
## -  P < lluneta@irc-euro.org >                                          - ##
## -  Este Service y módulo de los EuroServices tiene la función de       - ##
## -  hacer encuestas para así hacer una Red como la quiere el usuario.   - ##
##                                                                          ##
##################### - Euro Services - ######################################
####lluneta@irc-euro.org##########################################GNU/GPL#####

# Este servicio está un poco BETA, digamos que está hecho deprisa.


$Vcomando = \%comandos_vota;

#Comandos de Usuarios.
$Vcomando -> {"HELP"} = "vota_help";
$Vcomando -> {"AYUDA"} = "vota_help";
$Vcomando -> {"VOTA"} = "vota_vota";
$Vcomando -> {"ESTADO"} = "vota_ver";
$Vcomando -> {"VER"} = "vota_ver";
$Vcomando -> {"CREDITOS"} = "do_creditos";

#Comandos Operadores.

$Vcomando -> {"ADD"} = "vota_anyadir";
$Vcomando -> {"DEL"} = "vota_borrar";
$Vcomando -> {"OPCION"} = "vota_opcion";

sub vota_anyadir {

	if (&operador("$origen")) {

		if ((!$trozo[4]) or (!$trozo[5])) { sintaxis("$N_vota", "ADD <título> <comentario>"); }
		else {

			my($kaka, $comentarioENCU) = split(":$trozo[3] $trozo[4] ", $_);
			my $encuesta_hora = localtime();

			tie(%VOTA,'MLDBM',"vota.db");
			%votadb = %VOTA;

			for (my $num_del = 1; ($votadb{$num_del}->{TEXTO}); $num_del++) {

				delete($votadb{$num_del});
		 	 }

			$db_vota -> {"OPCIONES"} = {"TITULO" => $trozo[4], "COMENTARIO" => $comentarioENCU, "VOTOS" => 0, "HORA" => $encuesta_hora, "OPCIONES" => 0 };

			msg("$N_vota", "Encuesta añadida, se ha cambiado la encuesta anterior (si es que había).");
			msg("$N_vota", "Ahora con el comando 12OPCION para añadir opciones para votar.");
			topic("$N_vota", "$canalEncuesta", "Título: $trozo[4] · Encuesta: $comentarioENCU");

			%VOTA = %votadb;
			untie(%VOTA);
	 	 }
     }
    else { denegado("$N_vota", "$trozo[0]"); }
 }

sub vota_opcion {

	if (&operador("$origen")) {
		if (!$trozo[4]) { sintaxis("$N_vota", "OPCION <texto>"); }
		else {

			tie(%VOTA,'MLDBM',"vota.db");
			%votadb = %VOTA;

			my($kaka, $opcion) = split(":$trozo[3] ", $_);

			my $title = $votadb{OPCIONES} -> {TITULO};
			my $comentario = $votadb{OPCIONES} -> {COMENTARIO};
			my $hora_encuesta = $votadb{OPCIONES} -> {HORA};
			my $votos_totales = $votadb{OPCIONES} -> {VOTOS};
			my $ver_opciones = $votadb{OPCIONES} -> {OPCIONES};
			$ver_opciones++;

			$db_vota -> {$ver_opciones} = {"TEXTO" => $opcion, "VOTOS" => 0 };
			$db_vota -> {"OPCIONES"} = {"TITULO" => $title, "COMENTARIO" => $comentario, "VOTOS" => $votos_totales, "HORA" => $hora_encuesta, "OPCIONES" => $ver_opciones };

			msg("$N_vota", "Añadida la nueva opción con el número12 $ver_opciones.");
			%VOTA = %votadb;
			untie(%VOTA);
	 	 }
     }
    else { denegado("$N_vota", "$trozo[0]"); }
 }

sub vota_vota {

	if (!$trozo[4]) { sintaxis("$N_vota", "VOTA <número>"); }
	else {

		tie(%VOTA,'MLDBM',"vota.db");
		%votadb = %VOTA;

		if (!$votadb{OPCIONES}->{TITULO}) { msg("$N_vota", "No hay ninguna votación en curso."); %VOTA = %votadb; untie(%VOTA); }
		else {

			my $numero_opciones = $votadb{OPCIONES} -> {OPCIONES};
			if (($trozo[4] > $numero_opciones) || ($trozo[4] < 0) || ($trozo[4] =~/[a-z]/i)) { msg("$N_vota", "Valor de votación incorrecto."); %VOTA = %votadb; untie(%VOTA); }
			else {

				my $texto_encu = $votadb{$trozo[4]} -> {TEXTO};
				my $num_votos = $votadb{$trozo[4]} -> {VOTOS};
				$num_votos++;
				$db_vota -> {$trozo[4]} = {"TEXTO" => $texto_encu, "VOTOS" => $num_votos };

				my $votos_encu = $votadb{OPCIONES} -> {VOTOS};
				my $title = $votadb{OPCIONES} -> {TITULO};
				my $comentario = $votadb{OPCIONES} -> {COMENTARIO};
				my $hora_encuesta = $votadb{OPCIONES} -> {HORA};
				my $ver_opciones = $votadb{OPCIONES} -> {OPCIONES};
				$votos_encu++;
				$db_vota -> {"OPCIONES"} = {"TITULO" => $title, "COMENTARIO" => $comentario, "VOTOS" => $votos_encu, "HORA" => $hora_encuesta, "OPCIONES" => $ver_opciones };

				msg("$N_vota", "Usted ha votado a:");
				msg("$N_vota", "$trozo[4] · $texto_encu");
				msg("$N_vota", "Su número de voto en esa opción es el12 $num_votos.");
				msg("$N_vota", "Recibidos un total de12 $votos_encu votos.");
				%VOTA = %votadb;
				untie(%VOTA);
			 }
		 }
     }
 }

sub vota_ver {

	tie(%VOTA,'MLDBM',"vota.db");
	%votadb = %VOTA;

	if ($votadb{OPCIONES}->{TITULO}) {

		my $title = $votadb{OPCIONES} -> {TITULO};
		my $comentarioVER = $votadb{OPCIONES} -> {COMENTARIO};
		my $votos_totales = $votadb{OPCIONES} -> {VOTOS};
		my $hora_encuesta = $votadb{OPCIONES} -> {HORA};

		msg("$N_vota", "Información sobre la última encuesta.");
		msg("$N_vota", "Título: $title");
		msg("$N_vota", "Comentario: $comentarioVER");
		msg("$N_vota", "Hora: $hora_encuesta");

		for (my $num_ver = 1; ($votadb{$num_ver}->{TEXTO}); $num_ver++) {

			my $votos_ahi = $votadb{$num_ver} -> {VOTOS};
			if (($votos_ahi) && ($votos_totales)) {
				$porcentaje = int(($votos_ahi * 100) / $votos_totales);
				$porcentaje = "$porcentaje%";
			 }
			if ((!$votos_ahi) or (!$votos_totales)) { $porcentaje = "0"; $porcentaje = "$porcentaje%"; }
			my $txt = $votadb{$num_ver} -> {TEXTO};

			# Ya que no me imprimía el porcentaje, vi que no lo hacía porque la variable era local
			# así que no la hice local y al final la borra con undef. Así que es lo mismo :)
			msg("$N_vota", "$num_ver · $txt");
			msg("$N_vota", "Votos:12 $votos_ahi ·5 $porcentaje");
		 }

		msg("$N_vota", "Recibidos un total de12 $votos_totales votos.");
		undef $porcentaje;
		%VOTA = %votadb;
		untie(%VOTA);
	 }
	else {

		msg("$N_vota", "En este momento no existe ninguna encuesta activa.");
		%VOTA = %votadb;
		untie(%VOTA);
	 }

 }

sub vota_borrar {

	if (&operador("$origen")) {

		tie(%VOTA,'MLDBM',"vota.db");
		%votadb = %VOTA;
		if ($votadb{OPCIONES}->{TITULO}) {

			delete($votadb{OPCIONES});

			for (my $num_del = 1; ($votadb{$num_del}->{TEXTO}); $num_del++) {

				delete($votadb{$num_del});
		 	 }

			msg("$N_vota", "Borrada la encuesta activa. En este momento no hay ninguna encuesta.");
			topic("$N_vota", "$canalEncuesta", "Ninguna Encuesta activa.");
			%VOTA = %votadb;
			untie(%VOTA);
	 	 }
		else {

			msg("$N_vota", "En este momento no existe ninguna encuesta activa.");
			%VOTA = %votadb;
			untie(%VOTA);
	 	 }

	 }
	else { denegado("$N_vota", "$trozo[0]"); }
 }

sub vota_help {

	if (&operador("$origen")) {

		my $lcayuda = lc($trozo[4]);
		if (!$trozo[4]) { my $rutina = "sys/help/vota/oper/help"; ayuda("$N_vota", "$rutina", "$votaserv"); }
		elsif (-e "sys/help/vota/oper/$lcayuda") { my $rutina = "sys/help/vota/oper/$lcayuda"; ayuda("$N_vota", "$rutina", "$nick2"); }
		else { msg("$N_vota", "No existe ayuda para12 $trozo[4]."); }
	 }
	else {

		my $lcayuda = lc($trozo[4]);
		if (!$trozo[4]) { my $rutina = "sys/help/vota/user/help"; ayuda("$N_vota", "$rutina", "$votaserv"); }
		elsif (-e "sys/help/vota/user/$lcayuda") { my $rutina = "sys/help/vota/user/$lcayuda"; ayuda("$N_vota", "$rutina", "$nick2"); }
		else { msg("$N_vota", "No existe ayuda para12 $trozo[4]."); }
	 }
}

return 1;
