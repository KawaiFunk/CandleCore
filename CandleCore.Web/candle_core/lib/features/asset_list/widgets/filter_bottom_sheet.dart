import 'package:flutter/material.dart';

import 'filter/filter_sheet.dart';

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FilterSheet(),
  );
}
