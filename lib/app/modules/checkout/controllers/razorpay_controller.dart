import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/booking_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class RazorPayController extends GetxController {
  WebViewController? webView;
  late PaymentRepository _paymentRepository;
  final url = "".obs;
  final progress = 0.0.obs;
  final Rx<Booking?> booking = new Booking().obs;

  RazorPayController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    booking.value = Get.arguments['booking'] as Booking?;
    getUrl();
    super.onInit();
  }

  void getUrl() {
    url.value = _paymentRepository.getRazorPayUrl(booking.value!);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl!)}payments/razorpay";
    if (url == _doneUrl) {
      Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(50).id!;
      if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
        Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(50).id!;
      }
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
