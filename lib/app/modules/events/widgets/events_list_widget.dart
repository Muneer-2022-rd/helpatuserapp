import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/modules/events/controllers/event_controller.dart';
import 'package:helpat/app/modules/events/controllers/events_controller.dart';

import '../../global_widgets/circular_loading_widget.dart';
import 'events_list_item_widget.dart';


class EventsListWidget extends GetView<EventsController> {
  EventsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // return Obx(() {
      if (controller.events.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.events.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.events.length) {
              // return Obx(() {

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      // opacity: controller.isLoading.value ? 1 : 0,
                      opacity:1,

                      // child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              // });
            } else {
              var _event = controller.events.elementAt(index);
              return EventsListItemWidget(event: _event);
            }
          }),
        );
      }
    // });
  }
}
