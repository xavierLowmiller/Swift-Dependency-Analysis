resolveDependencies() {
  path=$@
  case "$path" in
    "Carthage/")
      echo "Resolving Carthage"
      cd "$path"
      rm -rf DerivedData
      rm -rf Carthage
      time carthage bootstrap --platform iOS
      cd ..
      ;;
    "Cocoapods/")
      echo "Resolving Cocoapods"
      cd "$path"
      rm -rf DerivedData
      pod deintegrate
      pod cache clean --all
      time pod install
      cd ..
      ;;
    "No Dependencies/")
      echo "No Dependencies: 0 seconds"
      ;;
    "Swift Package Manager/")
      echo "Resolving Swift packages"
      cd "$path"
      rm -rf DerivedData
      time xcodebuild \
        -resolvePackageDependencies \
        -derivedDataPath DerivedData \
        -scheme Dependencies
      cd ..
      ;;
    "Git Submodules/")
      echo "Resolving Git Submodules"
      cd "$path"
      rm -rf DerivedData Submodules
      time git submodule update --init
      cd ..
      ;;
    *)
      echo "Unexpected folder $path"
      exit 1
      ;;
  esac
}

cleanBuild() {
  path=$@
  buildCommand="
  xcodebuild clean build \
  -quiet \
  -scheme Dependencies \
  -configuration Release \
  -derivedDataPath DerivedData
  "
  if [ $(ls "$path" | grep .xcworkspace) ]; then
    buildCommand="${buildCommand} -workspace *.xcworkspace"
  fi
  buildCommand="time ${buildCommand}"
  cd "$path"
  echo "building project..."
  eval $buildCommand
  cd ..
}

incrementalBuild() {
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
  buildCommand="time ${buildCommand}"
  cd "$path"
  echo "building project..."
  eval $buildCommand
  cd ..
}

ciBuild() {
  path=$@
  resolveDependencies $path
  cleanBuild $path
}

for directory in */; do
  echo "--- $directory ---";
  resolveDependencies $directory
  cleanBuild $directory
  incrementalBuild $directory
  ciBuild $directory
  echo ""
done
