import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _userId = 0;
  var _userName = TextEditingController(); //用户名
  var _userPwd = TextEditingController(); //密码
  var _userPhone = TextEditingController(); //手机号
  GlobalKey _globalKey = new GlobalKey<FormState>();

  //判断手机号是否被注册
  Future<bool> _verify() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select userId from user where phone = ${_userPhone.text}'))
        .deStream();

    if (result.isEmpty == true) {
      conn.close();
      return false;
    } else {
      conn.close();
      return true;
    }
  }

//注册
  _add() async {
    var conn = await MySqlConnection.connect(connect);
    Results result =
        await (await conn.execute('Select max(userId) as max from user'))
            .deStream();
    _userId = result.map((r) => r.byName('max')).single + 1;

    await conn.prepared(
        'Insert into user (userId,username,userPassword,phone,num)values(?,?,?,?,0)',
        [_userId, _userName.text, _userPwd.text, _userPhone.text]);
    conn.close();
  }

  //根据手机号是否被注册进行操作
  Future<bool> _register() async {
    if (await _verify() == false) {
      //手机号未被注册
      await _add();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("注册完成，您的ID为$_userId，该ID用于登陆或忘记密码，请注意保存"),
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
      //手机号被注册
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("手机号已注册"),
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
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
        title: Text("注册", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
          child: Form(
        key: _globalKey,
        // ignore: deprecated_member_use
        autovalidate: true,
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Color.fromARGB(255, 255, 200, 0)),
                  child: TextFormField(
                    controller: _userName,
                    decoration: InputDecoration(
                        labelText: "昵称",
                        hintText: "输入你的昵称",
                        icon: Icon(Icons.person)),
                    validator: (v) {
                      //昵称不能为空且要小于6位
                      if (v.trim().length > 0) {
                        return v.trim().length < 7 ? null : "昵称不能大于6位";
                      }
                      return "昵称不能为空";
                    },
                  )), //输入昵称
            ),
            Container(
                width: 400,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Color.fromARGB(255, 255, 200, 0)),
                  child: TextFormField(
                    controller: _userPwd,
                    decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "输入你的密码",
                      icon: Icon(Icons.lock),
                    ),
                    validator: (v) {
                      //密码不低于6位
                      if (v.trim().length != 0) {
                        if (v.trim().length < 17) {
                          return v.trim().length > 5 ? null : "密码不低于6位";
                        } else {
                          return "密码不大于16位";
                        }
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                )), //输入密码
            Container(
                width: 400,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Color.fromARGB(255, 255, 200, 0)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "确认密码",
                      hintText: "确认你的密码",
                      icon: Icon(Icons.lock),
                    ),
                    validator: (v) {
                      //两次密码不同
                      if (v.trim().length != 0) {
                        return v.trim().compareTo(this._userPwd.text) == 0
                            ? null
                            : "两次密码不同";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                )), //确认密码
            Container(
              width: 400,
              child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Color.fromARGB(255, 255, 200, 0)),
                  child: TextFormField(
                    inputFormatters: [
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly
                    ], //只允许输入数字
                    controller: _userPhone,
                    decoration: InputDecoration(
                        labelText: "手机号",
                        hintText: "输入你的手机号",
                        icon: Icon(Icons.phone)),
                    validator: (v) {
                      //手机号是否符合规定
                      if (v.trim().length != 0) {
                        return v.trim().length == 11 ? null : "手机号不符合规定";
                      }
                      return null;
                    },
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),

            //注册按钮
            SizedBox(
              width: 300,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  if ((_globalKey.currentState as FormState).validate()) {
                    _register();
                  }
                },
                child: Text(
                  "注册",
                  style: TextStyle(color: Colors.white), //字体白色
                ),
                color: Color.fromARGB(255, 255, 200, 0),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
