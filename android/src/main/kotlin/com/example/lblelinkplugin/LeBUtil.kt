package com.example.lblelinkplugin

import android.content.Context
import android.util.Log
import com.hpplay.sdk.source.api.IConnectListener
import com.hpplay.sdk.source.api.ILelinkPlayerListener
import com.hpplay.sdk.source.api.LelinkPlayerInfo
import com.hpplay.sdk.source.api.LelinkSourceSDK
import com.hpplay.sdk.source.browse.api.LelinkServiceInfo
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable

class LeBUtil private constructor() {
    var events: EventChannel.EventSink? = null
    val sdk: LelinkSourceSDK = LelinkSourceSDK.getInstance()
    val deviceList = mutableListOf<LelinkServiceInfo>()


    private fun initListener() {
        sdk.run {
            setBrowseResultListener { code, resultList ->
                deviceList.clear()
                deviceList.addAll(resultList)

                var finalList = deviceList.map {
                    mapOf("tvName" to it.name, "tvUID" to it.uid)
                }.toList()
                Observable.just(resultList).observeOn(AndroidSchedulers.mainThread()).subscribe {
                    events?.success(
                            buildResult(ResultType.seasch, finalList)
                    )
                }

            }
            setConnectListener(object : IConnectListener {
                override fun onConnect(p0: LelinkServiceInfo?, p1: Int) {

                }

                override fun onDisconnect(p0: LelinkServiceInfo?, p1: Int, p2: Int) {

                }
            })
            setPlayListener(object : ILelinkPlayerListener {
                override fun onLoading() {
    //                    events?.success( buildResult(ResultType.load))
                }

                override fun onPause() {
                    events?.success(Result().addParam("type", ResultType.pause))
                }

                override fun onCompletion() {
                    events?.success(Result().addParam("type", ResultType.complete))
                }

                override fun onStop() {
                    events?.success(Result().addParam("type", ResultType.stop))
                }

                override fun onSeekComplete(p0: Int) {
                    events?.success(Result().addParam("type", ResultType.seek))
                }

                override fun onInfo(p0: Int, p1: Int) {
                    events?.success(Result().addParam("type", ResultType.info))
                }

                override fun onVolumeChanged(p0: Float) {
                }

                override fun onPositionUpdate(p0: Long, p1: Long) {
                    events?.success(Result().addParam("type", ResultType.position))
                }

                override fun onError(p0: Int, p1: Int) {
                    events?.success(Result().addParam("type", ResultType.error))
                }

                override fun onStart() {
                    events?.success(Result().addParam("type", ResultType.start))
                }
            })
        }
    }

    companion object {
        val instance by lazy {
            LeBUtil()
        }
    }

    ///初始化SDK
    fun initUtil(ctx: Context, appId: String, secret: String, result: MethodChannel.Result) {
        Log.d("乐播云注册id", appId)
        Log.d("乐播云注册secret", secret)
        sdk.bindSdk(ctx, appId, secret) {
            Observable.just(it).observeOn(AndroidSchedulers.mainThread()).subscribe { result.success(it) }
            Log.d("乐播云注册", it.toString())
            if (it) {
                sdk.setDebugMode(true)
                initListener()
            }
        }
    }

    ///连接设备
    fun connectService(id: String, name: String) {
        var connectData: LelinkServiceInfo? = null
        deviceList.forEach {
            //循环数据
            if (id == it.uid && name == it.name) {//确定连接项
                connectData = it
            }
        }
        connectData?.run {
            sdk.connect(this)
        }

    }

    fun buildResult(type: Int, map: Any): Map<String, Any> {
        return mapOf<String, Any>("type" to type, "data" to map)
    }

    ///设备断链
    fun disConnect() {
        sdk.connectInfos.run {
            sdk.disConnect(this[0])
        }
    }

    ///暂停播放
    fun pause() {
        sdk.pause()
    }

    ///重新播放
    fun resumePlay() {
        sdk.resume()
    }

    ///停止播放
    fun stop() {
        sdk.stopPlay()
    }

    ///停止搜索
    fun stopSearch() {
        sdk.stopBrowse()
    }

    ///搜索设备
    fun searchDevice() {
        deviceList.clear()
        sdk.startBrowse()
    }

    fun play(url: String) {
        sdk.startPlayMedia(url, LelinkPlayerInfo.TYPE_VIDEO, false)
    }

    fun initEvent(events: EventChannel.EventSink?) {
        this.events = events
    }

    fun removeEvent() {
        events = null
    }

}