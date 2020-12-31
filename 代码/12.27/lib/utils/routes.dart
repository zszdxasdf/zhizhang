import 'package:flutter/material.dart';
import 'package:zhizhang/pages/login.dart';
import 'package:zhizhang/pages/add.dart';
import 'package:zhizhang/pages/modifyPWD.dart';
import 'package:zhizhang/pages/person.dart';
import 'package:zhizhang/pages/rank.dart';
import 'package:zhizhang/pages/register.dart';
import 'package:zhizhang/pages/forgetPwd.dart';
import 'package:zhizhang/pages/billDetail.dart';
import 'package:zhizhang/pages/changeIncome.dart';
import 'package:zhizhang/pages/changePay.dart';
import 'tabs.dart';

//路由
final routes = {
  "/bill": (context, {arguments}) => BillDatilPage(arguments: arguments), //账单明细
  "/changeIncome": (context, {arguments}) =>
      ChangeIncomePage(arguments: arguments), //修改收入页面
  "/changePay": (context, {arguments}) =>
      ChangePayPage(arguments: arguments), //修改支出页面
  "/modify": (context) => ModifyPwdPage(), //修改密码页面
  "/login": (context) => LoginPage(), //登录页面
  "/add": (context) => AddPage(), //增加账单页面
  "/rank": (context) => RankPage(), //排行榜页面
  "/person": (context) => PersonPage(), //个人页面
  "/register": (context) => RegisterPage(), //注册页面
  "/forgetPwd": (context) => ForgetPwdPage(), //忘记密码页面
  "/": (context) => Tabs() //主页面
};

var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
