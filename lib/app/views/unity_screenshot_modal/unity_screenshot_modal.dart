import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import 'view_model.dart';

void showUnityScreenshotModal(BuildContext context) => showDialog<void>(
      context: context,
      builder: (context) => const AlertDialog(content: UnityScreenshotModal()),
    );

class UnityScreenshotModal extends HookConsumerWidget {
  const UnityScreenshotModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(unityScreenshotModalViewModelProvider);
    final image = viewModel.image;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 360,
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: image != null
              ? Image(
                  image: image,
                  fit: BoxFit.contain,
                )
              : Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: viewModel.postToGallery,
                  onChanged: viewModel.setPostToGallery,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: viewModel.togglePostToGallery,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 3),
                  child: Text(
                    'ギャラリーに投稿する',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
            onPressed: viewModel.postToGallery
                ? () {}
                : () async {
                    final success = await viewModel.saveImage();
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.9,
                40,
              ),
              elevation: 5,
              primary: CommonStyle.black,
              onPrimary: CommonStyle.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              viewModel.postToGallery ? '保存してギャラリーに投稿' : '保存',
              maxLines: 2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: CommonStyle.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
