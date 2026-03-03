import 'dart:io';

import 'package:flutter/material.dart';
import "package:mobile_scanner/mobile_scanner.dart";
import 'package:orchastrator/components/password_form_field.dart';
import 'package:string_validator/string_validator.dart';

class GroupForm extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController gidController;

  const GroupForm({
    super.key,
    required this.urlController,
    required this.gidController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
          controller: urlController,
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Group id',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field is required';
            }
            if (!value.isHexadecimal) {
              return "value not a hex number";
            }
            if (value.length != 16) {
              return 'key length invalid';
            }
            return null;
          },
          controller: gidController,
        )
      ],
    );
  }
}

class AccountForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const AccountForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field is required';
            }
            return null;
          },
          controller: usernameController,
        ),
        SizedBox(
          height: 16,
        ),
        PasswordFormField(
          controller: passwordController,
        )
      ],
    );
  }
}

class KeyForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController keyController;
  const KeyForm(
      {super.key, required this.nameController, required this.keyController});

  @override
  State<KeyForm> createState() => _KeyFormState();
}

class _KeyFormState extends State<KeyForm> {
  bool _scanning = false;
  final MobileScannerController _scannerController = MobileScannerController(
      autoStart: false, formats: [BarcodeFormat.dataMatrix]);
  final Duration _switching = Duration(milliseconds: 400);
  final formKey = GlobalKey<FormState>();

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
                labelText: 'display name',
                border: const OutlineInputBorder(),
              ),
              controller: widget.nameController,
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: widget.keyController,
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
                    widget.keyController.text =
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
