import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';


CachedNetworkImage cachedNetworkImage(String image, {required imagePath,width=null,height=null,onFailed}) {
  return CachedNetworkImage(
      fit: BoxFit.cover,
      // imageUrl: DataSourceURL.baseUrl + imagePath + image,
      imageUrl: DataSourceURL.baseImagesUrl + image,
      //
      placeholder: (context, url) => Center(
              child: Image.asset(
            "assets/images/delivery.gif",
            fit: BoxFit.cover,
            height:height ?? double.infinity,
            width: width ?? double.infinity,
          )),
      errorWidget: (context, url, error) {
          if(onFailed!=null)  onFailed();
        return Center(
            child: Image.asset(
          "assets/images/background2.jpg",
          fit: BoxFit.cover,
          height: height ?? double.infinity,
          width: width ?? double.infinity,
        ));
      });
}

