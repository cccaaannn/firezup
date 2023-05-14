class StringUtils {
  static String splitName(String? idWithName) {
    if (idWithName == null) {
      return "";
    }
    List<String> split = idWithName.split("_");

    if (split.length != 2) {
      return "";
    }

    return split[1];
  }
}
