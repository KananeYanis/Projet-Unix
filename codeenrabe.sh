sum_hours_with_nodes=0
while read ligne_beginned ; do
  while read ligne_finished ; do
      id_job_beg=$(echo -e $ligne_beginned | cut -d " " -f1)
      id_job_fin=$(echo -e $ligne_finished | cut -d " " -f1)
      if [[ $id_job_beg == $id_job_fin ]] ; then
        begin=$(echo -e $ligne_beginned | cut -d " " -f9)
        finish=$(echo -e $ligne_finished | cut -d " " -f9)
        begin_time=$(echo -e $begin | cut -d ":" -f1,2,3)
        finish_time=$(echo -e $finish | cut -d ":" -f1,2,3)
        echo "$begin_time --- $finish_time"
        #number_nodes=$(echo -e $ligne_beginned | cut -d " " -f15)
        #diff=$(( $finish_time - $begin_time ))
        #diff_with_nodes=$(( $diff * $number_nodes ))
        #sum_hours_with_nodes=$(( $sum_hours_with_nodes + $diff_with_nodes ))
        #echo "$begin///$begin_time ------- $finish///$finish_time ------ $diff --------"
      fi
  done < finished_jobs.log
done < beginned_jobs.log
#echo "Temps utilisation = $sum_hours_with_nodes"


if [[ $heure_begin == "08" ]] ; then
  heure_begin=8
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"

elif [[ $minutes_begin == "08" ]]; then
  minutes_begin=8
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"

elif [[ $seconde_begin == "08" ]]; then
  seconde_begin=8
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"

elif [[ $heure_begin == "08" && $minutes_begin == "08" ]]; then
  heure_begin=8
  minutes_begin=8
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"

elif [[ $minutes_begin == "08" && $seconde_begin == "08" ]]; then
  minutes_begin=8
  seconde_begin=8
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"

elif [[ $heure_begin == "08" && $seconde_begin == "08" ]]; then


if [[ $minutes_begin == "09" || $heure_begin == "09" || $seconde_begin == "09" ]] ; then
  minutes_begin=9
  heure_totale_begin=$(( $heure_begin * 3600 + $minutes_begin * 60 + $seconde_begin ))
  echo "Heure en secondes : $heure_totale_begin"
fi

#sort clusterqueue.log > temp1.tmp
#sort job_launched.log > temp2.tmp
#comm -1 -2 temp1.tmp temp2.tmp

#declare -a array_teams=(idemec star flux micro)
declare -a array_users=(tom jean arthur paul jules yves antoine nathalie sonia jules2 leila bruno)



retourne_job_user(){
  for user in ${array_users[*]}
    do
        while read ligne; do
          nom_user=$(echo $ligne | tr "," " " | cut -d " " -f7)
          if [[ $user == $nom_user ]]; then
            datas=$(echo $ligne | tr "," " " | cut -d " " -f4,7)
            nom_equipe=$(echo "$var" | grep "$nom_user "| awk '{print $2}')
            if [[ $nom_equipe == $1 ]]; then
              echo "$datas -> $nom_equipe"
            else
              break
            fi
          fi
        done < job_launched.log
    done
}
#while read ligne_joblaunched ; do
#id_job_job=$(echo $ligne_joblaunched | cut -d " " -f4)
    #if [[ $id_job_clu == $id_job_job ]]; then
#fi
#done < job_launched.log


retourne_job_team_in_month(){
  echo "JOBS DU MOIS DE $1"
  while read ligne_cluster ; do
      ligne_voulue=$(echo $ligne_cluster | grep $1 | cut -d " " -f4,11)
      if [[ ligne_voulue == " " ]]; then
        continue
      else
        echo $ligne_voulue
      fi
  done < clusterqueue.log
}

retourne_donnees_voulus(){
  while read ligne_joblaunched ; do
    while read ligne_cluster; do
      id_job_job=$(echo -e $ligne_joblaunched | cut -d " " -f4)
      nom_user=$(echo -e $ligne_joblaunched | tr "," " " | cut -d " " -f7)
      nom_equipe=$(echo "$var" | grep "$nom_user "| awk '{print $2}')

      id_job_clu=$(echo -e $ligne_cluster | cut -d " " -f11)
      mois=$(echo -e $ligne_cluster | cut -d " " -f2)

      echo "$nom_equipe"
      if [[ "$nom_equipe" == $1 && "$mois" == $2 ]]; then
          echo " DDDOOOOOOONNNNEEEEE ! "
      else
        continue
      fi
      echo "FIIIIINNIIIIII !!!!"
    done < clusterqueue.log
    break
  done < job_launched.log
}
#retourne_job_user idemec
#retourne_job_team_in_month mar
#retourne_donnees_voulus micro sep


------------
CONVERTIR TOTAL SECONDE EN HEURE/MINUTES/SECONDES
my $totalsecondes = 1324324;

my $secondes = $totalsecondes % 60;
my $minutes = ($totalsecondes / 60) % 60;
my $heures = ($totalsecondes / (60 * 60))
