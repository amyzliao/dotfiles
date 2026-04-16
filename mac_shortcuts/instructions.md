to apply these settings:
```
defaults import com.apple.symbolichotkeys /path/to/symbolichotkeys.plist
```
note:
- this disables spotlight shortcut. i have replaced spotlight with raycast.
- this will override the entire existing `com.apple.symbolichotkeys` config 
- this will probably work well across minor versions, but not recommended across major versions. just manually apply in that case.

this file was created using:
MAC_VERSION: 26.4