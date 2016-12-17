#!/bin/bash
[[ -d $HOME/bin ]] || mkdir $HOME/bin

for FILE in *; do
    [[ "$FILE" == "install.sh" ]] || cp $FILE $HOME/bin/$FILE
done
