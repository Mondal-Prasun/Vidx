package com.example.vidx

import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val methodChannel : String = "VIDX_CHANNEL"
    private var mediaRetriever : MediaRetriever = MediaRetriever(this)

    private var pendingResult : MethodChannel.Result? = null

    private var mediaType : MediaType? = null

    val pickMedia = registerForActivityResult(ActivityResultContracts.PickVisualMedia()){ uri ->
        if(mediaType == MediaType.IS_IMAGE){
            val res = mediaRetriever.getSelectedImage(uri)
            Log.d("Image", "$res")
            pendingResult?.success(res)
        }else{
            val res = mediaRetriever.getSelectedVideo(uri)
            Log.d("Video", "$res")
            pendingResult?.success(res)
        }
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
            ).setMethodCallHandler { call, result ->

                when(call.method) {
                    "selectImage" ->{
                        pendingResult = result
                        mediaType = MediaType.IS_IMAGE
                        pickMedia.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))
                    }
                    "selectVideo" ->{
                        pendingResult = result
                        mediaType = MediaType.IS_VIDEO
                        pickMedia.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.VideoOnly))
                    }
                }

        }

    }

    override fun onDestroy() {
        super.onDestroy()
        pickMedia.unregister()
    }

}
