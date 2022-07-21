#/!/bin/bash

now=`date +"%Y%m%d-%H%M"`
appName="History of Me"
appNameClean="HistoryOfMe"
arm64="arm64-v8a"
arm32="armeabi-v7a"
x86="x86_64"
platform="Android"
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`

echo "${blue}Creating '${appName}' builds for ${now}.\n${reset}"
echo "Building APK files ..."
flutter build apk --split-per-abi
echo "${green}Finished building APK files.${reset}"
echo "Building AppBundle file ...\n"
flutter build appbundle
echo "${green}Finished building AppBundle file.\n"
echo "${green}✓ Finished creating '${appName}' builds.\n${reset}"
echo "Exporting files ...\n"
mkdir -p -v ./dist/"${now}"
mkdir -p -v ./dist/"${now}"/apk
mkdir -p -v ./dist/"${now}"/appbundle
cat <<EOF >./dist/"${now}"/release_notes_play.txt
<en-US>
- Bug fixes and stability improvements
</en-US>
<de-DE>
- Fehlerbehebungen und Stabilitätsverbesserungen
</de-DE>
EOF
cat <<EOF >./dist/"${now}"/release_notes_github.txt
## What's new?

- Bug fixes and stability improvements
EOF
rsync -rvh --progress ./build/app/outputs/apk/ ./dist/"${now}"/apk
rsync -rvh --progress ./build/app/outputs/bundle/ ./dist/"${now}"/appbundle
echo "\n"
echo "Renaming builds ...\n"

# Rename and relocate arm64 build
mv ./dist/"${now}"/apk/release/app-arm64-v8a-release.apk ./dist/"${now}"/apk/"${appNameClean}-${now}-${platform}-${arm64}.apk"

# Rename and relocate arm32 build
mv ./dist/"${now}"/apk/release/app-armeabi-v7a-release.apk ./dist/"${now}"/apk/"${appNameClean}-${now}-${platform}-${arm32}.apk"

# Rename and relocate x86 build
mv ./dist/"${now}"/apk/release/app-x86_64-release.apk ./dist/"${now}"/apk/"${appNameClean}-${now}-${platform}-${x86}.apk"

# Rename and relocate app bundle
mv ./dist/"${now}"/appbundle/release/app-release.aab ./dist/"${now}"/appbundle/"${appNameClean}-${now}-${platform}.aab"

# Delete debug builds if existing
rm -rf ./dist/"${now}"/apk/debug
# Delete empty folders
rm -rf ./dist/"${now}"/apk/release
rm -rf ./dist/"${now}"/appbundle/release

echo "${green}✓ Finished building and exporting '${appName}' releases.\n${reset}"
echo "${yellow}Please edit the release notes before uploading your production builds.\n${reset}"
