import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPageListTile extends StatelessWidget {
  const AccountPageListTile({
    required this.iconData,
    required this.title,
    required this.onTap,
    this.isLauncher = false,
  });

  final IconData iconData;
  final String title;
  final bool isLauncher;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(iconData),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            title,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        trailing: isLauncher ? const Icon(Icons.launch) : null,
        onTap: onTap,
      );
}
