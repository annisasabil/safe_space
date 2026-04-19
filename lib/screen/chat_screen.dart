import 'package:safe_space/model/chat.dart';
import 'package:safe_space/model/profil.dart';
import 'package:safe_space/provider/firebase_auth_provider.dart';
import 'package:safe_space/provider/shared_preference_provider.dart';
import 'package:safe_space/services/firebase_firestore_service.dart';
import 'package:safe_space/static/firebase_auth_status.dart';
import 'package:safe_space/static/screen_route.dart';
import 'package:safe_space/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final _contentController = TextEditingController();
  final _padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 8);
  late final Profil? profil;

  @override
  void initState(){
    super.initState();
    profil = context.read<FirebaseAuthProvider>().profil;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5976AC),
        title: Text(
          "Ruang Obrolan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            ),
          ),
        actions: [
          Consumer<FirebaseAuthProvider>(
            builder: (context, value, child){
              return switch (value.authStatus){
                FirebaseAuthStatus.signingOut => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF5976AC),
                    strokeWidth: 3,
                  ),
                ),
                _ => IconButton(
                    icon: Icon(Icons.close,
                    color: Colors.white),
                    tooltip: 'Keluar',
                    onPressed: () => _tapToSignOut(),
                  ),
              };
            },
          ),
        ],
      ),
      body: Padding(
        padding: _padding,
        child: Column(
          children: [
            Expanded(
              child: StreamProvider<List<Chat>>(
                create: (context) =>
                    context.read<FirebaseFirestoreService>().getMessage(),
                initialData: const <Chat>[],
                catchError: (context, error){
                  debugPrint("error: $error");
                  return[];
                },
                builder:(context, child){
                  final chats = Provider.of<List<Chat>>(context);
                  print("JUMLAH CHAT: ${chats.length}");
                  return chats.isEmpty
                      ? const Center(
                        child: Text("Mulai obrolan!"),
                      )
                    : ListView.builder(
                      reverse: true,
                      itemCount: chats.length,
                      itemBuilder: (context, index){
                        final chat = chats[index];
                        return MessageBubble(
                          content: chat.text, 
                          sender: chat.emailSender, 
                          isMyChat: chat.emailSender == profil?.email,
                        );
                      },
                    );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: _padding,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: Color(0xFF5976AC),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send,
                    color: Colors.white),
                    onPressed: () => _sendMessage(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _tapToSignOut() async{
    final sharedPreferenceProvider = context.read<SharedPreferenceProvider>();
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    await firebaseAuthProvider.signOutUser().then((value) async{
      await sharedPreferenceProvider.logout();
      navigator.pushReplacementNamed(
        ScreenRoute.login.name,
      );
    }).whenComplete(() {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(firebaseAuthProvider.message ?? ""),
      ));
    });
  }

  void _sendMessage() async {
  final service = context.read<FirebaseFirestoreService>();
  final profil = context.read<FirebaseAuthProvider>().profil;
  if (profil == null) return;

  final email = profil.email!;
  final content = _contentController.text;

    if (content.isNotEmpty) {
      _contentController.clear(); 
      await service.sendMessage(text: content, emailSender: email);
    }
  }
}