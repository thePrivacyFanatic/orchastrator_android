import 'package:dart_eval/dart_eval_bridge.dart';
import 'bindings.eval.dart';

/// [EvalPlugin] for orchastrator
class OrchastratorPlugin implements EvalPlugin {
  @override
  String get identifier => 'package:orchastrator';

  @override
  void configureForCompile(BridgeDeclarationRegistry registry) {
    registry.defineBridgeClass($Message.$declaration);
    registry.defineBridgeClass($User.$declaration);
    registry.defineBridgeClass($ObjectiveInput.$declaration);
  }

  @override
  void configureForRuntime(Runtime runtime) {
    $Message.configureForRuntime(runtime);
    $User.configureForRuntime(runtime);
    $ObjectiveInput.configureForRuntime(runtime);
  }
}
