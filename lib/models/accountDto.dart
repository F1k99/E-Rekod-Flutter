import 'dart:convert';

AccountDto accountDtoFromJson(String str) =>
    AccountDto.fromJson(json.decode(str));

String accountDtoToJson(AccountDto data) => json.encode(data.toJson());

class AccountDto {
  AccountDto(
      {this.startingAmt, this.incomeAmt, this.expenseAmt, this.inc, this.exp});

  int? startingAmt;
  int? incomeAmt;
  int? expenseAmt;
  int? inc;
  int? exp;

  factory AccountDto.fromJson(Map<String, dynamic> json) => AccountDto(
      startingAmt: json["startingAmt"],
      incomeAmt: json["incomeAmt"],
      expenseAmt: json["expenseAmt"],
      inc: json["inc"],
      exp: json["exp"]);

  Map<String, dynamic> toJson() => {
        "startingAmt": startingAmt,
        "incomeAmt": incomeAmt,
        "expenseAmt": expenseAmt,
        "inc": inc,
        "exp": exp
      };
}
