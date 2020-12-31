import 'package:flutter/material.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class ForgetPwdPage extends StatefulWidget {
  @override
  _ForgetPwdPageState createState() => _ForgetPwdPageState();
}

class _ForgetPwdPageState extends State<ForgetPwdPage> {
  var _userId = TextEditingController(); //用户名
  var _userPhone = TextEditingController(); //手机号
  GlobalKey _globalKey = new GlobalKey<FormState>();

  //判断账号与手机号是否匹配
  Future<bool> _verify() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select userId from user where phone = ${_userPhone.text} and userId = ${_userId.text}'))
        .deStream();

    //匹配返回false，否则返回true
    if (result.isEmpty == true) {
      conn.close();
      return false;
    } else {
      conn.close();
      return true;
    }
  }

  //密码重置
  _reset() async {
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared(
        'Update user set userPassword = 123456 where userId = ?',
        [_userId.text]);
    conn.close();
  }

  Future<bool> _forgetPwd() async {
    //根据ID与手机是否匹配输出
    if (await _verify() == true) {
      _reset();
      showDialog(
          context: context,
          builder: (context) {
            //提示重置成功
            return AlertDialog(
              title: Text("提示"),
              content: Text("密码重置为：123456，请返回登录"),
              actions: <Widget>[
                FlatButton(
                  child: Text("确认",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 200, 0))),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/login", ModalRoute.withName("/login")); //返回登录页面
                  },
                )
              ],
            );
          });
      return true;
    } else {
      //提示账号与手机号不匹配
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("账号与手机号不匹配"),
              actions: <Widget>[
                FlatButton(
                  child: Text("确认",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 200, 0))),
                  onPressed: () {
                    Navigator.of(context).pop(true); //关闭对话框
                  },
                )
              ],
            );
          });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 200, 0),
          iconTheme: IconThemeData(
            color: Colors.black, //修改颜色
          ),
          title: Text("忘记密码", style: TextStyle(color: Colors.black)),
        ),
        body: Center(
            child: Form(
                key: _globalKey,
                // ignore: deprecated_member_use
                autovalidate: true,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 20,
                  ), //中间间隔
                  //账号输入
                  Container(
                    width: 400,
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: Color.fromARGB(255, 255, 200, 0)),
                        child: TextFormField(
                          controller: _userId,
                          decoration: InputDecoration(
                              labelText: "账号",
                              hintText: "输入你的账号",
                              icon: Icon(Icons.person)),
                        )),
                  ),

                  //手机号输入
                  Container(
                    width: 400,
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: Color.fromARGB(255, 255, 200, 0)),
                        child: TextFormField(
                          controller: _userPhone,
                          decoration: InputDecoration(
                              labelText: "手机号",
                              hintText: "输入你的手机号",
                              icon: Icon(Icons.phone)),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),

                  //找回密码按钮
                  SizedBox(
                    width: 300,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if ((_globalKey.currentState as FormState).validate()) {
                          _forgetPwd();
                        }
                      }, //忘记密码操作
                      child: Text(
                        "找回密码",
                        style: TextStyle(color: Colors.white), //字体白色
                      ),
                      color: Color.fromARGB(255, 255, 200, 0),
                    ),
                  ),
                ]))));
  }
}
