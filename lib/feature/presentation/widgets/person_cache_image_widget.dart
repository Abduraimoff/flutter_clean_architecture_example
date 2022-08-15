import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonCacheImage extends StatelessWidget {
  final String imageUrl;
  final double width, height;
  const PersonCacheImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) {
          return _imageWidget(imageProvider);
        },
        placeholder: (_, url) => const Center(
              child: CircularProgressIndicator(),
            ),
        errorWidget: (context, url, error) {
          return _imageWidget(const AssetImage('assets/images/noimage.jpg'));
        });
  }

  Widget _imageWidget(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }
}
