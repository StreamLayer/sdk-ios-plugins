# Plugins repository for StreamLayer SDK

## Watch party plugin

### Configuration

Add StreamLayerSDKWatchParty framework into your project during adding SPM package phase or in your project target Frameworks, Libraries, and Embeded Content section

Add this package into your project and import it:

```swift
import StreamLayerSDKPluginsWatchParty
```

Pass plugin bridge object to the sdk:

```swift
  func configureSLWatchPartyPlugin() {
    let plugin: SLRWatchParyServiceProtocol = SLRWatchPartyPlugin()
    StreamLayer.registerWatchPartyPlugin(plugin)
  }
```

## Google PAL plugin

### Configuration

Add StreamLayerSDKGooglePAL framework into your project during adding SPM package phase or in your project target Frameworks, Libraries, and Embeded Content section

Add this package into your project and import it:

```swift
import StreamLayerSDKPluginsGooglePAL
```

Pass plugin bridge object to the sdk:

```swift
  func configureSLGooglePALPlugin() {
    let plugin: SLRGooglePALServiceProtocol = SLRGooglePALPlugin()
    StreamLayer.registerPALPlugin(plugin)
  }
```