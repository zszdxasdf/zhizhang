import 'package:flutter/material.dart';
import 'package:zhizhang/utils/types.dart';
import 'package:zhizhang/utils/numberKeyboard.dart';

class AddPayPage extends StatefulWidget {
  @override
  _AddPayPageState createState() => _AddPayPageState();
}

class _AddPayPageState extends State<AddPayPage> {
  var price = TextEditingController();

  var color = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ]; //判断按钮是否被选中

  //数字键盘

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
      key: Key('addpay$index'),
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
                  bill: Bill(1, index),
                  action: 0,
                ),
              );
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
              child: Icon(payIcons[index], color: Colors.black38), //按钮图标
            ),
          ),
          Text(payTypes[index]) //按钮label
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            //页面按钮布局
            child: GridView.count(
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                flatButton(0),
                flatButton(1),
                flatButton(2),
                flatButton(3),
                flatButton(4),
                flatButton(5),
                flatButton(6),
                flatButton(7),
                flatButton(8),
                flatButton(9),
                flatButton(10),
                flatButton(11),
                flatButton(12),
                flatButton(13),
                flatButton(14),
                flatButton(15),
                flatButton(16),
                flatButton(17),
                flatButton(18),
              ], //增加按钮
            )));
  }
}
