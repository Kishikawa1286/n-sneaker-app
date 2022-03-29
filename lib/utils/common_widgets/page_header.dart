import 'package:flutter/material.dart';

import '../common_style.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.showBackButton = false,
    this.height = 80,
  });

  final String title;
  final bool showBackButton;
  final double height;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CommonStyle.grey)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          showBackButton
              ? Positioned(
                  top: 32,
                  left: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: Navigator.of(context).pop,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );
}
