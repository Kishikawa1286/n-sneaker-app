/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../../../../utils/show_flushbar.dart';
import '../view_model.dart';

class AccountPageSignInRewardSection extends HookConsumerWidget {
  const AccountPageSignInRewardSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(accountPageViewModelProvider);
    final signInReward = viewModel.signInReward;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'ポイントとフィギュアを交換する',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
        ),
        signInReward != null
            ? CachedNetworkImage(
                height: 200,
                width: 140,
                imageUrl: signInReward.product.tileImageUrls.first,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (_, __) => Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: CommonStyle.grey,
                  ),
                ),
              )
            : const SizedBox(height: 200),
        signInReward != null
            ? Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  signInReward.product.titleJp,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                ),
              )
            : const SizedBox(height: 200),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  '現在所有しているポイント',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 2,
                  left: 10,
                ),
                child: Text(
                  viewModel.point.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  '交換するポイント',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 2,
                  left: 10,
                ),
                child: Text(
                  signInReward != null
                      ? signInReward.consumedPoint.toString()
                      : '',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final message = await viewModel.getSignInReward();
            if (message.isNotEmpty) {
              await showFlushbar(context, message: message);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.7,
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
            '交換する',
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: CommonStyle.white,
            ),
          ),
        ),
      ],
    );
  }
}
*/
