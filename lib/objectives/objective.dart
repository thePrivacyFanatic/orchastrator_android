import 'package:flutter/cupertino.dart';
import 'package:orchastrator/bindings.dart';

abstract interface class Objective implements Widget{
  Objective load( ObjectiveInput input );
}
