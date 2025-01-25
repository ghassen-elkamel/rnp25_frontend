import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rnp_front/app/data/models/form/entity_form.dart';

import '../../../core/utils/file_picker.dart';
import '../../../data/models/entities/event.dart';
import '../../../data/models/form/item_form.dart';
import '../../../global_widgets/atoms/grid_view.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Events'.tr,
        selectedIndex: 7,
        entityForms: [addForm(context)],
        body: Obx(() {
          return AtomGridView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            addCrowding: true,
            crossAxisCount: (MediaQuery.of(context).size.width / 380).toInt(),
            children: controller.events.value
                .map((event) => eventCard(event, context))
                .toList(),
          );
        }));
  }

  Widget eventCard(Event event, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        children: [
          Image.network(
            'https://www.eventbookings.com/wp-content/uploads/2024/01/Different-Types-of-Events-in-2024-Which-is-Right-for-You.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.MMM().format(event.startDate).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        DateFormat.d().format(event.startDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${DateFormat.jm().format(event.startDate)} - ${DateFormat.jm().format(event.endDate)}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  EntityForm addForm(context) {
    return EntityForm(
      icon: Icons.add_business_sharp,
      itemsForm: [
        ItemForm(
          onTap: () async {
            controller.selectedFile =
                await CustomFilePicker.showPicker(context: context);
            controller.imagePath.text = controller.selectedFile?.fileName ?? "";
          },
          label: "logo".tr,
          controller: controller.imagePath,
          isRequired: false,
          suffix: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () async {
                controller.selectedFile =
                    await CustomFilePicker.showPicker(context: context);
                controller.imagePath.text =
                    controller.selectedFile?.fileName ?? "";
              }),
        ),
        ItemForm(
          label: "title".tr,
          controller: controller.title,
        ),
        ItemForm(
          label: "description".tr,
          controller: controller.description,
        ),
        ItemForm.date(
          controller: controller.startDateController,
          label: "startDate".tr,
          onChange: (newItem) {
            controller.startDate = newItem;
          },
        ),
        ItemForm.date(
          controller: controller.endDateController,
          label: "endDate".tr,
          onChange: (newItem) {
            controller.endDate = newItem;
          },
        ),
        ItemForm(
          label: "location".tr,
          controller: controller.location,
          readOnly: true,
          isRequired: false,
          onTap: () => controller.selectPosition(context),
          suffix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.map),
          ),
        ),
      ],
      onAdd: controller.addItem,
    );
  }
}
