import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_tab_view/infinite_scroll_tab_view.dart';

import '../../../utils/common_style.dart';
import 'components/product_grid/product_grid.dart';
import 'series_list.dart';

class MarketPage extends StatelessWidget {
  const MarketPage();

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          padding: const EdgeInsets.only(top: 25),
          color: CommonStyle.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InfiniteScrollTabView(
              backgroundColor: CommonStyle.white,
              contentLength: seriesList.length,
              tabBuilder: (index, isSelected) => Text(
                seriesList[index],
                style: TextStyle(
                  color: isSelected
                      ? CommonStyle.enabledColor
                      : CommonStyle.disabledColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              separator: const BorderSide(color: CommonStyle.disabledColor),
              indicatorColor: CommonStyle.enabledColor,
              pageBuilder: (context, index, _) =>
                  MarketPageProductGrid(series: seriesList[index]),
            ),
          ),
        ),
      );
}
