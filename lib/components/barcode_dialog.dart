import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

/// dialog for showing the aes key as a datamatrix barcode for the third addition step
class BarcodeDialog extends StatelessWidget {
  final String aesKey;
  const BarcodeDialog({super.key, required this.aesKey});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: BarcodeWidget(data: aesKey, barcode: Barcode.dataMatrix(), width: 500, height: 500,),
      ),
    );
  }
}
