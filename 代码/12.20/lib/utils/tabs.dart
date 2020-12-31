import 'package:flutter/material.dart';
import 'package:zhizhang/pages/details.dart';
import 'package:zhizhang/pages/charts.dart';
import 'package:zhizhang/pages/add.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0; //页面值

  List _pageList = [DetailsPage(), AddPage(), ChartsPage()]; //页面内容
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //浮动增加按钮
      floatingActionButton: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: Colors.white),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
          onPressed: () {
            Navigator.pushNamed(context, "/add");
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: this._pageList[this._currentIndex], //内容页面
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index) {
          //改变页面内容
          if (index == 1) {
            Navigator.pushNamed(context, "/add");
          } else {
            setState(() {
              this._currentIndex = index;
            });
          }
        },
        fixedColor: Color.fromARGB(255, 255, 200, 0),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              // ignore: deprecated_member_use
              title: Text("明细")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              // ignore: deprecated_member_use
              title: Text("添加")),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              // ignore: deprecated_member_use
              title: Text("图表")),
        ], //底部导航条内容
      ),
    );
  }
}
