import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/common_style.dart';

class MaintainancePage extends StatelessWidget {
  const MaintainancePage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: CommonStyle.scaffoldBackgroundColor,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const Image(
                        image: AssetImage('assets/launcher_icon/icon.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'メンテナンス中',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
