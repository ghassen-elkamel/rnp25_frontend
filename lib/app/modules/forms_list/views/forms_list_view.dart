import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rnp_front/app/core/utils/alert.dart';
import 'package:rnp_front/app/data/models/entities/question.dart';
import 'package:rnp_front/app/data/models/item_select.dart';
import 'package:rnp_front/app/global_widgets/atoms/button.dart';
import 'package:rnp_front/app/global_widgets/atoms/floating_action_button.dart';
import 'package:rnp_front/app/global_widgets/molecules/date_picker.dart';
import 'package:rnp_front/app/global_widgets/organisms/dropdown.dart';

import '../../../data/enums/question_type.dart';
import '../../../global_widgets/atoms/text_field.dart';
import '../../../global_widgets/templates/app_scaffold.dart';
import '../controllers/forms_list_controller.dart';

class FormsListView extends GetView<FormsListController> {
  const FormsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(

      body: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: AtomButton(label: 'addForm'.tr, onPressed: () {
              createForm();
            },),
          )
        ],
      ),

    );
  }

  createForm() {
    Alert.showCustomDialog(
        title: 'createNewForm.tr',
        content: Column(
          children: [
            AtomTextField.simple(
              hintText: 'formName'.tr,
            ),
            AtomTextField.simple(
              hintText: 'formDescription'.tr,
            ),
            IconButton(onPressed: () {
              Rx<QuestionType> selectedQuestionType = QuestionType.text.obs;
              Alert.showCustomDialog(
                  title: 'addQuestion'.tr,
                  content: Column(
                    children: [
                      AtomTextField.simple(
                        hintText: 'question'.tr,
                      ),
                      OrganismDropdown(items: QuestionType.values.map((e) =>
                          ItemSelect(label: e.name.tr, value: e)

                      ).toList()
                        , onChange: (item) {
selectedQuestionType.value=item.value;
                        },
                      ),
                      if(selectedQuestionType.value==QuestionType.select)
                        Column(
                          children: [
                            AtomTextField.simple(
                              hintText: 'option'.tr,
                            ),
                            IconButton(onPressed: () {
                              //add option
                            }, icon: const Icon(Icons.add_circle_outline_sharp)),
                    ],
                  )
                    ],
                  ),
              );
            }, icon: const Icon(Icons.add_circle_outline_sharp)),


            AtomButton(label: 'create'.tr, onPressed: () {

            },)
          ],
        )
    );
  }

}
