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
