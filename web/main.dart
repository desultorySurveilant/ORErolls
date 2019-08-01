import 'dart:html';
import 'dart:math';

void main() {
  int p1 = 0;
  int p2 = 0;
  int t = 0;
  int m = 0;
  TextInputElement p1ele = querySelector('#p1');
  TextInputElement p2ele = querySelector('#p2');
  TextInputElement tele = querySelector('#t');
  TextInputElement mele = querySelector('#rolls');

  querySelector("#sRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    p2 = int.parse(p2ele.value);
    querySelector("#output").text = sRoll(p1, p2);
  });
  querySelector("#tRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    t = int.parse(tele.value);
    querySelector("#output").text = tRoll(p1, t);
  });
  querySelector("#mRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    p2 = int.parse(p2ele.value);
    m = int.parse(mele.value);
    querySelector("#output").text = mRoll(p1, p2, m);
  });
  querySelector("#mtRoll").onClick.listen((e) {
    p1 = int.parse(p1ele.value);
    t = int.parse(tele.value);
    m = int.parse(mele.value);
    querySelector("#output").text = mtRoll(p1, t, m);
  });
}

String sRoll(int p1, int p2) {
  var rand = Random();
  String ret = "";
  List<int> rolls1 = [];
  List<int> rolls2 = [];
  String outcome = "ERROR!";
  ret += "Player 1 rolls: ";
  for (int i = 0; i < p1; i++) {
    rolls1.add(rand.nextInt(10) + 1);
    ret += "${rolls1[i]}, ";
  }
  ret += "\nHighest Set: ${getHighSet(rolls1)}";
  ret += "\nWidest Set: ${getWideSet(rolls1)}\n\n";
  ret += "Player 2 rolls: ";
  for (int i = 0; i < p2; i++) {
    rolls2.add(rand.nextInt(10) + 1);
    ret += "${rolls2[i]}, ";
  }
  outcome = getOutcome(rolls1, rolls2).toString();
  outcome = outcome.substring(outcome.indexOf('.') + 1);
  ret += "\nHighest Set: ${getHighSet(rolls2)}";
  ret += "\nWidest Set: ${getWideSet(rolls2)}";
  ret += "\n\n" + outcome;
  return ret;
}

String mRoll(int p1, int p2, int m) {
  var rand = Random();
  String ret = "";
  List<int> rolls1 = [];
  List<int> rolls2 = [];
  ContestOutcome outcome;
  List<int> outcomes = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  for (int i = 0; i < m; i++) {
    rolls1 = [];
    for (int i = 0; i < p1; i++) {
      rolls1.add(rand.nextInt(10) + 1);
    }
    rolls2 = [];
    for (int i = 0; i < p2; i++) {
      rolls2.add(rand.nextInt(10) + 1);
    }
    outcome = getOutcome(rolls1, rolls2);
    switch (outcome) {
      case ContestOutcome.winFast:
        outcomes[0]++;
        break;
      case ContestOutcome.win:
        outcomes[1]++;
        break;
      case ContestOutcome.winSlow:
        outcomes[2]++;
        break;
      case ContestOutcome.tieFast:
        outcomes[3]++;
        break;
      case ContestOutcome.tie:
        outcomes[4]++;
        break;
      case ContestOutcome.tieSlow:
        outcomes[5]++;
        break;
      case ContestOutcome.failFast:
        outcomes[6]++;
        break;
      case ContestOutcome.fail:
        outcomes[7]++;
        break;
      case ContestOutcome.failSlow:
        outcomes[8]++;
        break;
    }
  }
  int wins = outcomes[0] + outcomes[1] + outcomes[2];
  int ties = outcomes[3] + outcomes[4] + outcomes[5];
  int fails = outcomes[6] + outcomes[7] + outcomes[8];
  ret += "Wins: ${wins / m} ($wins)";
  ret += "\n  fast: ${outcomes[0] / m} (${outcomes[0]})";
  ret += "\n  reg: ${outcomes[1] / m} (${outcomes[1]})";
  ret += "\n  slow: ${outcomes[2] / m} (${outcomes[2]})";
  ret += "\nTies: ${ties / m} ($ties)";
  ret += "\n  fast: ${outcomes[3] / m} (${outcomes[3]})";
  ret += "\n  reg: ${outcomes[4] / m} (${outcomes[4]})";
  ret += "\n  slow: ${outcomes[5] / m} (${outcomes[5]})";
  ret += "\nFails: ${fails / m} ($fails)";
  ret += "\n  fast: ${outcomes[6] / m} (${outcomes[6]})";
  ret += "\n  reg: ${outcomes[4] / m} (${outcomes[7]})";
  ret += "\n  slow: ${outcomes[8] / m} (${outcomes[8]})";
  return ret;
}

String tRoll(int p1, int t) {
  var rand = Random();
  String ret = "";
  List<int> rolls = [];
  String high = "";
  ret += "Target: $t";
  ret += "\nPlayer 1 rolls: ";
  for (int i = 0; i < p1; i++) {
    rolls.add(rand.nextInt(10) + 1);
    ret += "${rolls[i]}, ";
  }
  high = getHighSet(rolls);
  ret += "\nHighest Set: $high";
  ret += "\n" + (parseRoll(high)[1] > t ? "Success" : "Failure");
  return ret;
}

String mtRoll(int p1, int t, int m) {
  var rand = Random();
  String ret = "";
  List<int> rolls = [];
  String high = "";
  int wins = 0;
  int fails = 0;
  for (int i = 0; i < m; i++) {
    rolls = [];
    for (int i = 0; i < p1; i++) {
      rolls.add(rand.nextInt(10) + 1);
    }
    high = getHighSet(rolls);
    parseRoll(high)[1] > t ? wins++ : fails++;
  }
  ret += "Target: $t";
  ret += "\nWins: ${wins / m} ($wins)";
  ret += "\nFails: ${fails / m} ($fails)";
  return ret;
}

ContestOutcome getOutcome(List<int> r1, List<int> r2) {
  List<int> high1 = parseRoll(getHighSet(r1));
  List<int> high2 = parseRoll(getHighSet(r2));
  if (high1[1] == high2[1]) {
    if (high1[0] > high2[0]) {
      return ContestOutcome.tieFast;
    } else if (high2[0] > high1[0]) {
      return ContestOutcome.tieSlow;
    } else {
      return ContestOutcome.tie;
    }
  } else if (high2[1] > high1[1]) {
    high2 = parseRoll(getWideSet(r2, high1[1]));
    if (high2[0] > high1[0]) {
      return ContestOutcome.failSlow;
    } else if (high1[0] > high2[0]) {
      return ContestOutcome.failFast;
    } else {
      return ContestOutcome.fail;
    }
  } else {
    high1 = parseRoll(getWideSet(r1, high2[1]));
    if (high1[0] > high2[0]) {
      return ContestOutcome.winFast;
    } else if (high2[0] > high1[0]) {
      return ContestOutcome.winSlow;
    } else {
      return ContestOutcome.win;
    }
  }
}

String getHighSet(List<int> rolls) {
  int height = 10;
  int width = 0;
  while (height > 0) {
    for (int i = 0; i < rolls.length; i++) {
      if (rolls[i] == height) width++;
    }
    if (width >= 2) return "$width x $height";
    width = 0;
    height--;
  }
  return "0 x 0";
}

String getWideSet(List<int> rolls, [int min = 0]) {
  int height = 10;
  int width = 0;

  int widest = 0;
  int highest = 0;
  while (height > min) {
    for (int i = 0; i < rolls.length; i++) {
      if (rolls[i] == height) width++;
    }
    if (width > widest && width >= 2) {
      widest = width;
      highest = height;
    }
    width = 0;
    height--;
  }
  return "$widest x $highest";
}

List<int> parseRoll(String roll) {
  return [
    int.parse(roll.substring(0, roll.indexOf(' '))),
    int.parse(roll.substring(roll.indexOf('x') + 2))
  ];
}

enum ContestOutcome {
  winFast,
  win,
  winSlow,
  tieFast,
  tie,
  tieSlow,
  failFast,
  fail,
  failSlow
}
