# PPReader
PPReader [Native Extension](https://www.defold.com/manuals/extensions/) for the [Defold Game Engine](https://www.defold.com)

This library helps to read Unity PlayerPrefs file as a Lua table.

## Possible use cases:

* If you want to update your Unity game with Defold version of the game and the user's progress are stored in PlayerPrefs.

## Platforms

* **iOS**
* **macOS**
* **Android**

## Setup

You can use the PPReader extension in your own project by adding this project as a [Defold library dependency](https://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

> https://github.com/AGulev/ppreader/archive/master.zip

Or point to the ZIP file of a [specific release](https://github.com/AGulev/ppreader/releases).

### Android

Your `Package` name must be the same as your package name in Unity version of the game. Game `apk` must be signed with the same `Certificate` and `Private key` as Unity version of the `apk`.
[Forum post](https://forum.defold.com/t/how-to-convert-unity-keystore-to-pk8-format/13235) how to convert your Unity `Certificate` and `Private key` for using with Defold.

### iOS

Your `Bundle Identifier` must be the same as your bundle identifier in Unity version of the game. For the signing process, you must use the same `Code Signing Identity` and `Provisioning profile` as for Unity version of the game.

### macOS

Your `Bundle Identifier` must be the same as your bundle identifier in Unity version of the game. For the signing process, you must use the same `Code Signing Identity` and `Provisioning profile` as for Unity version of the game.

Add next lines to your `game.project` file:

```lua
[ppreader]
company_name = YourCompanyName
product_name = YourProductName
```
Where `YourCompanyName` is the name of the company from your Unity project (`Project Settings`->`Player`->`Company Name`) and `YourProductName` is the name of the product from your Unity project (`Project Settings`->`Player`->`Product Name`).

## API

#### `ppreader.get()`

Returns table with PlayerPrefs values and path to the file:

```lua
local player_prefs, path_to_the_pp_file = ppreader.get()
pprint(player_prefs) -- Example:
--{
-- UnityGraphicsQuality = 3,
-- field = "string",
-- unity.player_sessionid = "your_session_id",
-- scores = 100,
-- unity.cloud_userid = "your_cloud_user_id",
-- New item = "",
-- some_FloatField = 2.3303999900818,
-- unity.player_session_count = "6",
-- SomeIntField = 100,
-- some_string_field = "some_sctring_for example-just-test@"
}]--
print(path_to_the_pp_file) -- Example: /Users/your_user_name/Library/Preferences/unity.TestCompany.TestProduct.plist
```

## Special thanks

Library uses [XML2LUA](https://github.com/manoelcampos/xml2lua).

## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/AGulev/uptime/issues), make a pull request or contact me: me@agulev.com
