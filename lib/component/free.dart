import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> compressAndGetFile(File file, String targetPath) async {
  print("djasjdnsakjdabsdjkas");
  XFile? result;
  try {
    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
      // rotate: 180,
    );
  } catch (e) {
    print("djasjdnsakjdabsdjkas-debug_print-compressAndGetFile-error>>${e}");
  }

  print(file.lengthSync());
  print(await result?.length());

  return (result == null) ? null : File(result.path);
}

String renameFile(String oldPath, String prefix) {
  // renameFile(fileToBeUplloaded.path, "_compressed");
  String fileName =
      //  fileToBeUplloaded.path
      oldPath.split('/').last;
  String newFileName =
      "${fileName.split('.').sublist(0, fileName.split('.').length - 1).join('.')}$prefix.${fileName.split('.').last}";
  String newFilePath =
      "${oldPath.split('/').sublist(0, oldPath.split('/').length - 1).join('/')}$newFileName";
  return newFilePath;
}
