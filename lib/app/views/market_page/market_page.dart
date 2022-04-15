import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import 'components/all_product_grid/product_grid.dart';
import 'components/series_product_grid/product_grid.dart';
import 'view_model.dart';

class MarketPage extends HookConsumerWidget {
  const MarketPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketPageViewModelProvider);
    final tabTitles = ['All', ...viewModel.tabTitles];

    if (tabTitles.isEmpty) {
      return const SizedBox();
    }

    return DefaultTabController(
      length: tabTitles.length,
      child: Builder(
        builder: (context) {
          DefaultTabController.of(context)?.addListener(() {
            final controller = DefaultTabController.of(context);
            if (controller == null) {
              return;
            }
            if (controller.indexIsChanging) {
              return;
            }
            final index = controller.index;
            viewModel.setIndex(index);
          });

          return Container(
            padding: const EdgeInsets.only(top: 25),
            color: CommonStyle.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TabBar(
                      isScrollable: true,
                      indicatorWeight: 1,
                      tabs: tabTitles
                          .asMap()
                          .map(
                            (index, series) => MapEntry(
                              index,
                              Text(
                                series,
                                style: TextStyle(
                                  color: index == viewModel.currentIndex
                                      ? CommonStyle.enabledColor
                                      : CommonStyle.disabledColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .values
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: tabTitles
                          .asMap()
                          .map(
                            (index, series) => MapEntry(
                              index,
                              index == 0
                                  ? const MarketPageAllProductGrid()
                                  : MarketPageSeriesProductGrid(series: series),
                            ),
                          )
                          .values
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
