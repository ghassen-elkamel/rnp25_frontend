import 'package:flutter/material.dart';
import '../atoms/drawer_content.dart';

class MoleculeDrawer extends StatelessWidget {
  final int? selectedIndex;

  const MoleculeDrawer({
    super.key,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: SafeArea(
          child: AtomDrawerContent(
        selectedIndex: selectedIndex,
      )),
    );
  }
}
