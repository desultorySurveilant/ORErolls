import 'dart:html';
import 'dart:math';

void main() {
  querySelector("#sRoll").onClick.listen((e) {
    querySelector("#output").text = sRoll();
  });
  querySelector("#mRoll").onClick.listen((e) {
    //mRoll();
  });
}

String sRoll(){
  var p1 = getVal("p1");
  var p2 = getVal("p2");
  var rand = Random();
  String ret = "";
  List rolls1 = [];
  List rolls2 = [];
  for(int i = 0; i < p1; i++){
    rolls1.add(rand.nextInt(10)+1);
    ret += "${rolls1[i]}, ";
  }
  ret += "\n";
  for(int i = 0; i < p2; i++){
    rolls2.add(rand.nextInt(10)+1);
    ret += "${rolls2[i]}, ";
  }
  return ret;
}

int getVal(String id) => int.parse(getValString(id));
String getValString(String id) => querySelector("#$id").getAttribute("value");