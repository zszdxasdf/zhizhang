import 'package:flutter/material.dart';
import 'chartIncomeMonth.dart';
import 'chartIncomeYear.dart';

class ChartIncomePage extends StatefulWidget {
  @override
  _ChartIncomePageState createState() => _ChartIncomePageState();
}

class _ChartIncomePageState extends State<ChartIncomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ), //修改图标颜色
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 255, 200, 0),
            elevation: 1, //阴影
            title: Row(
              children: <Widget>[
                Expanded(
                    child: TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                      Tab(
                        text: "月",
                        key: Key('chartincomemonth'),
                      ),
                      Tab(text: "年", key: Key('chartincomeyear'))
                    ])) //头部导航
              ],
            ),
          ),
          body: TabBarView(
            children: [ChartIncomeMonthPage(), ChartIncomeYearPage()], //显示页面
          ),
        ));
  }
}
