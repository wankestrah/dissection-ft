#!/usr/bin/perl

# Copyright (C) 2013, Juan C. Rodríguez Cruces
# This file is part of Dissection Forensic Toolkit (DFT).

# DFT is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# DFT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with DFT.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use Gtk2 '-init';
use Glib qw/TRUE FALSE/; 
		

my ($direccionsalida,$direccionimagenes,$scrolled_window,$diferencia,$text,$imagenactual,$auxpdf);

## Argumentos ##
if ( $#ARGV == 0 ) { # El ultimo indice es 0, por lo tanto hay un elemento
	# Solo necesitamos un argumento
	$direccionsalida = $ARGV[0];
} else {
	die "Error, an argument is needed.\n";
}

my $dact = `pwd`;
chomp $dact;

my($window,$boton_anterior,$boton_siguiente,$i,$j,$maxarray,$imagenvacia,
	$dir1,$dir2,$dir3,$dir4,$dir5,$dir6,$dir7,$dir8,$dir9,$dir10,$dir11,$dir12,$dir13,$dir14,$dir15,$dir16,
	@total,
	$img1vacia,$img2vacia,$img3vacia,$img4vacia,$img5vacia,$img6vacia,$img7vacia,$img8vacia,$img9vacia,
	$img10vacia,$img11vacia,$img12vacia,$img13vacia,$img14vacia,$img15vacia,$img16vacia,
	%hash,$imgact,$visto,$linea,$label,
	%evidencia,$fichevidencia,$fichvisto,$fichi,$clave,$valor,$status,$ev,$diferencia,
	$totalimagenes,$vistas,$evidencias,@aux,@tokenizer); ### Declaro las variables que usaré en el programa

$window = my $window = Gtk2::Window->new('toplevel');
## Preparamos la ventana
$window->set_border_width( 4 );
$window->set_default_size( 800, 600 );
$window->signal_connect( destroy => \&salir );
$window->set_title('Dissection :: Image Viewer');
$window->maximize;
##

$boton_siguiente = Gtk2::Button->new("_Next"); ### Creo el objeto "$boton_cerrar" (haciendo referencia al 
$boton_anterior  = Gtk2::Button->new("_Previous"); #botón creado en glade) para así tener métodos predefinidos que me permitan trabajar he interactuar con el botón. 

#Referenciamos widget de imagenes
my $imagen1 = Gtk2::Image->new; #Referenciamos a $imagen1 el widget image1
my $imagen2 = Gtk2::Image->new; 
my $imagen3 = Gtk2::Image->new;
my $imagen4 = Gtk2::Image->new;
my $imagen5 = Gtk2::Image->new;
my $imagen6 = Gtk2::Image->new;
my $imagen7 = Gtk2::Image->new;
my $imagen8 = Gtk2::Image->new;
my $imagen9 = Gtk2::Image->new;
my $imagen10 = Gtk2::Image->new; 
my $imagen11 = Gtk2::Image->new; 
my $imagen12 = Gtk2::Image->new; 
my $imagen13 = Gtk2::Image->new; 
my $imagen14 = Gtk2::Image->new; 
my $imagen15 = Gtk2::Image->new; 
my $imagen16 = Gtk2::Image->new; 

#Referenciamos widget de labels
my $label1 = Gtk2::Label->new("");
my $label2 = Gtk2::Label->new("");
my $label3 = Gtk2::Label->new("");
my $label4 = Gtk2::Label->new("");
my $label5 = Gtk2::Label->new("");
my $label6 = Gtk2::Label->new("");
my $label7 = Gtk2::Label->new("");
my $label8 = Gtk2::Label->new("");
my $label9 = Gtk2::Label->new("");
my $label10 = Gtk2::Label->new("");
my $label11 = Gtk2::Label->new("");
my $label12 = Gtk2::Label->new("");
my $label13 = Gtk2::Label->new("");
my $label14 = Gtk2::Label->new("");
my $label15 = Gtk2::Label->new("");
my $label16 = Gtk2::Label->new("");

#Referenciamos widget de checks
my $check1 = Gtk2::CheckButton->new("Evidence");
my $check2 = Gtk2::CheckButton->new("Evidence");
my $check3 = Gtk2::CheckButton->new("Evidence");
my $check4 = Gtk2::CheckButton->new("Evidence");
my $check5 = Gtk2::CheckButton->new("Evidence");
my $check6 = Gtk2::CheckButton->new("Evidence");
my $check7 = Gtk2::CheckButton->new("Evidence");
my $check8 = Gtk2::CheckButton->new("Evidence");
my $check9 = Gtk2::CheckButton->new("Evidence");
my $check10 = Gtk2::CheckButton->new("Evidence");
my $check11 = Gtk2::CheckButton->new("Evidence");
my $check12 = Gtk2::CheckButton->new("Evidence");
my $check13 = Gtk2::CheckButton->new("Evidence");
my $check14 = Gtk2::CheckButton->new("Evidence");
my $check15 = Gtk2::CheckButton->new("Evidence");
my $check16 = Gtk2::CheckButton->new("Evidence");

#Referenciamos status
my $status = Gtk2::Statusbar->new;

#########Preparamos para leer todos los datos de las imagenes que vamos a ver mostrar
eval { $imagenvacia= $dact."/empty.jpg" };
eval { $direccionimagenes = $direccionsalida."/imgparseadascarving/" };
eval { $ev = $direccionimagenes."evidencia.txt" };

my $generar;
if (-e $ev){
	$generar=1;
} else {
	$generar=0;
}

chdir($direccionimagenes);
my @total = `ls *.jpg`;
$maxarray=@total-1;
$totalimagenes=@total;
#####################################################

#Retomamos valores iniciales
chdir($direccionimagenes);
$fichvisto=">visto.txt"; #Lo dejamos como overwrite, leeremos con cat
$fichevidencia=">evidencia.txt"; #Lo dejamos como overwrite
$fichi="i.txt";
if (-e $fichi) {
   #Existe, asi que cogemos el valor que tenia
   $i = `cat i.txt`; #cuando hacemos el carving hay que guardar este fichero con un 0
   if ($i>=$maxarray){
	#Ya hemos visto todos
	#&anterior;
   }
   
}  else {
   #Como no existe, le ponemos un 0
   #creamos el fchero i.txt con un valor aleatorio, ya que luego se sobreescribira
   system("ls > i.txt");
   $i=0;
}

#Inicializamos barra de estado
$status->push( $status->get_context_id( 'statusbar1' ), "Pictures seen: $i / $totalimagenes." );

if ($i==0){ 
	# Es la primera vez que abrimos el visor
	
	#Inicializamos a todas las imagenes como no vistas
	foreach $linea (@total) {
		$imgact = $linea;
		chop $imgact;
		$hash{$imgact}="No visto";
	}

	#Inicializamos todas las imagenes como que no son evidencias, utilizamos hash para poder acceder a activar y desactivar evidencias fácilmente
	foreach $linea (@total) {
		$imgact = $linea;
		chop $imgact;
		$evidencia{$imgact}=0; #1 = evidencia, podremos comprobarlo con if ($evidencia{img})
	}

	
} else {
	#No es la primera vez, recuperamos datos
	#Recuperamos los datos de evidencia
	open FICHEVIDENCIA, "evidencia.txt" or die "Can't access to evidencia.txt";
	@aux = <FICHEVIDENCIA>;
	foreach $linea (@aux){
		@tokenizer = split(",",$linea); #$tokenizer[0] = clave, #tokenizer[1]=valor\n
		chop $tokenizer[1];
		if (($tokenizer[0] ne "")&&($tokenizer[0] ne $imagenvacia)) { 
			$evidencia{$tokenizer[0]}=$tokenizer[1];
		}
	}
	close(FICHEVIDENCIA);
	
	#Recuperamos los datos de vistos
	open FICHEVISTO, "visto.txt" or die "Can't access to visto.txt";
	@aux = <FICHEVISTO>;
	foreach $linea (@aux){
		@tokenizer = split(",",$linea); #$tokenizer[0] = clave, #tokenizer[1]=valor\n
		chop $tokenizer[1];
		$hash{$tokenizer[0]}=$tokenizer[1];
	}
	close(FICHVISTO);
	
	$i=$i-16;
	#leer imgvacias :)
}


$boton_siguiente->signal_connect(clicked => \&siguiente); ### Estoy asignándole al objeto "$boton_siguiente" (al botón) la señal "clicked" que a su vez hace referencia a una subrutina. Así, una vez presionado el botón se ejecutará la subrutina "&siguiente"

$boton_anterior->signal_connect(clicked => \&anterior); ##Asignamos $

my $scrolled_window = Gtk2::ScrolledWindow->new;
$scrolled_window->set_policy('automatic', 'automatic');

#Packing
my $vbox1 = Gtk2::VBox->new(FALSE,5);
$vbox1->pack_start($label1,FALSE,FALSE,0);
$vbox1->pack_start($imagen1,FALSE,FALSE,0);
$vbox1->pack_start($check1,FALSE,FALSE,0);
my $vbox2 = Gtk2::VBox->new(FALSE,5);
$vbox2->pack_start($label2,FALSE,FALSE,0);
$vbox2->pack_start($imagen2,FALSE,FALSE,0);
$vbox2->pack_start($check2,FALSE,FALSE,0);
my $vbox3 = Gtk2::VBox->new(FALSE,5);
$vbox3->pack_start($label3,FALSE,FALSE,0);
$vbox3->pack_start($imagen3,FALSE,FALSE,0);
$vbox3->pack_start($check3,FALSE,FALSE,0);
my $vbox4 = Gtk2::VBox->new(FALSE,5);
$vbox4->pack_start($label4,FALSE,FALSE,0);
$vbox4->pack_start($imagen4,FALSE,FALSE,0);
$vbox4->pack_start($check4,FALSE,FALSE,0);
my $vbox5 = Gtk2::VBox->new(FALSE,5);
$vbox5->pack_start($label5,FALSE,FALSE,0);
$vbox5->pack_start($imagen5,FALSE,FALSE,0);
$vbox5->pack_start($check5,FALSE,FALSE,0);
my $vbox6 = Gtk2::VBox->new(FALSE,5);
$vbox6->pack_start($label6,FALSE,FALSE,0);
$vbox6->pack_start($imagen6,FALSE,FALSE,0);
$vbox6->pack_start($check6,FALSE,FALSE,0);
my $vbox7 = Gtk2::VBox->new(FALSE,5);
$vbox7->pack_start($label7,FALSE,FALSE,0);
$vbox7->pack_start($imagen7,FALSE,FALSE,0);
$vbox7->pack_start($check7,FALSE,FALSE,0);
my $vbox8 = Gtk2::VBox->new(FALSE,5);
$vbox8->pack_start($label8,FALSE,FALSE,0);
$vbox8->pack_start($imagen8,FALSE,FALSE,0);
$vbox8->pack_start($check8,FALSE,FALSE,0);
my $vbox9 = Gtk2::VBox->new(FALSE,5);
$vbox9->pack_start($label9,FALSE,FALSE,0);
$vbox9->pack_start($imagen9,FALSE,FALSE,0);
$vbox9->pack_start($check9,FALSE,FALSE,0);
my $vbox10 = Gtk2::VBox->new(FALSE,5);
$vbox10->pack_start($label10,FALSE,FALSE,0);
$vbox10->pack_start($imagen10,FALSE,FALSE,0);
$vbox10->pack_start($check10,FALSE,FALSE,0);
my $vbox11 = Gtk2::VBox->new(FALSE,5);
$vbox11->pack_start($label11,FALSE,FALSE,0);
$vbox11->pack_start($imagen11,FALSE,FALSE,0);
$vbox11->pack_start($check11,FALSE,FALSE,0);
my $vbox12 = Gtk2::VBox->new(FALSE,5);
$vbox12->pack_start($label12,FALSE,FALSE,0);
$vbox12->pack_start($imagen12,FALSE,FALSE,0);
$vbox12->pack_start($check12,FALSE,FALSE,0);
my $vbox13 = Gtk2::VBox->new(FALSE,5);
$vbox13->pack_start($label13,FALSE,FALSE,0);
$vbox13->pack_start($imagen13,FALSE,FALSE,0);
$vbox13->pack_start($check13,FALSE,FALSE,0);
my $vbox14 = Gtk2::VBox->new(FALSE,5);
$vbox14->pack_start($label14,FALSE,FALSE,0);
$vbox14->pack_start($imagen14,FALSE,FALSE,0);
$vbox14->pack_start($check14,FALSE,FALSE,0);
my $vbox15 = Gtk2::VBox->new(FALSE,5);
$vbox15->pack_start($label15,FALSE,FALSE,0);
$vbox15->pack_start($imagen15,FALSE,FALSE,0);
$vbox15->pack_start($check15,FALSE,FALSE,0);
my $vbox16 = Gtk2::VBox->new(FALSE,5);
$vbox16->pack_start($label16,FALSE,FALSE,0);
$vbox16->pack_start($imagen16,FALSE,FALSE,0);
$vbox16->pack_start($check16,FALSE,FALSE,0);


my $hbox1 = Gtk2::HBox->new(FALSE,5);
$hbox1->pack_start($vbox1,FALSE,FALSE,0);
$hbox1->pack_start($vbox2,FALSE,FALSE,0);
$hbox1->pack_start($vbox3,FALSE,FALSE,0);
$hbox1->pack_start($vbox4,FALSE,FALSE,0);
my $hbox2 = Gtk2::HBox->new(FALSE,5);
$hbox2->pack_start($vbox5,FALSE,FALSE,0);
$hbox2->pack_start($vbox6,FALSE,FALSE,0);
$hbox2->pack_start($vbox7,FALSE,FALSE,0);
$hbox2->pack_start($vbox8,FALSE,FALSE,0);
my $hbox3 = Gtk2::HBox->new(FALSE,5);
$hbox3->pack_start($vbox9,FALSE,FALSE,0);
$hbox3->pack_start($vbox10,FALSE,FALSE,0);
$hbox3->pack_start($vbox11,FALSE,FALSE,0);
$hbox3->pack_start($vbox12,FALSE,FALSE,0);
my $hbox4 = Gtk2::HBox->new(FALSE,5);
$hbox4->pack_start($vbox13,FALSE,FALSE,0);
$hbox4->pack_start($vbox14,FALSE,FALSE,0);
$hbox4->pack_start($vbox15,FALSE,FALSE,0);
$hbox4->pack_start($vbox16,FALSE,FALSE,0);

my $hbox5 = Gtk2::HBox->new(FALSE,5);
$hbox5->pack_start($boton_anterior,FALSE,FALSE,0);
$hbox5->pack_start($boton_siguiente,FALSE,FALSE,0);

my $vbox = Gtk2::VBox->new(FALSE,5);
$vbox->pack_start($hbox1,FALSE,FALSE,0);
$vbox->pack_start($hbox2,FALSE,FALSE,0);
$vbox->pack_start($hbox3,FALSE,FALSE,0);
$vbox->pack_start($hbox4,FALSE,FALSE,0);
$vbox->pack_start($hbox5,FALSE,FALSE,0);
$vbox->pack_start($status,FALSE,FALSE,0);

$scrolled_window->add_with_viewport($vbox);
$window->add($scrolled_window);
$window->show_all;  


if ($i==0){
 &siguiente; # hacemos la primera iteración
} else {
 &anterior;
}

Gtk2->main;

sub siguiente {
	# print "Traza: Al entrar en siguiente, i=$i\n";

	#Ponemos a los anteriores como visto:
	if ($img1vacia==0) {	$hash{$dir1} = "Visto"; }
	if ($img2vacia==0) {	$hash{$dir2} = "Visto"; }
	if ($img3vacia==0) {	$hash{$dir3} = "Visto"; }
	if ($img4vacia==0) {	$hash{$dir4} = "Visto";	}
	if ($img5vacia==0) {	$hash{$dir5} = "Visto"; }
	if ($img6vacia==0) {	$hash{$dir6} = "Visto"; }
	if ($img7vacia==0) {	$hash{$dir7} = "Visto";	}
	if ($img8vacia==0) {	$hash{$dir8} = "Visto"; }
	if ($img9vacia==0) {	$hash{$dir9} = "Visto"; }
	if ($img10vacia==0) {	$hash{$dir10} = "Visto"; }
	if ($img11vacia==0) {	$hash{$dir11} = "Visto"; }
	if ($img12vacia==0) {	$hash{$dir12} = "Visto"; }
	if ($img13vacia==0) {	$hash{$dir13} = "Visto"; }
	if ($img14vacia==0) {	$hash{$dir14} = "Visto"; }
	if ($img15vacia==0) {	$hash{$dir15} = "Visto"; }
	if ($img16vacia==0) {	$hash{$dir16} = "Visto"; }
	
	#Ponemos como evidencias los que hayan sido marcado como tales:
	if ($check1->get_active) { #Esta pulsado
		#Es una evidencia
		if ($img1vacia==0) { $evidencia{$dir1}=1; }
	} else { 
		#No es una evidencia
		if ($img1vacia==0) { $evidencia{$dir1}=0; }
	}
	if ($check2->get_active) { 
		if ($img2vacia==0) { $evidencia{$dir2}=1; }
	} else {
		if ($img2vacia==0) { $evidencia{$dir2}=0; }
	}
	if ($check3->get_active) {
		if ($img3vacia==0) { $evidencia{$dir3}=1; }
	} else {
		if ($img3vacia==0) { $evidencia{$dir3}=0; }
	}
	if ($check4->get_active) {
		if ($img4vacia==0) { $evidencia{$dir4}=1; }
	} else {
		if ($img4vacia==0) { $evidencia{$dir4}=0; }
	}

	if ($check5->get_active) {
		if ($img5vacia==0) { $evidencia{$dir5}=1; }
	} else {
		if ($img5vacia==0) { $evidencia{$dir5}=0; }
	}

	if ($check6->get_active) {
		if ($img6vacia==0) { $evidencia{$dir6}=1; }
	} else {
		if ($img6vacia==0) { $evidencia{$dir6}=0; }
	}
	
	if ($check7->get_active) {
		if ($img7vacia==0) { $evidencia{$dir7}=1; }
	} else {
		if ($img7vacia==0) { $evidencia{$dir7}=0; }
	}

	if ($check8->get_active) {
		if ($img8vacia==0) { $evidencia{$dir8}=1; }
	} else {
		if ($img8vacia==0) { $evidencia{$dir8}=0; }
	}

	if ($check9->get_active) {
		if ($img9vacia==0) { $evidencia{$dir9}=1; }
	} else {
		if ($img9vacia==0) { $evidencia{$dir9}=0; }
	}

	if ($check10->get_active) {
		if ($img10vacia==0) { $evidencia{$dir10}=1; }
	} else {
		if ($img10vacia==0) { $evidencia{$dir10}=0; }
	}
	
	if ($check11->get_active) {
		if ($img11vacia==0) { $evidencia{$dir11}=1; }
	} else {
		if ($img11vacia==0) { $evidencia{$dir11}=0; }
	}

	if ($check12->get_active) {
		if ($img12vacia==0) { $evidencia{$dir12}=1; }
	} else {
		if ($img12vacia==0) { $evidencia{$dir12}=0; }
	}

	if ($check13->get_active) {
		if ($img13vacia==0) { $evidencia{$dir13}=1; }
	} else {
		if ($img13vacia==0) { $evidencia{$dir13}=0; }
	}

	if ($check14->get_active) {
		if ($img14vacia==0) { $evidencia{$dir14}=1; }
	} else {
		if ($img14vacia==0) { $evidencia{$dir14}=0; }
	}

	if ($check15->get_active) {
		if ($img15vacia==0) { $evidencia{$dir15}=1; }
	} else {
		if ($img15vacia==0) { $evidencia{$dir15}=0; }
	}

	if ($check16->get_active) {
		if ($img16vacia==0) { $evidencia{$dir16}=1; }
	} else {
		if ($img16vacia==0) { $evidencia{$dir16}=0; }
	}

	#Modificamos la barra de estado
	$vistas=0;
	while (($clave,$valor) = each(%hash)) { 
		if ($valor =~ /Visto/){
			if (($clave ne "")&&($clave ne $imagenvacia)) { 
				$vistas=$vistas+1; 
			} #calculamos las imagenes vistas que hay que no sean vacias
		}
	}
	$evidencias=0;
	while (($clave,$valor) = each(%evidencia)) {
		if ($valor==1){
			$evidencias=$evidencias+1;
		}
	}
	$status->push( $status->get_context_id( 'statusbar1' ), "Seen: $vistas / $totalimagenes \t Checked as evidences: $evidencias." );	

	if ($i<=$maxarray){
		if ($i<=$maxarray) {
			#Nueva foto
			$dir1=$total[$i];
			chop $dir1;
			$img1vacia=0;
			#Comprobamos si ha sido vista o no la nueva foto
			$visto = $hash{$dir1};
			eval { $label = $dir1." - ".$visto};
			$label1->set_text($label); #Mostramos nombre fichero y si ha sido o no vista
			#Ponemos activa si ha sido evidencia anteriormente (porque ya haya sido vista)
			if ($evidencia{$dir1}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check1->set_active(1);
			} else {
				$check1->set_active(0);			
			}
			$i=$i+1;
		} else {
			$dir1=$imagenvacia; #sacamos una pantallita, diciendo de que no hay más :P
			$img1vacia=1;
			$check1->set_active(0);
			$label1->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir1
		$imagen1->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir1));

		if ($i<=$maxarray) {
			$dir2=$total[$i];
			chop $dir2;
			$img2vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir2};
			eval { $label = $dir2." - ".$visto};
			$label2->set_text($label);
			if ($evidencia{$dir2}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check2->set_active(1);
			} else {
				$check2->set_active(0);			
			}
			$i=$i+1;
		} else {
			$dir2=$imagenvacia;
			$img2vacia=1;
			$check2->set_active(0);
			$label2->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir2
		$imagen2->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir2));
	
		if ($i<=$maxarray) {
			$dir3=$total[$i];
			chop $dir3;
			$img3vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir3};
			eval { $label = $dir3." - ".$visto};
			$label3->set_text($label);
			if ($evidencia{$dir3}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check3->set_active(1);
			} else {
				$check3->set_active(0);
			}			
			$i=$i+1;
		} else {
			$dir3=$imagenvacia;
			$img3vacia=1;
			$check3->set_active(0);
			$label3->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir3
		$imagen3->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir3));

		if ($i<=$maxarray) {
			$dir4=$total[$i];
			chop $dir4;
			$img4vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir4};
			eval { $label = $dir4." - ".$visto};
			$label4->set_text($label);
			if ($evidencia{$dir4}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check4->set_active(1);
			} else {
				$check4->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir4=$imagenvacia;
			$img4vacia=1;
			$check4->set_active(0);
			$label4->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir4
		$imagen4->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir4));

		if ($i<=$maxarray) {
			$dir5=$total[$i];
			chop $dir5;
			$img5vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir5};
			eval { $label = $dir5." - ".$visto};
			$label5->set_text($label);
			if ($evidencia{$dir5}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check5->set_active(1);
			} else {
				$check5->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir5=$imagenvacia;
			$img5vacia=1;
			$check5->set_active(0);
			$label5->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir5
		$imagen5->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir5));

		if ($i<=$maxarray) {
			$dir6=$total[$i];
			chop $dir6;
			$img6vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir6};
			eval { $label = $dir6." - ".$visto};
			$label6->set_text($label);
			if ($evidencia{$dir6}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check6->set_active(1);
			} else {
				$check6->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir6=$imagenvacia;
			$img6vacia=1;
			$check6->set_active(0);
			$label6->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir6
		$imagen6->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir6));

		if ($i<=$maxarray) {
			$dir7=$total[$i];
			chop $dir7;
			$img7vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir7};
			eval { $label = $dir7." - ".$visto};
			$label7->set_text($label);
			if ($evidencia{$dir7}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check7->set_active(1);
			} else {
				$check7->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir7=$imagenvacia;
			$img7vacia=1;
			$check7->set_active(0);
			$label7->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir7
		$imagen7->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir7));

		if ($i<=$maxarray) {
			$dir8=$total[$i];
			chop $dir8;
			$img8vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir8};
			eval { $label = $dir8." - ".$visto};
			$label8->set_text($label);
			if ($evidencia{$dir8}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check8->set_active(1);
			} else {
				$check8->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir8=$imagenvacia;
			$img8vacia=1;
			$check8->set_active(0);
			$label8->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir8
		$imagen8->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir8));

		if ($i<=$maxarray) {
			$dir9=$total[$i];
			chop $dir9;
			$img9vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir9};
			eval { $label = $dir9." - ".$visto};
			$label9->set_text($label);
			if ($evidencia{$dir9}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check9->set_active(1);
			} else {
				$check9->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir9=$imagenvacia;
			$img9vacia=1;
			$check9->set_active(0);
			$label9->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir9
		$imagen9->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir9));

		if ($i<=$maxarray) {
			$dir10=$total[$i];
			chop $dir10;
			$img10vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir10};
			eval { $label = $dir10." - ".$visto};
			$label10->set_text($label);
			if ($evidencia{$dir10}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check10->set_active(1);
			} else {
				$check10->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir10=$imagenvacia;
			$img10vacia=1;
			$check10->set_active(0);
			$label10->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir10
		$imagen10->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir10));

		if ($i<=$maxarray) {
			$dir11=$total[$i];
			chop $dir11;
			$img11vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir11};
			eval { $label = $dir11." - ".$visto};
			$label11->set_text($label);
			if ($evidencia{$dir11}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check11->set_active(1);
			} else {
				$check11->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir11=$imagenvacia;
			$img11vacia=1;
			$check11->set_active(0);
			$label11->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir11
		$imagen11->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir11));

		if ($i<=$maxarray) {
			$dir12=$total[$i];
			chop $dir12;
			$img12vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir12};
			eval { $label = $dir12." - ".$visto};
			$label12->set_text($label);
			if ($evidencia{$dir12}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check12->set_active(1);
			} else {
				$check12->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir12=$imagenvacia;
			$img12vacia=1;
			$check12->set_active(0);
			$label12->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir12
		$imagen12->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir12));

		if ($i<=$maxarray) {
			$dir13=$total[$i];
			chop $dir13;
			$img13vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir13};
			eval { $label = $dir13." - ".$visto};
			$label13->set_text($label);
			if ($evidencia{$dir13}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check13->set_active(1);
			} else {
				$check13->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir13=$imagenvacia;
			$img13vacia=1;
			$check13->set_active(0);
			$label13->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir13
		$imagen13->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir13));

		if ($i<=$maxarray) {
			$dir14=$total[$i];
			chop $dir14;
			$img14vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir14};
			eval { $label = $dir14." - ".$visto};
			$label14->set_text($label);
			if ($evidencia{$dir14}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check14->set_active(1);
			} else {
				$check14->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir14=$imagenvacia;
			$img14vacia=1;
			$check14->set_active(0);
			$label14->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir14
		$imagen14->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir14));

		if ($i<=$maxarray) {
			$dir15=$total[$i];
			chop $dir15;
			$img15vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir15};
			eval { $label = $dir15." - ".$visto};
			$label15->set_text($label);
			if ($evidencia{$dir15}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check15->set_active(1);
			} else {
				$check15->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir15=$imagenvacia;
			$img15vacia=1;
			$check15->set_active(0);
			$label15->set_text("Imagen vacia");
		}
		# modificamos  la imagen con la dir15
		$imagen15->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir15));

		if ($i<=$maxarray) {
			$dir16=$total[$i];
			chop $dir16;
			$img16vacia=0;
			#Modificamos como vista
			$visto = $hash{$dir16};
			eval { $label = $dir16." - ".$visto};
			$label16->set_text($label);
			if ($evidencia{$dir16}) { 
				#Ha sido marcada como evidencia, asi que dejamos activo
				$check16->set_active(1);
			} else {
				$check16->set_active(0);
			}
			$i=$i+1; #Lo dejamos para la siguiente
		} else {
			$dir16=$imagenvacia;
			$img16vacia=1;
			$check16->set_active(0);
			$label16->set_text("Imagen vacia");
		}
		# modificamos la imagen con la dir16
		$imagen16->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir16));


	} else { # Estamos al final dlfichero¿?
				#Modificamos el label1
		$visto = $hash{$dir1};
		eval { $label = $dir1." - ".$visto};
		$label1->set_text($label);
		#Modificamos el label2
		$visto = $hash{$dir2};
		eval { $label = $dir2." - ".$visto};
		$label2->set_text($label);
		#Modificamos el label3
		$visto = $hash{$dir3};
		eval { $label = $dir3." - ".$visto};
		$label3->set_text($label);
		#Modificamos el label4
		$visto = $hash{$dir4};
		eval { $label = $dir4." - ".$visto};
		$label4->set_text($label);
		#Modificamos el label5
		$visto = $hash{$dir5};
		eval { $label = $dir5." - ".$visto};
		$label5->set_text($label);
		#Modificamos el label6
		$visto = $hash{$dir6};
		eval { $label = $dir6." - ".$visto};
		$label6->set_text($label);
		#Modificamos el label7
		$visto = $hash{$dir7};
		eval { $label = $dir7." - ".$visto};
		$label7->set_text($label);
		#Modificamos el label8
		$visto = $hash{$dir8};
		eval { $label = $dir8." - ".$visto};
		$label8->set_text($label);
		#Modificamos el label9
		$visto = $hash{$dir9};
		eval { $label = $dir9." - ".$visto};
		$label9->set_text($label);
		#Modificamos el label10
		$visto = $hash{$dir10};
		eval { $label = $dir10." - ".$visto};
		$label10->set_text($label);
		#Modificamos el label11
		$visto = $hash{$dir11};
		eval { $label = $dir11." - ".$visto};
		$label11->set_text($label);
		#Modificamos el label12
		$visto = $hash{$dir12};
		eval { $label = $dir12." - ".$visto};
		$label12->set_text($label);
		#Modificamos el label13
		$visto = $hash{$dir13};
		eval { $label = $dir13." - ".$visto};
		$label13->set_text($label);
		#Modificamos el label14
		$visto = $hash{$dir14};
		eval { $label = $dir14." - ".$visto};
		$label14->set_text($label);
		#Modificamos el label15
		$visto = $hash{$dir15};
		eval { $label = $dir15." - ".$visto};
		$label15->set_text($label);
		#Modificamos el label16
		$visto = $hash{$dir16};
		eval { $label = $dir16." - ".$visto};
		$label16->set_text($label);
		
		#No hacemos nada o mostramos ventana de: No hay más imagenes detrás

	}
	#Guardamos ficheros ahora por si no se vuelve a pulsar los botones	
	#Salvaguardamos el hash de evidencia
	open(FICHEVIDENCIA, $fichevidencia) or die "Can't access to $fichevidencia.\n";
	while (($clave, $valor) = each(%evidencia))
	{
		if (($clave ne "")&&($clave ne $imagenvacia)) {
        		print FICHEVIDENCIA "$clave,$valor\n"; #Los guardamos como imagen,1 o imagen,0
		}					#Luego tokenizaremos con el caracter ','
	}
	close(FICHEVIDENCIA);

	#Salvaguardamos el hash de visto
	open(FICHVISTO, $fichvisto) or die "Can't access to $fichvisto.\n";
	while (($clave, $valor) = each(%hash))
	{
		if (($clave ne "")&&($clave ne $imagenvacia)) {
        		print FICHVISTO "$clave,$valor\n"; #Los guardamos como imagen,visto o imagen,no visto
		}					#Luego tokenizaremos con el caracter ','
	}
	close(FICHVISTO);

	#Salvaguardamos el valor de i
	open(FICHI, ">i.txt") or die "Can't access to $fichi.\n";
	print FICHI "$i"; #Solo guardamos la i
	close(FICHI);
	
	#print "Traza: Al salir de siguiente, i=$i\n";
	
} # Esta subrutina llamada salir sólo se va a ejecutar si sucede el evento que le asignamos al botón

sub anterior {

	# print "Traza: Al entrar en anterior, i=$i\n";
	#Ponemos a los anteriores como visto:
	if ($img1vacia==0) {	$hash{$dir1} = "Visto"; }
	if ($img2vacia==0) {	$hash{$dir2} = "Visto"; }
	if ($img3vacia==0) {	$hash{$dir3} = "Visto"; }
	if ($img4vacia==0) {	$hash{$dir4} = "Visto";	}
	if ($img5vacia==0) {	$hash{$dir5} = "Visto"; }
	if ($img6vacia==0) {	$hash{$dir6} = "Visto"; }
	if ($img7vacia==0) {	$hash{$dir7} = "Visto";	}
	if ($img8vacia==0) {	$hash{$dir8} = "Visto"; }
	if ($img9vacia==0) {	$hash{$dir9} = "Visto"; }
	if ($img10vacia==0) {	$hash{$dir10} = "Visto"; }
	if ($img11vacia==0) {	$hash{$dir11} = "Visto"; }
	if ($img12vacia==0) {	$hash{$dir12} = "Visto"; }
	if ($img13vacia==0) {	$hash{$dir13} = "Visto"; }
	if ($img14vacia==0) {	$hash{$dir14} = "Visto"; }
	if ($img15vacia==0) {	$hash{$dir15} = "Visto"; }
	if ($img16vacia==0) {	$hash{$dir16} = "Visto"; }

	#Ponemos como evidencias los que hayan sido marcado como tales:
	if ($check1->get_active) { #Esta pulsado
		#Es una evidencia
		if ($img1vacia==0) { $evidencia{$dir1}=1; }
	} else { 
		#No es una evidencia
		if ($img1vacia==0) { $evidencia{$dir1}=0; }
	}
	if ($check2->get_active) { 
		if ($img2vacia==0) { $evidencia{$dir2}=1; }
	} else {
		if ($img2vacia==0) { $evidencia{$dir2}=0; }
	}
	if ($check3->get_active) {
		if ($img3vacia==0) { $evidencia{$dir3}=1; }
	} else {
		if ($img3vacia==0) { $evidencia{$dir3}=0; }
	}
	if ($check4->get_active) {
		if ($img4vacia==0) { $evidencia{$dir4}=1; }
	} else {
		if ($img4vacia==0) { $evidencia{$dir4}=0; }
	}
	if ($check5->get_active) {
		if ($img5vacia==0) { $evidencia{$dir5}=1; }
	} else {
		if ($img5vacia==0) { $evidencia{$dir5}=0; }
	}
	if ($check6->get_active) {
		if ($img6vacia==0) { $evidencia{$dir6}=1; }
	} else {
		if ($img6vacia==0) { $evidencia{$dir6}=0; }
	}
	if ($check7->get_active) {
		if ($img7vacia==0) { $evidencia{$dir7}=1; }
	} else {
		if ($img7vacia==0) { $evidencia{$dir7}=0; }
	}
	if ($check8->get_active) {
		if ($img8vacia==0) { $evidencia{$dir8}=1; }
	} else {
		if ($img8vacia==0) { $evidencia{$dir8}=0; }
	}
	if ($check9->get_active) {
		if ($img9vacia==0) { $evidencia{$dir9}=1; }
	} else {
		if ($img9vacia==0) { $evidencia{$dir9}=0; }
	}
	if ($check10->get_active) {
		if ($img10vacia==0) { $evidencia{$dir10}=1; }
	} else {
		if ($img10vacia==0) { $evidencia{$dir10}=0; }
	}
	if ($check11->get_active) {
		if ($img11vacia==0) { $evidencia{$dir11}=1; }
	} else {
		if ($img11vacia==0) { $evidencia{$dir11}=0; }
	}
	if ($check12->get_active) {
		if ($img12vacia==0) { $evidencia{$dir12}=1; }
	} else {
		if ($img12vacia==0) { $evidencia{$dir12}=0; }
	}
	if ($check13->get_active) {
		if ($img13vacia==0) { $evidencia{$dir13}=1; }
	} else {
		if ($img13vacia==0) { $evidencia{$dir13}=0; }
	}
	if ($check14->get_active) {
		if ($img14vacia==0) { $evidencia{$dir14}=1; }
	} else {
		if ($img14vacia==0) { $evidencia{$dir14}=0; }
	}
	if ($check15->get_active) {
		if ($img15vacia==0) { $evidencia{$dir15}=1; }
	} else {
		if ($img15vacia==0) { $evidencia{$dir15}=0; }
	}
	if ($check16->get_active) {
		if ($img16vacia==0) { $evidencia{$dir16}=1; }
	} else {
		if ($img16vacia==0) { $evidencia{$dir16}=0; }
	}


	#Modificamos la barra de estado
	$vistas=0;
	while (($clave,$valor) = each(%hash)) { 
		if ($valor =~ /Visto/){
			if (($clave ne "")&&($clave ne $imagenvacia)) { 
				$vistas=$vistas+1; 
			} #calculamos las imagenes vistas que hay que no sean vacias
		}
	}
	$evidencias=0;
	while (($clave,$valor) = each(%evidencia)) {
		if ($valor==1){
			$evidencias=$evidencias+1;
		}
	}
	$status->push( $status->get_context_id( 'statusbar1' ), "Seen: $vistas / $totalimagenes \t Checked as evidences: $evidencias." );


	if ($i>16) { #No estamos en la posicion inicial y damos por hecho que se puede ir hacia atrás
		#Salvaguardar los img1vacia,img2vacia,img3vacia e img4vacia		
		$valor = $i%16; #Con las 9 imagenes, vamos a ponerlas 
		if ($valor==0) { # Todas las imagenes caben --------------> Funciona bien
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=0;
			$img13vacia=0;
			$img14vacia=0;
			$img15vacia=0;
			$img16vacia=0;
			
		} elsif ($valor==1) { # Hay una imagen visible
			$img1vacia=0;
			$img2vacia=1;
			$img3vacia=1;
			$img4vacia=1;
			$img5vacia=1;
			$img6vacia=1;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
			
		} elsif ($valor==2) { # Hay dos imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=1;
			$img4vacia=1;
			$img5vacia=1;
			$img6vacia=1;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
		} elsif ($valor==3) { # Hay tres imagenes visibles y 1 vacia#
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=1;
			$img5vacia=1;
			$img6vacia=1;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
		} elsif ($valor==4) { # Hay cuatro imagenes visibles 
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=1;
			$img6vacia=1;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
		} elsif ($valor==5) { # Hay cinco imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=1;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==6) { # Hay seis imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=1;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==7) { # Hay siete imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=1;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;	
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==8) { # Hay ocho imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=1;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
	
		} elsif ($valor==9) { # Hay nueve imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=1;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;
		
		} elsif ($valor==10) { # Hay diez imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=1;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==11) { # Hay once imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=1;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==12) { # Hay doce imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=0;
			$img13vacia=1;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==13) { # Hay trece imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=0;
			$img13vacia=0;
			$img14vacia=1;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==14) { # Hay catorce imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=0;
			$img13vacia=0;
			$img14vacia=0;
			$img15vacia=1;
			$img16vacia=1;

		} elsif ($valor==15) { # Hay quince imagenes visibles
			$img1vacia=0;
			$img2vacia=0;
			$img3vacia=0;
			$img4vacia=0;
			$img5vacia=0;
			$img6vacia=0;
			$img7vacia=0;
			$img8vacia=0;
			$img9vacia=0;
			$img10vacia=0;
			$img11vacia=0;
			$img12vacia=0;
			$img13vacia=0;
			$img14vacia=0;
			$img15vacia=0;
			$img16vacia=1;

		}
		if ($img2vacia==1){ #solo esta la primera mostrada
			$i=$i-1;
		} elsif ($img3vacia==1){ #solo estan la primera y segunda mostrada
			$i=$i-2;
		} elsif ($img4vacia==1){ #estan la primera,segunda y tercera mostrada
			$i=$i-3;
		} elsif ($img5vacia==1){ #estan la 1,2,3 y 4 mostradas
			$i=$i-4;
		} elsif ($img6vacia==1){ #estan la 1,2,3,4 y 5 mostradas
			$i=$i-5;
		} elsif ($img7vacia==1){ #estan la 1,2,3,4,5 y 6 mostradas
			$i=$i-6;
		} elsif ($img8vacia==1){ #estan la 1,2,3,4,5,6 y 7 mostradas
			$i=$i-7;
		} elsif ($img9vacia==1){ #estan la 1,2,3,4,5,6,7 y 8 mostradas
			$i=$i-8;
		} elsif ($img10vacia==1){ #estan la 1,2,3,4,5,6,7,8 y 9 mostradas
			$i=$i-9;
		} elsif ($img11vacia==1){ #estan la 1,2,3,4,5,6,7,8,9 y 10 mostradas
			$i=$i-10;
		} elsif ($img12vacia==1){ #estan la 1,2,3,4,5,6,7,8,9,10 y 11 mostradas
			$i=$i-11;
		} elsif ($img13vacia==1){ #estan la 1,2,3,4,5,6,7,8,9,10,11 y 12 mostradas
			$i=$i-12;
		} elsif ($img14vacia==1){ #estan la 1,2,3,4,5,6,7,8,9,10,11,12 y 13 mostradas
			$i=$i-13;
		} elsif ($img15vacia==1){ #estan la 1,2,3,4,5,6,7,8,9,10,11,12,13 y 14 mostradas
			$i=$i-14;
		} elsif ($img16vacia==1){ #estan la 1,2,3,4,5,6,7,8,9,10,11,12,13,14 y 15 mostradas
			$i=$i-15;
		} else { #Estan todas mostradas
			$i=$i-16;
			#Ahora $i apunta a donde $dir1 actual, que es donde habrá que dejar el índice
		}
		$j=$i;   #Para la siguiente iteración esté correcta, tanto para sig como ant
		
		#Empezamos por la cuarta imagen
		#Si damos hacia atrás siempre cabrán las imagenes
		
		# Imagen 16		
		$i=$i-1; #Lugar donde va dir16
		$dir16=$total[$i];
		chop $dir16;
		$visto = $hash{$dir16};
		eval { $label = $dir16." - ".$visto};
		$label16->set_text($label);
		if ($evidencia{$dir16}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check16->set_active(1);
		} else {
			$check16->set_active(0);
		}
		$imagen16->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir16));

		# Imagen 15
		$i=$i-1; #Lugar donde va dir15
		$dir15=$total[$i];
		chop $dir15;
		$visto = $hash{$dir15};
		eval { $label = $dir15." - ".$visto};
		$label15->set_text($label);
		if ($evidencia{$dir15}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check15->set_active(1);
		} else {
			$check15->set_active(0);
		}
		$imagen15->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir15));

		# Imagen 14		
		$i=$i-1; #Lugar donde va dir14
		$dir14=$total[$i];
		chop $dir14;
		$visto = $hash{$dir14};
		eval { $label = $dir14." - ".$visto};
		$label14->set_text($label);
		if ($evidencia{$dir14}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check14->set_active(1);
		} else {
			$check14->set_active(0);
		}
		$imagen14->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir14));

		# Imagen 13
		$i=$i-1; #Lugar donde va dir13
		$dir13=$total[$i];
		chop $dir13;
		$visto = $hash{$dir13};
		eval { $label = $dir13." - ".$visto};
		$label13->set_text($label);
		if ($evidencia{$dir13}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check13->set_active(1);
		} else {
			$check13->set_active(0);
		}
		$imagen13->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir13));

		# Imagen 12		
		$i=$i-1; #Lugar donde va dir12
		$dir12=$total[$i];
		chop $dir12;
		$visto = $hash{$dir12};
		eval { $label = $dir12." - ".$visto};
		$label12->set_text($label);
		if ($evidencia{$dir12}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check12->set_active(1);
		} else {
			$check12->set_active(0);
		}
		$imagen12->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir12));

		# Imagen 11		
		$i=$i-1; #Lugar donde va dir11
		$dir11=$total[$i];
		chop $dir11;
		$visto = $hash{$dir11};
		eval { $label = $dir11." - ".$visto};
		$label11->set_text($label);
		if ($evidencia{$dir11}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check11->set_active(1);
		} else {
			$check11->set_active(0);
		}
		$imagen11->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir11));

		# Imagen 10
		$i=$i-1; #Lugar donde va dir10
		$dir10=$total[$i];
		chop $dir10;
		$visto = $hash{$dir10};
		eval { $label = $dir10." - ".$visto};
		$label10->set_text($label);
		if ($evidencia{$dir10}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check10->set_active(1);
		} else {
			$check10->set_active(0);
		}
		$imagen10->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir10));

		# Ahora Imagen 9		
		$i=$i-1; #Lugar donde va dir9
		$dir9=$total[$i];
		chop $dir9;
		$visto = $hash{$dir9};
		eval { $label = $dir9." - ".$visto};
		$label9->set_text($label);
		if ($evidencia{$dir9}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check9->set_active(1);
		} else {
			$check9->set_active(0);
		}
		$imagen9->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir9));

		# Ahora imagen 8
		$i=$i-1; #Lugar donde va dir8
		$dir8=$total[$i];
		chop $dir8;
		$visto = $hash{$dir8};
		eval { $label = $dir8." - ".$visto};
		$label8->set_text($label);
		if ($evidencia{$dir8}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check8->set_active(1);
		} else {
			$check8->set_active(0);
		}
		$imagen8->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir8));
		
		# Ahora imagen 7
		$i=$i-1; #Lugar donde va dir7
		$dir7=$total[$i];
		chop $dir7;
		$visto = $hash{$dir7};
		eval { $label = $dir7." - ".$visto};
		$label7->set_text($label);
		if ($evidencia{$dir7}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check7->set_active(1);
		} else {
			$check7->set_active(0);
		}
		$imagen7->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir7));
		

		# Ahora imagen 6
		$i=$i-1; #Lugar donde va dir6
		$dir6=$total[$i];
		chop $dir6;
		$visto = $hash{$dir6};
		eval { $label = $dir6." - ".$visto};
		$label6->set_text($label);
		if ($evidencia{$dir6}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check6->set_active(1);
		} else {
			$check6->set_active(0);
		}
		$imagen6->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir6));
		
		# Ahora imagen 5
		$i=$i-1; #Lugar donde va dir5
		$dir5=$total[$i];
		chop $dir5;
		$visto = $hash{$dir5};
		eval { $label = $dir5." - ".$visto};
		$label5->set_text($label);
		if ($evidencia{$dir5}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check5->set_active(1);
		} else {
			$check5->set_active(0);
		}
		$imagen5->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir5));

		#Ahora imagen 4
		$i=$i-1; #Lugar donde va dir4
		$dir4=$total[$i];
		chop $dir4;
		$visto = $hash{$dir4};
		eval { $label = $dir4." - ".$visto};
		$label4->set_text($label);
		if ($evidencia{$dir4}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check4->set_active(1);
		} else {
			$check4->set_active(0);
		}
		$imagen4->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir4));

		#Ahora imagen 3	
		$i=$i-1; #Lugar donde va dir3
		$dir3=$total[$i];
		chop $dir3;
		$visto = $hash{$dir3};
		eval { $label = $dir3." - ".$visto};
		$label3->set_text($label);
		if ($evidencia{$dir3}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check3->set_active(1);
		} else {
			$check3->set_active(0);
		}
		$imagen3->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir3));
		
		#Ahora imagen 2
		$i=$i-1; #Lugar donde va dir2
		$dir2=$total[$i];
		chop $dir2;
		$visto = $hash{$dir2};
		eval { $label = $dir2." - ".$visto};
		$label2->set_text($label);
		if ($evidencia{$dir2}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check2->set_active(1);
		} else {
			$check2->set_active(0);
		}
		$imagen2->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir2));

		#Ahora imagen 1
		$i=$i-1; #Lugar donde va dir1
		$dir1=$total[$i];
		chop $dir1;
		$visto = $hash{$dir1};
		eval { $label = $dir1." - ".$visto};
		$label1->set_text($label);
		if ($evidencia{$dir1}) { 
			#Ha sido marcada como evidencia, asi que dejamos activo
			$check1->set_active(1);
		} else {
			$check1->set_active(0);
		}
		$imagen1->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir1));
		
		#Recogemos el valor de $i para la siguiente iteración
		$img1vacia=0; #Ahora decimos que estan todas mostradas
		$img2vacia=0;
		$img3vacia=0;
		$img4vacia=0;
		$img5vacia=0;
		$img6vacia=0;
		$img7vacia=0;
		$img8vacia=0;
		$img9vacia=0;
		$img10vacia=0;
		$img11vacia=0;
		$img12vacia=0;
		$img13vacia=0;
		$img14vacia=0;
		$img15vacia=0;
		$img16vacia=0;
		#Recuperamos el valor de $j
		$i=$j;

	} else { #Estamos en la posicion inicial
		$img1vacia=0;
		$img2vacia=0;
		$img3vacia=0;
		$img4vacia=0;
		$img5vacia=0;
		$img6vacia=0;
		$img7vacia=0;
		$img8vacia=0;
		$img9vacia=0;
		$img10vacia=0;
		$img11vacia=0;
		$img12vacia=0;
		$img13vacia=0;
		$img14vacia=0;
		$img15vacia=0;
		$img16vacia=0;
		
		#Recogemos imagen1
		$dir1 = $total[0];
		chop $dir1;	 
		$imagen1->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir1));
		#Recogemos imagen2
		$dir2 = $total[1];
		chop $dir2;	 
		$imagen2->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir2));
		#Recogemos imagen3
		$dir3 = $total[2];
		chop $dir3;	 
		$imagen3->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir3));
		#Recogemos imagen4
		$dir4 = $total[3];
		chop $dir4;	 
		$imagen4->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir4));
		#Recogemos imagen5
		$dir5 = $total[4];
		chop $dir5;	 
		$imagen5->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir5));
		#Recogemos imagen6
		$dir6 = $total[5];
		chop $dir6;	 
		$imagen6->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir6));
		#Recogemos imagen7
		$dir7 = $total[6];
		chop $dir7;	 
		$imagen7->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir7));
		#Recogemos imagen8
		$dir8 = $total[7];
		chop $dir8;	 
		$imagen8->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir8));
		#Recogemos imagen9
		$dir9 = $total[8];
		chop $dir9;	 
		$imagen9->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir9));
		#Recogemos imagen10
		$dir10 = $total[9];
		chop $dir10;	 
		$imagen10->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir10));
		#Recogemos imagen11
		$dir11 = $total[10];
		chop $dir11;	 
		$imagen11->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir11));
		#Recogemos imagen12
		$dir12 = $total[11];
		chop $dir12;	 
		$imagen12->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir12));
		#Recogemos imagen13
		$dir13 = $total[12];
		chop $dir13;	 
		$imagen13->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir13));
		#Recogemos imagen14
		$dir14 = $total[13];
		chop $dir14;	 
		$imagen14->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir14));
		#Recogemos imagen15
		$dir15 = $total[14];
		chop $dir15;	 
		$imagen15->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir15));
		#Recogemos imagen16
		$dir16 = $total[15];
		chop $dir16;	 
		$imagen16->set_from_pixbuf(Gtk2::Gdk::Pixbuf->new_from_file($dir16));
		
		
		#Modificamos el label1
		$visto = $hash{$dir1};
		eval { $label = $dir1." - ".$visto};
		$label1->set_text($label);
		#Modificamos el label2
		$visto = $hash{$dir2};
		eval { $label = $dir2." - ".$visto};
		$label2->set_text($label);
		#Modificamos el label3
		$visto = $hash{$dir3};
		eval { $label = $dir3." - ".$visto};
		$label3->set_text($label);
		#Modificamos el label4
		$visto = $hash{$dir4};
		eval { $label = $dir4." - ".$visto};
		$label4->set_text($label);
		#Modificamos el label5
		$visto = $hash{$dir5};
		eval { $label = $dir5." - ".$visto};
		$label5->set_text($label);
		#Modificamos el label6
		$visto = $hash{$dir6};
		eval { $label = $dir6." - ".$visto};
		$label6->set_text($label);
		#Modificamos el label7
		$visto = $hash{$dir7};
		eval { $label = $dir7." - ".$visto};
		$label7->set_text($label);
		#Modificamos el label8
		$visto = $hash{$dir8};
		eval { $label = $dir8." - ".$visto};
		$label8->set_text($label);
		#Modificamos el label9
		$visto = $hash{$dir9};
		eval { $label = $dir9." - ".$visto};
		$label9->set_text($label);
		#Modificamos el label10
		$visto = $hash{$dir10};
		eval { $label = $dir10." - ".$visto};
		$label10->set_text($label);
		#Modificamos el label11
		$visto = $hash{$dir11};
		eval { $label = $dir11." - ".$visto};
		$label11->set_text($label);
		#Modificamos el label12
		$visto = $hash{$dir12};
		eval { $label = $dir12." - ".$visto};
		$label12->set_text($label);
		#Modificamos el label13
		$visto = $hash{$dir13};
		eval { $label = $dir13." - ".$visto};
		$label13->set_text($label);
		#Modificamos el label14
		$visto = $hash{$dir14};
		eval { $label = $dir14." - ".$visto};
		$label14->set_text($label);
		#Modificamos el label15
		$visto = $hash{$dir15};
		eval { $label = $dir15." - ".$visto};
		$label15->set_text($label);
		#Modificamos el label16
		$visto = $hash{$dir16};
		eval { $label = $dir16." - ".$visto};
		$label16->set_text($label);


		#No hacemos nada o mostramos ventana de: No hay más imagenes detrás
		$i=16; #Dejamos la siguiente iteración listo para funcionar
	}

	#Guardamos ficheros ahora por si no se vuelve a pulsar los botones	
	#Salvaguardamos el hash de evidencia
	open(FICHEVIDENCIA, $fichevidencia) or die "Can't access to $fichevidencia.\n";
	while (($clave, $valor) = each(%evidencia))
	{
		if (($clave ne "")&&($clave ne $imagenvacia)) {
        		print FICHEVIDENCIA "$clave,$valor\n"; #Los guardamos como imagen,1 o imagen,0
		}					#Luego tokenizaremos con el caracter ','
	}
	close(FICHEVIDENCIA);

	#Salvaguardamos el hash de visto
	open(FICHVISTO, $fichvisto) or die "Can't access to $fichvisto.\n";
	while (($clave, $valor) = each(%hash))
	{
		if (($clave ne "")&&($clave ne $imagenvacia)) {
        		print FICHVISTO "$clave,$valor\n"; #Los guardamos como imagen,visto o imagen,no visto
		}					#Luego tokenizaremos con el caracter ','
	}
	close(FICHVISTO);

	#Salvaguardamos el valor de i
	open(FICHI, $fichi) or die "Can't access to $fichi.\n";
	print FICHI "$i"; #Solo guardamos la i
	close(FICHI);
		
	#print "Traza: Al salir de anterior, i=$i\n";
}

sub salir{ 
	if ($vistas == $totalimagenes){
		my $auxfich;
		eval { $auxfich = $direccionsalida."/informe.tex" };	
		eval { $auxpdf = $direccionsalida."/informe.pdf" };

		#Miramos si ha sido creado antes el .tex
		if (-e $auxpdf){ #existe el pdf
			#print "No escribimos en el .tex\n"; 
			goto noEscribe; 
		} else { 
			if (-e $auxfich) { #existe el tex
				my $val = `cat $auxfich | tail -n 1`; # pillariamos el \end{document} si hemos acabado de escribir
				if ($val =~ /end{document}/) { 
					#print "No escribimos en el .tex\n"; 
					goto noEscribe; 
				}

			}
		}

		open(FICH,">>$auxfich") || die("Can't access to $auxfich.\n");	
		print FICH '
\section{Pictures}

';
		$text = "Have been found $totalimagenes pictures and $evidencias are evidences. \n\n The evidences are: \n\n";
		print FICH "$text";

		#Mostrar imagenes pertinentes
	
		my @files = `cat evidencia.txt`;
		foreach my $linea (@files) {
		   my ($pict,$prueba) = (split /,/, $linea);
           my $extFile = (split /\./, $pict)[-1]; #conseguimos la extensión del archivo
		   if (($extFile =~ /jpg|jpeg/ ) and ($prueba==1)) { #Es una imagen
			
				# Inicio inserción de imagen en LaTeX
				$text = '\begin{figure}[H]
\centering
	\includegraphics{';
				print FICH "$text";
				eval { $imagenactual= "./imgparseadascarving/".$pict };
				print FICH "$imagenactual";
				$text= '}
\caption{';
				print FICH "$text";
				print FICH "$imagenactual";
				$text= '}
\label{fig:';
				print FICH "$text";
				print FICH "$imagenactual";
				$text= '}
\end{figure}

';
				print FICH "$text \n\n";
				#Fin inserción de imagen en LaTeX
		   }
		}


		$diferencia = $totalimagenes-$evidencias;
		$text = "$diferencia normal pictures have been found.\n\n";
		print FICH "$text";
		$text = '
%FinImagenes';
		print FICH "$text";
		
		if ($generar == 1){
			#Generamos el PDF porque ha sido restaurada la sesion
			# Para acabar el informe final:
			$text = '
\end{document}
';
			print FICH "$text"; # Comentar
			close(FICH);
			chdir($direccionsalida);
			system("pdflatex informe.tex >> /dev/null"); #funciona
		
			# Borrar .tex, aux, ...
			my $auxdelete;		
			eval { $auxdelete = $direccionsalida."/informe.aux" };	
			system("rm $auxdelete");
			eval { $auxdelete = $direccionsalida."/informe.log" };
			system("rm $auxdelete");
			eval { $auxdelete = $direccionsalida."/informe.out" };
			system("rm $auxdelete");
			eval { $auxdelete = $direccionsalida."/informe.tex" };
			system("rm $auxdelete");

			#firmamos el pdf de Latex
			my $pdf;
			eval { $pdf = $direccionsalida."/informe.pdf" };
			system("md5sum $pdf > $pdf.txtmd5"); # Hacemos el md5
			system("sha1sum $pdf > $pdf.txtsha1"); # Hacemos el firmado sha1
					
		} else {
			
			close(FICH);

		}

		noEscribe:

	}
	
	Gtk2->main_quit; 

}
	
