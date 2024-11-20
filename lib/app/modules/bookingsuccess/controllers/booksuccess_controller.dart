import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class BooksuccessController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var audioUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Add more detailed logging
    ever(audioUrl, (url) {
      print('Audio URL changed: $url');
      if (url.isNotEmpty) {
        playJingle();
      }
    });
  }

  Future<void> playJingle() async {
    print('Attempting to play jingle');
    print('Current audio URL: ${audioUrl.value}');
    
    if (audioUrl.value.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(audioUrl.value));
        print('Successfully started playing audio');
      } catch (e) {
        print('Detailed error playing audio: $e');
      }
    } else {
      print('Audio URL is empty. Cannot play jingle.');
    }
  }

  void updateAudioUrl(String url) {
    print('Updating audio URL to: $url');
    audioUrl.value = url;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
