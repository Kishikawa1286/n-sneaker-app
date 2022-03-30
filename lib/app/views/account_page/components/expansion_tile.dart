import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';

class AccountPageExpansionTile extends StatelessWidget {
  const AccountPageExpansionTile({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => ExpansionTile(
        collapsedTextColor: CommonStyle.black,
        iconColor: CommonStyle.black,
        title: Text(
          title,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: CommonStyle.transparent,
        collapsedBackgroundColor: CommonStyle.transparent,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
            child: child,
          ),
        ],
      );
}
