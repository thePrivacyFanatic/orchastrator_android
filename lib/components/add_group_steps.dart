import 'dart:io';

import 'package:flutter/material.dart';
import "package:mobile_scanner/mobile_scanner.dart";
import 'package:orchastrator/classes/group_details.dart';
import 'package:string_validator/string_validator.dart';

class KeyedForm extends Form {
  final GroupDetailsConstructor constructor;
  KeyedForm(
      {GlobalKey<FormState>? key,
      required this.constructor,
      required super.child})
      : super(key: key ?? GlobalKey<FormState>());
}

abstract class FormContainer {
  bool validate();
}

class GroupDetailsConstructor {
  int? gid;
  String? displayName;
  String? relayURL;
  String? username;
  String? password;
  String? aesKey;

  GroupDetails construct() => GroupDetails(
      gid: gid!,
      displayName: displayName!,
      relayURL: relayURL!,
      username: username!,
      password: password!,
      aesKey: aesKey!,
      lastSid: 0);
}

class GroupForm extends StatelessWidget implements FormContainer {
  final GroupDetailsConstructor constructor;
  late final KeyedForm form;
  GroupForm({
    super.key,
    required this.constructor,
  });

  @override
  Widget build(BuildContext context) {
    form = KeyedForm(
      constructor: constructor,
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
            onSaved: (val) {
              constructor.relayURL = val!;
            },
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
              if (!value.isNumeric) {
                return "value not a number";
              }
              if (value.length != 8) {
                return 'key length invalid';
              }
              return null;
            },
            onSaved: (val) {
              constructor.gid = int.parse(val!);
            },
          )
        ],
      ),
    );
    return form;
  }

  @override
  bool validate() {
    var valid =
        (form.key as GlobalKey<FormState>).currentState?.validate() ?? false;
    if (valid) (form.key as GlobalKey<FormState>).currentState?.save();
    return valid;
  }
}

class AccountForm extends StatelessWidget implements FormContainer {
  final GroupDetailsConstructor constructor;
  late final KeyedForm form;
  AccountForm({
    super.key,
    required this.constructor,
  });

  @override
  Widget build(BuildContext context) {
    form = KeyedForm(
      constructor: constructor,
      child: Column(
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
            onSaved: (val) {
              constructor.username = val!;
            },
          ),
          SizedBox(
            height: 16,
          ),
          PasswordFormField(
            constructor: constructor,
          )
        ],
      ),
    );
    return form;
  }

  @override
  bool validate() {
    var valid =
        (form.key as GlobalKey<FormState>).currentState?.validate() ?? false;
    if (valid) (form.key as GlobalKey<FormState>).currentState?.save();
    return valid;
  }
}

class PasswordFormField extends StatefulWidget {
  final GroupDetailsConstructor constructor;
  const PasswordFormField({super.key, required this.constructor});

  @override
  State<PasswordFormField> createState() {
    return _PasswordFieldState();
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
      onSaved: (val) {
        widget.constructor.password = val!;
      },
    );
  }
}

class KeyForm extends StatefulWidget implements FormContainer {
  final GroupDetailsConstructor constructor;
  late final Widget form;
  KeyForm({super.key, required this.constructor});

  @override
  State<KeyForm> createState() => _KeyFormState();

  @override
  bool validate() {
    var valid =
        (form.key as GlobalKey<FormState>).currentState?.validate() ?? false;
    if (valid) (form.key as GlobalKey<FormState>).currentState?.save();
    return valid;
  }
}

class _KeyFormState extends State<KeyForm> {
  bool _scanning = false;
  final MobileScannerController _scannerController = MobileScannerController(
      autoStart: false, formats: [BarcodeFormat.dataMatrix]);
  final TextEditingController _keyController = TextEditingController();
  final Duration _switching = Duration(milliseconds: 400);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    widget.form = KeyedForm(
      constructor: widget.constructor,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'display name',
              border: const OutlineInputBorder(),
            ),
            onSaved: (val) {
              widget.constructor.displayName = val!;
            },
          ),
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
            onSaved: (val) {
              widget.constructor.aesKey = val!;
            },
          ),
          const Text(
              "you need to scan a data matrix provided by another user of "
              "the group in order to be able to access messages")
        ],
      ),
    );
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
        firstChild: widget.form,
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
