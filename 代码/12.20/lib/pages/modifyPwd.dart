import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class ModifyPwdPage extends StatefulWidget {
  @override
  _ModifyPwdPageState createState() => _ModifyPwdPageState();
}

class _ModifyPwdPageState extends State<ModifyPwdPage> {
  var _userOldPwd = TextEditingController(); //密码
  var _userPwd = TextEditingController(); //手机号
  GlobalKey _globalKey = new GlobalKey<FormState>();

//判断账号与密码是否匹配
  Future<bool> _verify() async {
    var conn = await MySqlConnection.connect(connect);
    Results result = await (await conn.execute(
            'select userId from user where userId = $userId and userPassword = ${_userOldPwd.text}'))
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

//修改密码
  _change() async {
    var conn = await MySqlConnection.connect(connect);
    await conn.prepared('Update user set userPassword = ? where userId = ?',
        [_userPwd.text, userId]);
    conn.close();
  }

  Future<bool> _modify() async {
    //根据旧密码是否错误进行相应操作
    if (await _verify() == true) {
      _change(); //修改密码
      //对话框提示修改成功
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("密码修改完成"),
              actions: <Widget>[
                FlatButton(
                  child: Text("确认",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 200, 0))),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString("pwd", _userPwd.text); //修改缓存中密码
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true); //返回个人页面
                  },
                )
              ],
            );
          });
      return true;
    } else {
      //对话框提示密码错误
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("密码错误"),
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
          title: Text("修改密码", style: TextStyle(color: Colors.black)),
        ),
        body: Center(
            child: Form(
          key: _globalKey,
          // ignore: deprecated_member_use
          autovalidate: true,
          child: Column(
            children: <Widget>[
              //旧密码输入
              Container(
                  width: 400,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 255, 200, 0)),
                    child: TextFormField(
                      controller: _userOldPwd,
                      decoration: InputDecoration(
                        labelText: "旧密码",
                        hintText: "输入你的密码",
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                  )),

              //输入新密码
              Container(
                  width: 400,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 255, 200, 0)),
                    child: TextFormField(
                      controller: _userPwd,
                      decoration: InputDecoration(
                        labelText: "新密码",
                        hintText: "输入你的密码",
                        icon: Icon(Icons.lock),
                      ),
                      validator: (v) {
                        //新密码不少于6位
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
                  )),

              //确认新密码
              Container(
                  width: 400,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 255, 200, 0)),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "确认密码",
                        hintText: "确认你的密码",
                        icon: Icon(Icons.lock),
                      ),
                      validator: (v) {
                        //确认密码
                        if (v.trim().length != 0) {
                          return v.trim().compareTo(this._userPwd.text) == 0
                              ? null
                              : "两次密码不同";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),

              //修改密码按钮
              SizedBox(
                width: 300,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    if ((_globalKey.currentState as FormState).validate()) {
                      _modify(); //修改密码
                    }
                  },
                  child: Text(
                    "修改密码",
                    style: TextStyle(color: Colors.white), //字体白色
                  ),
                  color: Color.fromARGB(255, 255, 200, 0),
                ),
              ),
            ],
          ),
        )));
  }
}
