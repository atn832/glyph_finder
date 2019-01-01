import 'dart:html';

CanvasElement canvas;  
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext('2d');
  ctx.font = '50px serif';
  ctx.textBaseline = 'top';
  ctx.fillText('녕', 0, 0);
  final sumOfValues = sum(ctx.getImageData(0, 0, 50, 50).data);
  querySelector('#output').text = 'Sum of pixel values: $sumOfValues';
}

int sum(List<int> data) {
  var total = 0;
  data.forEach((n) {
    total += n;
  });
  return total;
}
