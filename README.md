This program will generate base64-encoded data to provide a primitive way to embed resources into pure Dart code. This is to work around the fact that Dart doesn't have asset support like Flutter does.

# Usage
```sh
usage: dart bin/main.dart <assets-folder>
```

Given a set of files like this:

```
assets/
  123.txt
  png-transparent.png
```

the following command:

```sh
myproj$ dart ~/asset_codegen/bin/main.dart assets > /lib/assets.dart
```

will yield Dart code like the following:

```dart
import 'dart:convert';

class Assets {
  static final pngTransparentPng = base64.decode([
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAA',
    'AABJRU5ErkJggg==',
  ].join());

  static final the123Txt = utf8.decode(base64.decode([
    'b25lCnR3bwp0aHJlZQ==',
  ].join()));

  ...
}
```
which you can use like so:

```dart
import 'assets.dart';
import 'package:image/image.dart';

void main() {
  print(Assets.the123Txt);
  print(Image.fromBytes(1, 1, Assets.pngTransparentPng));
}
```

to output the following:

```
one
two
three
Instance of 'Image'
```

In addition, the generated Assets class contains a loadString and a loadBytes function for dynamic asset lookup:

```dart
class Assets {
  ...

  static String loadString(String name) {
    switch (name) {
      case '123.txt':
        return the123_txt;
      default:
        throw Exception('unknown text asset: $name');
    }
  }

  static List<int> loadBytes(String name) {
    switch (name) {
      case 'png-transparent.png':
        return png_transparent_png;
      default:
        throw Exception('unknown binary asset: $name');
    }
  }
}

```
which allows you to write code using strings provided at runtime like so:

```dart
void main() {
  print(Assets.loadString('123.txt'));
  print(Image.fromBytes(1, 1, Assets.loadBytes('png-transparent.png')));
}
```

Enjoy!