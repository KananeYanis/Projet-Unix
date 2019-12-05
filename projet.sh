#!/bin/bash
database=$(echo -e 'tom idemec\njean idemec\narthur idemec\npaul star\njules star\nyves star\nantoine star\nnathalie star\nsonia flux\njules2 flux\nleila flux\nbruno micro')

croiser_les_donnees(){
  join -14 -211 job_launched.log clusterqueue.log > donnees_croisees.log #Croiser les données en fct de la colonne Id_Job vu que c'est la seule colonne commune au deux fichiers
  while read ligne ; do
    mois=$(echo -e $ligne | cut -d " " -f18)
    if [[ $mois == $2 ]] ; then
      nom_user=$(echo -e $ligne | tr "," " " | cut -d " " -f7)
      state_task=$(echo -e $ligne | cut -d " " -f27)
      nom_equipe=$(echo "$database" | grep "$nom_user "| awk '{print $2}')
      begin_or_finish_time=$(echo -e $ligne | cut -d " " -f20)
      date_job=$(echo $ligne | cut -d " " -f17,18,19)

      if [[ $nom_equipe == $1 ]] ; then
        id_job=$(echo -e $ligne | cut -d " " -f1)

        if [[ $state_task == "started" ]] ; then
          number_of_nodes=$(echo -e $ligne | cut -d " " -f15)
          echo "$id_job DONE BY : $nom_user BEGINNED AT : $begin_or_finish_time NUMBER OF NODES USED : $number_of_nodes DATE $date_job" >> beginned_jobs.log
        fi

        if [[ $state_task == "finished" ]] ; then
          echo "$id_job DONE BY : $nom_user FINISHED AT : $begin_or_finish_time DATE $date_job" >> finished_jobs.log
        fi

      fi

    else
      continue
    fi
  done < donnees_croisees.log
}

retourne_temps_utlisation(){
  join -11 -21 beginned_jobs.log finished_jobs.log > datas_with_jobs_nodes.log
  heure_totale_equipe=0
  total_machine_cost=0
  while read ligne; do

    nom_user=$(echo $ligne | cut -d " " -f5)
    nom_equipe=$(echo "$database" | grep "$nom_user " | awk '{print $2}')

    heure_begin_octa=$(echo $ligne | cut -d " " -f9 | cut -d ":" -f1)
    minutes_begin_octa=$(echo $ligne | cut -d " " -f9 | cut -d ":" -f2)
    seconde_begin_octa=$(echo $ligne | cut -d " " -f9 | cut -d ":" -f3)

    heure_finish_octa=$(echo $ligne | cut -d " " -f27 | cut -d ":" -f1)
    minutes_finish_octa=$(echo $ligne | cut -d " " -f27 | cut -d ":" -f2)
    seconde_finish_octa=$(echo $ligne | cut -d " " -f27 | cut -d ":" -f3)

    date_begin_octa=$(echo $ligne | cut -d " " -f19)
    date_finish_octa=$(echo $ligne | cut -d " " -f31)

    used_nodes=$(echo $ligne | cut -d " " -f15)

    to_ten='10#'

    date_begin="$to_ten$date_begin_octa"
    date_finish="$to_ten$date_finish_octa"

    heure_begin="$to_ten$heure_begin_octa"
    minutes_begin="$to_ten$minutes_begin_octa"
    seconde_begin="$to_ten$seconde_begin_octa"

    heure_finish="$to_ten$heure_finish_octa"
    minutes_finish="$to_ten$minutes_finish_octa"
    seconde_finish="$to_ten$seconde_finish_octa"

    compare_date=$(( $date_finish - $date_begin ))

    if [[ $compare_date != 0 && $heure_begin > $heure_finish ]]; then
      heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
      heure_totale_finish=$(( $compare_date * 24 * 3600 + $heure_finish * 3600 + $minutes_finish * 60 + $seconde_finish ))
      heure_total_sec=$(( $heure_totale_finish - $heure_totale_begin ))

      machine_cost=$(( $heure_total_sec / ( 60 * 60 ) * $used_nodes))
      total_machine_cost=$(( $total_machine_cost + $machine_cost ))

      heure_totale_equipe=$(( $heure_totale_equipe + $heure_total_sec ))
      convert_to_sec=$(( $heure_total_sec % 60 ))
      convert_to_min=$(( ($heure_total_sec / 60 ) % 60 ))
      convert_to_hour=$(( $heure_total_sec / ( 60 * 60 ) ))

      #echo "JOB FAIT PAR $nom_user -> Heure d'utilisation : $convert_to_hour h $convert_to_min m $convert_to_sec s"
      #echo "$heure_finish_octa ----- $heure_finish ----- $heure_totale_finish ------------ $heure_totale_begin -----------------$heure_total_sec"
    else
      heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
      heure_totale_finish=$(( $heure_finish * 3600 + $minutes_finish * 60 + $seconde_finish ))

      heure_total_sec=$(( $heure_totale_finish - $heure_totale_begin ))

      heure_totale_equipe=$(( $heure_totale_equipe + $heure_total_sec  ))

      convert_to_sec=$(( $heure_total_sec % 60 ))
      convert_to_min=$(( ($heure_total_sec / 60 ) % 60 ))
      convert_to_hour=$(( $heure_total_sec / ( 60 * 60 ) ))

      if [[ $convert_to_hour == 0 ]]; then
        convert_to_hour=1
        machine_cost=$(( $convert_to_hour * $used_nodes))
        total_machine_cost=$(( $total_machine_cost + $machine_cost ))
      else
        machine_cost=$(( $convert_to_hour * $used_nodes))
        total_machine_cost=$(( $total_machine_cost + $machine_cost ))
      fi
      #echo "JOB FAIT PAR $nom_user -> Heure d'utilisation : $convert_to_hour h $convert_to_min m $convert_to_sec s nodes : $used_nodes"
  fi
    #echo "$heure_finish_octa ----- $heure_finish ----- $heure_totale_finish ------------ $heure_totale_begin -----------------$heure_total_sec"
  done < datas_with_jobs_nodes.log
  convert_heure_total_equipe=$(( $heure_totale_equipe / (60 * 60 ) ))
  echo "Temps Utilisation de l'équipe $nom_equipe est de : $convert_heure_total_equipe heures et en fonction des noeuds : $total_machine_cost heures"
}

croiser_les_donnees idemec avr
retourne_temps_utlisation
rm donnees_croisees.log
rm datas_with_jobs_nodes.log
rm beginned_jobs.log
rm finished_jobs.log

croiser_les_donnees flux avr
retourne_temps_utlisation
rm donnees_croisees.log
rm datas_with_jobs_nodes.log
rm finished_jobs.log
rm beginned_jobs.log

croiser_les_donnees star avr
retourne_temps_utlisation
rm donnees_croisees.log
rm datas_with_jobs_nodes.log
rm beginned_jobs.log
rm finished_jobs.log

croiser_les_donnees micro avr
retourne_temps_utlisation
#rm donnees_croisees.log
#rm datas_with_jobs_nodes.log
#rm beginned_jobs.log
#rm finished_jobs.log
