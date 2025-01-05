import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:eco_trans/app/data/models/dto/create_company.dart';
import 'package:eco_trans/app/data/models/entities/region.dart';
import 'package:eco_trans/app/data/models/entities/user.dart';
import 'package:eco_trans/app/data/models/file_info.dart';
import 'package:eco_trans/app/data/services/company_service.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/text.dart';
import '../../../core/utils/alert.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/models/entities/country.dart';
import '../../../data/services/country_service.dart';
import '../../../global_widgets/atoms/button.dart';
import 'package:permission_handler/permission_handler.dart';

class CompanyController extends GetxController {
  CountryService countryService = CountryService();
  CompanyService companyService = CompanyService();

  TextEditingController companyName = TextEditingController();
  TextEditingController branchName = TextEditingController();
  TextEditingController branchPosition = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCode = TextEditingController(text: "218");
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
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
        branchPosition: branchPosition.text,
        branchRegionId: selectedRegion?.id,
        branchName: branchName.text,
        firstName: firstName.text,
        lastName: lastName.text,
        countryCode: countryCode.text,
        phoneNumber: phoneNumber.text);
    User? user = await companyService.createCompany(companyDto: companyDto, file: selectedFile);
    if (user != null) {
      Get.back();
      Alert.showCustomDialog(
        content: Column(
          children: [
            CustomText.m('${'phoneNumber'.tr}: ${user.countryCode} ${user.phoneNumber}'),
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

  selectPosition(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText.xxl(
                  "branchPosition".tr,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: selectedPosition.value ?? const LatLng(50.5, 30.51),
                        initialZoom: selectedPosition.value == null ? 6.0 : 15,
                        onTap: (tapPosition, point) {
                          selectedPosition.value = point;
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        Obx(() {
                          return MarkerLayer(
                            markers: [
                              if (selectedPosition.value != null)
                                Marker(
                                  point: selectedPosition.value!,
                                  child:  const Icon(
                                    Icons.my_location_rounded,
                                    color: primaryColor,
                                    size: 60,
                                  ),
                                  height: 60,
                                  width: 60,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                    Obx(() {
                      if (selectedPosition.value == null) {
                        return const SizedBox();
                      }
                      return Positioned(
                        bottom: 32,
                        right: 32,
                        child: AtomButton(
                          label: 'save'.tr,
                          isSmall: true,
                          onPressed: () {
                            LatLng position = selectedPosition.value!;
                            branchPosition.text =
                                "${position.latitude}, ${position.longitude}";
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 32,
                      left: 32,
                      child: AtomButton(
                        label: 'cancel'.tr,
                        buttonColor: ButtonColor.third,
                        isSmall: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
