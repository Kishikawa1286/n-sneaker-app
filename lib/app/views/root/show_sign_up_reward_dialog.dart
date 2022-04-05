import 'package:flutter/material.dart';

import '../../../utils/common_style.dart';

void showSignUpRewardDialog({
  required BuildContext context,
  required void Function() onTapButton,
}) =>
    showDialog<void>(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          width: 250,
          height: 330,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/sign_up_reward/mark_present.jpg',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 10,
                    right: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: onTapButton,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.9,
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
                      'さっそく見てみる',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: CommonStyle.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
