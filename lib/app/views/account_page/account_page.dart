import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/common_style.dart';
import '../../../utils/environment_variables.dart';
import '../../../utils/show_flushbar.dart';
import '../account_gallery_posts_page/account_gallery_posts_page.dart';
import 'components/expansion_tile.dart';
import 'components/list_tile.dart';
import 'view_model.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({required this.goToArPage});

  final void Function() goToArPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(accountPageViewModelProvider);
    return Material(
      color: CommonStyle.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(top: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const Image(
                  image: AssetImage('assets/launcher_icon/icon.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  viewModel.isTrialActive
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'トライアル期間中',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      '${viewModel.trialExpiresAt.month}月${viewModel.trialExpiresAt.day}日まで',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: ElevatedButton(
                                  onPressed: goToArPage,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.5,
                                      30,
                                    ),
                                    elevation: 5,
                                    primary: CommonStyle.black,
                                    onPrimary: CommonStyle.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    '試してみる',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: CommonStyle.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'バージョン',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${viewModel.version} (${viewModel.buildNumber})',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'アカウントID',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        SelectableText(
                          viewModel.accountId,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            showFlushbar(
                              context,
                              message: 'アカウントIDをコピーしました',
                            );
                            Clipboard.setData(
                              ClipboardData(text: viewModel.accountId),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 5,
                            ),
                            child: Icon(Icons.copy, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AccountPageExpansionTile(
              title: '利用規約等',
              child: Column(
                children: [
                  AccountPageListTile(
                    iconData: Icons.description,
                    title: '利用規約',
                    isLauncher: true,
                    onTap: () async {
                      if (await canLaunchUrlString(termsOfServiceUrl)) {
                        await launchUrlString(termsOfServiceUrl);
                      }
                    },
                  ),
                  AccountPageListTile(
                    iconData: Icons.description,
                    title: 'プライバシーポリシー',
                    isLauncher: true,
                    onTap: () async {
                      if (await canLaunchUrlString(privacyPolicyUrl)) {
                        await launchUrlString(privacyPolicyUrl);
                      }
                    },
                  ),
                  AccountPageListTile(
                    iconData: Icons.description,
                    title: '特定商取引法に基づく表記',
                    isLauncher: true,
                    onTap: () async {
                      if (await canLaunchUrlString(
                        notionBasedOnSpecifiedCommercialTransactionsActUrl,
                      )) {
                        await launchUrlString(
                          notionBasedOnSpecifiedCommercialTransactionsActUrl,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            AccountPageExpansionTile(
              title: '問い合わせ',
              child: Column(
                children: [
                  AccountPageListTile(
                    iconData: Icons.mail,
                    title: 'ヘルプ・問い合わせ',
                    isLauncher: true,
                    onTap: () async {
                      if (await canLaunchUrlString(contactUrl)) {
                        await launchUrlString(contactUrl);
                      }
                    },
                  ),
                  AccountPageListTile(
                    iconData: Icons.person_remove,
                    title: 'アカウント削除申請',
                    isLauncher: true,
                    onTap: () async {
                      if (await canLaunchUrlString(accountDeletionRequestUrl)) {
                        await launchUrlString(accountDeletionRequestUrl);
                      }
                    },
                  ),
                ],
              ),
            ),
            AccountPageExpansionTile(
              title: 'アプリ設定',
              child: Column(
                children: [
                  AccountPageListTile(
                    iconData: Icons.clear_all,
                    title: 'アカウントブロックを初期化',
                    onTap: () async {
                      final message = await viewModel.clearBlockedAccountIds();
                      if (message.isNotEmpty) {
                        await showFlushbar(context, message: message);
                      }
                    },
                  ),
                  AccountPageListTile(
                    iconData: Icons.account_circle,
                    title: 'ログアウト',
                    onTap: () async {
                      await viewModel.signOut();
                    },
                  ),
                ],
              ),
            ),
            AccountPageListTile(
              iconData: Icons.image,
              title: '自分の投稿一覧',
              onTap: () => pushAccountGalleryPostsPage(context),
            ),
          ],
        ),
      ),
    );
  }
}
