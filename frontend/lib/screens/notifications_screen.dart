import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/notification_service.dart';

/// Screen that displays the FCM device token, permission status,
/// and a live list of foreground notifications received while the
/// screen is open. Useful for testing and demonstrating FCM integration.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<RemoteMessage> _messages = [];
  late final void Function(RemoteMessage) _listener;

  @override
  void initState() {
    super.initState();
    _listener = (RemoteMessage message) {
      if (!mounted) return;
      setState(() => _messages.insert(0, message));
    };
    NotificationService.instance.addForegroundListener(_listener);
  }

  @override
  void dispose() {
    NotificationService.instance.removeForegroundListener(_listener);
    super.dispose();
  }

  void _copyToken() {
    final token = NotificationService.instance.deviceToken;
    if (token == null) return;
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FCM token copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = NotificationService.instance.deviceToken;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Token card ---
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.key, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('FCM Device Token',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      if (token != null)
                        IconButton(
                          tooltip: 'Copy token',
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: _copyToken,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    token ?? 'Token not available yet',
                    style: TextStyle(
                      fontSize: 12,
                      color: token != null ? Colors.black87 : Colors.grey,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          // --- Info banner ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Send a test notification from Firebase Console → Cloud Messaging. '
              'Messages received while this screen is open will appear below.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 12),

          // --- Received messages ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Received Messages (${_messages.length})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications received yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _messages.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final notification = msg.notification;
                      return ListTile(
                        leading: const Icon(Icons.notifications_active,
                            color: Colors.orange),
                        title: Text(notification?.title ?? 'No title'),
                        subtitle: Text(notification?.body ?? 'No body'),
                        trailing: Text(
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
