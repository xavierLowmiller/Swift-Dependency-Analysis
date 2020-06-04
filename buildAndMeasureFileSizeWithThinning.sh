build() {
  local path=$@
  local buildCommand="
  xcodebuild archive \
  -quiet \
  -scheme Dependencies \
  -configuration Release \
  -archivePath 'DerivedData/archive.xcarchive' \
  -derivedDataPath DerivedData
  "
  local exportCommand="
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
  local path=$@
  local command='du -sh "${path}"DerivedData/thinned-ipa/*.ipa'
  local ipaSize=$(eval $command | awk '{ print $1 }')
  echo "Total Size of ipa: $ipaSize"
}

unzipIpa() {
  local path=$@
  echo "Unzipping .ipa file..."
  unzip -o -q "${path}DerivedData/thinned-ipa/*.ipa" -d "${path}DerivedData/thinned-ipa"
}

measureUnzippedSize() {
  local path=$@
  local command='du -sh "${path}DerivedData/thinned-ipa/Payload/"'
  local unzippedSize=$(eval $command | awk '{ print $1 }')
  echo "Size (unzipped): $unzippedSize"
}

measureExecutableSize() {
  local path=$@
  local command='du -sh "${path}DerivedData/thinned-ipa/Payload/Dependencies.app/Dependencies"'
  local executableSize=$(eval $command | awk '{ print $1 }')
  echo "Executable Size: $executableSize"
}

measureFrameworksFolder() {
  local path=$@
  local command='du -sh "${path}DerivedData/thinned-ipa/Payload/Dependencies.app/Frameworks"'
  local frameworksSize=$(eval $command 2> /dev/null | awk '{ print $1 }')
  if [ -z $size ]; then
    frameworksSize="No Frameworks"
  fi
  echo "Frameworks Folder Size: $frameworksSize"
}

for directory in */; do
  echo "--- $directory ---";
  # build $directory
  measureArtifactSize $directory
  unzipIpa $directory
  measureUnzippedSize $directory
  measureExecutableSize $directory
  measureFrameworksFolder $directory
  echo ""
done
