import 'dart:html';

// Must be smalle than the canvas.
var squareSize = 20;

enum Script {
  korean, chinese
}

void main() {
  // Must match the checked radio button.
  prepareAndCompute(Script.korean);

  final radios = querySelectorAll('input');
  radios.onClick.listen((e) {
    final target = e.target as InputElement;
    final scriptValue = target.value;
    final script = Script.values.firstWhere((e) => e.toString() == scriptValue);

    prepareAndCompute(script);
  });
}

void prepareAndCompute(Script script) {
  showText('Computing...');
  Future.delayed(Duration(seconds: 1), () {
    compute(script);
  });
}

void compute(Script script) {
  CanvasElement canvas = querySelector('#canvas');
  CanvasRenderingContext2D ctx = canvas.getContext('2d');
  ctx.font = '${squareSize}px sans-serif';
  ctx.textBaseline = 'top';

  List<CharacterData> characters = [];
  DateTime start = DateTime.now();
  for (String char in charactersToAnalyze(script)) {
    final value =  analyzeCharacter(ctx, char);
    characters.add(CharacterData(char, value));
  }
  Duration duration = DateTime.now().difference(start);
  print('Took ${duration.inSeconds} seconds');

  characters.sort((a, b) {
    final cmp = -a.value.compareTo(b.value);
    return cmp != 0 ? cmp : a.character.compareTo(b.character);
  });

  showText(characters.map((d) => d.character).join(' '));
}

int analyzeCharacter(CanvasRenderingContext2D ctx, String char) {
  ctx.clearRect(0, 0, squareSize, squareSize);
  ctx.fillText(char, 0, 0);
  final sumOfValues = sum(ctx.getImageData(0, 0, squareSize, squareSize).data);
  return sumOfValues;
}

int sum(List<int> data) {
  var total = 0;
  data.forEach((n) {
    total += n;
  });
  return total;
}

Iterable<String> charactersToAnalyze(Script script) sync* {
  switch(script) {
    // Hangul: 12k characters
    case Script.korean:
      for (var code = 0xAC00; code <= 0xAC05; code++)
        yield String.fromCharCode(code);
      for (var code = 0xAC00; code <= 0xD7A3; code++)
        yield String.fromCharCode(code);
      for (var code = 0x1100; code <= 0x11FF; code++)
        yield String.fromCharCode(code);
      for (var code = 0x3130; code <= 0x318F; code++)
        yield String.fromCharCode(code);
      for (var code = 0xA960; code <= 0xA97F; code++)
        yield String.fromCharCode(code);
      for (var code = 0xD7B0; code <= 0xD7FF; code++)
        yield String.fromCharCode(code);
      break;
    // Hanja: 22k characters
    case Script.chinese:
      for (var code = 0x4E00; code <= 0x9FFF; code++)
        yield String.fromCharCode(code);
      for (var code = 0xF900; code <= 0xFAFF; code++)
        yield String.fromCharCode(code);
      break;
    default:
      throw Exception('Not supported');
  }
}

void showText(String text) {
  querySelector('#output').text = text;
}

class CharacterData {
  String character;
  int value;

  CharacterData(this.character, this.value);
}
