import 'package:rnp_front/app/core/extensions/map/map_extension.dart';
import 'package:rnp_front/app/data/models/dto/create_company.dart';
import 'package:rnp_front/app/data/models/entities/company.dart';
import 'package:rnp_front/app/data/models/entities/user.dart';
import 'package:rnp_front/app/data/models/file_info.dart';

import '../providers/external/api_provider.dart';

class CompanyService {
  Future<List<Company>> getCompanies() async {
    final response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/company/all",
      ),
    );
    if (response.containsKeyNotNull('items')) {
      return companiesFromJson(response);
    }
    return [];
  }



  Future<User?> createCompany(
      {required CreateCompanyDto companyDto, FileInfo? file}) async {
    final response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/company",
        body: companyDto.toJson(),
        isFormData: file != null ? true : false,
        files: file != null ? [file] : [],
      ),
    );

    if (response != null) {
      return User.fromJson(response);
    }

    return null;
  }




  Future<Company?> getCurrentCompany() async {
    final response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/company/current-company",
        withLoadingAlert: false,
      ),
    );
    if (response != null) {
      return Company.fromJson(response);
    }
    return null;
  }
}
