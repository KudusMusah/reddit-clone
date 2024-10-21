import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.image,
    compressionQuality: 15,
  );
  return image;
}
