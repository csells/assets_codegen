This program will generate base64-encoded data to provide a primitive way to embed resources into pure Dart code, which doesn't have asset support like Flutter.

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
  static final png_transparent = base64.decode([
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAA',
    'AABJRU5ErkJggg==',
  ].join());
  static final the123 = utf8.decode(base64.decode([
    'b25lCnR3bwp0aHJlZQ==',
  ].join()));
}
```
which you can use like so:

```dart
import 'package:image/image.dart';
import 'assets.dart';

void main() {
  print(Assets.the123);
  print(Image.fromBytes(1, 1, Assets.png_transparent));
}
```

to output the following:

```
one
two
three
Instance of 'Image'
```

In addition, the generated Assets class contains a loadString and a loadBytes function for dynamic asset lookup.

Enjoy.

# TODO
- put all of these into github as issues:
- turn this into an [aggregate builder](https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md)
- make this into a CLI via [pub global activate](https://dart.dev/tools/pub/cmd/pub-global#activating-a-package)
- handle nested asset folders
- make the naming use camelCase instead of underscores (perhaps via the recase package?)