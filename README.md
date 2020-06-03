# Swift Dependency Analysis

A repository containing the same project implemented using different package managers.
There's an article on the [blog][] about it.

## Measurements

All measurements were made using a 2017 15" MacBook Pro using Xcode 11.5 and iOS 13.5.

### App Launch Times

|               | No dependencies | CocoaPods | Carthage | Swift Package Manager |
| ------------- | --------------- | --------- | -------- | --------------------- |
| iPhone 11 Pro | 1.009s          | 1.021s    | 1.105s   | 1.032s                |
| Simulator     | 1.056s          | 1.105s    | 1.118s   | 1.080s                |

### App Size

|                        | No dependencies | CocoaPods | Carthage | Swift Package Manager |
| ---------------------- | --------------- | --------- | -------- | --------------------- |
| Total Size             | 140 KB          | 14 MB     | 84 MB    | 12 MB                 |
| Executable Size        | 104 KB          | 104 KB    | 104 KB   | 12 MB                 |
| Frameworks Folder Size | No Frameworks   | 14 MB     | 84 MB    | No Frameworks         |

### App Size (Thinning)

|                        | No dependencies | CocoaPods | Carthage | Swift Package Manager |
| ---------------------- | --------------- | --------- | -------- | --------------------- |
| Total Size             | 88 KB           | 2.2 MB    | 2.2 MB   | 2.2 MB                |
| Executable Size        | 88 KB           | 88 KB     | 88 KB    | 5.0 MB                |
| Frameworks Folder Size | No Frameworks   | 6.4 MB    | 6.0 MB   | No Frameworks         |

### Build Times

|                       | No dependencies | CocoaPods | Carthage | Swift Package Manager |
| --------------------- | --------------- | --------- | -------- | --------------------- |
| Dependency Resolution | -               | 1m 38s    | 13m 25s  | 2m 23s                |
| Clean Build           | 3s              | 1m 10s    | 5s       | 1m 20s                |
| Incremental Build     | 2s              | 3s        | 2s       | 3s                    |
| DR + Build            | 3s              | 2m 32s    | 12m 39s  | 2m 31s                |

[blog]: https://xavierlowmiller.github.io
