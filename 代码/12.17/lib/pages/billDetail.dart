import 'package:flutter/material.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

//单个账单明细

// ignore: must_be_immutable
class BillDatilPage extends StatefulWidget {
  var arguments;
  BillDatilPage({Key key, this.arguments}) : super(key: key);

  _BillDatilPageState createState() =>
      _BillDatilPageState(arguments: this.arguments);
}

class _BillDatilPageState extends State<BillDatilPage> {
  int billId;
  int billTypesId;
  int billFromId;
  double billAmount;
  int billYear;
  int billMonth;
  int billDay;
  int billHour;
  String billRemark; //上述属性为账单属性
  var arguments;
  _BillDatilPageState({this.arguments}); //总体账单页面传值

  //删除
  _delete() async {
    var conn = await MySqlConnection.connect(connect);
    await conn
        .prepared('Delete from bill where billId = ?', [arguments["billId"]]);
    conn.close();
  }

  //根据传值对账单属性赋值
  @override
  initState() {
    super.initState();
    billId = arguments['billId'];
    billFromId = arguments['billFromId'];
    billTypesId = arguments['billTypesId'];
    billAmount = arguments['billAmount'];
    billYear = arguments['billYear'];
    billMonth = arguments['billMonth'];
    billDay = arguments['billDay'];
    billHour = arguments['billHour'];
    billRemark = arguments['billRemark'];
  }

  //刷新页面
  _refresh() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select * from bill where billId = ${arguments["billId"]}'))
        .deStream();
    //更新账单属性
    setState(() {
      billTypesId = result.map((v) => v.byName('billTypesId')).single;
      billAmount = result.map((v) => v.byName('billAmount')).single;
      billYear = result.map((v) => v.byName('billYear')).single;
      billMonth = result.map((v) => v.byName('billMonth')).single;
      billDay = result.map((v) => v.byName('billDay')).single;
      billHour = result.map((v) => v.byName('billHour')).single;
      billRemark = result.map((v) => v.byName('billRemark')).single;
    });
    conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //头部
      appBar: PreferredSize(
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.keyboard_backspace),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ), //返回总体账单页面
            iconTheme: IconThemeData(
              color: Colors.black,
            ), //修改图标颜色
            backgroundColor: Color.fromARGB(255, 255, 200, 0), //背景色
            title: Column(
              children: <Widget>[
                Icon(
                  billFromId == 1
                      ? payIcons[billTypesId]
                      : incomeIcons[billTypesId],
                  size: 35,
                  color: Colors.white,
                ), //账单图标
                Text(billFromId == 1
                    ? payTypes[billTypesId]
                    : incomeTypes[billTypesId]) //账单类型
              ],
            ),
            centerTitle: true, //居中
          ),
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 10)),
      body: Column(
        children: <Widget>[
          //类型
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Text("类型", style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(
                width: 10,
              ),
              Text(billFromId == 1 ? "支出" : "收入",
                  style: TextStyle(fontSize: 20))
            ]),
          ),
          //分隔线
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: Colors.grey,
          ),

          //金额
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Text("金额", style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(
                width: 10,
              ),
              Text("$billAmount", style: TextStyle(fontSize: 20))
            ]),
          ),
          //分隔线
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: Colors.grey,
          ),

          //时间
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Text("时间", style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(
                width: 10,
              ),
              Text("$billYear 年 $billMonth 月 $billDay 日 $billHour 时",
                  style: TextStyle(fontSize: 20))
            ]),
          ),
          //分隔线
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: Colors.grey,
          ),

          //备注
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Text("备注", style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(
                width: 10,
              ),
              Text(billRemark, style: TextStyle(fontSize: 20))
            ]),
          ),
          //分隔线
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: Colors.grey,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 2.1,
          ),
          //按钮
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(children: <Widget>[
              //编辑
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: FlatButton(
                    onPressed: () {
                      _change(); //跳转至修改页面
                    },
                    child: Text("编辑")),
              ),
              //分隔线
              Container(
                width: 0.5,
                height: 20,
                color: Colors.grey,
              ),

              //删除
              Container(
                width: MediaQuery.of(context).size.width / 2 - 0.5,
                child: FlatButton(
                    onPressed: () {
                      //提示
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("确认删除"),
                            content: Text("删除后数据不可恢复！"),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text("取消",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 200, 0))),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); //取消删除，返回明细页面
                                  }),
                              FlatButton(
                                child: Text("删除",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 200, 0))),
                                onPressed: () async {
                                  await _delete();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(true); //删除，并返回账单页面
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text("删除")),
              )
            ]),
          )
        ],
      ),
    );
  }

  //根据账单类型跳转至“支出”或“收入”修改
  _change() {
    if (arguments["billFromId"] == 1) {
      Navigator.pushNamed(context, "/changePay", arguments: {
        "billId": billId,
        "billFromId": billFromId,
        "billTypesId": billTypesId,
        "billAmount": billAmount,
        "billYear": billYear,
        "billMonth": billMonth,
        "billDay": billDay,
        "billHour": billHour,
        "billRemark": billRemark
      }).then((value) => {
            if (value == true) {_refresh()}
          }); //如果修改，刷新页面
    } else {
      Navigator.pushNamed(context, "/changeIncome", arguments: {
        "billId": billId,
        "billFromId": billFromId,
        "billTypesId": billTypesId,
        "billAmount": billAmount,
        "billYear": billYear,
        "billMonth": billMonth,
        "billDay": billDay,
        "billHour": billHour,
        "billRemark": billRemark
      }).then((value) => {
            if (value == true) {_refresh()}
          }); //如果修改，刷新页面
    }
  }
}
