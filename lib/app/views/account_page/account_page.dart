import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/common_style.dart';
import '../../../utils/environment_variables.dart';
import 'components/expansion_tile.dart';
import 'components/list_tile.dart';
import 'view_model.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage();

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
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const Image(
                  image: AssetImage('assets/launcher_icon/icon.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 2),
                    child: Text(
                      'バージョン',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 10),
                    child: Text(
                      '${viewModel.version} (${viewModel.buildNumber})',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'アカウントID',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
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
                            Flushbar<void>(
                              message: 'アカウントIDをコピーしました',
                              duration: const Duration(seconds: 1),
                            ).show(context);
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
    );
  }
}
