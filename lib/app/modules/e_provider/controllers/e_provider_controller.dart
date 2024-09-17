import 'dart:async';

import 'package:get/get.dart';
import 'package:helpat/app/modules/e_service/controllers/e_service_controller.dart';

import '../../../../common/ui.dart';
import '../../../models/award_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/gallery_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/review_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../routes/app_routes.dart';

class EProviderController extends GetxController {
  final Rx<EProvider?> eProvider = EProvider().obs;
  final RxList<Review> reviews = <Review>[].obs;
  final RxList<Award> awards = <Award>[].obs;
  final RxList<Media> galleries = <Media>[].obs;
  final RxList<Experience> experiences = <Experience>[].obs;
  final RxList<EService> featuredEServices = <EService>[].obs;
  final currentSlide = 0.obs;
  String? heroTag = "";
  late EProviderRepository _eProviderRepository;

  EProviderController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    eProvider.value = arguments['eProvider'] as EProvider?;
    heroTag = arguments['heroTag'] as String?;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }
  @override
  void dispose() {
    Get.put(EServiceController());
    super.dispose();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();
    await getFeaturedEServices();
    await getAwards();
    await getExperiences();
    await getGalleries();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value!.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProvider() async {
    try {
      eProvider.value = await _eProviderRepository.get(eProvider.value!.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedEServices() async {
    try {
      featuredEServices.assignAll(await _eProviderRepository.getFeaturedEServices(eProvider.value!.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _eProviderRepository.getReviews(eProvider.value!.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAwards() async {
    try {
      awards.assignAll(await _eProviderRepository.getAwards(eProvider.value!.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getExperiences() async {
    try {
      experiences.assignAll(await _eProviderRepository.getExperiences(eProvider.value!.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getGalleries() async {
    try {
      final _galleries = await _eProviderRepository.getGalleries(eProvider.value!.id);
      galleries.assignAll(_galleries.map((e) {
        e.image!.name = e.description;
        return e.image!;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void startChat() {
    List<User> _employees = eProvider.value!.employees!.map((e) {
      e.avatar = eProvider.value!.images![0];
      return e;
    }).toList();
    Message _message = new Message(_employees, name: eProvider.value!.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
