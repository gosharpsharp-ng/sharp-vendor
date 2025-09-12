import 'package:sharpvendor/core/utils/exports.dart';

class Base64Image extends StatelessWidget {
  final String base64String;

  Base64Image({required this.base64String});

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(base64String);
    return Image.memory(
      imageBytes,
      fit: BoxFit.cover,
    );
  }
}

