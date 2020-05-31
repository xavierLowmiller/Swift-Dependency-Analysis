build() {
  path=$@
  buildCommand="
  xcodebuild build \
  -quiet \
  -scheme Dependencies \
  -configuration Release \
  -derivedDataPath DerivedData
  "
  if [ $(ls "$path" | grep .xcworkspace) ]; then
    buildCommand="${buildCommand} -workspace *.xcworkspace"
  fi
  cd "$path"
  echo "building project..."
  eval $buildCommand
  cd ..
}

measureArtifactSize() {
  path=$@
  command='du -sh "${path}"DerivedData/Build/Products/Release-iphoneos/Dependencies.app'
  size=$(eval $command | awk '{ print $1 }')
  echo "Total Size: $size"
}

measureExecutableSize() {
  path=$@
  command='du -sh "${path}DerivedData/Build/Products/Release-iphoneos/Dependencies.app/Dependencies"'
  size=$(eval $command | awk '{ print $1 }')
  echo "Executable Size: $size"
}

measureFrameworksFolder() {
  path=$@
  command='du -sh "${path}DerivedData/Build/Products/Release-iphoneos/Dependencies.app/Frameworks"'
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
  measureExecutableSize $directory
  measureFrameworksFolder $directory
  echo ""
done
