class User {
  String name;
  String deviceId;
  String model;
  String manufacturer;
  String release;
  int sdkInt;
  bool grant;
  String brand;
  String ip;

  User(
      {required this.name,
      required this.deviceId,
      required this.model,
      required this.manufacturer,
      required this.release,
      required this.sdkInt,
      required this.grant,
      required this.brand,
      required this.ip});

  factory User.checkDevice(String deviceId) {
    return User(
        name: "",
        deviceId: deviceId,
        model: "",
        manufacturer: "",
        release: "",
        sdkInt: 0,
        grant: false,
        brand: "",
        ip: "");
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        deviceId: json['deviceId'],
        model: json['model'],
        manufacturer: json['manufacturer'],
        release: json['release'],
        sdkInt: json['sdkInt'],
        grant: json['grant'],
        brand: json['brand'],
        ip: json['ip']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'deviceId': deviceId,
      'model': model,
      'manufacturer': manufacturer,
      'release': release,
      'sdkInt': sdkInt,
      'grant': grant,
      'brand': brand,
      'ip': ip
    };
  }
}
