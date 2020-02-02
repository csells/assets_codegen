import 'dart:io';
import 'assets_code_generator.dart';

void main(List<String> args) async {
  if (args.length != 1 || !(await Directory(args[0]).exists())) {
    stderr.writeln('usage: dart bin/main.dart <assets-folder>');
    exit(1);
  }

  print(await AssetsCodeGenerator.generateFromDirectory(Directory(args[0])));
}
