import 'dart:typed_data';
import 'dart:core';

List<int> martial(int number) {
  const int radix = 8;
  BigInt bigInt = BigInt.from(number);
  final data = ByteData((bigInt.bitLength / radix).ceil());
  var _bigInt = bigInt;
  for (var i = 1; i <= data.lengthInBytes; i++) {
    data.setUint8(data.lengthInBytes - i, _bigInt.toUnsigned(radix).toInt());
    _bigInt = _bigInt >> radix;
  }

  return data.buffer.asUint8List().toList();
}

int unmartial(List<int> bytes) {
  //  https://github.com/appditto/nanodart/blob/master/lib/src/util.dart
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result.toUnsigned(64).toInt();
}

main() {
  print("Start");
  var res1 = martial(5);
  print(res1);
  print(unmartial(res1));

  res1 = martial(1633767686115);
  print(res1);
  print(unmartial(res1));
  // 1633767686115
  // 00000001 01111100 01100100 00100100 01111111 11100011
  // [1, 124, 100, 36, 127, 227]
}
