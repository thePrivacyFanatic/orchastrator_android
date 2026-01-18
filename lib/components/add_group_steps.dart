import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import "package:mobile_scanner/mobile_scanner.dart";
import 'dart:io';

class KeyedForm extends Form {
  KeyedForm({GlobalKey<FormState>? key, required super.child})
      : super(key: key ?? GlobalKey<FormState>());
}

KeyedForm groupForm = KeyedForm(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'relay URL',
          hintText: 'example.com',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field is required';
          }
          if (!value.isURL()) {
            return 'URL not valid';
          }
          return null;
        },
      ),
      SizedBox(
        height: 16,
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Group key',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field is required';
          }
          if (value.length != 8) {
            return 'key length invalid';
          }
          return null;
        },
      )
    ],
  ),
);

KeyedForm accountForm = KeyedForm(
  child: Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
      ),
      SizedBox(
        height: 16,
      ),
      PasswordFormField()
    ],
  ),
);

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({super.key});

  @override
  State<PasswordFormField> createState() {
    return _PasswordFieldState();
  }
}

KeyedForm keyForm = KeyedForm(child: KeyForm());

class KeyForm extends StatefulWidget {
  const KeyForm({super.key});

  @override
  State<KeyForm> createState() => _KeyFormState();
}

class _KeyFormState extends State<KeyForm> {
  bool _scanning = false;
  final MobileScannerController _scannerController = MobileScannerController(
      autoStart: false, formats: [BarcodeFormat.dataMatrix]);
  final TextEditingController _keyController = TextEditingController();
  final Duration _switching = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_scanning) {
          setState(() {
            _scanning = false;
            _scannerController.stop();
          });
        } else {
          Navigator.pop(context);
        }
      },
      child: AnimatedCrossFade(
        firstChild: Column(
          children: [
            TextFormField(
                decoration: InputDecoration(
              labelText: 'group name',
              border: const OutlineInputBorder(),
            )),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _keyController,
              decoration: InputDecoration(
                  labelText: '256 bit shared group key',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_2),
                    onPressed: () {
                      setState(() {
                        _scanning = true;
                      });
                      sleep(_switching);
                      _scannerController.start();
                    },
                  )),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required';
                }
                if (!value.isAlphanumeric) {
                  return "value has to be a base64 key";
                }
                if (value.length != 32) {
                  return 'key length invalid';
                }
                return null;
              },
            ),
            const Text(
                "you need to scan a data matrix provided by another user of "
                "the group in order to be able to access messages")
          ],
        ),
        secondChild: SizedBox(
          height: 350,
          width: 400,
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(25)),
            child: MobileScanner(
                controller: _scannerController,
                onDetect: (BarcodeCapture capture) {
                  setState(() {
                    _keyController.text =
                        capture.barcodes.elementAt(0).displayValue ?? "";
                    _scanning = false;
                  });
                  _scannerController.stop();
                }),
          ),
        ),
        crossFadeState:
            (_scanning) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: _switching,
        reverseDuration: _switching,
      ),
    );
  }
}

class _PasswordFieldState extends State<PasswordFormField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
    );
  }
}
