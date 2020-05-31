build() {
  path=$@
  buildCommand="
  xcodebuild archive \
  -quiet \
  -scheme Dependencies \
  -configuration Release \
  -archivePath 'DerivedData/archive.xcarchive' \
  -derivedDataPath DerivedData
  "
  exportCommand="
  xcodebuild build \
  -quiet \
  -configuration Release \
  -exportArchive \
  -archivePath 'DerivedData/archive.xcarchive' \
  -exportPath 'DerivedData/thinned-ipa' \
  -exportOptionsPlist ../exportOptions.plist
  "
  if [ $(ls "$path" | grep .xcworkspace) ]; then
    buildCommand="${buildCommand} -workspace *.xcworkspace"
  fi
  cd "$path"
  echo "building project..."
  eval $buildCommand
  echo "exporting project..."
  eval $exportCommand
  cd ..
}

measureArtifactSize() {
  path=$@
  command='du -sh Carthage/DerivedData/thinned-ipa/*.ipa'
  size=$(eval $command | awk '{ print $1 }')
  echo "Total Size of ipa: $size"
}

unzipIpa() {
  path=$@
  echo "Unzipping .ipa file..."
  unzip -o -q "${path}DerivedData/thinned-ipa/*.ipa" -d "${path}DerivedData/thinned-ipa"
}

measureExecutableSize() {
  path=$@
  command='du -sh "${path}DerivedData/thinned-ipa/Payload/Dependencies.app/Dependencies"'
  size=$(eval $command | awk '{ print $1 }')
  echo "Executable Size: $size"
}

measureFrameworksFolder() {
  path=$@
  command='du -sh "${path}DerivedData/thinned-ipa/Payload/Dependencies.app/Frameworks"'
  size=$(eval $command 2> /dev/null | awk '{ print $1 }')
  if [ -z $size ]; then
    size="No Frameworks"
  fi
  echo "Frameworks Folder Size: $size"
}

for directory in */; do
  echo "--- $directory ---";
  build $directory
  measureArtifactSize $directory
  unzipIpa $directory
  measureExecutableSize $directory
  measureFrameworksFolder $directory
  echo ""
done
