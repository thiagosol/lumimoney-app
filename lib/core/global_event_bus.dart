import 'package:event_bus/event_bus.dart';

final globalEventBus = EventBus();

class GlobalEvent {
  static const loggedOut = 'loggedOut';
}
