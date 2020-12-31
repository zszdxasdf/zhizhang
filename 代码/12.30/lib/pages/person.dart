import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  var _userName = TextEditingController();
  var _userPhone = TextEditingController();
  var _medal;
  var _num;
  var change;
  GlobalKey _globalKey = new GlobalKey<FormState>();

  //加载个人信息
  _load() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select userName,phone,num from user where userId = $userId'))
        .deStream();
    setState(() {
      _userName.text = result.map((r) => r.byName('userName')).single;
      _userPhone.text = result.map((r) => r.byName('phone')).single;
      _num = result.map((r) => r.byName('num')).single;
      if (_num < 10) {
        _medal = '初进记账';
      } else if (_num < 100) {
        _medal = '停不下来';
      } else if (_num < 200) {
        _medal = '记账能手';
      } else if (_num < 300) {
        _medal = '记账小将';
      } else if (_num < 600) {
        _medal = '记账高手';
      } else if (_num < 1000) {
        _medal = '记账大师';
      } else if (_num < 2000) {
        _medal = '记账至尊';
      } else {
        _medal = '高处不胜寒';
      }
    });

    conn.close();
  }

//修改手机号
  _changePhone() async {
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared(
        'Update user set phone = ? where userId = $userId', [_userPhone.text]);
    conn.close();
  }

//修改昵称
  _changeName() async {
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared('Update user set userName = ? where userId = $userId',
        [_userName.text]);
    conn.close();
  }

  //初始化个人信息
  @override
  initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: Key('personback'),
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //修改颜色
          ),
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
          title: Text(
            "个人页面",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ), //间隔

            //用户ID
            Stack(
              alignment: Alignment(0.8, 0),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text('ID'),
                  ),
                ),
                Text(userId.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.grey))
              ],
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ), //间隔

            //昵称
            Stack(
              alignment: Alignment(0.7, 0),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    key: Key('name'),
                    title: Text('昵称'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //修改昵称
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Form(
                                key: _globalKey,
                                // ignore: deprecated_member_use
                                autovalidate: true,
                                child: AlertDialog(
                                  title: Text("修改昵称"),
                                  content: Theme(
                                      data: Theme.of(context).copyWith(
                                          primaryColor:
                                              Color.fromARGB(255, 255, 200, 0)),
                                      child: TextFormField(
                                        key: Key('changename'),
                                        //controller: _userName,
                                        decoration: InputDecoration(
                                          labelText: "昵称",
                                          hintText: "输入你的昵称",
                                        ), //昵称输入
                                        onChanged: (value) {
                                          setState(() {
                                            change = value;
                                          });
                                        },
                                        validator: (v) {
                                          //昵称不能为空且要小于6位
                                          if (v.trim().length > 0) {
                                            return v.trim().length < 6
                                                ? null
                                                : "昵称不能大于6";
                                          }
                                          return "昵称不能为空";
                                        },
                                      )),
                                  actions: <Widget>[
                                    //取消修改
                                    FlatButton(
                                        key: Key('namefalse'),
                                        child: Text("取消",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 200, 0))),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(true); //返回个人页面
                                        }),
                                    //确认修改
                                    FlatButton(
                                      key: Key('nametrue'),
                                      child: Text("确认",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 200, 0))),
                                      onPressed: () {
                                        if ((_globalKey.currentState
                                                as FormState)
                                            .validate()) {
                                          setState(() {
                                            _userName.text = change;
                                          });
                                          _changeName();
                                          Navigator.of(context)
                                              .pop(true); //返回个人页面
                                        }
                                      },
                                    ),
                                  ],
                                ));
                          });
                    },
                  ),
                ),
                Text("${_userName.text}",
                    style: TextStyle(fontSize: 16, color: Colors.grey))
              ],
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ), //间隔

            Stack(
              alignment: Alignment(0.7, 0),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListTile(
                    key: Key('phone'),
                    title: Text('手机号'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Form(
                                key: _globalKey,
                                // ignore: deprecated_member_use
                                autovalidate: true,
                                child: AlertDialog(
                                  title: Text("修改手机号"),
                                  content: Theme(
                                      data: Theme.of(context).copyWith(
                                          primaryColor:
                                              Color.fromARGB(255, 255, 200, 0)),
                                      child: TextFormField(
                                        key: Key('changephone'),
                                        inputFormatters: [
                                          // ignore: deprecated_member_use
                                          WhitelistingTextInputFormatter
                                              // ignore: deprecated_member_use
                                              .digitsOnly
                                        ], //只允许输入数字
                                        decoration: InputDecoration(
                                          labelText: "手机号",
                                          hintText: "输入你的手机号",
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            change = value;
                                          });
                                        },
                                        validator: (v) {
                                          //手机号是否符合规定
                                          if (v.trim().length != 0) {
                                            return v.trim().length == 11
                                                ? null
                                                : "手机号不符合规定";
                                          }
                                          return "手机号不能为空";
                                        },
                                      )),
                                  actions: <Widget>[
                                    //取消修改
                                    FlatButton(
                                        key: Key('phonefalse'),
                                        child: Text("取消",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 200, 0))),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(true); //返回个人页面
                                        }),
                                    //确认修改
                                    FlatButton(
                                        key: Key('phonetrue'),
                                        child: Text("确认",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 200, 0))),
                                        onPressed: () {
                                          if ((_globalKey.currentState
                                                  as FormState)
                                              .validate()) {
                                            setState(() {
                                              _userPhone.text = change;
                                            });
                                            _changePhone();
                                            Navigator.of(context)
                                                .pop(true); //返回个人页面
                                          }
                                        }),
                                  ],
                                ));
                          });
                    },
                  ),
                ),
                Text("${_userPhone.text}",
                    style: TextStyle(fontSize: 16, color: Colors.grey))
              ],
            ), //用户手机号
            SizedBox(
              height: 50,
            ), //间隔

            Container(
              color: Colors.white,
              width: double.infinity,
              height: 150,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '记账成就',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          key: Key('medal'),
                          icon: Icon(
                            Icons.help_outline,
                            size: 20,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('勋章等级'),
                                    content: Container(
                                      child: Table(
                                        columnWidths: const {
                                          0: FixedColumnWidth(20.0),
                                          1: FixedColumnWidth(50.0),
                                        },
                                        border: TableBorder.all(
                                          color: Colors.black,
                                          width: 0.5,
                                          style: BorderStyle.solid,
                                        ),
                                        children: [
                                          TableRow(children: [
                                            Text('\t\t\t等级'),
                                            Text('\t\t记账总笔数')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t初进记账'),
                                            Text('\t\t>=0')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t停不下来'),
                                            Text('\t\t>=10')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t记账能手'),
                                            Text('\t\t>=100')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t记账小将'),
                                            Text('\t\t>=200')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t记账高手'),
                                            Text('\t\t>=300')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t记账大师'),
                                            Text('\t\t>=600')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t记账至尊'),
                                            Text('\t\t>=1000')
                                          ]),
                                          TableRow(children: [
                                            Text('\t\t高处不胜寒'),
                                            Text('\t\t>=2000')
                                          ]),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                          key: Key('medaltrue'),
                                          child: Text("确认",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 200, 0))),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(true); //关闭对话框
                                          })
                                    ],
                                  );
                                });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _medal.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('勋章',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '$_num笔',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '记账总笔数',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            SizedBox(
              height: 50,
            ),
            //修改密码按钮
            Container(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                key: Key('modifypwd'),
                child: Text('修改密码'),
                textColor: Colors.black,
                color: Colors.white,
                elevation: 10,
                onPressed: () {
                  Navigator.pushNamed(context, "/modify"); //跳转至修改密码页面
                },
              ),
            ),

            //退出登录按钮
            Container(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                  key: Key('quit'),
                  child: Text('退出登录'),
                  textColor: Colors.red,
                  color: Colors.white,
                  elevation: 10,
                  onPressed: () {
                    //对话框提示
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: Text("退出后不会删除任何数据，下次登录依然可以使用本账号"),
                          actions: <Widget>[
                            FlatButton(
                                key: Key('quitfalse'),
                                child: Text("取消",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 200, 0))),
                                onPressed: () {
                                  Navigator.of(context).pop(true); //返回个人页面
                                }),
                            FlatButton(
                              key: Key('quittrue'),
                              child: Text("退出登录",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 200, 0))),
                              onPressed: () {
                                userId = 0;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/login",
                                    ModalRoute.withName("/login")); //返回登录页面
                              },
                            )
                          ],
                        );
                      },
                    );
                  }),
            )
          ],
        )));
  }
}
