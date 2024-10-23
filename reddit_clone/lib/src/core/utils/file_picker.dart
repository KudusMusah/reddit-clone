import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    compressionQuality: 0,
    type: FileType.image,
  );
  return image;
}
