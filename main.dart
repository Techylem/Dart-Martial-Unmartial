import 'dart:typed_data' show ByteData;

List<int> martial(int number) {
  const int radix = 8;
  BigInt bigInt = BigInt.from(number);
  final data = ByteData((bigInt.bitLength / radix).ceil());
  var _bigInt = bigInt;
  for (var i = 0; i < data.lengthInBytes; i++) {
    data.setUint8(i, _bigInt.toUnsigned(radix).toInt());
    _bigInt = _bigInt >> 7;
  }

  return data.buffer.asUint8List().toList();
}

int unmartial(List<int> bytes) {
  const MaxVarintLen64 = 10;
	BigInt x = BigInt.from(0);
	int s = 0;
  for(var i = 0; i< bytes.length; i++){
    if (i == MaxVarintLen64) {
			return 0 ;//, -(i + 1) // overflow
		}
    if (bytes[i] < 0) {
			if (i == MaxVarintLen64-1 && bytes[i] > 1 ){
				return 0; //, -(i + 1) // overflow
			}
			return (x | BigInt.from(bytes[i])<<s).toInt() ; //, i + 1
		}
    x |= (BigInt.from(bytes[i] & 0x7F ) ) << s;
		s += 7;
  }
  return x.toInt();
}

main() {
  print("Start");
  var res1 = martial(5);
  print(res1);
  print(unmartial(res1));

  res1 = martial(1633767686115);
  print(res1);
  print(unmartial(res1));


}
