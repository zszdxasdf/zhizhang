class Bill {
  int billId; //账单id
  int billTypesId; //账单类型
  int billFromId; //账单类别
  double billAmount; //账单金额
  int billYear; //账单年
  int billMonth; //账单月
  int billDay; //账单日
  int billHour; //账单时
  String billRemark; //账单备注

  Bill(this.billFromId, this.billTypesId,
      [this.billId,
      this.billAmount,
      this.billYear,
      this.billMonth,
      this.billDay,
      this.billHour,
      this.billRemark]);
}
