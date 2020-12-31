import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/tabs.dart';
import 'package:zhizhang/utils/types.dart';
import 'bill.dart';

//账单增加键盘

// ignore: must_be_immutable
class NumberKeyboard extends StatefulWidget {
  Bill bill;
  int action;
  NumberKeyboard({
    Key key,
    @required this.bill,
    @required this.action,
  }) : super(key: key);

  @override
  State createState() => new _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> {
  var _price = TextEditingController();
  var _remark = TextEditingController(); //备注
  DateTime _dateTime; //时间
  ///键盘上的键值名称
  static const List<String> _keyNames = [
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
    '.',
    '0',
    '<-'
  ];

//增加账单
  _add() async {
    var _money = double.parse(_price.text);
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared(
        'Insert into bill (billTypesId,billFromId,userId,billAmount,billYear,billMonth,billDay,billHour,billRemark) values (?,?,?,?,?,?,?,?,?)',
        [
          this.widget.bill.billTypesId,
          this.widget.bill.billFromId,
          userId,
          _money,
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          _dateTime.hour,
          _remark.text
        ]);
    conn.close();
  }

//修改账单
  _modify() async {
    var _money = double.parse(_price.text);
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared(
        'Update bill set billTypesId=?, billFromId=?, userId=?, billAmount=?, billYear=?, billMonth=?, billDay=?, billHour=?, billRemark=? where billId =?',
        [
          this.widget.bill.billTypesId,
          this.widget.bill.billFromId,
          userId,
          _money,
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          _dateTime.hour,
          _remark.text,
          this.widget.bill.billId
        ]);
    conn.close();
  }

  //初始化：增加账单时，金额为0，时间为当前时间；修改账单时，信息为账单信息
  @override
  void initState() {
    super.initState();
    if (this.widget.action == 0) {
      _price.text = '0.00';
      _dateTime = DateTime.now();
    } else {
      _price.text = this.widget.bill.billAmount.toString();
      _remark.text = this.widget.bill.billRemark;
      var hour;
      if (this.widget.bill.billHour < 10) {
        hour = "0" + "${this.widget.bill.billHour}";
      } else {
        hour = "${this.widget.bill.billHour}";
      }
      _dateTime = DateTime.parse(
          '${this.widget.bill.billYear}-${this.widget.bill.billMonth}-${this.widget.bill.billDay} $hour:00:00');
    }
  }

  //时间
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
      minDateTime: DateTime.parse('1900-01-01 00:00:00'), //最小日期
      maxDateTime: DateTime.parse('2100-12-31 23:59:59'), //最大日期
      initialDateTime: _dateTime,
      dateFormat: 'yyyy-MMMM-dd-HH',
      pickerMode: DateTimePickerMode.datetime,
      locale: DateTimePickerLocale.zh_cn,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  ///控件点击事件
  void _onViewClick(String keyName) {
    var currentText = _price.text; //当前的文本
    //如果第一位是数字0，那么第二次输入的是1-9，那么就替换
    if (currentText == '0.00' && (RegExp('^[1-9]\$').hasMatch(keyName))) {
      _price.text = keyName;
      return;
    }

    //如果第一位是数字0，那么第二次输入的是1-9，那么就替换
    if (currentText == '0' && (RegExp('^[1-9]\$').hasMatch(keyName))) {
      _price.text = keyName;
      return;
    }

    //如果第一位是数字0，输入的是0，不做反应
    if (currentText == '0' && (RegExp('^[0]\$').hasMatch(keyName))) {
      _price.text = keyName;
      return;
    }

    //已有小数点，且小数点后有两位，不做反应
    if (RegExp('^\\d+\\.\\d{2}\$').hasMatch(currentText) && keyName != '<-') {
      return;
    }

    //不能第一个就输入.或者<-,不能在已经输入了.再输入
    if ((currentText == '' && (keyName == '.' || keyName == '<-')) ||
        (RegExp('\\.').hasMatch(currentText) && keyName == '.')) {
      return;
    }

    //撤销
    if (keyName == '<-') {
      //值为0.00，不做反应
      if (currentText == '0.00') {
        return;
      }
      //值如果只有一位，返回1；否则删除最后一位
      if (currentText.length == 1) {
        _price.text = '0';
      } else {
        _price.text = currentText.substring(0, currentText.length - 1);
      }
      return;
    }

    _price.text = currentText + keyName;
  }

  ///数字展示面板
  Widget _showDigitalView() {
    return Container(
      height: 80.0,
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          //输入备注
          Container(
            width: MediaQuery.of(context).size.width / 4.0 * 3,
            child: Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 255, 200, 0)),
                child: TextFormField(
                  controller: _remark,
                  decoration: InputDecoration(
                      labelText: "备注",
                      hintText: "点击写备注..",
                      icon: Icon(Icons.bookmark_outline)),
                )),
          ),

          //输入的数字
          Expanded(
            child: TextField(
              enabled: false,
              textAlign: TextAlign.center,
              controller: _price,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Color(0xeaeaeaea),
                      fontSize: 18,
                      letterSpacing: 2.0),
                  contentPadding: const EdgeInsets.all(0.0)),
            ),
          ),
        ],
      ),
    );
  }

  ///构建显示数字键盘的视图
  Widget _showKeyboardGridView() {
    List<Widget> keyWidgets = new List();
    for (int i = 0; i < _keyNames.length; i++) {
      keyWidgets.add(
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => _onViewClick(_keyNames[i]),
            child: Container(
              width: MediaQuery.of(context).size.width / 4.0,
              height: 50,
              child: Center(
                child: i == _keyNames.length - 1
                    ? Icon(Icons.backspace)
                    : Text(
                        _keyNames[i],
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(
                            0xff606060,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    }
    return Wrap(children: keyWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            _showDigitalView(), //备注与金额显示
            Row(
              children: <Widget>[
                //数字键盘
                Container(
                  width: MediaQuery.of(context).size.width / 4.0 * 3,
                  height: 200,
                  child: _showKeyboardGridView(),
                ),

                Column(
                  children: <Widget>[
                    //时间选择
                    Container(
                      width: MediaQuery.of(context).size.width / 4.0,
                      height: 50,
                      child: FlatButton(
                          child: Text("${formatDate(_dateTime, [
                            yyyy,
                            '-',
                            mm,
                            '-',
                            dd,
                            '\n\t\t\t\t\t',
                            HH,
                            '时'
                          ])}"),
                          onPressed: () {
                            _showDatePicker();
                          }),
                    ),
                    //完成按钮
                    Container(
                      width: MediaQuery.of(context).size.width / 4.0,
                      height: 150,
                      color: Color.fromARGB(255, 255, 200, 0),
                      child: FlatButton(
                          child: Text("完 成", style: TextStyle(fontSize: 15)),
                          onPressed: () async {
                            if (this.widget.action == 0) {
                              await _add();
                              Navigator.of(context).pushAndRemoveUntil(
                                  new MaterialPageRoute(
                                      builder: (context) => new Tabs()),
                                  (route) => route == null); //返回明细页面
                            } else if (this.widget.action == 1) {
                              await _modify();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(true); //返回账单详情
                            }
                          }),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
