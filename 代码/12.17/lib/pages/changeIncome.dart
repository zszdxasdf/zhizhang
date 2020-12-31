import 'package:flutter/material.dart';
import 'package:zhizhang/utils/bill.dart';
import 'package:zhizhang/utils/numberKeyboard.dart';
import 'package:zhizhang/utils/types.dart';

// ignore: must_be_immutable
class ChangeIncomePage extends StatefulWidget {
  var arguments;
  ChangeIncomePage({Key key, this.arguments}) : super(key: key);

  @override
  _ChangeIncomePageState createState() =>
      _ChangeIncomePageState(arguments: this.arguments);
}

class _ChangeIncomePageState extends State<ChangeIncomePage> {
  var arguments;
  _ChangeIncomePageState({this.arguments}); //上一页面传值
  Bill bill;

  //初始化按钮
  @override
  void initState() {
    super.initState();
    color[arguments['billTypesId']] = true;
  }

  var color = [false, false, false]; //判断按钮是否被选中

  //改变按钮颜色
  void _set(int index) {
    var value = color.indexWhere((element) => element == true);
    if (value != -1) {
      color[value] = false; //恢复之前按钮颜色
    }
    color[index] = true; //改变选中按钮颜色
  }

  //按钮布局及事件
  flatButton(int index) {
    return FlatButton(
      color: Colors.white,
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onPressed: () {
        setState(() {
          _set(index); //改变按钮颜色
        });
        //显示数字键盘
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                  child: NumberKeyboard(
                      bill: Bill(
                        0,
                        index,
                        arguments['billId'],
                        arguments['billAmount'],
                        arguments['billYear'],
                        arguments['billMonth'],
                        arguments['billDay'],
                        arguments['billHour'],
                        arguments['billRemark'],
                      ),
                      action: 1));
            });
      },
      child: Column(
        children: <Widget>[
          Container(
            color: null,
            child: CircleAvatar(
              backgroundColor: color[index]
                  ? Color.fromARGB(255, 255, 200, 0)
                  : Color.fromARGB(255, 239, 239, 239), //按钮颜色
              radius: 30.0,
              child: Icon(incomeIcons[index], color: Colors.black38), //按钮图标
            ),
          ),
          Text(incomeTypes[index]) //按钮label
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ), //修改头部图标颜色
          title: Text(
            "收入",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
        ),
        body: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 4,
            padding: EdgeInsets.all(20),
            children: [flatButton(0), flatButton(1), flatButton(2)], //增加按钮
          ),
        ));
  }
}
