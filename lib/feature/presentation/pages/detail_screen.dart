import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/common/app_colors.dart';
import 'package:flutter_clean_architecture/feature/presentation/widgets/person_cache_image_widget.dart';

import '../../domain/entities/person_entity.dart';

class DetailPage extends StatelessWidget {
  final PersonEntity person;

  const DetailPage({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Hero(
              
              tag: person.id,
              child: PersonCacheImage(
                imageUrl: person.image,
                width: 260,
                height: 260,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: person.status == 'Alive' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  person.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (person.type.isNotEmpty)
              ...buildText('Type', person.type.toString()),
            ...buildText('Gender', person.gender),
            ...buildText(
                'Number of episodes:', person.episode.length.toString()),
            ...buildText('Species', person.species),
            ...buildText('Last known location:', person.location.name),
            ...buildText('Origin:', person.origin.name),
            ...buildText('Was created:', person.created.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> buildText(String text, String value) {
    return [
      Text(text, style: const TextStyle(color: AppColors.greyColor)),
      Text(value, style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 12),
    ];
  }
}
