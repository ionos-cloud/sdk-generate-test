#!/usr/bin/env bash
# Can be either a folder, or a path(folder1/folder2)
# We want to get only the last folder in the path
sdkFolderPath=$1
if  [[ "$sdkFolderPath" =~ "/"  ]]; then
    pathArray=(${sdkFolderPath//// })
    len=${#pathArray[@]}-1
    echo "{packageName}=${pathArray[len]}" >> $GITHUB_OUTPUT
fi

