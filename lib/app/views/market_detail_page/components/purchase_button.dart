import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../../../repositories/product/product_model.dart';
import '../view_model.dart';

class MarketDetailPagePurchaseButton extends HookConsumerWidget {
  const MarketDetailPagePurchaseButton({required this.productId});

  final String productId;

  String _text(ProductModel? product, bool? purchased) {
    if (product == null) {
      return '';
    }
    if (purchased == null) {
      return '購入済み';
    }
    if (purchased) {
      return '購入済み';
    }
    return '購入';
  }

  void Function()? _onPressed(
    ProductModel? product,
    bool? purchased,
    void Function() purchase,
  ) {
    if (product == null || purchased == null) {
      return null;
    }
    if (purchased) {
      return null;
    }
    return () {
      purchase();
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketDetailPageViewModelProvider(productId));
    final product = viewModel.product;
    return ElevatedButton(
      onPressed: _onPressed(
        product,
        viewModel.purchased,
        () async {
          final message = await viewModel.purchase();
          if (message.isNotEmpty) {
            await Flushbar<void>(
              message: message,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        },
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          40,
        ),
        elevation: 5,
        primary: CommonStyle.black,
        onPrimary: CommonStyle.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        _text(product, viewModel.purchased),
        maxLines: 1,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: CommonStyle.white,
        ),
      ),
    );
  }
}
