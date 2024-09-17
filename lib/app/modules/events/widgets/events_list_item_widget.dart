/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/models/event_model.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/intl.dart' as intl;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
// import 'booking_options_popup_menu_widget.dart';

class EventsListItemWidget extends StatelessWidget {

  const EventsListItemWidget({
    Key? key,
    required Event event,
  })  : _event = event,
        super(key: key);

  final Event _event;

  @override
  Widget build(BuildContext context) {
    print('hi');

    // Color _color = _event.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.EVENTS, arguments: {'event': _event, 'heroTag': 'services_carousel'});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: _event.firstImageThumb,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 80,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  ),
                ),
                if (_event.id != null)
                  Container(
                    width: 80,
                    child:   Text(   new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)),
                        style: Get.textTheme.caption!.merge(
                          TextStyle(fontSize: 10),
                        ),
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Text(   new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)),
                          // Text(('ddddd'),
                          maxLines: 1,
                          style: Get.textTheme.bodyText2!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1.4),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(   new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)),
                          maxLines: 1,
                          style: Get.textTheme.headline3!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(   new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)),
                          maxLines: 1,
                          style: Get.textTheme.bodyText2!.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                    ],
                  ),
                  decoration: BoxDecoration(
                    // color: _color,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Opacity(
                opacity:  1,
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _event.title?? '',
                            style: Get.textTheme.bodyText2,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                        ),
                        // BookingOptionsPopupMenuWidget(booking: _booking),
                      ],
                    ),
                    Divider(height: 8, thickness: 1),
                    Row(
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.from!)) + ' - '
                            +     new intl.DateFormat("yyyy-MM-dd").format(DateTime.parse(_event.to!)),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _event.place!,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 8, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(
                        //   flex: 1,
                        //   child: Text(
                        //     "Total".tr,
                        //     maxLines: 1,
                        //     overflow: TextOverflow.fade,
                        //     softWrap: false,
                        //     style: Get.textTheme.bodyText1,
                        //   ),
                        // ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              _event.title_btn!,
                              style: Get.textTheme.headline6),
                            ),
                          ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
