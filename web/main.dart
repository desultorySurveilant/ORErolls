import 'dart:html';
import 'dart:math';

void main() {
  int p1 = 0;
  int p2 = 0;
  TextInputElement p1ele = querySelector('#p1');
  TextInputElement p2ele = querySelector('#p2');
//  p1ele.value = "74";
  querySelector("#sRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    p2 = int.parse(p2ele.value);
    querySelector("#output").text = sRoll(p1, p2);
  });
  querySelector("#mRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    p2 = int.parse(p2ele.value);
    //mRoll();
  });
}

String sRoll(int p1, int p2){
  var rand = Random();
  String ret = "";
  List<int> rolls1 = [];
  List<int> rolls2 = [];
  ret += "Player 1 rolls: ";
  for(int i = 0; i < p1; i++){
    rolls1.add(rand.nextInt(10)+1);
    ret += "${rolls1[i]}, ";
  }
  ret += "\nHighest Set: ${getHighSet(rolls1)}";
  ret += "\nWidest Set: ${getWideSet(rolls1)}\n\n";
  ret += "Player 1 rolls: ";
  for(int i = 0; i < p2; i++){
    rolls2.add(rand.nextInt(10)+1);
    ret += "${rolls2[i]}, ";
  }
  ret += "\nHighest Set: ${getHighSet(rolls2)}";
  ret += "\nWidest Set: ${getWideSet(rolls2)}";
  return ret;
}
String getHighSet(List<int> rolls){
  int height = 10;
  int width = 0;
  while(height > 0) {
    for (int i = 0; i < rolls.length; i++) {
      if(rolls[i] == height) width++;
    }
    if (width >= 2) return "$width x $height";
    width = 0;
    height--;
  }
  return "0 x 0";
}
String getWideSet(List<int> rolls){
  int height = 10;
  int width = 0;

  int widest = 0;
  int highest = 0;
  while(height > 0) {
    for (int i = 0; i < rolls.length; i++) {
      if(rolls[i] == height) width++;
    }
    if(width > widest && width >= 2){
      widest = width;
      highest = height;
    }
    width = 0;
    height--;
  }
  return "$widest x $highest";
}
List<int> parseRoll(String roll){
  return [int.parse(roll.substring(0,roll.indexOf(' '))), int.parse(roll.substring(roll.indexOf('x') + 2))];
}