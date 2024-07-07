class apiConstants {
  static const String REQ_REGIST = '/vision/regist';
  static const String REQ_CHECK = '/vision/check';
  static const String REQ_GRAMMAR = '/vision/grammar';

  // 응답
  static const String RES_SUCCESS_CHECK = 'SUCCESS_CHECK';
  static const String RES_SUCCESS_RESIT = 'SUCCESS_REGIT';
  static const String RES_SUCCESS_GRAMMAR = 'SUCCESS_GRAMMAR';
  static const String RES_NOT_AVAILABLE_OS = 'NOT_AVAILABLE_OS';
  static const String RES_SERVER_ERROR = 'SERVER_ERROR';
  static const String RES_EXIST_USER = 'ALREADY_EXIST_USER';
  static const String RES_NOT_EXIST_USER = 'NOT_EXIST_USER';
  static const String RES_NOT_GRANT = 'NOT_GRANT';
}
