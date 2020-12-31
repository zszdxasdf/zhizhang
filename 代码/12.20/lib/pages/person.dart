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
  var change;
  GlobalKey _globalKey = new GlobalKey<FormState>();

  //加载个人信息
  _load() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn
            .execute('select userName,phone from user where userId = $userId'))
        .deStream();
    setState(() {
      _userName.text = result.map((r) => r.byName('userName')).single;
      _userPhone.text = result.map((r) => r.byName('phone')).single;
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

            //修改密码按钮
            Container(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
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
                                child: Text("取消",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 200, 0))),
                                onPressed: () {
                                  Navigator.of(context).pop(true); //返回个人页面
                                }),
                            FlatButton(
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
