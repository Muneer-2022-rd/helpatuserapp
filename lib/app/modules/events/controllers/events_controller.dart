import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/models/event_model.dart';
import 'package:helpat/app/repositories/event_repository.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/global_service.dart';

class EventsController extends GetxController {
  late EventRepository _eventRepository;

  final RxList<Event> events = <Event>[].obs;
  // final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  ScrollController? scrollController;

  EventsController() {
    _eventRepository = new EventRepository();
  }

  @override
  Future<void> onInit() async {
    await getEvents();
    // currentStatus.value = getStatusByOrder(1).id;
    super.onInit();
  }

  Future refreshEvents({bool showMessage = false, String? statusId}) async {

    // changeTab(statusId);
    // if (showMessage) {
      await getEvents();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Events page refreshed successfully".tr));
    // }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      if (scrollController!.position.pixels == scrollController!.position.maxScrollExtent && !isDone.value) {
        loadBookingsOfStatus(statusId: currentStatus.value);

      }
      isLoading.value = false;
    });
  }

  //
  Future getEvents() async {
    try {

      events.assignAll(await (_eventRepository.getAllEvents() as FutureOr<Iterable<Event>>));
      isLoading.value = false;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void changeTab(String statusId) async {
    this.events.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }



  Future loadBookingsOfStatus({String? statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Event> _events = [];

        isDone.value = true;

    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> cancelBookingService(Booking booking) async {
  //   try {
  //     if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
  //       final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
  //       final _booking = new Booking(id: booking.id, cancel: true, status: _status);
  //       await _bookingsRepository.update(_booking);
  //       bookings.removeWhere((element) => element.id == booking.id);
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
