import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker picker;

  ImagePickerService({required this.picker});

  Future<XFile?> pickImageFromGallery() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
