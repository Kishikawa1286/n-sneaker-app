import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_widgets/page_header.dart';
import '../../../../utils/environment_variables.dart';

void showBackgroundImageSelectorModalBottomSheet(
  BuildContext context, {
  required void Function(int) onTapTile,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (context) =>
        BackgroundImageSelectorModalBottomSheet(onTapTile: onTapTile),
  );
}

class BackgroundImageSelectorModalBottomSheet extends HookConsumerWidget {
  const BackgroundImageSelectorModalBottomSheet({required this.onTapTile});

  final void Function(int) onTapTile;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          const PageHeader(title: '背景画像を選択', height: 35),
          Flexible(
            child: GridView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              children: collectionPageBackgroundImagePaths
                  .asMap()
                  .map(
                    (index, path) => MapEntry(
                      index,
                      GestureDetector(
                        onTap: () {
                          onTapTile(index);
                          Navigator.of(context).pop();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Container(
                            constraints: const BoxConstraints.expand(),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(path),
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.repeatY,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ],
      );
}
