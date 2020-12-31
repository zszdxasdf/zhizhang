import 'package:flutter/material.dart';
import 'chartIncome.dart';
import 'chartPay.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List _pageList = [ChartPayPage(), ChartIncomePage()]; //页面内容
  var _selectValue;
  @override
  void initState() {
    super.initState();
    _selectValue = getListData()[0].value; //初始化页面内容
  }

  List<DropdownMenuItem> getListData() {
    //头部下拉框
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
      child: new Text('支出'),
      value: 0,
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
      child: new Text('收入'),
      value: 1,
    );
    items.add(dropdownMenuItem2);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
        title: Center(
          child: DropdownButton(
            items: getListData(),
            onChanged: (value) {
              setState(() {
                _selectValue = value;
              });
            }, //改变下拉框内容
            value: _selectValue,
            underline: Container(), //把底部那条线去掉
          ),
        ),
      ),
      body: this._pageList[this._selectValue], //根据下拉框选项改变页面内容
    );
  }
}
