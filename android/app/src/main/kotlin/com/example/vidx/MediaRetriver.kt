package com.example.vidx

import android.content.Context
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.provider.MediaStore
import android.util.Log


enum class MediaType{
    IS_VIDEO,
    IS_IMAGE
}

class MediaRetriever(context: Context)  {

  private var  ctx : Context = context

    private fun retrieveMediaMetadata(mediaUri : Uri, mediaType: MediaType): Map<String, Any?>{
        val resolver = ctx.contentResolver

        var mediaPathUri : Uri? = null
        var mediaDisplayName : String? = null
        var mediaSize : Long? = null
        var mediaImageHeigh: String? = null
        var mediaImageWidth : String? = null
        var mediaVideoHeight : String? = null
        var mediaVideoWidth : String? = null
        var mediaVideoDuration : String? = null
        var mediaByte : ByteArray? = null


   try{

        val projection =  if(mediaType == MediaType.IS_IMAGE){
            arrayOf(
                    MediaStore.Files.FileColumns.DISPLAY_NAME,
                    MediaStore.Files.FileColumns.SIZE,
                    MediaStore.Images.Media.HEIGHT,
                    MediaStore.Images.Media.WIDTH
                )
        }else{
                arrayOf(
                    MediaStore.Files.FileColumns.DISPLAY_NAME,
                    MediaStore.Files.FileColumns.SIZE,
                    MediaStore.Video.Media.HEIGHT,
                    MediaStore.Video.Media.WIDTH,
                    MediaStore.Video.Media.DURATION,
                )
        }



            resolver.query(
                mediaUri,
                projection,
                null,
                null,
                null
            )?.use { cursor ->

                if(cursor.moveToFirst()){
                    val dName = cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DISPLAY_NAME)
                    val size = cursor.getColumnIndexOrThrow((MediaStore.Files.FileColumns.SIZE))

                    if(mediaType == MediaType.IS_IMAGE){
                        val iHeight = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.HEIGHT)
                        val iWidth = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.WIDTH)
                        mediaImageHeigh = cursor.getString(iHeight)
                        mediaImageWidth = cursor.getString(iWidth)
                    }else{
                        val vHeight = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.HEIGHT)
                        val vWidth = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.WIDTH)
                        val vDuration = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION)
                        mediaVideoHeight = cursor.getString(vHeight)
                        mediaVideoWidth = cursor.getString(vWidth)
                        mediaVideoDuration = cursor.getString(vDuration)
                    }

                    mediaDisplayName = cursor.getString(dName)
                    mediaSize = cursor.getLong(size)
                }

            }

            resolver.openInputStream(mediaUri)?.use { stream ->
                 if(mediaSize != null){
                     mediaByte = ByteArray(mediaSize.toInt())
                    stream.read(mediaByte)
                 }
            }

            if(mediaType == MediaType.IS_IMAGE){
                return mapOf<String, Any?>(
                    "mediaTitle" to mediaDisplayName,
                    "mediaSize" to mediaSize,
                    "mediaImageHeight" to mediaImageHeigh,
                    "mediaImageWidth" to mediaImageWidth,
                    "mediaByte" to mediaByte
                )
            }else{
                return mapOf<String,Any?>(
                    "mediaTitle" to mediaDisplayName,
                    "mediaSize" to mediaSize,
                    "mediaVideoHeight" to mediaVideoHeight,
                    "mediaVideoWidth" to mediaVideoWidth,
                    "mediaVideoDuration" to mediaVideoDuration,
                    "mediaByte" to mediaByte
                )
            }

        }catch (e: Exception){
            Log.d("MediaRetriever","File not found: ${e.message} ${e.stackTrace}")
            return mapOf<String, Any?>()
        }
    }

    fun getSelectedImage(mediaUri: Uri?): Map<String, Any?>{

        Log.d("MediaUri","$mediaUri")
        return if(mediaUri!= null){
            retrieveMediaMetadata(mediaUri, MediaType.IS_IMAGE)
        }else{
            mapOf<String,Any?>()
        }
    }

    fun getSelectedVideo(mediaUri : Uri?) : Map<String, Any?>{
        Log.d("MediaUri","$mediaUri")
        return if(mediaUri!= null){
            retrieveMediaMetadata(mediaUri, MediaType.IS_VIDEO)
        }else{
            mapOf<String, Any?>()
        }
    }


}