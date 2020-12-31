import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:zhizhang/utils/types.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget simplePie(var typeSum,double sum,int form) {
    var pie = List<PieSales>();

    //增加类型
    for (var i = 0; i < 19; i++) {
      if (typeSum[i] != 0) {
        pie.add(new PieSales(payTypes[i], typeSum[i] / sum));
      }
    }

    var seriesList = [
      charts.Series<PieSales, String>(
        id: 'Sales',
        domainFn: (PieSales sales, _) => sales.year,
        measureFn: (PieSales sales, _) => sales.sales,
        data: pie,
        labelAccessorFn: (PieSales row, _) =>
            row.year +
            ': ${(NumUtil.getNumByValueDouble(row.sales * 100, 2)).toStringAsFixed(2)}%',
      )
    ];

    return charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }