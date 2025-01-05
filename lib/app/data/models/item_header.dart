import 'package:eco_trans/app/data/enums/order.dart';

class ItemHeader {
  final String name;
  final void Function(Order order)? onChangeOrder;

  const ItemHeader(this.name, {this.onChangeOrder});
}
