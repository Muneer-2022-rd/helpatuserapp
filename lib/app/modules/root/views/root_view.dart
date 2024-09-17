import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/modules/global_widgets/custom_bottom_nav_bar_animation.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MainDrawerWidget(),
        elevation: 0,
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AnimationCustomNavigationBar(),
      body: GetBuilder<RootController>(
        builder: (controller) => controller.currentPage,
      ),

    );
  }
}
