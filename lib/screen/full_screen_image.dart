// ignore_for_file: must_be_immutable

import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:carelinemed/utils/custom_colors.dart';
import 'package:carelinemed/utils/customwidget.dart';

class FullScreenImage extends StatelessWidget {
  String? imageUrl;
  String? tag;

  FullScreenImage({super.key, this.imageUrl, this.tag});

  @override
  Widget build(BuildContext context) {

  final GlobalKey globalKey = GlobalKey();

  saveLocalImage() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    debugPrint("----------- boundary ----------- $boundary");
    ui.Image image = await boundary.toImage();
    debugPrint("----------- image ----------- $image");
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    debugPrint("----------- byteData ----------- $byteData");
    if (byteData != null) {
      final result = await ImageGallerySaverPlus.saveImage(byteData.buffer.asUint8List());
      showToastMessage("Image saved in gallery".tr);
      debugPrint("----------- result ----------- $result");
    }
  }
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag ?? "",
              child: RepaintBoundary(
                key: globalKey,
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                  imageUrl: imageUrl ?? "",
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: Get.height / 15,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BlackColor,
                      ),
                      child: Blur(
                        borderRadius: BorderRadius.circular(50),
                        colorOpacity: 0.50,
                        blurColor: Colors.grey.shade900,
                        overlay: Icon(
                          Icons.arrow_back,
                          color: WhiteColor,
                        ),
                        child: SizedBox(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => saveLocalImage(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BlackColor,
                      ),
                      child: Blur(
                        borderRadius: BorderRadius.circular(50),
                        colorOpacity: 0.50,
                        blurColor: Colors.grey.shade900,
                        overlay: Icon(
                          Icons.file_download_outlined,
                          color: WhiteColor,
                        ),
                        child: SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

