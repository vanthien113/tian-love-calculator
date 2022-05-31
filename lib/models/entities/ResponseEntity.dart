class ResponseEntity {
  String? fname;
  String? sname;
  String? percentage;
  String? result;

  ResponseEntity({this.fname, this.sname, this.percentage, this.result});

  ResponseEntity.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    sname = json['sname'];
    percentage = json['percentage'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fname'] = fname;
    data['sname'] = sname;
    data['percentage'] = percentage;
    data['result'] = result;
    return data;
  }
}
