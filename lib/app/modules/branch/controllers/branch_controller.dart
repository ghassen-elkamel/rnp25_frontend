import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/entities/branch.dart';
import '../../../data/models/entities/company.dart';
import '../../../data/models/entities/region.dart';
import '../../../data/services/company_service.dart';
import '../../../core/theme/text.dart';
import '../../../core/values/colors.dart';
import '../../../data/enums/button_type.dart';
import '../../../data/models/entities/country.dart';
import '../../../data/services/country_service.dart';
import '../../../global_widgets/atoms/button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class BranchController extends GetxController {
  CountryService countryService = CountryService();
  CompanyService companyService = CompanyService();

  TextEditingController branchName = TextEditingController();
  TextEditingController branchPosition = TextEditingController();
  Rx<LatLng?> selectedPosition = Rx(null);

  RxList<Country> countries = <Country>[].obs;
  RxList<Region> regions = <Region>[].obs;
  RxList<Company> companies = <Company>[].obs;

  Rx<Country?> selectedCountry = Rx(null);
  Region? selectedRegion;
  TextEditingController region = TextEditingController();

  Rx<List<Branch>> branches = Rx([]);
  Company? selectedCompany;

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = true;

    countries.value = await countryService.findAllCountries();
    companies.value = await companyService.getCompanies();

    await loadData();
    getCurrentLocation();
    isLoading.value = false;

    super.onInit();
  }



  Future<bool> addItem() async {
    Branch? branch = Branch(
      position: branchPosition.text,
      regionId: selectedRegion?.id,
      name: branchName.text,
      companyId: selectedCompany?.id,
    );
    branch = await companyService.createBranch(branch: branch);
    if (branch != null) {
      Get.back();
      loadData();
    }
    return branch != null;
  }

  Future<void> loadData() async {
    branches.value = await companyService.getBranches(
      relations: {
        "withCompany": "true",
      },
    );
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
                                  child: const Icon(
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
