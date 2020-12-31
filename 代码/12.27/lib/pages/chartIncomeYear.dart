import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class ChartIncomeYearPage extends StatefulWidget {
  @override
  _ChartIncomeYearPageState createState() => _ChartIncomeYearPageState();
}

class _ChartIncomeYearPageState extends State<ChartIncomeYearPage> {
  DateTime _dateTime = DateTime.now(); //时间
  double _sum = 0.00; //总金额
  int _num = 0; //类型数量
  var _monthSum = List<double>(); //每月总金额
  var _typeSum = List<double>(); //每种类别总金额
  double _height = 80; //柱形图高度

  //每日收入
  _getDay() async {
    //改变时间后对数据重置
    double _price;
    int _month;
    _sum = 0.00;
    _monthSum.clear();
    for (var i = 0; i < 13; i++) {
      _monthSum.add(0.00);
    }

    var conn = await MySqlConnection.connect(connect);
    Results results = await (await conn.execute(
            'select sum(billAmount) as sum,billMonth from bill ' +
                'where billYear=${_dateTime.year} ' +
                'And billFromId=0 and userId=$userId group by billMonth'))
        .deStream();
    results.forEach((element) {
      //读取日期及其总金额，并存入_monthSum
      setState(() {
        _price = element.byName('sum');
        _sum += _price;
        _month = element.byName('billMonth');
        _monthSum[_month] = _price;
      });
    });
    conn.close();
  }

  //每类收入
  _getTypes() async {
    //改变时间后对数据重置
    double _price;
    int _type;
    _num = 0;
    _typeSum.clear();
    for (var i = 0; i < 3; i++) {
      _typeSum.add(0.00);
    }

    var conn = await MySqlConnection.connect(connect);
    Results results = await (await conn.execute(
            'select sum(billAmount) as sum,billTypesId from bill ' +
                'where billYear=${_dateTime.year} ' +
                'And billFromId=0 and userId =$userId  group by billTypesId'))
        .deStream();
    results.forEach((element) {
      //读取类别及其总金额，并存入_typesSum
      setState(() {
        _type = element.byName('billTypesId');
        _price = element.byName('sum');
        _typeSum[_type] = _price;
        _num++;
        _height = _num * 90.0; //根据类型数量设置柱形图高度
      });
    });

    conn.close();
  }

//页面内容
  _body() {
    List<Widget> list = new List();
    list.add(Text(' 总收入：$_sum')); //总收入
    list.add(SizedBox(
      height: 20,
    )); //中间间隔
    list.add(
        Column(children: [Container(height: 150, child: _simpleLine())])); //折线图
    list.add(SizedBox(
      height: 30,
    )); //中间间隔
    list.add(Container(
      height: 0.5,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
    )); //分隔线
    list.add(SizedBox(
      height: 15,
    )); //中间间隔
    //如果有数据，显示柱形图；没有提示没有数据
    if (_num == 0) {
      list.add(Text(
        ' 收入类别总计',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ));
      list.add(Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Icon(
              Icons.assignment,
              size: 50,
            ),
            Text("没有数据")
          ],
        ),
      ));
      list.add(SizedBox(
        height: 30,
      )); //中间间隔
      list.add(Text(
        ' 收入比例',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ));

      list.add(Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Icon(
              Icons.assignment,
              size: 50,
            ),
            Text("没有数据")
          ],
        ),
      ));
    } else {
      list.add(Text(
        ' 收入类别总计',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ));
      list.add(Column(
          children: [Container(height: _height, child: _simpleBar())])); //柱形图
      list.add(SizedBox(
        height: 30,
      )); //中间间隔
      list.add(Text(
        ' 收入比例',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ));
      list.add(Column(
          children: [Container(height: 160, child: _simplePie())])); //柱形图
    }
    list.add(SizedBox(
      height: 50,
    )); //间隔
    return list;
  }

  //初始化
  @override
  initState() {
    super.initState();
    _getDay();
    _getTypes();
  }

  _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: false,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('确定',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 0))),
        cancel: Text('取消',
            style: TextStyle(color: Color.fromARGB(255, 255, 200, 0))),
      ),
      minDateTime: DateTime.parse('1900-01-01'),
      maxDateTime: DateTime.parse('2100-12-31'),
      initialDateTime: _dateTime,
      dateFormat: 'yyyy',
      locale: DateTimePickerLocale.zh_cn,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          _getDay(); //更新时间后刷新
          _getTypes(); //更新时间后刷新
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("${formatDate(_dateTime, [yyyy, ' 年 '])}"),
                onPressed: () {
                  _showDatePicker();
                }),
          )),
      body: ListView(
        children: _body(),
      ),
    );
  }

  Widget _simpleLine() {
    var line = List<TimeSeriesSales>();

    //增加月份
    for (var i = 1; i <= 12; i++) {
      line.add(new TimeSeriesSales(
          DateTime(_dateTime.year, _dateTime.month, i), _monthSum[i]));
    }

    //折线图数据
    var seriesList = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'line',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.black),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: line,
      )
    ];

    return charts.TimeSeriesChart(seriesList,
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
            // 圆点大小
            radiusPx: 3.0,
            stacked: false,
            // 线的宽度
            strokeWidthPx: 1.0,
            // 是否显示线
            includeLine: true,
            // 是否显示圆点
            includePoints: true,
            // 是否显示包含区域
            includeArea: false));
  }

  //柱状图
  Widget _simpleBar() {
    var bar = List<OrdinalSales>();

    //增加类型
    for (var i = 0; i < 3; i++) {
      if (_typeSum[i] != 0) {
        bar.add(new OrdinalSales(incomeTypes[i], _typeSum[i]));
      }
    }

    //柱形图数据
    var seriesList = [
      charts.Series<OrdinalSales, String>(
        id: 'bar',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 255, 200, 0)),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: bar,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales.toString()}',
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          return new charts.TextStyleSpec(
              color: charts.MaterialPalette.black.darker);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          return new charts.TextStyleSpec(
              color: charts.MaterialPalette.white.darker);
        },
      )
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      vertical: false,
    );
  }

  Widget _simplePie() {
    var pie = List<PieSales>();

    //增加类型
    for (var i = 0; i < 3; i++) {
      if (_typeSum[i] != 0) {
        pie.add(new PieSales(incomeTypes[i], _typeSum[i] / _sum));
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
            ':\n ${(NumUtil.getNumByValueDouble(row.sales * 100, 2)).toStringAsFixed(2)}%',
      )
    ];

    return charts.PieChart(seriesList,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }
}
