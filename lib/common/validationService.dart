import 'secureStorageService.dart' as SecureStorage;
import '../constants/secureStorageConstants.dart';
import '../constants/grantConstants.dart';

import '../api/visionGrammarApiService.dart' as VISION;
import '../model/apiResponse.dart';
import '../constants/apiConstants.dart';

class validationService {
  final SecureStorage.secureStorageservice _secureStorage =
      SecureStorage.secureStorageservice();

  final VISION.visionGrammarApiService _vision =
      VISION.visionGrammarApiService();

  Future<void> asyncGrant() async {
    Future<ApiResponse> apiResponse = _vision.checkDevice();
    String? deviceGrant =
        await _secureStorage.read(Securestorageconstants.GRANT);

    String? deviceName = await _secureStorage.read(Securestorageconstants.NAME);

    await apiResponse.then((response) => {
          if (response.result == apiConstants.RES_SUCCESS_CHECK)
            {
              if (deviceName != response.name)
                {
                  _secureStorage.write(
                      Securestorageconstants.NAME, response.name)
                },
              if (response.grant == false)
                {
                  if (deviceGrant != grantConstants.NO_PERMISSION)
                    {
                      _secureStorage.delete(Securestorageconstants.GRANT),
                      _secureStorage.write(Securestorageconstants.GRANT,
                          grantConstants.NO_PERMISSION),
                    }
                }
              else
                {
                  if (deviceGrant != grantConstants.PERMISSION)
                    {
                      _secureStorage.delete(Securestorageconstants.GRANT),
                      _secureStorage.write(Securestorageconstants.GRANT,
                          grantConstants.PERMISSION)
                    }
                }
            }
          else if (response.result == apiConstants.RES_NOT_EXIST_USER)
            {
              _secureStorage.delete(Securestorageconstants.NAME),
              _secureStorage.delete(Securestorageconstants.GRANT),
            },
        });
  }

  Future<String> checkingGrant() async {
    String? deviceGrant =
        await _secureStorage.read(Securestorageconstants.GRANT);

    if (deviceGrant == null || deviceGrant.isEmpty) {
      // 첫 접속 유저로 인지
      return grantConstants.NO_USER;
    } else if (deviceGrant == grantConstants.NO_USER) {
      // 첫 접속 유저로 인지
      return grantConstants.NO_USER;
    } else if (deviceGrant == grantConstants.NO_PERMISSION) {
      return grantConstants.NO_PERMISSION;
    } else if (deviceGrant == grantConstants.PERMISSION) {
      return grantConstants.PERMISSION;
    } else {
      return grantConstants.NO_USER;
    }
  }

  Future<String> checkingDevice() async {
    await asyncGrant();

    return checkingGrant();
  }
}
