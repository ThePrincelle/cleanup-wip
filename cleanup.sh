#!/bin/bash
# cleanup.sh
# ----------------

# Working directory
DIR="./test_dir"

# Stuff to remove
remove_arr=()

# Match resolution (ie. '2400x1234', '234x241')
regex_resolution="([\d ]{2,5}[x][\d ]{2,5})"

# Match "-scaled" on the end of filename
regex_scaled="-scaled$"

for f in $(find ${DIR} -type f -name '*.jpg' -printf '%P\n'); do
    filename=$(basename -- "$f")
    extension="${filename#*.}"
    filename_only="${filename%%.*}"

    (echo "$filename_only" | grep -P "$regex_resolution") && remove_arr+=( "${f}" )
    (echo "$filename_only" | grep -P "$regex_scaled") && remove_arr+=( "${f}" )
done

if [ -z "$remove_arr" ]; then
    echo -e "\nNo files to remove... Bye..."
else
    echo -e "\nFiles to delete:"
    for file in "${remove_arr[@]}"
    do 
        echo $file
    done

    echo
    read -p "Are you sure you want to continue? (y/n) " yn
    case $yn in
        [Yy]* )
            echo "Ok... Removing files..."
            ;;
        * ) echo "Bye..." && exit
            ;;
    esac

    for file in "${remove_arr[@]}"
    do 
        rm $DIR/$file
    done

    echo "Done."
fi