Arcane FCM Models works with [arcane_fcm](https://pub.dev/packages/arcane_fcm)

This package is used in your _models package to handle saving / loading FCM devices. arcane_fcm manages said tokens on your models.

# Connecting FCMDevice to your user model
```dart
part 'user_settings.mapper.dart';

// ModelCrud is from fire_crud, assuming your models use this
@MappableClass()
class MyUserSettings with MyUserSettingsMappable, ModelCrud {
  ...
  
  // Along with your other properties, add this field here
  @MappableField(hook: FCMDeviceHook()) // <-- This helps encode/decode with dart mappable
  final List<FCMDeviceInfo> devices;

  MyUserSettings({
    ...,
    
    // Add devices to your constructor non-required
    this.devices = const [],
  });

  // This is if your using firecrud
  @override
  List<FireModel<ModelCrud>> get childModels => [];
}
```

# Crafting Notification Models
To create notification models in arcane_fcm, each notification has its own respective model. All notification models extend a BASE model. So first we need to create the base model, then some subclass notifications along with that.

First this is our base notification.
```dart
part 'notification.mapper.dart';

@MappableClass(
  // Every time you add a new subclass notification model
  // You need to add it here so mappable knows about it
  includeSubClasses: [
    MyNotificationTaskReminder,
    // Add more subclass notifications here
  ],
  
  // This is so mappable knows what field to use to determine the subclass
  discriminatorKey: "ntype",
)

// You need to add the mixin ArcaneFCMMessage
class MyNotification with MyNotificationMappable, ArcaneFCMMessage {
  // ArcaneFCMMessage requires a user field since all notifications
  // Are delivered to a signed in user, this ensures only signed in users see their notifications
  @override
  final String user;

  // Add user to your constructor as required
  const MyNotification({required this.user});
}
```

Now that we have the base notification class, we will add the "Task Reminder" notification type
```dart
part 'notification_task_reminder.mapper.dart';

@MappableClass(
    // This is the type name of our notification
    // So this would map to {"ntype": "task_reminder"}
    discriminatorValue: "task_reminder"
)
class MyNotificationTaskReminder extends MyNotification
    with MyNotificationTaskReminderMappable {
  
  // Add any desired fields here. The data here is ONLY the payload
  // No need to include a title / body. This is just the data we need
  // When a user opens a notification and the app needs to do something
  final String task;

  const MyNotificationTaskReminder({
    // Define the user superparameter
    required super.user,
    
    // Define our task parameter
    required this.task,
  });
}
```