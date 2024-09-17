import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/modules/home/widgets/cities_carousel_widget.dart';
import 'package:helpat/app/modules/root/controllers/root_controller.dart';
import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.willPopExitApp,
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              await controller.refreshHome(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: CustomScrollView(
              controller: ScrollController(),
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 300,
                    elevation: 0.5,
                    floating: true,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.sort, color: Colors.black87),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    actions: [
                      NotificationsButtonWidget(
                        iconColor: Get.isDarkMode
                            ? Get.theme.primaryColor
                            : Get.theme.hintColor,
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: controller.slider.isEmpty
                              ? AlignmentDirectional.center
                              : Ui.getAlignmentDirectional(controller.slider
                                  .elementAt(controller.currentSlide.value)
                                  .textPosition),
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 7),
                                height: 360,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  controller.currentSlide.value = index;
                                },
                              ),
                              items: controller.slider.map((Slide slide) {
                                return SlideItemWidget(slide: slide);
                              }).toList(),
                            ),
                            Align(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      controller.slider.map((Slide slide) {
                                    return Container(
                                      width: 20.0,
                                      height: 5.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color:
                                              controller.currentSlide.value ==
                                                      controller.slider
                                                          .indexOf(slide)
                                                  ? slide.indicatorColor
                                                  : slide.indicatorColor!
                                                      .withOpacity(0.4)),
                                    );
                                  }).toList(),
                                ),
                              ),
                              alignment: Alignment.bottomCenter,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left:
                                      Get.locale.toString() == 'ar' ? 20.0 : 0,
                                  top: Get.height / 20.5),
                              child: Align(
                                child: HomeSearchBarWidget(),
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ],
                        );
                      }),
                    )),
                SliverToBoxAdapter(
                  child: Wrap(
                    children: [
                      AddressWidget(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("Categories".tr,
                                    style: Get.textTheme.headline5)),
                            MaterialButton(
                              onPressed: () {
                                Get.toNamed(Routes.CATEGORIES);
                              },
                              shape: StadiumBorder(),
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(.9),
                              child: Text("View All".tr,
                                  style: Get.textTheme.subtitle1!
                                      .copyWith(color: Get.theme.primaryColor)),
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                      CategoriesCarouselWidget(),
                      //Cities
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            // Cities
                            Expanded(
                                child: Text("Cities".tr,
                                    style: Get.textTheme.headline5)),
                            // MaterialButton(
                            //   onPressed: () {
                            //     Get.toNamed(Routes.CITIES);
                            //   },
                            //   shape: StadiumBorder(),
                            //   color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            //   child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            //   elevation: 0,
                            // ),
                          ],
                        ),
                      ),
                      CitiesCarouselWidget(),

                      Container(
                        color: Get.theme.primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text("Recommended for you".tr,
                                    style: Get.textTheme.headline5)),
//                            MaterialButton(
//                              onPressed: () {
//                                Get.toNamed(Routes.CATEGORIES);
//                              },
//                              shape: StadiumBorder(),
//                              color: Get.theme.colorScheme.secondary
//                                  .withOpacity(.9),
//                              child: Text("View All".tr,
//                                  style: Get.textTheme.subtitle1!
//                                      .copyWith(color: Get.theme.primaryColor)),
//                              elevation: 0,
//                            ),
                          ],
                        ),
                      ),
                      RecommendedCarouselWidget(),

                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      //   child: Row(
                      //     children: [
                      //       // Event
                      //       Expanded(
                      //           child: Text("Events".tr,
                      //               style: Get.textTheme.headline5)),
                      //       MaterialButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => EventsViews()),
                      //           );
                      //           // Get.find<EventsController>().refreshEvents();
                      //         },
                      //         shape: StadiumBorder(),
                      //         color: Get.theme.colorScheme.secondary
                      //             .withOpacity(0.1),
                      //         child: Text("View All".tr,
                      //             style: Get.textTheme.subtitle1),
                      //         elevation: 0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // EventCarouselWidget(),
                      FeaturedCategoriesWidget(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
