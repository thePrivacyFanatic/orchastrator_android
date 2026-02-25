// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'bindings.dart';
import 'dart:io';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:orchastrator/bindings.eval.dart';
import 'package:dart_eval/stdlib/io.dart';

/// dart_eval wrapper binding for [Message]
class $Message implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:orchastrator/bindings.dart',
      'Message.',
      $Message.$new,
    );

    runtime.registerBridgeFunc(
      'package:orchastrator/bindings.dart',
      'Message.fromJson',
      $Message.$fromJson,
    );
  }

  /// Compile-time type specification of [$Message]
  static const $spec = BridgeTypeSpec(
    'package:orchastrator/bindings.dart',
    'Message',
  );

  /// Compile-time type declaration of [$Message]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Message]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'content',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'timestamp',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'sender',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'mtype',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),
          ],
          params: [],
        ),
        isFactory: false,
      ),

      'fromJson': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [],
          params: [
            BridgeParameter(
              'jsonString',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
              ),
              false,
            ),
          ],
        ),
        isFactory: false,
      ),
    },

    methods: {},
    getters: {},
    setters: {},
    fields: {
      'content': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'timestamp': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'sender': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'mtype': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [Message.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Message.wrap(
      Message(
        content: args[0]!.$value,
        timestamp: args[1]!.$value,
        sender: args[2]!.$value,
        mtype: args[3]!.$value,
      ),
    );
  }

  /// Wrapper for the [Message.fromJson] constructor
  static $Value? $fromJson(
    Runtime runtime,
    $Value? thisValue,
    List<$Value?> args,
  ) {
    return $Message.wrap(Message.fromJson((args[0]!.$reified as Map).cast()));
  }

  final $Instance _superclass;

  @override
  final Message $value;

  @override
  Message get $reified => $value;

  /// Wrap a [Message] in a [$Message]
  $Message.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'content':
        final _content = $value.content;
        return $String(_content);

      case 'timestamp':
        final _timestamp = $value.timestamp;
        return $int(_timestamp);

      case 'sender':
        final _sender = $value.sender;
        return $int(_sender);

      case 'mtype':
        final _mtype = $value.mtype;
        return $int(_mtype);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'content':
        $value.content = value.$reified;
        return;
    }
    return _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper binding for [User]
class $User implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:orchastrator/bindings.dart',
      'User.',
      $User.$new,
    );

    runtime.registerBridgeFunc(
      'package:orchastrator/bindings.dart',
      'User.fromJson',
      $User.$fromJson,
    );
  }

  /// Compile-time type specification of [$User]
  static const $spec = BridgeTypeSpec(
    'package:orchastrator/bindings.dart',
    'User',
  );

  /// Compile-time type declaration of [$User]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$User]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'uid',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'username',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'privilege',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),
          ],
          params: [],
        ),
        isFactory: false,
      ),

      'fromJson': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [],
          params: [
            BridgeParameter(
              'jsonString',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
              ),
              false,
            ),
          ],
        ),
        isFactory: false,
      ),
    },

    methods: {},
    getters: {},
    setters: {},
    fields: {
      'uid': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'username': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'privilege': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [User.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $User.wrap(
      User(
        uid: args[0]!.$value,
        username: args[1]!.$value,
        privilege: args[2]!.$value,
      ),
    );
  }

  /// Wrapper for the [User.fromJson] constructor
  static $Value? $fromJson(
    Runtime runtime,
    $Value? thisValue,
    List<$Value?> args,
  ) {
    return $User.wrap(User.fromJson((args[0]!.$reified as Map).cast()));
  }

  final $Instance _superclass;

  @override
  final User $value;

  @override
  User get $reified => $value;

  /// Wrap a [User] in a [$User]
  $User.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'uid':
        final _uid = $value.uid;
        return $int(_uid);

      case 'username':
        final _username = $value.username;
        return $String(_username);

      case 'privilege':
        final _privilege = $value.privilege;
        return $int(_privilege);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper binding for [ObjectiveInput]
class $ObjectiveInput implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:orchastrator/bindings.dart',
      'ObjectiveInput.',
      $ObjectiveInput.$new,
    );
  }

  /// Compile-time type specification of [$ObjectiveInput]
  static const $spec = BridgeTypeSpec(
    'package:orchastrator/bindings.dart',
    'ObjectiveInput',
  );

  /// Compile-time type declaration of [$ObjectiveInput]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$ObjectiveInput]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'receiver',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.stream, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:orchastrator/bindings.dart',
                        'Message',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              false,
            ),

            BridgeParameter(
              'send',
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:dart_eval/src/eval/runtime/function.dart',
                    '\$Closure',
                  ),
                  [],
                ),
              ),
              false,
            ),

            BridgeParameter(
              'users',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:orchastrator/bindings.dart',
                        'User',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              false,
            ),

            BridgeParameter(
              'state',
              BridgeTypeAnnotation(BridgeTypeRef(IoTypes.file, [])),
              false,
            ),
          ],
          params: [],
        ),
        isFactory: false,
      ),
    },

    methods: {},
    getters: {},
    setters: {},
    fields: {
      'receiver': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.stream, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec('package:orchastrator/bindings.dart', 'Message'),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'send': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(
            BridgeTypeSpec(
              'package:dart_eval/src/eval/runtime/function.dart',
              '\$Closure',
            ),
            [],
          ),
        ),
        isStatic: false,
      ),

      'users': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec('package:orchastrator/bindings.dart', 'User'),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'state': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(IoTypes.file, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [ObjectiveInput.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $ObjectiveInput.wrap(
      ObjectiveInput(
        receiver: args[0]!.$value,
        send: args[1]!.$value,
        users: (args[2]!.$reified as List).cast(),
        state: args[3]!.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final ObjectiveInput $value;

  @override
  ObjectiveInput get $reified => $value;

  /// Wrap a [ObjectiveInput] in a [$ObjectiveInput]
  $ObjectiveInput.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'receiver':
        final _receiver = $value.receiver;
        return $Stream.wrap(_receiver.map((e) => $Message.wrap(e)));

      case 'send':
        final _send = $value.send;
        return runtime.wrapAlways(_send);

      case 'users':
        final _users = $value.users;
        return $List.view(_users, (e) => $User.wrap(e));

      case 'state':
        final _state = $value.state;
        return $File.wrap(_state);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
