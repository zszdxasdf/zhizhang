import 'package:flutter/material.dart';
import 'package:zhizhang/pages/chartPayMonth.dart';
import 'package:zhizhang/pages/chartPayYear.dart';

class ChartPayPage extends StatefulWidget {
  @override
  _ChartPayPageState createState() => _ChartPayPageState();
}

class _ChartPayPageState extends State<ChartPayPage> {
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
                        tabs: [Tab(text: "月"), Tab(text: "年")])) //头部导航
              ],
            ),
          ),
          body: TabBarView(
            children: [ChartPayMonthPage(), ChartPayYearPage()], //显示页面
          ),
        ));
  }
}
