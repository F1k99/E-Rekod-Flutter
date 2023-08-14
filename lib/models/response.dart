class ResponseDto {
  ResponseDto({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic data;

  factory ResponseDto.fromJson(Map<String, dynamic> json) => ResponseDto(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}

class Data {
  Data({
    this.result,
    this.maxRowCount,
    this.currentPage,
    this.maxPage,
  });

  dynamic result;
  int? maxRowCount;
  int? currentPage;
  int? maxPage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"],
        maxRowCount: json["maxRowCount"],
        currentPage: json["currentPage"],
        maxPage: json["maxPage"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "maxRowCount": maxRowCount,
        "currentPage": currentPage,
        "maxPage": maxPage,
      };
}
