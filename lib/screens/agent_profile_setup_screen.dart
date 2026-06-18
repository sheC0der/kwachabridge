import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class _Country {
  final String flag;
  final String name;
  final String code;
  const _Country(this.flag, this.name, this.code);
}

const List<_Country> _countries = [
  _Country('🇲🇼', 'Malawi', '+265'),
  _Country('🇿🇦', 'South Africa', '+27'),
  _Country('🇿🇲', 'Zambia', '+260'),
  _Country('🇰🇪', 'Kenya', '+254'),
  _Country('🇹🇿', 'Tanzania', '+255'),
  _Country('🇺🇸', 'USA', '+1'),
];

class AgentProfileSetupScreen extends StatefulWidget {
  const AgentProfileSetupScreen({super.key});

  @override
  State<AgentProfileSetupScreen> createState() => _AgentProfileSetupScreenState();
}

class _AgentProfileSetupScreenState extends State<AgentProfileSetupScreen> {
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  _Country _selectedCountry = _countries[0];
  String? _provider;
  File? _selectedImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _displayNameController.text = MockData.agentName;
    _phoneController.text = '991 234 567';
    _provider = 'airtel';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: kText),
              title: const Text('Camera', style: TextStyle(color: kText)),
              onTap: () async {
                Navigator.pop(ctx);
                final img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
                if (img != null && mounted) setState(() => _selectedImage = File(img.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: kText),
              title: const Text('Gallery', style: TextStyle(color: kText)),
              onTap: () async {
                Navigator.pop(ctx);
                final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
                if (img != null && mounted) setState(() => _selectedImage = File(img.path));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Select Country', style: TextStyle(color: kText, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            ..._countries.map(
              (c) => ListTile(
                leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                title: Text(c.name, style: const TextStyle(color: kText, fontSize: 15)),
                trailing: Text(c.code, style: const TextStyle(color: kMuted, fontSize: 14)),
                onTap: () {
                  setState(() => _selectedCountry = c);
                  Navigator.pop(ctx);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile(String publicKey) async {
    final name = _displayNameController.text.trim();
    final displayName = name.isEmpty ? MockData.agentName : name;
    final phone = _phoneController.text.trim();
    final fullPhone = '${_selectedCountry.code} $phone';
    final providerLabel = _provider == 'airtel' ? 'Airtel Money' : 'TNM Mpamba';

    setState(() => _loading = true);
    try {
      if (AppSession.firebaseReady) {
        String? photoUrl;
        if (_selectedImage != null) {
          photoUrl = await FirebaseService.uploadProfilePhoto(publicKey, _selectedImage!);
        }
        await FirebaseService.saveAgentProfile(
          publicKey: publicKey,
          displayName: displayName,
          phoneNumber: fullPhone,
          mobileMoneyProvider: providerLabel,
          nationalId: _nationalIdController.text.trim(),
          photoUrl: photoUrl,
        );
        await FirebaseService.saveAgentDiscoveryProfile(
          publicKey: publicKey,
          displayName: displayName,
          phoneNumber: fullPhone,
          mobileMoneyProvider: providerLabel,
        );
      }
      AppSession.displayName = displayName;
      AppSession.phoneNumber = fullPhone;
      AppSession.provider = providerLabel;

      if (mounted) Navigator.pushReplacementNamed(context, '/agent-dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final publicKey = args?['publicKey'] as String? ?? AppSession.publicKey;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set Up Your\nAgent Profile',
                    style: TextStyle(color: kText, fontSize: 30, fontWeight: FontWeight.bold, height: 1.2, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 10),
                  const Text('Visible to customers. Used for verification.', style: TextStyle(color: kMuted, fontSize: 14)),
                  const SizedBox(height: 32),

                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: kSurface, boxShadow: kCardShadow),
                            clipBehavior: Clip.antiAlias,
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : const Icon(Icons.camera_alt_outlined, color: kMuted, size: 28),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Profile photo (optional)', style: TextStyle(color: kMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  const _FieldLabel('DISPLAY NAME'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _displayNameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: kText, fontSize: 15),
                    decoration: const InputDecoration(hintText: 'How customers will find you'),
                  ),
                  const SizedBox(height: 20),

                  const _FieldLabel('PHONE NUMBER'),
                  const SizedBox(height: 8),
                  _PhoneField(controller: _phoneController, country: _selectedCountry, onCountryTap: _showCountryPicker),
                  const SizedBox(height: 20),

                  const _FieldLabel('MOBILE MONEY PROVIDER'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ProviderChip(label: 'Airtel Money', selected: _provider == 'airtel', onTap: () => setState(() => _provider = 'airtel')),
                      const SizedBox(width: 10),
                      _ProviderChip(label: 'TNM Mpamba', selected: _provider == 'tnm', onTap: () => setState(() => _provider = 'tnm')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const _FieldLabel('NATIONAL ID NUMBER'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nationalIdController,
                    style: const TextStyle(color: kText, fontSize: 15),
                    decoration: const InputDecoration(hintText: 'For verification purposes only'),
                  ),
                  const SizedBox(height: 6),
                  const Text('Your ID is encrypted and never shared publicly', style: TextStyle(color: kMuted, fontSize: 12)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () => _saveProfile(publicKey),
                child: _loading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Create Agent Profile'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500));
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final _Country country;
  final VoidCallback onCountryTap;

  const _PhoneField({required this.controller, required this.country, required this.onCountryTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCountryTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: kBorder))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(country.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(country.code, style: const TextStyle(color: kText, fontSize: 14)),
                  const Icon(Icons.arrow_drop_down, color: kMuted, size: 18),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: kText, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Your mobile money number',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProviderChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? kAccent : kSurface,
          borderRadius: BorderRadius.circular(kRadiusPill),
          boxShadow: kCardShadow,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kText : kMuted,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
