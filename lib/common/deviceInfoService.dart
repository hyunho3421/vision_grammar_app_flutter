import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

import 'secureStorageService.dart';
import '../model/user.dart';
import '../constants/commonConstants.dart';

class deviceInfoService {
  static const MethodChannel _methodChannel = MethodChannel('deviceId');

  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      // final deviceInfoPlugin = DeviceInfoPlugin();
      // var androidInfo = await deviceInfoPlugin.androidInfo;
      // String deviceId = androidInfo.id;
      String? deviceId = await _methodChannel.invokeMethod<String?>('getId');
      // String? a =
      // print("@@@ getId : ${a}");

      return deviceId ?? "";
    } else {
      return commonConstants.NOT_OS;
    }
  }

  Future<String> getWifiIp() async {
    final NetworkInfo _networkInfo = NetworkInfo();

    String? ipAddress;

    try {
      ipAddress = await _networkInfo.getWifiIP();
    } catch (e) {
      ipAddress = 'err';
    }

    return ipAddress ?? 'none';
  }

  Future<User?> firstApp(String name) async {
    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      var androidInfo = await deviceInfoPlugin.androidInfo;

      String? deviceId =
          await _methodChannel.invokeMethod<String?>('getId') ?? "";
      // String deviceId = androidInfo.id;
      String model = androidInfo.model;
      int sdkInt = androidInfo.version.sdkInt;
      String release = androidInfo.version.release;
      String manufacturer = androidInfo.manufacturer;
      String brand = androidInfo.brand;
      String ip = await getWifiIp();

      return User(
          name: name,
          deviceId: deviceId,
          model: model,
          manufacturer: manufacturer,
          release: release,
          sdkInt: sdkInt,
          grant: false,
          brand: brand,
          ip: ip);
    } else {
      // 다른 플랫폼 지원안함.
      return null;
    }
  }
}
