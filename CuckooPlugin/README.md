# CuckooPlugin

[Cuckoo](https://github.com/Brightify/Cuckoo) mock generation for Swift packages that works on any machine. No installation required, simply add the package to your `Package.swift`'s dependencies:

```swift
      dependencies: [
        .package(url: "https://github.com/Brightify/Cuckoo", from: "1.9.1"),
        .package(url: "https://github.com/{organization}/CuckooPlugin", from: "1.0.0")
    ],
```


Once you’ve declared any new dependencies, simply ask SPM to resolve your dependencies and install them, and then re-generate the Xcode project:

```shell
$ swift package update
```

## Using it as a (pre-)build tool

Adding CuckooPlugin as a prebuild tool will execute it and generate your mock classes **before each build**.

### Add to Package.swift

After adding the dependency to your `Package.swift`, include the `CuckooPlugin` plugin in any targets for which you would like it to run.

```swift
  targets: [
          .testTarget(
            name: "YourTestTargetName",
            dependencies: ["YourTargetName", "Cuckoo"],
            plugins: [
                .plugin(name: "CuckooPlugin", package: "CuckooPlugin")
            ]
        )
      ]
```

### Add a Cuckoo config

Add a `cuckoo.json` file to your package.
Take a look at the json configuration below as an example.

```json
  {
    "targetName": "CardGame",
    "inputDir": "/Sources/CardGame",
    "inputFiles": [
        "/CardGame.swift",
        "/CardGameEngine.swift"
    ],
    "outputFile": "/Tests/CardGameTests/GeneratedMocks.swift"
}
```
