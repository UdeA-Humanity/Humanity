import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';

// Message model
class Message {
  final String id;
  final String senderName;
  final String senderRole;
  final String message;
  final String status;
  final String date;
  final String avatarUrl;

  Message({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.status,
    required this.date,
    required this.avatarUrl,
  });
}

class MensajesScreen extends StatefulWidget {
  const MensajesScreen({super.key});

  @override
  State<MensajesScreen> createState() => _MensajesScreenState();
}

class _MensajesScreenState extends State<MensajesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Message> _messages = [
    Message(
      id: '1',
      senderName: 'Humanity',
      senderRole: '',
      message: 'Novedades: Revisa nuestras nuevas act...',
      status: '',
      date: '',
      avatarUrl: 'assets/images/logo.png',
    ),
    Message(
      id: '2',
      senderName: 'Sofia',
      senderRole: 'Masajista',
      message: 'Humanity actualización: Reserva canc...',
      status: 'Cancelado',
      date: 'Agosto 6, 2024',
      avatarUrl: 'assets/images/masajista.png',
    ),
    Message(
      id: '3',
      senderName: 'Mateo',
      senderRole: 'Mecánico',
      message: 'Cambio de aceite programado',
      status: 'Servicio agendado',
      date: '',
      avatarUrl: 'assets/images/mecanico.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMessagesList(),
                  _buildNotificationsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          hexStringToColor("00ff2e"),
          hexStringToColor("00ff8b"),
          hexStringToColor("03f7ff")]
        ),
      ),
      child: const Text(
        'Buzón de Mensajes',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.black,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Mensajes'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Tab(text: 'Notificaciones'),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.separated(
      itemCount: _messages.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final message = _messages[index];
        return ListTile(
          onTap: () => _navigateToChat(message),
          leading: CircleAvatar(
            backgroundImage: AssetImage(message.avatarUrl),
            radius: 25,
          ),
          title: Row(
            children: [
              Text(
                message.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (message.senderRole.isNotEmpty) ...[
                const Text(' · '),
                Text(
                  message.senderRole,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.message),
              if (message.status.isNotEmpty || message.date.isNotEmpty)
                Text(
                  '${message.status}${message.status.isNotEmpty && message.date.isNotEmpty ? ' · ' : ''}${message.date}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      },
    );
  }

  Widget _buildNotificationsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Estás al día',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            Icons.notifications_none,
            size: 48,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  void _navigateToChat(Message message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(message: message),
      ),
    );
  }
}

// Chat Screen
class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen({
    super.key,
    required this.message,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2ECC71),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.message.avatarUrl),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.senderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.message.senderRole.isNotEmpty)
                  Text(
                    widget.message.senderRole,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                // Add chat messages here
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color(0xFF2ECC71),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                // Send message logic here
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}