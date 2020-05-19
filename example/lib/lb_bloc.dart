import 'package:lblelinkplugin/lblelinkplugin.dart';

/**
 *
 * @ProjectName:    lblelink_plugin
 * @ClassName:      lb_bloc
 * @Description:    dart类作用描述
 * @Author:         孙浩
 * @QQ:             243280864
 * @CreateDate:     2020/5/19 9:45
 */
class LBbloc with LbCallBack {
  ///添加监听
  void addListener() {
    Lblelinkplugin.lbCallBack = this;
  }

  ///播放url地址需优先调用Connect
  void playByUrl(String url) {
    Lblelinkplugin.play(url);
  }

  ///播放暂停
  void playPause() {
    Lblelinkplugin.pause();
  }

  ///播放停止
  void playStop() {
    Lblelinkplugin.stop();
  }

  ///搜索数据
  void searchList() {
    Lblelinkplugin.getServicesList((data) {});
  }

  ///连接数据
  void connectData() {
    Lblelinkplugin.connectToService("uuId",
        fConnectListener: () {

        }, fDisConnectListener: () {

        });
  }

  ///断开连接
  void disConnect() {
    Lblelinkplugin.disConnect();
  }

  @override
  void complete() {
    // 完成事件回调
  }

  @override
  void error() {
    // 错误事件回调
  }

  @override
  void loading() {
    // 加载中事件回调
  }

  @override
  void start() {
    // 开始事件回调
  }

  @override
  void pause() {
    // 暂停事件回调
  }

  @override
  void stop() {
    // 停止事件回调
  }
}
