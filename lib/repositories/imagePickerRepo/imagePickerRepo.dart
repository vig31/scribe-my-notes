import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:notebook/services/imagePickerService/ImagePickerService.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/customLogger.dart';

class ImagePickerRepo {
  final ImagePickerService _imagePickerService =
      ImagePickerService(picker: ImagePicker());

  Future<String> getImage() async {
    try {
      // Step 1: Pick an image from the gallery using ImagePicker
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        // Handle the case where the user didn't pick an image
        return "";
      }

      // Step 2: Get the application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      // Step 3: Extract the original file name and extension from the picked image
      String originalFileName = image.name;

      // Step 4: Create a full path for the saved image with the original file name and extension
      final String filePath = '${appDocDir.path}/$originalFileName';

      // Step 5: Move the picked image to the app's documents directory
      final File newImage = await File(image.path).copy(filePath);

      // Step 6: Delete the picked image from the app's temp to free up memory
      await File(image.path).delete();

      // Step 7: Return the saved image's file path as a string
      return newImage.path;
    } catch (ex, stack) {
      CustomLogger().logFatelException(error: ex, stack: stack);
      return "";
    }
  }
}
