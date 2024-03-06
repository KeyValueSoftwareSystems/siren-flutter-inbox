// ignore_for_file: constant_identifier_names

enum ErrorCode {
  ERR_INTERNAL_SERVER,
  ERR_UNAUTHORIZED,
  ERR_DUPLICATE_GROUP_NAME,
  ERR_NETWORK_ERROR;

  String toJson() => name;

  static ErrorCode fromJson(String json) => values.byName(json);
}
