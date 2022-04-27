import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConsentmentCheckbox extends StatelessWidget {
  const ConsentmentCheckbox({
    required this.padding,
    required this.value,
    required this.onChanged,
    required this.text,
    this.url,
  });

  final EdgeInsets padding;
  final bool value;
  final void Function(bool?) onChanged;
  final String text;
  final String? url;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                if (url == null) {
                  onChanged(false);
                  return;
                }
                if (await canLaunchUrlString(url!)) {
                  await launchUrlString(url!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    url != null
                        ? const Padding(
                            padding: EdgeInsets.only(top: 2, left: 10),
                            child: Icon(Icons.launch, size: 16),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
