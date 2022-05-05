import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../utils/common_style.dart';
import 'view_model.dart';

void showPointModal(
  BuildContext context, {
  required void Function() onPressed,
}) =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: PointModalContent(onPressed: onPressed),
      ),
    );

class PointModalContent extends HookConsumerWidget {
  const PointModalContent({required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(pointModalViewModelProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ログインボーナス',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '現在のポイント',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          viewModel.point.toString(),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
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
          child: const Text(
            'フィギュアと交換する',
            maxLines: 2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: CommonStyle.white,
            ),
          ),
        )
      ],
    );
  }
}
