import 'package:video_playbacker/functions/video_download_function.dart';

class AppBloc{

  void saveVideoBy(String url){
    VideoDownloadFunction.downloadVideoBy(url);
  }

  void dispose(){
    print("disposed");
  }
}