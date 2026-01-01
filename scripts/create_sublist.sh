#!/bin/bash

html_path=$1
list_path=$2

array=$(grep "http" "$html_path" | grep "id" | cut -f2 -d'?' | cut -f1 -d'"' | sed -e "s/id=//")

echo "${array}" >> "$list_path"

sort -u "$list_path" -o "$list_path.tmp"
mv "$list_path.tmp" "$list_path"

size=$(wc -l "${list_path}")
echo "Sublist ${html_path} created."
echo "Mods: ${size}"
echo ""
