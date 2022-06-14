List<T> stableSort<T>(List<T> list, int Function(T a, T b) comp) {
  List<List<dynamic>> temp = List.filled(list.length, []);
  for (var i = 0; i < list.length; i++) {
    temp[i] = [list[i], i];
  }
  temp.sort((a, b) {
    var result = comp(a[0], b[0]);
    if (result != 0) {
      return result;
    } else {
      return a[1] - b[1];
    }
  });
  for (var i = 0; i < list.length; i++) {
    list[i] = temp[i][0];
  }
  return list;
}
