#/!/bin/bash
now=`date +"%Y-%m-%d"`
appName="History of Me"
echo "Creating '${appName}' builds for ${now}."
echo "Building APK files ..."
flutter build apk --split-per-abi
echo "Finished building APK files."
echo "Building AppBundle file."
flutter build appbundle
echo "Finished building AppBundle file.\n"
echo "✓ Finished creating '${appName}' builds.\n"
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
# Delete debug builds if existing
rm -rf ./dist/"${now}"/apk/debug
echo "\n"
echo "✓ Finished building and exporting '${appName}' builds.\n"
echo "Please edit the release notes before uploading your production builds.\n"
