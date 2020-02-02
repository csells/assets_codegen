import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;

class AssetsCodeGenerator {
  static final _startsWithNumbersRE = RegExp(r'^[0-9]+');
  static final _binaryFileTypesRE = RegExp(r'\.(jpe?g|png|gif|ico|svg|ttf|eot|woff|woff2)$', caseSensitive: false);

  static Future<String> generateFromDirectory(Directory assetsDir) async {
    var sb = StringBuffer();
    sb.writeln("import 'dart:convert';");
    sb.writeln();
    sb.writeln('class Assets {');
    for (var file in await assetsDir
        .list(recursive: true)
        .where((e) => e is File && !path.basename(e.path).startsWith('.'))
        .toList()) {
      var s = await generateFromFile(file);
      sb.write(s);
    }
    sb.writeln('}');
    return sb.toString();
  }

  static Future<String> generateFromFile(File file) async {
    var isText = _isText(file);
    var sb = StringBuffer();
    sb.write('  static final ${_safeName(path.basenameWithoutExtension(file.path))} = ');
    if (isText) sb.write('utf8.decode(');
    sb.writeln('base64.decode([');
    _base64encode(await file.readAsBytes()).forEach((l) => sb.writeln("    '$l',"));
    sb.write('  ].join())');
    if (isText) sb.write(')');
    sb.writeln(';');
    return sb.toString();
  }

  static String _safeName(String name) =>
      (_startsWithNumbersRE.hasMatch(name) ? 'the$name' : name).replaceAll('-', '_');
  static bool _isText(File file) => !_binaryFileTypesRE.hasMatch(file.path);

  static Iterable<String> _base64encode(List<int> bytes) sync* {
    var encoded = base64.encode(bytes);

    // cut lines into 76-character chunks – makes for prettier source code
    var index = 0;
    while (index < encoded.length) {
      var line = encoded.substring(index, math.min(index + 76, encoded.length));
      yield line;
      index += line.length;
    }
  }
}
