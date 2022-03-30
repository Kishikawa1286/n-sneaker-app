import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import 'components/product_grid/product_grid.dart';
import 'series_list.dart';
import 'view_model.dart';

class MarketPage extends HookConsumerWidget {
  const MarketPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(marketPageViewModelProvider);
    return DefaultTabController(
      length: seriesList.length,
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
                      tabs: seriesList
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
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
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
                      children: seriesList
                          .asMap()
                          .map(
                            (index, series) => MapEntry(
                              index,
                              MarketPageProductGrid(series: series),
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