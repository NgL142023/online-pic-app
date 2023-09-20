import 'package:image_picker/image_picker.dart';

Future<dynamic> pickImage(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: source);
  if (image != null) {
    return image.readAsBytes();
  } else {
    return null;
  }
}
