import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScaffoldMessengerService with ChangeNotifier, DiagnosticableTreeMixin {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  // TODO: Pasar navegacion en parametros sin que se caiga por perder el contexto
  showSnackBar(String message) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              rootScaffoldMessengerKey.currentState!
                  .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
            },
          )),
    );
  }

  showMaterialBanner(String message) {
    rootScaffoldMessengerKey.currentState!.showMaterialBanner(MaterialBanner(
      backgroundColor: Colors.green,
      content: Text(message),
      actions: [
        // Close the banner by returning null.
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () => rootScaffoldMessengerKey.currentState!
              .removeCurrentMaterialBanner(
                  reason: MaterialBannerClosedReason.dismiss),
        ),
      ],
    ));
  }
}
