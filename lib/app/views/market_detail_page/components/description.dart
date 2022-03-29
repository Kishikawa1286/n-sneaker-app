import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/price_formatter.dart';
import '../view_model.dart';
import 'expansion_tile.dart';

class MarketDetailPageDescription extends HookConsumerWidget {
  const MarketDetailPageDescription({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketDetailPageViewModelProvider(productId));
    final product = viewModel.product;
    if (product == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 90,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${product.vendorJp}  ${product.seriesJp}',
            maxLines: 2,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              product.titleJp,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥ ${priceFormatter.format(product.priceJpy)}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    '（税込）',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 37, left: 8, right: 8),
            child: Text(
              product.descriptionJp,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                height: 1.8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: product.collectionProductStatementJp.isNotEmpty
                ? MarketDetailPageExpansionTile(
                    title: '注意事項（コレクション）',
                    content: product.collectionProductStatementJp,
                  )
                : const SizedBox(),
          ),
          product.arStatementJp.isNotEmpty
              ? MarketDetailPageExpansionTile(
                  title: '注意事項（AR）',
                  content: product.arStatementJp,
                )
              : const SizedBox(),
          product.otherStatementJp.isNotEmpty
              ? MarketDetailPageExpansionTile(
                  title: '備考',
                  content: product.otherStatementJp,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
