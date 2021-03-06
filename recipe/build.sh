#!/bin/bash -euo

chmod +x bin/*
mv bin/* $PREFIX/bin/
ls -la $PREFIX/bin

mv include/* $PREFIX/include
if [ -e ./lib/jspawnhelper ]; then
    chmod +x ./lib/jspawnhelper
fi

if [[ `uname` == "Linux" ]]
then
    mv lib/jli/*.so lib/

    # Include dejavu fonts to allow java to work even on minimal cloud
    # images where these fonts are missing (thanks to @chapmanb)
    mkdir -p lib/fonts
    mv ./fonts/ttf/* ./lib/fonts/
    rm -rf ./fonts
fi

mv lib/* $PREFIX/lib

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
