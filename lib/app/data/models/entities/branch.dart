import 'package:eco_trans/app/core/utils/transformer.dart';

import 'company.dart';
import 'region.dart';
import 'package:latlong2/latlong.dart';

List<Branch> branchesFromJson(dynamic str) =>
    List<Branch>.from(str["items"].map((x) => Branch.fromJson(x)));

class Branch {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;
  final int? regionId;
  final int? companyId;
  final String name;
  final String? position;
  final Region? region;
  final Company? company;
  final bool haveUserAccounts;

  Branch({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    required this.name,
    required this.position,
    this.regionId,
    this.region,
    this.companyId,
    this.company,
    this.haveUserAccounts = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        name: json["name"],
        position: json["position"],
        haveUserAccounts: json["haveUserAccounts"],
        region: Transformer(fromJson: Region.fromJson, data: json["region"])
            .tryTransformation(),
        company: Transformer(fromJson: Company.fromJson, data: json["company"])
            .tryTransformation(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "regionId": regionId,
        "companyId": companyId,
        "haveUserAccounts": haveUserAccounts,
      };

  @override
  String toString() {
    return name;
  }

  LatLng? getPosition() {
    if(position == null){
      return null;
    }
    try {
      List<String> pos = position!.split((','));

      return LatLng(double.parse(pos.first), double.parse(pos.first));
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Branch && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

extension BranchFilter on List<Branch> {
  List<Branch> get haveUsers {
    return where((element) => element.haveUserAccounts).toList();
  }
}
