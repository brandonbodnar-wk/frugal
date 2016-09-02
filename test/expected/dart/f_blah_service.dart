// Autogenerated by Frugal Compiler (1.17.0)
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING

library valid.src.f_blah_scope;

import 'dart:async';

import 'dart:typed_data' show Uint8List;
import 'package:thrift/thrift.dart' as thrift;
import 'package:frugal/frugal.dart' as frugal;

import 'package:excepts/excepts.dart' as t_excepts;
import 'package:validStructs/validStructs.dart' as t_validStructs;
import 'package:ValidTypes/ValidTypes.dart' as t_ValidTypes;
import 'package:valid/valid.dart' as t_valid;
import 'f_blah_structs.dart' as t_blah_file;


/// This is a service docstring.
abstract class FBlah {

  /// Use this to ping the server.
  Future ping(frugal.FContext ctx);

  /// Use this to tell the server how you feel.
  Future<int> bleh(frugal.FContext ctx, t_valid.Thing one, t_valid.Stuff two, List<int> custom_ints);

  Future<t_validStructs.Thing> getThing(frugal.FContext ctx);

  Future<int> getMyInt(frugal.FContext ctx);
}

/// This is a service docstring.
class FBlahClient implements FBlah {
  Map<String, frugal.FMethod> _methods;

  FBlahClient(frugal.FTransport transport, frugal.FProtocolFactory protocolFactory, [List<frugal.Middleware> middleware]) {
    _transport = transport;
    _transport.setRegistry(new frugal.FClientRegistry());
    _protocolFactory = protocolFactory;
    _oprot = _protocolFactory.getProtocol(_transport);

    writeLock = new frugal.Lock();
    this._methods = {};
    this._methods['ping'] = new frugal.FMethod(this._ping, 'Blah', 'ping', middleware);
    this._methods['bleh'] = new frugal.FMethod(this._bleh, 'Blah', 'bleh', middleware);
    this._methods['getThing'] = new frugal.FMethod(this._getThing, 'Blah', 'getThing', middleware);
    this._methods['getMyInt'] = new frugal.FMethod(this._getMyInt, 'Blah', 'getMyInt', middleware);
  }

  frugal.FTransport _transport;
  frugal.FProtocolFactory _protocolFactory;
  frugal.FProtocol _oprot;
  frugal.FProtocol get oprot => _oprot;
  frugal.Lock writeLock;

  /// Use this to ping the server.
  Future ping(frugal.FContext ctx) {
    return this._methods['ping']([ctx]);
  }

  Future _ping(frugal.FContext ctx) async {
    var controller = new StreamController();
    var closeSubscription = _transport.onClose.listen((_) {
      controller.addError(new thrift.TTransportError(
        thrift.TTransportErrorType.NOT_OPEN,
        "Transport closed before request completed."));
      });
    _transport.register(ctx, _recvPingHandler(ctx, controller));
    await writeLock.lock();
    try {
      try {
        oprot.writeRequestHeader(ctx);
        oprot.writeMessageBegin(new thrift.TMessage("ping", thrift.TMessageType.CALL, 0));
        t_blah_file.ping_args args = new t_blah_file.ping_args();
        args.write(oprot);
        oprot.writeMessageEnd();
        await oprot.transport.flush();
      } finally {
        writeLock.unlock();
      }

      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      closeSubscription.cancel();
      _transport.unregister(ctx);
    }
  }

  _recvPingHandler(frugal.FContext ctx, StreamController controller) {
    pingCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_blah_file.ping_result result = new t_blah_file.ping_result();
        result.read(iprot);
        iprot.readMessageEnd();
        controller.add(null);
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return pingCallback;
  }

  /// Use this to tell the server how you feel.
  Future<int> bleh(frugal.FContext ctx, t_valid.Thing one, t_valid.Stuff two, List<int> custom_ints) {
    return this._methods['bleh']([ctx, one, two, custom_ints]);
  }

  Future<int> _bleh(frugal.FContext ctx, t_valid.Thing one, t_valid.Stuff two, List<int> custom_ints) async {
    var controller = new StreamController();
    var closeSubscription = _transport.onClose.listen((_) {
      controller.addError(new thrift.TTransportError(
        thrift.TTransportErrorType.NOT_OPEN,
        "Transport closed before request completed."));
      });
    _transport.register(ctx, _recvBlehHandler(ctx, controller));
    await writeLock.lock();
    try {
      try {
        oprot.writeRequestHeader(ctx);
        oprot.writeMessageBegin(new thrift.TMessage("bleh", thrift.TMessageType.CALL, 0));
        t_blah_file.bleh_args args = new t_blah_file.bleh_args();
        args.one = one;
        args.two = two;
        args.custom_ints = custom_ints;
        args.write(oprot);
        oprot.writeMessageEnd();
        await oprot.transport.flush();
      } finally {
        writeLock.unlock();
      }

      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      closeSubscription.cancel();
      _transport.unregister(ctx);
    }
  }

  _recvBlehHandler(frugal.FContext ctx, StreamController controller) {
    blehCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_blah_file.bleh_result result = new t_blah_file.bleh_result();
        result.read(iprot);
        iprot.readMessageEnd();
        if (result.isSetSuccess()) {
          controller.add(result.success);
          return;
        }

        if (result.oops != null) {
          controller.addError(result.oops);
          return;
        }
        if (result.err2 != null) {
          controller.addError(result.err2);
          return;
        }
        throw new thrift.TApplicationError(
          thrift.TApplicationErrorType.MISSING_RESULT, "bleh failed: unknown result"
        );
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return blehCallback;
  }

  Future<t_validStructs.Thing> getThing(frugal.FContext ctx) {
    return this._methods['getThing']([ctx]);
  }

  Future<t_validStructs.Thing> _getThing(frugal.FContext ctx) async {
    var controller = new StreamController();
    var closeSubscription = _transport.onClose.listen((_) {
      controller.addError(new thrift.TTransportError(
        thrift.TTransportErrorType.NOT_OPEN,
        "Transport closed before request completed."));
      });
    _transport.register(ctx, _recvGetThingHandler(ctx, controller));
    await writeLock.lock();
    try {
      try {
        oprot.writeRequestHeader(ctx);
        oprot.writeMessageBegin(new thrift.TMessage("getThing", thrift.TMessageType.CALL, 0));
        t_blah_file.getThing_args args = new t_blah_file.getThing_args();
        args.write(oprot);
        oprot.writeMessageEnd();
        await oprot.transport.flush();
      } finally {
        writeLock.unlock();
      }

      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      closeSubscription.cancel();
      _transport.unregister(ctx);
    }
  }

  _recvGetThingHandler(frugal.FContext ctx, StreamController controller) {
    getThingCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_blah_file.getThing_result result = new t_blah_file.getThing_result();
        result.read(iprot);
        iprot.readMessageEnd();
        if (result.isSetSuccess()) {
          controller.add(result.success);
          return;
        }

        throw new thrift.TApplicationError(
          thrift.TApplicationErrorType.MISSING_RESULT, "getThing failed: unknown result"
        );
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return getThingCallback;
  }

  Future<int> getMyInt(frugal.FContext ctx) {
    return this._methods['getMyInt']([ctx]);
  }

  Future<int> _getMyInt(frugal.FContext ctx) async {
    var controller = new StreamController();
    var closeSubscription = _transport.onClose.listen((_) {
      controller.addError(new thrift.TTransportError(
        thrift.TTransportErrorType.NOT_OPEN,
        "Transport closed before request completed."));
      });
    _transport.register(ctx, _recvGetMyIntHandler(ctx, controller));
    await writeLock.lock();
    try {
      try {
        oprot.writeRequestHeader(ctx);
        oprot.writeMessageBegin(new thrift.TMessage("getMyInt", thrift.TMessageType.CALL, 0));
        t_blah_file.getMyInt_args args = new t_blah_file.getMyInt_args();
        args.write(oprot);
        oprot.writeMessageEnd();
        await oprot.transport.flush();
      } finally {
        writeLock.unlock();
      }

      return await controller.stream.first.timeout(ctx.timeout);
    } finally {
      closeSubscription.cancel();
      _transport.unregister(ctx);
    }
  }

  _recvGetMyIntHandler(frugal.FContext ctx, StreamController controller) {
    getMyIntCallback(thrift.TTransport transport) {
      try {
        var iprot = _protocolFactory.getProtocol(transport);
        iprot.readResponseHeader(ctx);
        thrift.TMessage msg = iprot.readMessageBegin();
        if (msg.type == thrift.TMessageType.EXCEPTION) {
          thrift.TApplicationError error = thrift.TApplicationError.read(iprot);
          iprot.readMessageEnd();
          if (error.type == frugal.FTransport.RESPONSE_TOO_LARGE) {
            controller.addError(new frugal.FMessageSizeError.response());
            return;
          }
          throw error;
        }

        t_blah_file.getMyInt_result result = new t_blah_file.getMyInt_result();
        result.read(iprot);
        iprot.readMessageEnd();
        if (result.isSetSuccess()) {
          controller.add(result.success);
          return;
        }

        throw new thrift.TApplicationError(
          thrift.TApplicationErrorType.MISSING_RESULT, "getMyInt failed: unknown result"
        );
      } catch(e) {
        controller.addError(e);
        rethrow;
      }
    }
    return getMyIntCallback;
  }

}
