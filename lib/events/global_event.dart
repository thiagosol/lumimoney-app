import 'package:event_bus/event_bus.dart';

enum GlobalEvent {
  loggedOut;

  void broadcast() {
    eventBus.fire(this);
  }
}

final eventBus = EventBus();
