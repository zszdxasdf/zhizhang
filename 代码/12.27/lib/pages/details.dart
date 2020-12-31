import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  double _monthPay = 0.00; //月支出
  double _monthIncome = 0.00; //月收入
  var bills = List<Bill>(); //账单列表
  var days = List<int>(); //日期列表

  //加载数据
  _getBills() async {
    //改变时间后对数据重置
    _monthIncome = 0;
    _monthPay = 0;
    bills.clear();
    days.clear();

    var conn = await MySqlConnection.connect(connect);
    Results results = await (await conn.execute(
            'select * from bill where userId = $userId and billYear = ${_dateTime.year} and billMonth = ${_dateTime.month}'))
        .deStream();
    results.forEach((element) {
      //读取符合条件的账单信息，存入bills
      setState(() {
        int day = element.byName('billDay');
        Bill bill =
            Bill(element.byName('billFromId'), element.byName('billTypesId'));
        bill.billId = element.byName('billId');
        bill.billYear = element.byName('billYear');
        bill.billMonth = element.byName('billMonth');
        bill.billDay = element.byName('billDay');
        bill.billHour = element.byName('billHour');
        bill.billAmount = element.byName('billAmount');
        bill.billRemark = element.byName('billRemark');
        bills.add(bill);
        //添加有账单的日期
        if (days.contains(day) == false) {
          days.add(day);
        }
        //判断账单类型，分别计算支出与收入的总和
        if (bill.billFromId == 1) {
          _monthPay += bill.billAmount;
        } else if (bill.billFromId == 0) {
          _monthIncome += bill.billAmount;
        }
      });
    });
    //天数排序
    days.sort((a, b) {
      return a - b;
    });
    conn.close();
  }

  //初始化
  @override
  initState() {
    super.initState();
    _getBills();
  }

  //页面内容
  _body() {
    List<Widget> list = new List();
    List<Widget> daylist = new List();
    list.add(
      //顶部
      Row(
        children: <Widget>[
          //月份选择
          Container(
            width: MediaQuery.of(context).size.width / 3.5,
            height: 80,
            color: Color.fromARGB(255, 255, 200, 0),
            child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${formatDate(_dateTime, [yyyy, '年'])}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${formatDate(_dateTime, [mm, '月'])}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   width: 1,
                    // ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  _showDatePicker();
                }),
          ),

          //分割线
          Container(
            width: 1,
            height: 80,
            color: Color.fromARGB(255, 255, 200, 0),
            child: Center(
              child: Container(
                height: 50,
                color: Colors.black,
              ),
            ),
          ),

          //收入合计
          Container(
              width: MediaQuery.of(context).size.width / 14 * 5 - 1,
              height: 80,
              color: Color.fromARGB(255, 255, 200, 0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " 收入",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Text(
                        " ${this._monthIncome}",
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                  ),
                ],
              )),

          //支出合计
          Container(
              width: MediaQuery.of(context).size.width / 14 * 5,
              height: 80,
              color: Color.fromARGB(255, 255, 200, 0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "支出",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Text(
                        " ${this._monthPay}",
                        style: TextStyle(fontSize: 20),
                      )),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
    //如果有数据，显示账单；没有提示没有数据
    if (bills.isEmpty == true) {
      list.add(Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
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
      //遍历天数
      for (var i = 0; i < days.length; i++) {
        var _dayIncome = 0.00;
        var _dayPay = 0.00;
        //遍历账单
        for (var j = 0; j < bills.length; j++) {
          if (bills[j].billDay == days[i]) {
            if (bills[j].billFromId == 1) {
              _dayPay += bills[j].billAmount;
            } else {
              _dayIncome += bills[j].billAmount;
            }
            daylist.add(ListTile(
              leading: Icon(bills[j].billFromId == 1
                  ? payIcons[bills[j].billTypesId]
                  : incomeIcons[bills[j].billTypesId]), //图标
              title: Text(bills[j].billFromId == 1
                  ? payTypes[bills[j].billTypesId]
                  : incomeTypes[bills[j].billTypesId]), //文本
              trailing: Text(bills[j].billFromId == 1
                  ? "-${bills[j].billAmount}"
                  : "${bills[j].billAmount}"), //金额
              onTap: () {
                Navigator.pushNamed(context, '/bill', arguments: {
                  "billId": bills[j].billId,
                  "billFromId": bills[j].billFromId,
                  "billTypesId": bills[j].billTypesId,
                  "billAmount": bills[j].billAmount,
                  "billYear": bills[j].billYear,
                  "billMonth": bills[j].billMonth,
                  "billDay": bills[j].billDay,
                  "billHour": bills[j].billHour,
                  "billRemark": bills[j].billRemark
                }).then((value) => {
                      if (value == true) {_getBills()}
                    }); //跳转至单个账单明细，如果有更改，返回时刷新
              },
            ));
          }
        }
        list.add(Column(
          children: <Widget>[
            //每日总计
            Row(
              children: <Widget>[
                Expanded(child: Text("${_dateTime.month}月${days[i]}日")),
                // Expanded(
                //     child: SizedBox(
                //   width: 10,
                // )),
                Expanded(
                    child: SizedBox(
                  width: 100,
                )),
                Expanded(child: Text("收入：$_dayIncome")),
                Expanded(child: Text("支出：$_dayPay"))
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.7,
              color: Colors.grey,
            ),
          ],
        ));
        //每日账单显示
        for (var j = 0; j < daylist.length; j++) {
          list.add(daylist[j]);
          list.add(
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.2,
              color: Colors.grey,
            ),
          );
        }
        list.add(SizedBox(
          height: 20,
        ));
        daylist.clear();
      }
    }
    return list;
  }

  DateTime _dateTime = DateTime.now();
  //月份选择
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
      dateFormat: 'yyyy-MMMM',
      locale: DateTimePickerLocale.zh_cn,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          _getBills();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.person_outline,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/person');
              } //跳转个人页面
              ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
          title: Text("制账", style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(
            color: Colors.black,
          ), //修改图标颜色
          actions: [
            FlatButton(
                child: Text("排行榜"),
                onPressed: () {
                  Navigator.pushNamed(context, '/rank');
                })
          ],
        ),
        body: ListView(
          children: _body(),
        ));
  }
}
