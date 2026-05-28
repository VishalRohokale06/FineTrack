import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PaymentMethodSelector extends StatefulWidget {
  final Function(String) onSelected;

  const PaymentMethodSelector({super.key, required this.onSelected});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String selectedValue = "UPI";

  @override
  void initState() {
    super.initState();
    widget.onSelected(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      dropdownColor: AppColors.surface,
      decoration: const InputDecoration(hintText: "Select Payment Method"),
      items: const [
        DropdownMenuItem(value: "UPI", child: Text("UPI")),
        DropdownMenuItem(value: "Cash", child: Text("Cash")),
        DropdownMenuItem(value: "Card", child: Text("Card")),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedValue = value;
        });

        widget.onSelected(value);
      },
    );
  }
}
