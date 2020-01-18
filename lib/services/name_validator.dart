class NameValidator {
  static bool isLetter(String c) {
    return (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) ||
        (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122);
  }

  static bool isSpace(String c) {
    return c.codeUnitAt(0) == 32;
  }

  static bool validate(String name) {
    int index = 0;
    if (name.isEmpty || name.length >= 100) return false;

    while (index < name.length - 1) {
      if (!isLetter(name.substring(index, index + 1)) &&
          !isSpace(name.substring(index, index + 1))) {
        return false;
      }
      index++;
    }
    return true;
  }
}
