import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';

class MarketDetailPageExpansionTile extends StatelessWidget {
  const MarketDetailPageExpansionTile({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

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
            child: Text(
              content,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
        ],
      );
}
