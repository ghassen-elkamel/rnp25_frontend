import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rnp_front/app/data/models/dto/create_company.dart';
import 'package:rnp_front/app/data/models/entities/region.dart';
import 'package:rnp_front/app/data/models/entities/user.dart';
import 'package:rnp_front/app/data/models/file_info.dart';
import 'package:rnp_front/app/data/services/company_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../data/models/entities/country.dart';
import '../../../data/services/country_service.dart';
import '../../../global_widgets/atoms/button.dart';

class CompanyController extends GetxController {
  CountryService countryService = CountryService();
  CompanyService companyService = CompanyService();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCode = TextEditingController(text: "218");
  TextEditingController fullName = TextEditingController();
  TextEditingController imagePath = TextEditingController();
  FileInfo? selectedFile;
  Rx<LatLng?> selectedPosition = Rx(null);

  RxList<Country> countries = <Country>[].obs;
  RxList<Region> regions = <Region>[].obs;

  Rx<Country?> selectedCountry = Rx(null);
  Region? selectedRegion;
  TextEditingController region = TextEditingController();

  Rx<List> companies = Rx([]);

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    countries.value = await countryService.findAllCountries();
    await loadData();
    getCurrentLocation();
    isLoading.value = false;

    super.onInit();
  }

  Future<bool> addItem() async {
    CreateCompanyDto companyDto = CreateCompanyDto(
        companyName: companyName.text,
        regionId: selectedRegion?.id,
        fullName: fullName.text,
        email: email.text,
        countryCode: countryCode.text,
        phoneNumber: phoneNumber.text);
    User? user = await companyService.createCompany(
        companyDto: companyDto, file: selectedFile);
    if (user != null) {
      Get.back();
      Alert.showCustomDialog(
        content: Column(
          children: [
            CustomText.m(
                '${'phoneNumber'.tr}: ${user.countryCode} ${user.phoneNumber}'),
            CustomText.m('${'password'.tr}: ${user.password}'),
            const SizedBox(height: 16),
            AtomButton(label: "share".tr, onPressed: () => shareMessage(user)),
          ],
        ),
        onClose: () {
          Get.back();
          loadData();
        },
      );
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

  Future<void> loadData() async {
    companies.value = await companyService.getCompanies();
  }

  onSelectCountry(newItem) async {
    selectedCountry.value = newItem;
    regions.value = await countryService.findAllRegionsByCountry(
        countryId: selectedCountry.value?.id);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => region.clear());
  }

  Future<LatLng?> getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      selectedPosition.value = LatLng(position.latitude, position.longitude);
    }
    return null;
  }
}
