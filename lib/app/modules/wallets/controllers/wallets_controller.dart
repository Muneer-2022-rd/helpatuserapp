import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../repositories/payment_repository.dart';

class WalletsController extends GetxController {
  final RxList<Wallet> wallets = <Wallet>[].obs;
  final RxList<WalletTransaction> walletTransactions =
      <WalletTransaction>[].obs;
  final Rx<Wallet> selectedWallet = new Wallet().obs;
  late PaymentRepository _paymentRepository;
  bool isDataLoaded = false;
  WalletsController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    await refreshWallets();
    super.onInit();
  }

  Future refreshWallets({bool? showMessage}) async {
    await getWallets();
    initSelectedWallet();
    await getWalletTransactions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of wallets refreshed successfully".tr));
    }
  }

  Future getWallets() async {
    try {
      isDataLoaded = true;
      update();
      wallets.assignAll(await _paymentRepository.getWallets());
      isDataLoaded = false;
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getWalletTransactions() async {
    try {
      walletTransactions.assignAll(
          await _paymentRepository.getWalletTransactions(selectedWallet.value));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initSelectedWallet() {
    if (!selectedWallet.value.hasData && wallets.isNotEmpty) {
      selectedWallet.value = wallets.elementAt(0);
    }
  }
}
