# PhoneGap CameraRoll plugin

1. [Description](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#1-description)
2. [Installation](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#2-installation)
	2. [Automatically (CLI / Plugman)](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#automatically-cli--plugman)
	2. [Manually](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#manually)
	2. [PhoneGap Build](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#phonegap-build)
3. [Usage](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#3-usage)
4. [License](https://github.com/EddyVerbruggen/CameraRoll-PhoneGap-Plugin#5-license)

## 1. Description

This plugin allows you to use photos from the cameraroll (photo album) of the mobile device.

* You can count the total number of photos and/or videos.
* You can find photos only (videos would likely crash your app).
* You can limit the number of returned photos by passing a `max` parameter.
* All methods work without showing the cameraroll to the user. Your app never looses control.

### iOS specifics
* Supported methods: `find`, `count`.

### Android specifics
* Work in progress.. support will be added soon

##Installation

```
$ phonegap local plugin add org.mantis.cameraroll
```


##Usage

Counting the number of photos in the photo library:

```javascript
  // prep some variables
  var includePhotos = true;
  var includeVideos = false;
  window.plugins.cameraRoll.count(includePhotos, includeVideos, showImageCount, cameraRollError);

  function showImageCount(count) {
    alert("Found " + count + " photos");
  }
```

Find and show max 10 photos from the photo library:

```javascript
  var maxPhotos = 10;
  window.plugins.cameraRoll.find(maxPhotos, cameraRollFindResult, cameraRollError);

  function cameraRollFindResult(photos) {
    var content = '';
    for (var i in photos) {
      content += '<br/><img src="data:image/png;base64,'+photos[i]+'" style="max-width:240px"/>';
    }
    document.getElementById("imgContainer").innerHTML = content;
}
```


##License

[The MIT License (MIT)](http://www.opensource.org/licenses/mit-license.html)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
