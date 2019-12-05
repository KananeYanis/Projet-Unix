#!/bin/bash
retourne_nom_user(){
  while read ligne ; do
    file_name=$(cut -d ":" -f1 )
    echo "$file_name"
  done < $1
}

retourne_id_job_launched(){
  while read ligne ; do
    id_job=$(cut -d " " -f4)
    echo "$id_job"
  done < $1
}

retourne_id_job_cluster(){
  while read ligne ; do
    id_job=$(cut -d " " -f11)
    echo "$id_job"
  done < $1
}

retourne_equipe_user(){
  if [[ $1 == "tom" || $1 == "jean" || $1 == "arthur" ]]; then
    nom_equipe="idemec"
    echo $nom_equipe
  elif [[ $1 == "paul" || $1 == "jules" || $1 == "yves" || $1 == "antoine" || $1 == "nathalie" ]]; then
    nom_equipe="star"
    echo $nom_equipe
  elif [[ $1 == "sonia" || $1 == "jules2" || $1 == "leila" ]]; then
    nom_equipe="flux"
    echo $nom_equipe
  elif [[ $1 == "bruno" ]]; then
    nom_equipe="micro"
    echo $nom_equipe
  else
    nom_equipe="NON AFFILIE"
    echo $nom_equipe
  fi
}

retourne_mois(){
  while read ligne ; do
      mois=$(cut -d " " -f2)
      echo "$mois"
  done < $1
}

retourne_info(){
  whil
}
  #retourne_nom_user job_launched.log
  #retourne_id_job_launched job_launched.log
  #retourne_id_job_cluster clusterqueue.log
  #retourne_mois clusterqueue.log
  #export -f retourne_equipe_user
  #retourne_nom_user bdd.txt
  #retourne_nom_user job_launched.log  | xargs -n 1  bash -c 'retourne_equipe_user "$@"' _
  retourne_info sep
