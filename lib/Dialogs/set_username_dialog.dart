import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/Values/const_values.dart';

class SetUsernameDialog extends StatelessWidget {
  const SetUsernameDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    const inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        strokeAlign: StrokeAlign.center,
        style: BorderStyle.solid,
        width: kButtonRadius,
        color: Color.fromARGB(255, 209, 209, 209),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(kTextFieldRadius),
      ),
    );

    return AlertDialog(
      title: Text(
        "Who is using?",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Theme(
              data: ThemeData(
                  primaryColor: kDisabledColor,
                  primaryColorDark: kDisabledColor,
                  primarySwatch: Colors.grey,
                  inputDecorationTheme:
                      Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: true,
                            focusColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: inputBorder,
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          )),
              child: TextFormField(
                maxLines: 1,
                maxLength: 8,
                controller: txtController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                ],
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    return null;
                  }
                  return "please enter valid name";
                },
                decoration: const InputDecoration(
                  isDense: true,
                  counter: SizedBox(),
                  fillColor: Colors.white,
                  hintText: "Eg:John",
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(kButtonColor),
            ),
            onPressed: () {
              if (formKey.currentState != null &&
                  formKey.currentState!.validate()) {
                Navigator.of(context).pop(txtController.text.trim());
              }
            },
            child: const Text(
              "Ok",
            ))
      ],
    );
  }
}

class SetUsernameDialogBox {
  final BuildContext context;
  bool isOpen = false;
  final bool useRootNavigator;

  SetUsernameDialogBox({
    required this.context,
    this.useRootNavigator = false,
  });
  Future<dynamic> show({VoidCallback? onOkClicked}) async {
    isOpen = true;
    dynamic result = await showDialog(
        useRootNavigator: useRootNavigator,
        context: context,
        barrierDismissible: false,
        builder: (context) => const SetUsernameDialog());
    isOpen = false;
    return result;
  }

  void close() {
    if (isOpen) {
      if (useRootNavigator) {
        Navigator.of(context, rootNavigator: true).pop(true);
      } else {
        Navigator.of(context).pop(true);
      }
      isOpen = false;
    }
  }
}
