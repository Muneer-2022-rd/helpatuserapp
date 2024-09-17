// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../routes/app_routes.dart';
// import '../controllers/home_controller.dart';
//
// class CitiesCarouselWidget extends GetWidget<HomeController> {
//   @override
//   Widget build(BuildContext context) {
//     print( controller.cities.length);
//     print( 'ji');
//     return Container(
//       height: 130,
//       margin: EdgeInsets.only(bottom: 15),
//       child: Obx(() {
//         return ListView.builder(
//             primary: false,
//             shrinkWrap: false,
//             scrollDirection: Axis.horizontal,
//             itemCount: controller.cities.length,
//
//             itemBuilder: (_, index) {
//               var _city = controller.cities.elementAt(index);
//               return InkWell(
//                 onTap: () {
//                   Get.toNamed(Routes.CITIES, arguments: _city);
//                 },
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0),
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   decoration: new BoxDecoration(
//                     // gradient: new LinearGradient(
//                     //     // colors: [_city.color.withOpacity(1), _city.color.withOpacity(0.1)],
//                     //     begin: AlignmentDirectional.topStart,
//                     //     //const FractionalOffset(1, 0),
//                     //     end: AlignmentDirectional.bottomEnd,
//                     //     stops: [0.1, 0.9],
//                     //     tileMode: TileMode.clamp),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: Stack(
//                     alignment: AlignmentDirectional.topStart,
//                     children: [
//                       Padding(
//                         padding: EdgeInsetsDirectional.only(start: 30, top: 30),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           child: (_city.image.url.toLowerCase().endsWith('.svg')
//                               ? SvgPicture.network(
//                             _city.image.url,
//                                   // color: _city.color,
//                                 )
//                               : CachedNetworkImage(
//                                   fit: BoxFit.cover,
//                                   imageUrl: _city.image.url,
//                                   placeholder: (context, url) => Image.asset(
//                                     'assets/img/loading.gif',
//                                     fit: BoxFit.cover,
//                                   ),
//                                   errorWidget: (context, url, error) => Icon(Icons.error_outline),
//                                 )),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.only(start: 10, top: 0),
//                         child: Text(
//                           _city.name,
//                           maxLines: 2,
//                           style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//       }),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CitiesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    // print( controller.cities.value.length);
    // print('city');


    return Container(
      height: 280,
      color: Get.theme.primaryColor,
      child: Obx(() {
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.cities.length,
            itemBuilder: (_, index) {

              var _city = controller.cities.elementAt(index);
              Get.log(_city.firstImageUrl.toString());
              // print(index);
              return GestureDetector(
                onTap: () {
                  // Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _city, 'heroTag': 'recommended_carousel'});
                 // Get.toNamed(Routes.CATEGORY, arguments: _category);
                  print(_city);
                  Get.toNamed(Routes.CITY, arguments: _city);
                 // Get.toNamed(Routes.CITY, arguments: {'city': _city, 'heroTag': 'recommended_carousel'});


                 // Get.toNamed(Routes.CITIES, arguments: {'cities': _city, 'heroTag': 'recommended_carousel'});
                },
                child: Container(
                  width: 180,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    //alignment: AlignmentDirectional.topStart,
                    children: [
                      Hero(
                        tag: 'recommended_carousel' + _city.id!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _city.firstImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Text(
                              _city.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.hintColor)),
                            ),

                            // SizedBox(height: 10),
                            // Wrap(
                            //   spacing: 1,
                            //   alignment: WrapAlignment.spaceBetween,
                            //   direction: Axis.horizontal,
                            //   children: [
                            //     Text(
                            //       _city.bio ?? ''.tr,
                            //       style: Get.textTheme.caption,
                            //     ),
                            //
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
