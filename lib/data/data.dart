class Data {
  int code;
  String name;
  String depratment;
  int branchCode;
  String branchName;
  int managerID;
  int superUser;
  int webIDSales;
  String imei;

  Data(
      {this.code,
        this.name,
        this.depratment,
        this.branchCode,
        this.branchName,
        this.managerID,
        this.superUser,
        this.webIDSales,
        this.imei});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    depratment = json['Depratment'];
    branchCode = json['BranchCode'];
    branchName = json['BranchName'];
    managerID = json['ManagerID'];
    superUser = json['SuperUser'];
    webIDSales = json['WebIDSales'];
    imei = json['Imei'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Depratment'] = this.depratment;
    data['BranchCode'] = this.branchCode;
    data['BranchName'] = this.branchName;
    data['ManagerID'] = this.managerID;
    data['SuperUser'] = this.superUser;
    data['WebIDSales'] = this.webIDSales;
    data['Imei'] = this.imei;
    return data;
  }
}