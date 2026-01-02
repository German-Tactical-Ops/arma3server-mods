#!/bin/bash
set -e

HTML_DIR="/etc/arma3/html"

SCRIPTS="/etc/arma3/scripts"
MOD_LIST="/etc/arma3/scripts/sub_list.txt"
MOD_DIRECTORY="/home/arma3server/Steam/steamapps/workshop/content/107410"

# import steam user and password
export STEAMUSER="$(cat /run/secrets/steam_user)"
export STEAMPASS="$(cat /run/secrets/steam_password)"

find ${HTML_DIR} -iname "*.html" -exec ${SCRIPTS}/create_sublist.sh {} "${MOD_LIST}" \;

# download mods
bash ${SCRIPTS}/download_mods.sh "/home/steam/steamcmd/steamcmd.sh" "${MOD_LIST}" "${STEAMUSER}" "${STEAMPASS}"
sleep 10
bash ${SCRIPTS}/download_mods.sh "/home/steam/steamcmd/steamcmd.sh" "${MOD_LIST}" "${STEAMUSER}" "${STEAMPASS}"
sleep 10
bash ${SCRIPTS}/download_mods.sh "/home/steam/steamcmd/steamcmd.sh" "${MOD_LIST}" "${STEAMUSER}" "${STEAMPASS}"
bash ${SCRIPTS}/fix_mods_lowercase.sh ${MOD_DIRECTORY}
