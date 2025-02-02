import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class PathHelper {
  static late final Directory appDir;

  static Future<void> init() async {
    appDir = await syspaths.getApplicationDocumentsDirectory();
  }

  static Future<File> copyImage(File image) async {
    final fileName = path.basename(image.path);
    return await image.copy('${appDir.path}/$fileName');
  }
}
