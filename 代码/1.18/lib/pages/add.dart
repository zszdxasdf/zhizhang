import 'package:flutter/material.dart';
import 'package:zhizhang/pages/addPay.dart';
import 'package:zhizhang/pages/addIncome.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          //头部
          appBar: AppBar(
            leading: IconButton(
              key: Key('addback'),
              icon: Icon(Icons.keyboard_backspace),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ), //修改颜色
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 255, 200, 0),
            title: Row(
              children: <Widget>[
                Expanded(
                    child: TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                      Tab(
                        text: "支出",
                        key: Key('addPayTab'),
                      ),
                      Tab(text: "收入", key: Key('addincomeTab'))
                    ])) //头部导航
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AddPayPage() /*支出增加 */,
              AddIncomePage() /*收入增加 */
            ], //显示页面
          ),
        ));
  }
}
