import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/empty_gallery_view.dart';
import '../widgets/image_list_view.dart';
import '../widgets/pick_image_button.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _imagePaths.addAll(images.map((image) => image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapGallery'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _imagePaths.isEmpty
                ? const EmptyGalleryView()
                : ImageListView(
              imagePaths: _imagePaths,
              onDelete: _removeImage,
            ),
          ),
          PickImageButton(onPressed: _pickImages),
        ],
      ),
    );
  }
}