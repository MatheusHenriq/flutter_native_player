package com.example.native_communication

import android.os.Handler
import android.os.Looper
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.Player
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class PlayerEventListener(var player: ExoPlayer, flutterEngine: FlutterEngine) :  EventChannel.StreamHandler, Player.Listener {
    private val eventChannelName = "playerListenerChannelTag"
    private var channelEvent  : EventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
    private var eventSink: EventChannel.EventSink? = null
    private  var handler : Handler = Handler()
    val  timerToSendCurrentTime : Long = 500
    private val timeChanged = Runnable { getCurrentPlayerPosition() }


    init {
        channelEvent.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun sendEvent(event : Any?) {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(event)
        }
    }

    private fun getCurrentPlayerPosition(){
        if(this.player.isPlaying){
            handler.postDelayed(timeChanged,timerToSendCurrentTime);
            val map = mapOf<String,Any>(
                "PlayerEvent" to "isPlaying",
                "currentTime" to ((player.currentPosition/1000)).toString(),
                "currentTimeInMilliseconds" to ((player.currentPosition)).toString(),
                )
            sendEvent(map)
        }
    }

    override fun onIsPlayingChanged(isPlaying: Boolean) {
        if (isPlaying) {
            handler.post(Runnable {
                handler.postDelayed(timeChanged, timerToSendCurrentTime);
            })

            val map = mapOf<String,Any>(
                "PlayerEvent" to "isPlaying",
                "currentTime" to ((player.currentPosition/1000)).toString(),
                "currentTimeInMilliseconds" to ((player.currentPosition)).toString()
            )

            sendEvent(map)
        } else {
            val map = mapOf<String,Any>(
                "PlayerEvent" to "isNotPlaying",
            )
            //sendEvent(map)
        }
    }

    override fun onPlaybackStateChanged(playbackState: Int) {
        when (playbackState) {
            Player.STATE_IDLE->{
                val map = mapOf<String,Any>(
                    "PlayerEvent" to "isIdle",
                )
                sendEvent(map)
                player.prepare();
            }
            Player.STATE_BUFFERING->{
                val map = mapOf<String,Any>(
                    "PlayerEvent" to "isBuffering",
                )
                sendEvent(map)
            }
            Player.STATE_READY->{
                val map = mapOf<String,Any>(
                    "PlayerEvent" to "isReady",
                    "duration" to (player.contentDuration/1000).toString(),
                    )
                sendEvent(map)
            }
            Player.STATE_ENDED->{
                val map = mapOf<String,Any>(
                    "PlayerEvent" to "isEnded",
                )
                sendEvent(map)
            }
            Player.EVENT_PLAYER_ERROR->{
                val map = mapOf<String,Any>(
                    "PlayerEvent" to "isError",
                )
                sendEvent(map)
            }
        }
    }

}