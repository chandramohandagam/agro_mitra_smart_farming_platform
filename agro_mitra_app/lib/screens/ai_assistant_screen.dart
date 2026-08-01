import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/services/permission_service.dart';
import '../core/providers/ai_provider.dart';
import '../core/models/ai_model.dart';
import '../theme/app_colors.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  bool _isListening = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _startListening() async {
    final granted = await PermissionService.instance.requestMicrophone(context);
    if (granted) {
      setState(() => _isListening = true);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<AIProvider>().sendMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AIProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(top: -100, left: -100, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)))),
          Positioned(bottom: -150, right: -100, child: Container(width: 400, height: 400, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryContainer.withValues(alpha: 0.15)))),

          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColors.surfaceBright.withValues(alpha: 0.7), border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)))),
                  child: Row(
                    children: [
                      Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryContainer, image: DecorationImage(image: NetworkImage('https://i.pravatar.cc/100?img=12'), fit: BoxFit.cover))),
                      const SizedBox(width: 12),
                      Text('Agro Mitra AI', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
                  itemCount: aiProvider.messages.length + (aiProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == aiProvider.messages.length) {
                      return const Padding(padding: EdgeInsets.all(16), child: Text('AgroMitra is thinking...', style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant, fontSize: 12)));
                    }
                    final msg = aiProvider.messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: msg.sender == MessageSender.ai
                        ? _buildAIChatBubble(context, msg)
                        : _buildUserChatBubble(context, msg),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(left: 16, right: 16, bottom: 120, child: _buildChatInput(context)),
        ],
      ),
    );
  }

  Widget _buildAIChatBubble(BuildContext context, ChatMessage msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]), padding: const EdgeInsets.all(6), child: const Icon(Icons.eco, color: AppColors.primaryContainer, size: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24), topLeft: Radius.circular(4))), child: Text(msg.text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5))),
              if (msg.insight != null) ...[
                const SizedBox(height: 12),
                _buildInsightsCard(context, msg.insight!),
              ],
              const SizedBox(height: 4),
              Text(DateFormat('hh:mm a').format(msg.timestamp), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserChatBubble(BuildContext context, ChatMessage msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24), topRight: Radius.circular(4))), child: Text(msg.text, style: const TextStyle(color: Colors.white, height: 1.5))),
              const SizedBox(height: 4),
              Text(DateFormat('hh:mm a').format(msg.timestamp), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsCard(BuildContext context, AIInsightCard insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [const Icon(Icons.water_drop, color: AppColors.secondary, size: 20), const SizedBox(width: 8), Text(insight.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))]),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(9999)), child: Text(insight.statusLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer))),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: insight.progress, backgroundColor: AppColors.surfaceContainer, color: AppColors.secondary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
          const SizedBox(height: 12),
          Text(insight.content, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(insight.actionLabel)),
        ],
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white.withValues(alpha: 0.4)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))]),
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined, color: AppColors.onSurfaceVariant)),
              Expanded(child: TextField(controller: _controller, onSubmitted: (_) => _sendMessage(), decoration: const InputDecoration(hintText: 'Ask AgroMitra...', border: InputBorder.none, focusedBorder: InputBorder.none, filled: false, contentPadding: EdgeInsets.symmetric(horizontal: 8)))),
              if (_isListening) const Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
              IconButton(onPressed: _startListening, icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? AppColors.primary : AppColors.onSurfaceVariant)),
              Container(decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: IconButton(onPressed: _sendMessage, icon: const Icon(Icons.arrow_upward, color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
