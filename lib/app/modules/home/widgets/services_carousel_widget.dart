import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';

class ServicesCarouselWidget extends StatelessWidget {
  final List<EService>? services;

  const ServicesCarouselWidget({Key? key, List<EService>? this.services})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10),
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: services!.length,
          itemBuilder: (_, index) {
            var _service = services!.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.E_SERVICE, arguments: {
                  'eService': _service,
                  'heroTag': 'services_category_carousel_list'
                });
              },
              child: Container(
                width: 220,
                margin: EdgeInsetsDirectional.only(
                    end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.focusColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Column(
                  //alignment: AlignmentDirectional.topStart,
                  children: [
                    Hero(
                      tag: 'services_category_carousel_list' +
                          _service.id! +
                          _service.name!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: _service.firstImageUrl,
//                          imageUrl: _service.pic!,
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 100,
                          ),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                            imageUrl: _service.pic!,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            _service.name!,
                            maxLines: 1,
                            style: Get.textTheme.bodyText2!
                                .merge(TextStyle(color: Get.theme.hintColor)),
                          ),
                          // Wrap(
                          //   children: Ui.getStarsList(_service.rate!),
                          // ),
                          // SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            alignment: WrapAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                "Start from".tr,
                                style: Get.textTheme.caption,
                              ),
                              Ui.getPrice(
                                _service.price,
                                style: Get.textTheme.bodyText2!.merge(TextStyle(
                                    color: Get.theme.colorScheme.secondary)),
                                unit: _service.getUnit,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
