# Plugins repository for StreamLayer SDK

## Watch party plugin

### Configuration

Add StreamLayerSDKWatchParty framework into your project during adding SPM package phase or in your project target Frameworks, Libraries, and Embeded Content section

Add this package into your project and import it:

```swift
import StreamLayerSDKPlugins
```

Pass plugin bridge object to the sdk:

```swift
  func configureWatchPartyPlugin() {
    let plugin: SLRWatchParyServiceProtocol = SLRWatchPartyPlugin()
    StreamLayer.registerWatchPartyPlugin(plugin)
  }
```