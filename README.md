# Firebase Dynamic Links - Titanium Module

Use the native Firebase SDK in Axway Titanium. This repository is part of the [Titanium Firebase](https://github.com/hansemannn/titanium-firebase) project.

## Supporting this effort

The whole Firebase support in Titanium is developed and maintained by the community (`@hansemannn` and `@m1ga`). To keep
this project maintained and be able to use the latest Firebase SDK's, please see the "Sponsor" button of this repository,
thank you!

## Requirements

- [x] The [Firebase Core](https://github.com/hansemannn/titanium-firebase-core) module
- [x] Titanium SDK 9.2.0+

## Example

```js
import TiFirebaseDynamicLinks from 'ti.firebasedynamiclinks';

// Place this in the earliest possible place, e.g. the alloy.js (Alloy) or app.js (classic Ti)
TiFirebaseDynamicLinks.addEventListener('deeplink', event => {
  console.warn(`URL: ${event.url}, Match type: ${event.matchType}`);
});

```

## Build

```js
cd [ios|android]
appc run -p [ios|android] --build-only
```

## Legal

This module is Copyright (c) 2021-present by Hans Knöchel. All Rights Reserved. 
