#!/bin/bash
source my.cnf
rm -fr files/*


now=$(date +%Y-%m-%d)
#periodo=$(date +%Y-%m)
#Define el periodo en base a al parametro que envia
periodo=$1

DB_NAME=$telcel_db

#crea las carpetas de trabajo
mkdir files/facturas
mkdir files/output
mkdir files/processing
touch files/temp.txt

#Obtiene el archivo de cuentas
#echo "Obtiene el archvio de cuentas"
#smbclient '//172.16.10.240/FacturacionTelcel' --directory "cuentas" -W COSMOCELMTY -U servicedesk%Cosmocel01 --debuglevel=0 -c 'prompt OFF; mget cuentas.csv'


#copy files from shared folder
echo "Obtiene las facturas del mes"
smbclient '$telcel_files_folder' --directory "input" -W COSMOCELMTY -U servicedesk%Cosmocel01 --debuglevel=0 -c 'prompt OFF; mget telcel.zip'

if [[ ! -f telcel.zip ]] ; then
      echo 'File "telcel.zip" is not there, aborting.'
          exit
fi


mv telcel.zip files/telcel.zip
#unziping files
unzip -q files/telcel.zip -d files/facturas

#busca los archivos que esten en subcarpetas y los pone en el directorio raiz, para un mejor manejo
find files/facturas/ -type f -print0 | xargs -0 mv -t files/facturas/ 2> /dev/null

#se eliminan los espacios es los nombre
rename 's/ /_/g' files/facturas/*

#Se copian los archivos PDF a una carpeta para su barrido
cp files/facturas/*.pdf files/processing/

#echo -e "Folio,Cuenta,Cargo,otrosCargos,fechacobro,Folio,Periodo" > files/Datos_Facturas_telcel.csv

FILES=files/processing/*
sep="|"

for f in $FILES
do
 if [[ ! -f $f ]] ; then
   echo 'File "$f" is not there, aborting.'
   exit
 fi

echo -ne "."

 pdftotext $f files/temp.txt
 archivo=${f:17:12} 
 folio=$(sed '5q;d' files/temp.txt) 
 total=$(sed '7q;d' files/temp.txt) 
 cuenta=$(sed '11q;d' files/temp.txt)
 corte=$(sed '9q;d' files/temp.txt)
# cargo=$(sed '55q;d' files/temp.txt)
 #Lee el archivo buscando el string "Equipo a Plazos" y si existe graba el dato de 8 posiciones posteriores
 file=$f
  readarray factura < files/temp.txt
   
#   for i in "${!factura[@]}"; do
#        echo $i".- ${factura[$i]}"
#    done
  

    #Se setea a cero el Cargo
    x=0
    y=0
    OtrosCargos=0
    for i in "${!factura[@]}"; do
      if [[ "${factura[$i]}" =~ "Equipo a Plazos" ]]; then
#      if [[ "${factura[$i]}" =~ "Total cargos anteriores" ]]; then
        x=$((i+8))
      fi
      
      if [[ "${factura[$i]}" =~ "Cargos del mes" ]]; then
        y=$((i+6))
      fi


    done
   
      if [  $x -gt 1 ];  then 
        OtrosCargos="${factura[$x]}"
      fi

      if [ $y -gt 1 ]; then 
        cargo="${factura[$y]}"
      fi



if [[ ! -f 'files/facturas/'$archivo'.xml' ]] ; then
      echo 'XML File  is not there, aborting.'
          exit
fi

 base=$(xmlstarlet sel -t -v '//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado/@Base'  'files/facturas/'$archivo'.xml')
 impuesto=$(xmlstarlet sel -t -v '//cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado/@Importe'  'files/facturas/'$archivo'.xml')
# total=$(xmlstarlet sel -t -v '//cfdi:Comprobante/@Total'  'files/facturas/'$archivo'.xml')

 #Se limpian los textos, cambiando el nombre del mes por el 
 #  digito y quitando los signos de pesos y las comas de los valores

 total=${total/'$'/}
 total=${total/','/}

 cargo=${cargo/'$'/}
 cargo=${cargo/','/}
 cargo=`echo $cargo` 

 OtrosCargos=${OtrosCargos/'$'/}
 OtrosCargos=${OtrosCargos/','/}
 OtrosCargos=`echo $OtrosCargos` 


 corte=${corte/' Ene '/'-01-'}
 corte=${corte/' Feb '/'-02-'}
 corte=${corte/' Mar '/'-03-'}
 corte=${corte/' Abr '/'-04-'}
 corte=${corte/' May '/'-05-'}
 corte=${corte/' Jun '/'-06-'}
 corte=${corte/' Jul '/'-07-'}
 corte=${corte/' Ago '/'-08-'}
 corte=${corte/' Ago '/'-08-'}
 corte=${corte/' Sep '/'-09-'}
 corte=${corte/' Oct '/'-10-'}
 corte=${corte/' Nov '/'-11-'}
 corte=${corte/' Dic '/'-12-'}

 #En base a la fecha de corte, determina el periodo
 ano=$(echo $corte | cut -c7-10)
 dia=$(echo $corte | cut -c1-2)
 mes=$(echo $corte | cut -c4-5)
 periodo=$ano-$mes
 fechacargo=$ano-$mes-$dia
  # echo -e "$folio,$cuenta,$total,$cargo,$corte,$f,$periodo" >> Datos_Facturas_telcel.csv

  #Graba el registro en telcel.facturasTelcel
#   echo 'INSERT INTO facturasTelcel (folio , cuenta, cargo, OtrosCargos, fechacobro,nombreArchivo,periodo,base,impuesto,total) VALUES ("'$folio'","'$cuenta'","'$cargo'","'$OtrosCargos'","'$fechacargo'","'$f'","'$periodo'","'$base'","'$impuesto'","'$total'");'
   mysql --defaults-extra-file=/etc/my.cnf $DB_NAME -e 'INSERT INTO facturasTelcel (folio , cuenta, cargo, OtrosCargos, fechacobro,nombreArchivo,periodo,base,impuesto,total) VALUES ("'$folio'","'$cuenta'","'$cargo'","'$OtrosCargos'","'$fechacargo'","'$f'","'$periodo'","'$base'","'$impuesto'","'$total'");'
done

#Se quitan los ceros al inicio del campo de cuenta
mysql --defaults-extra-file=my.cnf $DB_NAME -e 'UPDATE facturasTelcel SET cuenta = TRIM(LEADING '0' FROM cuenta);'

#Se inserta la region a la que corresponde la cuenta
mysql --defaults-extra-file=my.cnf $DB_NAME -e 'UPDATE facturasTelcel AS F, lineas AS l SET F.region = l.Region WHERE  F.region IS NULL AND F.cuenta = l.Cuenta ;'

#limpia el nombre del archivo quitando la ruta
mysql --defaults-extra-file=my.cnf $DB_NAME -e 'UPDATE facturasTelcel SET nombreArchivo = SUBSTRING_INDEX(nombreArchivo ,"/",-1);'

#Se eliminan archivos temporalesa
rm -fr files/*
rm -fr facturas/*
rm -fr output/*
rm -fr processing/*
rm results.txt
rm Telcel.zip
