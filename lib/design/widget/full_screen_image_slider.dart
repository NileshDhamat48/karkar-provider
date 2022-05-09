import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';
import 'package:karkar_provider_app/constants/utility.dart';
import 'package:karkar_provider_app/design/widget/back_arrow_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../constants/app_asstes.dart';

class FullScrennImageSlider extends StatefulWidget {
  const FullScrennImageSlider({
    required this.image,
    this.current = 0,
  });
  final String image;
  final int current;

  @override
  _FullScrennImageSliderState createState() => _FullScrennImageSliderState();
}

class _FullScrennImageSliderState extends State<FullScrennImageSlider> {
  int _current = 0;

  PageController pageController = PageController();
  @override
  void initState() {
    pageController = PageController(initialPage: widget.current);
    _current = widget.current;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bodybgcolor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(child: localNetworkImageViewer(_current)),
    );
  }

  localNetworkImageViewer(int index) {
    return Stack(
      children: <Widget>[
        PhotoViewGallery.builder(
          itemCount: 1,
          pageController: pageController,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: Utility.imageLoaderImage(
                widget.image,
                AppAssets().logo,
              ).image,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
            );
          },
          onPageChanged: (index) {
            _current = index;
            _notify();
          },
          // pageController: pageController,
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          scrollPhysics: const BouncingScrollPhysics(),
        )
      ],
    );
  }

  _notify() {
    if (mounted) setState(() {});
  }
}
