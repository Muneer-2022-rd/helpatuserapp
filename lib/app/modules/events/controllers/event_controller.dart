import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
// import '../../../models/tag_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/event_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/event_repository.dart';
import '../../../services/auth_service.dart';
import '../../events/controllers/event_controller.dart';

class EventController extends GetxController {
  final Rx<Event?> event = Event().obs;
  final RxList<Review> reviews = <Review>[].obs;
  // final tags = <Tag>[].obs;
  final RxList<OptionGroup> optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final quantity = 1.obs;
  final heroTag = ''.obs;
  late EventRepository _eventRepository;

  EventController() {
    _eventRepository = new EventRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    event.value = arguments['event'] as Event?;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEvent();
    super.onReady();
  }

  Future refreshEvent({bool showMessage = false}) async {
    await getEvent();

    // await getReviews();
    // await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: event.value!.title! + " " + "page refreshed successfully".tr));
    }
  }

  Future getEvent() async {
    try {
      event.value = await _eventRepository.getEvent(event.value!.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }



  // Future getReviews() async {
  //   try {
  //     reviews.assignAll(await _eventRepository.getReviews(event.value.id));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future getOptionGroups() async {
  //   try {
  //     var _optionGroups = await _eventRepository.getOptionGroups(event.value.id);
  //     optionGroups.assignAll(_optionGroups.map((element) {
  //       element.options.removeWhere((option) => option.eServiceId != event.value.id);
  //       return element;
  //     }));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future addToFavorite() async {
  //   try {
  //     Favorite _favorite = new Favorite(
  //       eService: this.event.value,
  //       userId: Get.find<AuthService>().user.value.id,
  //       options: getCheckedOptions(),
  //     );
  //     await _eventRepository.addFavorite(_favorite);
  //     eService.update((val) {
  //       val.isFavorite = true;
  //     });
  //     if (Get.isRegistered<FavoritesController>()) {
  //       Get.find<FavoritesController>().refreshFavorites();
  //     }
  //     Get.showSnackbar(Ui.SuccessSnackBar(message: this.event.value.name + " Added to favorite list".tr));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future removeFromFavorite() async {
  //   try {
  //     Favorite _favorite = new Favorite(
  //       eService: this.event.value,
  //       userId: Get.find<AuthService>().user.value.id,
  //     );
  //     await _eventRepository.removeFavorite(_favorite);
  //     eService.update((val) {
  //       val.isFavorite = false;
  //     });
  //     if (Get.isRegistered<FavoritesController>()) {
  //       Get.find<FavoritesController>().refreshFavorites();
  //     }
  //     Get.showSnackbar(Ui.SuccessSnackBar(message: this.event.value.name + " Removed from favorite list".tr));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // void selectOption(OptionGroup optionGroup, Option option) {
  //   optionGroup.options.forEach((e) {
  //     if (!optionGroup.allowMultiple && option != e) {
  //       e.checked.value = false;
  //     }
  //   });
  //   option.checked.value = !option.checked.value;
  // }
  //
  // List<Option> getCheckedOptions() {
  //   if (optionGroups.isNotEmpty) {
  //     return optionGroups.map((element) => element.options).expand((element) => element).toList().where((option) => option.checked.value).toList();
  //   }
  //   return [];
  // }

  TextStyle? getTitleTheme(Option option) {
    if (option.checked!.value) {
      return Get.textTheme.bodyText2!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle? getSubTitleTheme(Option option) {
    if (option.checked!.value) {
      return Get.textTheme.caption!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color? getColor(Option option) {
    if (option.checked!.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
  }
}
