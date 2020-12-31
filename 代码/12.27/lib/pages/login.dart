import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/tabs.dart';
import 'package:zhizhang/utils/types.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userId = TextEditingController(); //用户名
  var _userPwd = TextEditingController(); //密码
  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空

  Future<int> _verify() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select userId from user where userId = ${_userId.text} and userPassword = ${_userPwd.text}'))
        .deStream();
    if (result.isEmpty == false) {
      userId = await result.map((r) => r.byName('userId')).single;
    }

    conn.close();
    return userId;
  }

  Future<bool> _login() async {
    //登录成功，跳转至主页面；登录失败提示
    if (await _verify() != 0) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new Tabs()),
          (route) => route == null);
      return true;
    } else {
      //对话框提示
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("账号或密码错误，请检查"),
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

  // 保存账号密码
  void _saveLoginMsg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", _userId.text);
    preferences.setString("pwd", _userPwd.text);
  }

  // 读取账号密码，并将值直接赋给账号框和密码框
  void _getLoginMsg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId.text = preferences.get("name");
    _userPwd.text = preferences.get("pwd");
  }

  //初始化
  @override
  void initState() {
    super.initState();
    _getLoginMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
        title: Text("登录", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          // ignore: deprecated_member_use
          autovalidate: true,
          child: Column(
            children: <Widget>[
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
                      key: Key("id"),
                      controller: _userId,
                      decoration: InputDecoration(
                          labelText: "账号",
                          hintText: "输入你的账号",
                          icon: Icon(Icons.person)),
                      validator: (v) {
                        return v.trim().length > 0 ? null : "账号不能为空"; //判断账号是否输入
                      },
                    )),
              ),

              //密码输入
              Container(
                  width: 400,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 255, 200, 0)),
                    child: TextFormField(
                      key: Key("password"),
                      controller: _userPwd,
                      decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "输入你的密码",
                        icon: Icon(Icons.lock),
                      ),
                      validator: (v) {
                        return v.trim().length > 0 ? null : "密码不能为空"; //判断密码是否输入
                      },
                      obscureText: true,
                    ),
                  )),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: Row(
                  //注册按钮
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 15,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "立即注册",
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Color.fromARGB(0, 255, 255, 255),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.8,
                    ), //中间间隔

                    //忘记密码按钮
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgetPwd");
                      },
                      child: Text(
                        "忘记密码？",
                        style: TextStyle(color: Colors.black), //字体白色
                      ),
                      color: Color.fromARGB(0, 255, 255, 255),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),

              //登录按钮
              SizedBox(
                width: 300,
                height: 50.0,
                child: RaisedButton(
                  key: Key('increment'),
                  onPressed: () {
                    if ((_globalKey.currentState as FormState).validate()) {
                      _login(); //登录
                      _saveLoginMsg(); //缓存账号密码
                    }
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.white), //字体白色
                  ),
                  color: Color.fromARGB(255, 255, 200, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
