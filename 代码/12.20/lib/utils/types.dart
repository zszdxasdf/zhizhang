import 'package:flutter/material.dart';
import 'package:sqljocky5/sqljocky.dart';

int userId = 0; //用户id

//数据库连接
var connect = ConnectionSettings(
  user: "root",
  password: "y652x676R",
  host: "mlcmagic.mysql.rds.aliyuncs.com",
  port: 3306,
  db: "zhizhang",
);

//收入图标
var incomeIcons = [
  IconData(0xe615, fontFamily: 'MyIcons'),
  IconData(0xe697, fontFamily: 'MyIcons'),
  IconData(0xe629, fontFamily: 'MyIcons')
];

//收入类型
var incomeTypes = ["工资", "理财", "礼金"];

//支出图标
var payIcons = [
  IconData(0xe67b, fontFamily: 'MyIcons'),
  IconData(0xe646, fontFamily: 'MyIcons'),
  IconData(0xe60e, fontFamily: 'MyIcons'),
  IconData(0xe618, fontFamily: 'MyIcons'),
  IconData(0xe607, fontFamily: 'MyIcons'),
  IconData(0xe616, fontFamily: 'MyIcons'),
  IconData(0xe61c, fontFamily: 'MyIcons'),
  IconData(0xe679, fontFamily: 'MyIcons'),
  IconData(0xe63b, fontFamily: 'MyIcons'),
  IconData(0xe61d, fontFamily: 'MyIcons'),
  IconData(0xe85f, fontFamily: 'MyIcons'),
  IconData(0xe609, fontFamily: 'MyIcons'),
  IconData(0xe506, fontFamily: 'MyIcons'),
  IconData(0xe69b, fontFamily: 'MyIcons'),
  IconData(0xe743, fontFamily: 'MyIcons'),
  IconData(0xe70e, fontFamily: 'MyIcons'),
  IconData(0xe611, fontFamily: 'MyIcons'),
  IconData(0xe606, fontFamily: 'MyIcons'),
  IconData(0xe677, fontFamily: 'MyIcons')
];

//支出类型
var payTypes = [
  "餐饮美食",
  "服饰美容",
  "生活用品",
  "充值缴费",
  "交通出行",
  "通讯物流",
  "公益捐赠",
  "医疗健康",
  "住房物业",
  "图书教育",
  "酒店旅行",
  "爱车养车",
  "运动户外",
  "生活服务",
  "投资理财",
  "保险",
  "信用借还",
  "人情往来",
  "自定义"
];
