import 'package:flutter_test/flutter_test.dart';
import 'package:germ_smasher/game/config/score_book.dart';

void main() {
  test('combo and quick smash raise the score', () {
    final book = ScoreBook();
    expect(book.smash(now: 0, quick: true), 15);
    expect(book.smash(now: 0.4, quick: false), 20);
    expect(book.score, 35);
    expect(book.combo, 2);
  });

  test('a miss breaks the combo and costs a heart', () {
    final book = ScoreBook();
    book.smash(now: 0, quick: false);
    book.miss();
    expect(book.combo, 0);
    expect(book.hearts, 3);
    expect(book.score, 5);
  });

  test('soap is a penalty when tapped and a small bonus when ignored', () {
    final book = ScoreBook();
    book.soapSaved();
    expect(book.score, 2);
    book.soapHit();
    expect(book.score, 0);
    expect(book.hearts, 3);
  });
}
