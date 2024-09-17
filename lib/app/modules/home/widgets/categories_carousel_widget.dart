import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: _category);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      margin: EdgeInsetsDirectional.only(
                          start: index == 0 ? 20 : 0, end: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              _category.color!.withOpacity(1),
                              _category.color!.withOpacity(0.1)
                            ],
                            begin: AlignmentDirectional.topStart,
                            //const FractionalOffset(1, 0),
                            end: AlignmentDirectional.bottomEnd,
                            stops: [0.1, 0.9],
                            tileMode: TileMode.clamp),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Get.theme.colorScheme.secondary
                                .withOpacity(.4)),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          (_category.image!.url!.toLowerCase().endsWith('.svg')
                              ? SvgPicture.network(
                                  _category.image!.url!,
                                  color: _category.color,
                                  height: 65.0,
                                  width: 65.0,
                                )
                              : CachedNetworkImage(
                                  height: 50,
                                  width: 50.0,
                                  fit: BoxFit.contain,
                                  imageUrl: _category.background!,
                                  placeholder: (context, url) => Image.asset(
                                        'assets/img/loading.gif',
                                        fit: BoxFit.cover,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: index == 0 ? 20 : 0, end: 20.0),
                      child: Text(
                        _category.name!,
                        maxLines: 2,
                        style: Get.textTheme.bodyText2!.merge(TextStyle(
                            color: Get.theme.colorScheme.secondary,
                            fontSize: 11.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
