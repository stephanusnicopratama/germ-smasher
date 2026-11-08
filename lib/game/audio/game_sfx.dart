import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class GameSfx {
  GameSfx()
      : _popBytes = _tone(freq: 740, seconds: 0.09, decay: 14),
        _missBytes = _tone(freq: 180, seconds: 0.16, decay: 8),
        _soapBytes = _tone(freq: 240, seconds: 0.12, decay: 10),
        _winBytes = _chime();

  final Uint8List _popBytes;
  final Uint8List _missBytes;
  final Uint8List _soapBytes;
  final Uint8List _winBytes;

  final AudioPlayer _pop = AudioPlayer();
  final AudioPlayer _miss = AudioPlayer();
  final AudioPlayer _soap = AudioPlayer();
  final AudioPlayer _win = AudioPlayer();

  bool enabled = true;

  void playPop() => _play(_pop, _popBytes);
  void playMiss() => _play(_miss, _missBytes);
  void playSoap() => _play(_soap, _soapBytes);
  void playWin() => _play(_win, _winBytes);

  void _play(AudioPlayer player, Uint8List bytes) {
    if (!enabled) {
      return;
    }
    player.play(BytesSource(bytes, mimeType: 'audio/wav'))        .then((_) {}, onError: (Object error, StackTrace stack) {});
  }

  static Uint8List _chime() {
    const rate = 22050;
    const seconds = 0.38;
    final n = (rate * seconds).round();
    final samples = List<double>.filled(n, 0);
    void add(double freq, double start, double length) {
      final from = (rate * start).round();
      final count = (rate * length).round();
      for (var i = 0; i < count && from + i < n; i++) {
        final t = i / rate;
        samples[from + i] += sin(2 * pi * freq * t) * exp(-t * 6) * 0.45;
      }
    }

    add(523, 0, 0.16);
    add(659, 0.1, 0.16);
    add(784, 0.2, 0.18);
    return _pack(samples);
  }

  static Uint8List _tone({
    required double freq,
    required double seconds,
    required double decay,
  }) {
    const rate = 22050;
    final n = (rate * seconds).round();
    final samples = List<double>.generate(n, (i) {
      final t = i / rate;
      return sin(2 * pi * freq * t) * exp(-t * decay) * 0.7;
    });
    return _pack(samples);
  }

  static Uint8List _pack(List<double> samples) {
    const rate = 22050;
    final n = samples.length;
    final data = ByteData(44 + n * 2);
    void writeStr(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        data.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeStr(0, 'RIFF');
    data.setUint32(4, 36 + n * 2, Endian.little);
    writeStr(8, 'WAVE');
    writeStr(12, 'fmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, rate, Endian.little);
    data.setUint32(28, rate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    writeStr(36, 'data');
    data.setUint32(40, n * 2, Endian.little);
    for (var i = 0; i < n; i++) {
      var sample = (samples[i] * 32767).round();
      if (sample > 32767) {
        sample = 32767;
      } else if (sample < -32768) {
        sample = -32768;
      }
      data.setInt16(44 + i * 2, sample, Endian.little);
    }
    return data.buffer.asUint8List();
  }
}
