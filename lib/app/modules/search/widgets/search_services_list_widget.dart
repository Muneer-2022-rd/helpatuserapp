import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/modules/search/controllers/search_controller.dart';
import 'package:helpat/common/Functions/stutsrequest.dart';
import 'package:helpat/app/modules/search/controllers/search_controller.dart' as searchController;

import '../../../models/e_service_model.dart';
import '../../category/widgets/services_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';

class SearchServicesListWidget extends GetView<searchController.SearchController> {


  @override
  Widget build(BuildContext context) {
    return controller.searchStatusRequest == StatusRequest.loading && controller.eServices!.isEmpty ?
    Center(child: CircularProgressIndicator(),) :
    ListView.builder(padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eServices!.length,
          itemBuilder: ((_, index) {
            return ServicesListItemWidget(service: EService.fromJson(controller.eServices![index]));
          }),
        );
      }
  }

