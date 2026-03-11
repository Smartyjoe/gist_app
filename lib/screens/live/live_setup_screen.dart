import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/live_model.dart';
import '../../utils/responsive.dart';
import 'live_broadcast_screen.dart';

class LiveSetupScreen extends StatefulWidget {
  const LiveSetupScreen({super.key});

  @override
  State<LiveSetupScreen> createState() => _LiveSetupScreenState();
}

class _LiveSetupScreenState extends State<LiveSetupScreen> {
  final TextEditingController _titleController = TextEditingController();
  LiveAudience _selectedAudience = LiveAudience.everyone;
  String _selectedCategory = 'Community';
  final List<String> _categories = [
    'Community',
    'Emergency',
    'Health',
    'Infrastructure',
    'Entertainment'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showCoHostBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CoHostSelectionSheet(),
    );
  }

  void _startLive() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a live title')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveBroadcastScreen(
          title: _titleController.text,
          audience: _selectedAudience,
          category: _selectedCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Live'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Camera preview placeholder
              Container(
                width: double.infinity,
                height: responsive.hp(30),
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: AppTheme.white,
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing24),

              // Live title input
              Text(
                'Live Title',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.spacing8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'What are you streaming about?',
                  filled: true,
                  fillColor: AppTheme.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: const BorderSide(color: AppTheme.greySoft),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: const BorderSide(color: AppTheme.greySoft),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: const BorderSide(
                      color: AppTheme.greenPrimary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing24),

              // Audience selector
              Text(
                'Who can watch?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.spacing12),
              Wrap(
                spacing: AppTheme.spacing12,
                children: [
                  _AudienceChip(
                    label: 'Everyone',
                    isSelected: _selectedAudience == LiveAudience.everyone,
                    onTap: () => setState(
                      () => _selectedAudience = LiveAudience.everyone,
                    ),
                  ),
                  _AudienceChip(
                    label: 'Followers',
                    isSelected: _selectedAudience == LiveAudience.followers,
                    onTap: () => setState(
                      () => _selectedAudience = LiveAudience.followers,
                    ),
                  ),
                  _AudienceChip(
                    label: 'Friends',
                    isSelected: _selectedAudience == LiveAudience.friends,
                    onTap: () => setState(
                      () => _selectedAudience = LiveAudience.friends,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing24),

              // Category dropdown
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppTheme.spacing8),
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              SizedBox(height: AppTheme.spacing24),

              // Invite co-host button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showCoHostBottomSheet,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Invite Co-Host'),
                ),
              ),
              SizedBox(height: AppTheme.spacing32),

              // Start Live button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.spacing16,
                    ),
                  ),
                  onPressed: _startLive,
                  child: const Text(
                    'Start Live',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AudienceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.greenPrimary,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.white : AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.greenPrimary : AppTheme.greySoft,
      ),
    );
  }
}

class _CoHostSelectionSheet extends StatefulWidget {
  @override
  State<_CoHostSelectionSheet> createState() => _CoHostSelectionSheetState();
}

class _CoHostSelectionSheetState extends State<_CoHostSelectionSheet> {
  final List<_CoHostUser> users = [
    _CoHostUser(
      id: '1',
      name: 'Dr. Kunle Okonkwo',
      avatar: 'https://i.pravatar.cc/150?img=11',
    ),
    _CoHostUser(
      id: '2',
      name: 'Amara Okafor',
      avatar: 'https://i.pravatar.cc/150?img=4',
    ),
    _CoHostUser(
      id: '3',
      name: 'Ibrahim Mustapha',
      avatar: 'https://i.pravatar.cc/150?img=5',
    ),
    _CoHostUser(
      id: '4',
      name: 'Blessing Okonkwo',
      avatar: 'https://i.pravatar.cc/150?img=6',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invite Co-Host',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: AppTheme.spacing16),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _CoHostUserTile(
                  user: user,
                  onInvite: () {
                    setState(() {
                      user.isInvited = true;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CoHostUser {
  final String id;
  final String name;
  final String avatar;
  bool isInvited = false;

  _CoHostUser({
    required this.id,
    required this.name,
    required this.avatar,
  });
}

class _CoHostUserTile extends StatelessWidget {
  final _CoHostUser user;
  final VoidCallback onInvite;

  const _CoHostUserTile({
    required this.user,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
            radius: 24,
          ),
          SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Text(
              user.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          ElevatedButton(
            onPressed: user.isInvited ? null : onInvite,
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isInvited ? AppTheme.greenPrimary : null,
            ),
            child: Text(user.isInvited ? 'Invited ✓' : 'Invite'),
          ),
        ],
      ),
    );
  }
}
