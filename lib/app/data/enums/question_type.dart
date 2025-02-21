enum QuestionType {
  text('Short Answer', hasOptions: false),
  longText('Paragraph', hasOptions: false),
  checkbox('Checkboxes', hasOptions: true),
  radio('Multiple Choice', hasOptions: true),
  date('Date', hasOptions: false),
  time('Time', hasOptions: false),
  select('Dropdown', hasOptions: true),
  multipleSelect('Multiple Select', hasOptions: true),
  number('Number', hasOptions: false),
  email('Email', hasOptions: false),
  phone('Phone Number', hasOptions: false);

  final String label;
  final bool hasOptions;

  const QuestionType(this.label, {required this.hasOptions});
}

final List<QuestionType> questionTypes = [
  QuestionType.text,
  QuestionType.longText,
  QuestionType.checkbox,
  QuestionType.radio,
  QuestionType.date,
  QuestionType.time,
  QuestionType.select,
  QuestionType.multipleSelect,
  QuestionType.number,
  QuestionType.email,
  QuestionType.phone
];
