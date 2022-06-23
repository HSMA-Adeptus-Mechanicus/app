import 'dart:math';

int compareStringNumbers(String a, String b) {
  List<String> sectionsA = a.split(RegExp(r"(?<=\d)(?!\d)|(?<!\d)(?=\d)"));
  List<String> sectionsB = b.split(RegExp(r"(?<=\d)(?!\d)|(?<!\d)(?=\d)"));
  for (int i = 0; i < min(sectionsA.length, sectionsB.length); i++) {
    if (RegExp(r"^\d+$").hasMatch(sectionsA[i]) &&
        RegExp(r"^\d+$").hasMatch(sectionsB[i])) {
      int diff = int.parse(sectionsA[i]) - int.parse(sectionsB[i]);
      if (diff != 0) {
        return diff;
      }
    }
    else {
      int diff = sectionsA[i].compareTo(sectionsB[i]);
      if (diff != 0) {
        return diff;
      }
    }
  }
  return sectionsA.length - sectionsB.length;
}
