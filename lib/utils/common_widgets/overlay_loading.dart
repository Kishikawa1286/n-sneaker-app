import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OverlayLoading extends StatelessWidget {
  const OverlayLoading({
    required this.child,
    required this.visible,
    Key? key,
  }) : super(key: key);

  //表示状態
  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            child,
            visible
                ? Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                      child: Center(
                        child: Theme(
                          data: ThemeData(
                            cupertinoOverrideTheme: const CupertinoThemeData(
                              brightness: Brightness.dark,
                            ),
                          ),
                          child: const CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      );
}
