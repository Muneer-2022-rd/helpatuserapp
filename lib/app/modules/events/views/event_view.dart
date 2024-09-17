import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/modules/events/widgets/event_til_widget.dart';
import 'package:helpat/app/modules/events/widgets/event_title_bar_widget.dart';
import 'package:helpat/app/modules/home/widgets/welcome_widget.dart';

import '../../../../common/ui.dart';
import '../../../models/event_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/event_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intl/intl.dart' as intl;
class EventView extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {


    // print(controller.event.value.id);
    // print('event');

    return Obx(() {
      var _event = controller.event.value!;


      var _start= new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!));
      var _end= new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.to!));


      if (!_event.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: buildBottomWidget(_event),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEvent(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [
                      new IconButton(
                          icon: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                              BoxShadow(
                                color: Get.theme.primaryColor.withOpacity(0.5),
                                blurRadius: 20,
                              ),
                            ]),
                            // child: (_event?.isFavorite ?? false) ? Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_outline, color: Get.theme.hintColor),
                          ),
                          onPressed: () {
                            // if (!Get.find<AuthService>().isAuth) {
                            //   Get.toNamed(Routes.LOGIN);
                            // } else {
                            //   if (_event?.isFavorite ?? false) {
                            //     controller.removeFromFavorite();
                            //   } else {
                            //     controller.addToFavorite();
                            //   }
                          }
                        // },
                      ).marginSymmetric(horizontal: 10),
                    ],
                    bottom: buildEventTitleBarWidget(_event),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_event),
                            buildCarouselBullets(_event),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),


                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        // buildCategories(_event),
                        EventTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Ui.applyHtml(_event.details!, style: Get.textTheme.bodyText1),
                        ),
                        EventTilWidget(
                          title: Text("Place".tr, style: Get.textTheme.subtitle2),
                          content: Ui.applyHtml(_event.place!, style: Get.textTheme.bodyText1),
                        ),
                        // buildDuration(_event),
                        // buildTags(_event),
                        // buildOptions(),
                        // buildServiceProvider(_event),
                        if (_event.images!.isNotEmpty)
                          EventTilWidget(
                            horizontalPadding: 0,
                            title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                            content: Container(
                              height: 120,
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _event.images!.length,
                                  itemBuilder: (_, index) {
                                    var _media = _event.images!.elementAt(index);
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.GALLERY, arguments: {'media': _event.images, 'current': _media, 'heroTag': 'e_services_galleries'});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                        child: Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Hero(
                                              tag: 'e_services_galleries' + (_media?.id ?? ''),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: _media.thumb!,
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
                                            Padding(
                                              padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                                              child: Text(
                                                _media.name ?? '',
                                                maxLines: 2,
                                                style: Get.textTheme.bodyText2!.merge(TextStyle(
                                                  color: Get.theme.primaryColor,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 6.0,
                                                      color: Get.theme.hintColor.withOpacity(0.6),
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            actions: [
                              // TODO View all galleries
                            ],
                          ),
                        EventTilWidget(
                          title: Text("Details".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text("Started At".tr+" : "+ _start, style: Get.textTheme.headline6),
                              Text("Ended At".tr+" : "+ _end, style: Get.textTheme.headline6),
                              // Wrap(
                              //   children: Ui.getStarsList(_event.id, size: 32),
                              // ),
                              Text(
                                _event.place!,
                                style: Get.textTheme.caption,
                              ).paddingOnly(top: 10),
                              Divider(height: 35, thickness: 1.3),
                              // Obx(() {
                              // if (controller.reviews.isEmpty) {
                              //   return CircularLoadingWidget(height: 100);
                              // }
                              // return ListView.separated(
                              //   padding: EdgeInsets.all(0),
                              //   itemBuilder: (context, index) {
                              //     return ReviewItemWidget(review: controller.reviews.elementAt(index));
                              //   },
                              //   separatorBuilder: (context, index) {
                              //     return Divider(height: 35, thickness: 1.3);
                              //   },
                              //   itemCount: controller.reviews.length,
                              //   primary: false,
                              //   shrinkWrap: true,
                              // );
                              // }),
                            ],
                          ),
                          actions: [
                            // TODO view all reviews
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }
  //
  // Widget buildOptions() {
  //   return Obx(() {
  //     if (controller.optionGroups.isEmpty) {
  //       return SizedBox(height: 0);
  //     }
  //     return EServiceTilWidget(
  //       horizontalPadding: 0,
  //       title: Text("Options".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
  //       content: ListView.separated(
  //         padding: EdgeInsets.all(0),
  //         itemBuilder: (context, index) {
  //           return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
  //         },
  //         separatorBuilder: (context, index) {
  //           return SizedBox(height: 6);
  //         },
  //         itemCount: controller.optionGroups.length,
  //         primary: false,
  //         shrinkWrap: true,
  //       ),
  //     );
  //   });
  // }
  //
  // Container buildDuration(EService _event) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     decoration: Ui.getBoxDecoration(),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             children: [
  //               Text("Duration".tr, style: Get.textTheme.subtitle2),
  //               Text("This service can take up to ".tr, style: Get.textTheme.bodyText1),
  //             ],
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //           ),
  //         ),
  //         Text(_event.duration, style: Get.textTheme.headline6),
  //       ],
  //     ),
  //   );
  // }

  // Container buildTags(EService _event) {
  //   //// 1 ////
  //   // print(_event.tags.length);
  //   // print('_event.tags.length');
  //   // List.generate(_event.tags.length, (index) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     decoration: Ui.getBoxDecoration(),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Row(
  //             children: [
  //               Text("Tags ".tr, style: Get.textTheme.subtitle2),
  //               // Text("This service can take up to ".tr, style: Get.textTheme.bodyText1),
  //               for(var i = 0; i < _event.tags.length; i++)
  //                 Text(' #'+_event.tags[i].tag, style: Get.textTheme.headline6),
  //             ],
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //           ),
  //         ),
  //
  //       ],
  //
  //     ),
  //
  //   );
  //
  // }


  CarouselSlider buildCarouselSlider(Event _event) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _event.images!.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _event.id!,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url!,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Event _event) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _event.images!.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _event.images!.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EventTitleBarWidget buildEventTitleBarWidget(Event _event) {
    return EventTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _event.title ?? '',
                  style: Get.textTheme.headline5!.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (_event.place == null)
                Container(
                  child: Text("  .  .  .  ".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2!.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_event.details != null )
                Container(
                  child: Text("Start".tr+": " +  new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2!.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              // if (_event.place != null)
              //   Container(
              //     child: Text("Offline".tr,
              //         maxLines: 1,
              //         style: Get.textTheme.bodyText2.merge(
              //           TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
              //         ),
              //         softWrap: false,
              //         textAlign: TextAlign.center,
              //         overflow: TextOverflow.fade),
              //     decoration: BoxDecoration(
              //       color: Colors.grey.withOpacity(0.2),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              //     margin: EdgeInsets.symmetric(vertical: 3),
              //   ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      _event.place!,
                      style: Get.textTheme.caption,
                    )],

                ),
                // child: Wrap(
                //   crossAxisAlignment: WrapCrossAlignment.end,
                //   children: List.from(Ui.getStarsList(5))
                //     ..addAll([
                //       SizedBox(width: 5),
                //       Text(
                //         "Reviews (%s)".trArgs([_event.place]),
                //         style: Get.textTheme.caption,
                //       ),
                //     ]),
                // ),
              ),
              // Text(
              //   new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from)),
              //   style: Get.textTheme.headline4.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
              //
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget buildCategories(EService _event) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Wrap(
  //       alignment: WrapAlignment.start,
  //       spacing: 5,
  //       runSpacing: 8,
  //       children: List.generate(_event.categories.length, (index) {
  //         var _category = _event.categories.elementAt(index);
  //         return Container(
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //           child: Text(_category.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _category.color))),
  //           decoration: BoxDecoration(
  //               color: _category.color.withOpacity(0.2),
  //               border: Border.all(
  //                 color: _category.color.withOpacity(0.1),
  //               ),
  //               borderRadius: BorderRadius.all(Radius.circular(20))),
  //         );
  //       }) +
  //           List.generate(_event.subCategories.length, (index) {
  //             return Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //               child: Text(_event.subCategories.elementAt(index).name, style: Get.textTheme.caption),
  //               decoration: BoxDecoration(
  //                   color: Get.theme.primaryColor,
  //                   border: Border.all(
  //                     color: Get.theme.focusColor.withOpacity(0.2),
  //                   ),
  //                   borderRadius: BorderRadius.all(Radius.circular(20))),
  //             );
  //           }),
  //     ),
  //   );
  // }
  //
  // Widget buildServiceProvider(Event _event) {
  //   if (_event?.eProvider?.hasData ?? false) {
  //     return GestureDetector(
  //       onTap: () {
  //         Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _event.eProvider, 'heroTag': 'e_service_details'});
  //       },
  //       child: EServiceTilWidget(
  //         title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
  //         content: EProviderItemWidget(provider: _event.eProvider),
  //         actions: [
  //           Text("View More".tr, style: Get.textTheme.subtitle1),
  //         ],
  //       ),
  //     );
  //   } else {
  //     return EServiceTilWidget(
  //       title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
  //       content: SizedBox(
  //         height: 60,
  //       ),
  //       actions: [],
  //     );
  //   }
  // }
  //
  Widget buildBottomWidget(Event _event) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          // if (_event.priceUnit == 'fixed')
          Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              // children: [
              //   MaterialButton(
              //     height: 24,
              //     minWidth: 46,
              //     onPressed: controller.decrementQuantity,
              //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              //     color: Get.theme.colorScheme.secondary,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
              //     child: Icon(Icons.remove, color: Get.theme.primaryColor, size: 28),
              //     elevation: 0,
              //   ),
              //   SizedBox(
              //     width: 38,
              //     child: Obx(() {
              //       return Text(
              //         controller.quantity.toString(),
              //         textAlign: TextAlign.center,
              //         style: Get.textTheme.subtitle2.merge(
              //           TextStyle(color: Get.theme.colorScheme.secondary),
              //         ),
              //       );
              //     }),
              //   ),
              //   MaterialButton(
              //     onPressed: controller.incrementQuantity,
              //     height: 24,
              //     minWidth: 46,
              //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              //     color: Get.theme.colorScheme.secondary,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
              //     child: Icon(Icons.add, color: Get.theme.primaryColor, size: 28),
              //     elevation: 0,
              //   ),
              // ],
            ),
          ),
          // if (_event.priceUnit == 'fixed') SizedBox(width: 10),
          Expanded(
            child: BlockButtonWidget(
                text: Container(
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    _event.title_btn!.tr,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headline6!.merge(
                      TextStyle(color: Get.theme.primaryColor),
                    ),
                  ),
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: () {
                  launchURL(_event.link!);
                  // launch("https://${_event.link}");
                }
            ),
          ),
        ],
      ).paddingOnly(right: 20, left: 20),
    );
  }


  launchURL(String url) async {
    if (!url.contains('https://')){
      url="https://"+url;
      // print(url);
    }
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);

    } else {
      throw 'Could not launch $url';
    }
  }

}
