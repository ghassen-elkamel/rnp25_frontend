import 'package:eco_trans/app/core/extensions/string/language.dart';
import 'package:eco_trans/app/data/enums/order.dart';
import 'package:eco_trans/app/data/enums/role_type.dart';
import 'package:eco_trans/app/data/models/entities/branch.dart';
import 'package:eco_trans/app/data/models/entities/company.dart';
import 'package:eco_trans/app/data/models/file_info.dart';
import 'package:eco_trans/app/data/services/auth_service.dart';
import 'package:eco_trans/app/data/services/company_service.dart';
import 'package:eco_trans/app/data/services/user_service.dart';
import 'package:eco_trans/app/global_widgets/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../data/models/entities/country.dart';
import '../../../data/models/entities/region.dart';
import '../../../data/models/entities/user.dart';
import '../../../data/services/country_service.dart';

class UsersController extends GetxController {
  CountryService countryService = CountryService();
  CompanyService companyService = CompanyService();
  UserService userService = UserService();

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController region = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  TextEditingController address = TextEditingController();
  TextEditingController identificationPaper = TextEditingController();
  TextEditingController drivingLicenseNumber = TextEditingController();
  TextEditingController drivingLicenseType = TextEditingController();
  TextEditingController drivingLicenseExpirationDateController =
      TextEditingController();
  DateTime? drivingLicenseExpirationDate;

  String countryCode = '218';
  RxBool toVerify = false.obs;
  RxBool isLoading = false.obs;

  List<User> originUsers = [];
  RxList<User> users = <User>[].obs;
  Rx<RolesType?> selectedRole = Rx(null);

  RxList<Country> countries = <Country>[].obs;
  RxList<Branch> branches = <Branch>[].obs;
  Rx<List<Region>> regions = Rx([]);
  Country? selectedCountry;
  Region? selectedRegion;
  Rx<Branch?> selectedBranch = Rx(null);

  GlobalKey<FormState> chargingForm = GlobalKey();
  TextEditingController amount = TextEditingController();

  Company? currentCompany;

  TextEditingController search = TextEditingController();
  Rx<FileInfo?> selectedImage = Rx(null);
  TextEditingController attachment = TextEditingController();

  @override
  void onInit() async {
    String? role = Get.parameters["role"];
    if (role != null) {
      selectedRole.value = RolesType.values.byName(role);
    }
    selectedRole.value ??= AuthService.getMyRolesFilter().first;

    isLoading.value = true;

    List result = await Future.wait([
      countryService.findAllCountries(withLoadingAlert: false),
      companyService.getBranches(withLoadingAlert: false),
      companyService.getCurrentCompany(),
      loadData(false),
    ]);
    countries.value = result[0];
    branches.value = result[1];
    branches.value = branches.value.haveUsers;
    selectedBranch.value = branches.value.firstOrNull;
    currentCompany = result[2];
    isLoading.value = false;

    super.onInit();
  }

  List<RolesType> getRoles() {
    if (selectedRole.value != null) {
      return [selectedRole.value!];
    }

    return [];
  }

  Future<void> loadData([bool withLoading = true]) async {
    if (withLoading) {
      isLoading.value = true;
    }
    if (selectedRole.value != null) {
      originUsers = await userService.findAllByRole(
        roles: getRoles(),
      );
      searchItems();
    }
    if (withLoading) {
      isLoading.value = false;
    }
  }

  searchItems() {
    users.value = originUsers.where((user) {
      return user.fullData().toLowerCase().contains(search.text.toLowerCase());
    }).toList();
  }

  orderByFullName(Order order) {
    users.value.sort(
      (a, b) {
        int compareResult = 1;
        if (a.fullName != null && b.fullName != null) {
          compareResult = a.fullName!.compareTo(b.fullName!);
        }
        if (order == Order.DESC) {
          compareResult = compareResult * -1;
        }

        return compareResult;
      },
    );
    users.refresh();
  }

  orderByCode(Order order) {
    users.value.sort(
      (a, b) {
        int compareResult = 1;
        if (a.internalCode != null && b.internalCode != null) {
          compareResult = a.internalCode!.compareTo(b.internalCode!);
        }
        if (order == Order.DESC) {
          compareResult = compareResult * -1;
        }

        return compareResult;
      },
    );
    users.refresh();
  }

  onSelectCountry(newItem) async {
    selectedCountry = newItem;
    regions.value = await countryService.findAllRegionsByCountry(
        countryId: selectedCountry?.id);
  }

  Future<bool> addUpdateItem({User? oldItem}) async {
    Driver? driver;
    if (selectedRole.value == RolesType.driver) {
      driver = Driver(
        id: oldItem?.driver?.id,
        status: oldItem?.driver?.status,
        address: address.text,
        identificationPaper: identificationPaper.text,
        drivingLicenseNumber: drivingLicenseNumber.text,
        drivingLicenseType: drivingLicenseType.text,
        drivingLicenseExpirationDate: drivingLicenseExpirationDate,
      );
    }
    User? user = User(
      id: oldItem?.id,
      internalCode: oldItem?.internalCode,
      fullName: fullName.text,
      email: email.text,
      phoneNumber: phone.text,
      countryCode: countryCode,
      branchId: selectedBranch.value?.id,
      role: selectedRole.value,
      driver: driver,
    );
    user = await userService.createOrUpdate(user: user);
    if (user == null) {
      return false;
    }
    Get.back();

    if (user.password != null) {
      Alert.showCustomDialog(
        content: Column(
          children: [
            CustomText.m(
              '${'phone'.tr} :${'${user.countryCode} ${user.phoneNumber}'.reverseArabic()}',
            ),
            CustomText.m('${'password'.tr}: ${user.password}'),
            const SizedBox(height: 16),
            AtomButton(
              label: "share".tr,
              onPressed: () {
                shareMessage(user!);
              },
            ),
          ],
        ),
        onClose: () {
          Get.back();
          loadData();
        },
      );
    } else {
      loadData();
    }
    return false;
  }

  Future<void> shareMessage(
    User user,
  ) async {
    await Share.share(
      "${"username".tr}\n ${user.countryCode} ${user.phoneNumber} \n\n${"password".tr}\n${(user.password ?? "")}",
      subject: 'share'.tr,
    );
  }

  Future<void> updatePassword(User item) async {
    bool isUpdated = await userService.updatePassword(
      id: item.id,
      newPassword: newPassword.text,
    );
    if (isUpdated) {
      Get.back();
    }
  }

  Future<void> deleteAccount(User item) async {
    bool isUpdated = await userService.deleteUser(
      item.id,
    );
    if (isUpdated) {
      Get.back();
      loadData();
    }
  }
}
