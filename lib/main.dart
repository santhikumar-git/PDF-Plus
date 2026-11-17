import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

const Color navy = Color(0xFF102A56);
const Color blue = Color(0xFF1769E8);
const Color sky = Color(0xFF58A5FF);
const Color pageBg = Color(0xFFF4F7FC);

void main() => runApp(const PdfPlusApp());

class PdfPlusApp extends StatelessWidget {
  const PdfPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBg,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FD),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDCE5F2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFDCE5F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: blue, width: 1.5),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0.02),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    ),
  );
}

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [blue, sky],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * .27),
        boxShadow: [
          BoxShadow(
            color: blue.withOpacity(.22),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Icon(Icons.picture_as_pdf_rounded,
          color: Colors.white, size: size * .62),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0649C8), blue, Color(0xFF62B1FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -85,
              top: 100,
              child: _glowCircle(230, Colors.white.withOpacity(.08)),
            ),
            Positioned(
              left: -95,
              bottom: -40,
              child: _glowCircle(270, Colors.white.withOpacity(.10)),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, -7 * controller.value),
                      child: Transform.scale(
                        scale: .96 + .06 * controller.value,
                        child: child,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.18),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: const BrandMark(size: 82),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'PDF Plus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'YOUR DOCUMENTS. SIMPLIFIED.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.86),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.1,
                    ),
                  ),
                  const SizedBox(height: 42),
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.white.withOpacity(.9)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class ToolInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final ToolKind kind;
  final Color tint;

  const ToolInfo(
    this.title,
    this.subtitle,
    this.icon,
    this.kind,
    this.tint,
  );
}

enum ToolKind {
  imageToPdf,
  mergePdf,
  splitPdf,
  compressPdf,
  pdfToImages,
  rotatePdf,
}

const List<ToolInfo> toolList = [
  ToolInfo('Image to PDF', 'Turn photos into a PDF', Icons.image_rounded,
      ToolKind.imageToPdf, Color(0xFF2878F0)),
  ToolInfo('Merge PDF', 'Combine multiple documents', Icons.call_merge_rounded,
      ToolKind.mergePdf, Color(0xFF12A878)),
  ToolInfo('Split PDF', 'Separate pages from a PDF', Icons.call_split_rounded,
      ToolKind.splitPdf, Color(0xFF8755E8)),
  ToolInfo('Compress PDF', 'Reduce document file size', Icons.compress_rounded,
      ToolKind.compressPdf, Color(0xFFEF9638)),
  ToolInfo('PDF to Images', 'Export pages as images',
      Icons.photo_library_rounded, ToolKind.pdfToImages, Color(0xFF159DAB)),
  ToolInfo('Rotate PDF', 'Change page orientation',
      Icons.rotate_right_rounded, ToolKind.rotatePdf, Color(0xFFE05C83)),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: Row(
          children: [
            const BrandMark(size: 39),
            const SizedBox(width: 11),
            const Text('PDF Plus'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('2030AI',
                  style: TextStyle(
                      color: blue, fontSize: 9, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => pushPage(context, const ProfilePage()),
            icon: const Icon(Icons.account_circle_outlined, size: 28),
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(23),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0754D8), Color(0xFF55A5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: blue.withOpacity(.19),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your PDFs,\nsimplified.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            height: 1.13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 11),
                        Text(
                          'Smart tools for every document.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 17),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.17),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.white.withOpacity(.3)),
                          ),
                          child: const Text(
                            'Explore PDF tools  →',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 76),
                ],
              ),
            ),
            const SizedBox(height: 27),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PDF Tools',
                    style: TextStyle(
                        color: navy,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
                Text('${toolList.length} tools',
                    style: const TextStyle(
                        color: Color(0xFF8291A8),
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            GridView.builder(
              itemCount: toolList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 13,
                mainAxisSpacing: 13,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (context, index) {
                final tool = toolList[index];
                return ToolCard(
                  tool: tool,
                  onTap: () => pushPage(context, ToolPage(tool: tool)),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5EBF4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: blue, size: 25),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your documents stay on your device during this demo.',
                      style: TextStyle(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatefulWidget {
  final ToolInfo tool;
  final VoidCallback onTap;

  const ToolCard({super.key, required this.tool, required this.onTap});

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pressed ? .97 : 1,
      duration: const Duration(milliseconds: 130),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => pressed = value),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE4EAF3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: widget.tool.tint.withOpacity(.10),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(widget.tool.icon,
                      color: widget.tool.tint, size: 29),
                ),
                const SizedBox(height: 13),
                Text(
                  widget.tool.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: navy, fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.tool.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Color(0xFF7B8AA1), fontSize: 10, height: 1.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthMode { signIn, signUp, forgot }

class AuthPage extends StatefulWidget {
  final AuthMode mode;
  const AuthPage({super.key, required this.mode});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String get heading => switch (widget.mode) {
        AuthMode.signIn => 'Welcome back',
        AuthMode.signUp => 'Create your account',
        AuthMode.forgot => 'Reset password',
      };

  @override
  Widget build(BuildContext context) {
    final isSignUp = widget.mode == AuthMode.signUp;
    final isForgot = widget.mode == AuthMode.forgot;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const BrandMark(size: 68),
                  const SizedBox(height: 17),
                  const Text('PDF Plus',
                      style: TextStyle(
                          color: navy,
                          fontSize: 27,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text(heading,
                      style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 30),
                  if (isSignUp) ...[
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        hintText: 'Full name',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 13),
                  ],
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      hintText: 'Email address',
                    ),
                    validator: (v) {
                      if (v == null || !v.contains('@') || !v.contains('.')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  if (!isForgot) ...[
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => hidePassword = !hidePassword),
                          icon: Icon(hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Use at least 6 characters'
                          : null,
                    ),
                  ],
                  if (widget.mode == AuthMode.signIn)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            pushPage(context, const AuthPage(mode: AuthMode.forgot)),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _showDemoMessage(
                            context,
                            isForgot
                                ? 'Password reset needs account-service setup.'
                                : 'Connect Firebase Authentication to enable real accounts.',
                          );
                        }
                      },
                      child: Text(isForgot
                          ? 'Send reset link'
                          : isSignUp
                              ? 'Create account'
                              : 'Sign in'),
                    ),
                  ),
                  if (!isForgot) ...[
                    const SizedBox(height: 17),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          child: Text('OR',
                              style: TextStyle(
                                  color: Color(0xFF8995A8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: OutlinedButton.icon(
                        onPressed: () => _showDemoMessage(
                          context,
                          'Google sign-in requires Firebase and Google configuration.',
                        ),
                        icon: const Icon(Icons.g_mobiledata_rounded,
                            color: Color(0xFF4285F4), size: 28),
                        label: const Text('Continue with Google'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  if (widget.mode == AuthMode.signIn)
                    _switchText(
                      context,
                      "Don't have an account? ",
                      'Sign up',
                      () => pushPage(
                          context, const AuthPage(mode: AuthMode.signUp)),
                    ),
                  if (widget.mode == AuthMode.signUp)
                    _switchText(
                      context,
                      'Already have an account? ',
                      'Sign in',
                      () => pushPage(
                          context, const AuthPage(mode: AuthMode.signIn)),
                    ),
                  if (isForgot)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to sign in'),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '2030AI EDITION • ACCOUNT DEMO',
                    style: TextStyle(
                        color: Color(0xFF9AA6B7),
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _switchText(
      BuildContext context, String before, String action, VoidCallback onTap) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(before, style: const TextStyle(color: Color(0xFF718096))),
        GestureDetector(
          onTap: onTap,
          child: Text(action,
              style: const TextStyle(
                  color: blue, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 43,
            backgroundColor: Color(0xFFE2EEFF),
            child: Icon(Icons.person_rounded, color: blue, size: 48),
          ),
          const SizedBox(height: 13),
          const Text('Guest User',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: navy, fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Sign in to connect your account',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF7B8AA1), fontSize: 12)),
          const SizedBox(height: 26),
          _profileAction(
            context,
            Icons.login_rounded,
            'Sign in',
            () => pushPage(context, const AuthPage(mode: AuthMode.signIn)),
          ),
          _profileAction(
            context,
            Icons.person_add_alt_1_rounded,
            'Create account',
            () => pushPage(context, const AuthPage(mode: AuthMode.signUp)),
          ),
          _profileAction(context, Icons.settings_outlined, 'Settings',
              () => _showDemoMessage(context, 'Settings will be added in a later phase.')),
          _profileAction(context, Icons.help_outline_rounded, 'Help & Support',
              () => _showDemoMessage(context, 'Help centre will be added in a later phase.')),
          const SizedBox(height: 15),
          const Center(
            child: Text('PDF Plus • Version 1.0.0',
                style: TextStyle(color: Color(0xFF9AA6B7), fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _profileAction(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFFE5EBF4)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: blue),
        title: Text(title,
            style: const TextStyle(
                color: navy, fontSize: 14, fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA6B7)),
      ),
    );
  }
}

class ToolPage extends StatefulWidget {
  final ToolInfo tool;
  const ToolPage({super.key, required this.tool});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  List<PlatformFile> selectedFiles = [];
  bool busy = false;

  bool get isImageTool => widget.tool.kind == ToolKind.imageToPdf;

  Future<void> selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: isImageTool ? FileType.image : FileType.custom,
      allowedExtensions: isImageTool ? null : ['pdf'],
      allowMultiple: widget.tool.kind == ToolKind.mergePdf ||
          widget.tool.kind == ToolKind.imageToPdf,
      withData: true,
    );

    if (result == null || !mounted) return;
    setState(() => selectedFiles = result.files);
  }

  Future<void> createPdfFromImages() async {
    if (selectedFiles.isEmpty) {
      _showDemoMessage(context, 'Select at least one image first.');
      return;
    }

    setState(() => busy = true);
    try {
      final document = pw.Document();
      var pageCount = 0;

      for (final item in selectedFiles) {
        Uint8List? bytes = item.bytes;
        if (bytes == null && item.path != null) {
          bytes = await File(item.path!).readAsBytes();
        }
        if (bytes == null) continue;

        final image = pw.MemoryImage(bytes);
        document.addPage(
          pw.Page(
            pageFormat: pdf.PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(24),
            build: (_) => pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ),
        );
        pageCount++;
      }

      if (pageCount == 0) {
        throw Exception('No readable image files were selected.');
      }

      final directory = await getApplicationDocumentsDirectory();
      final output = File(
        '${directory.path}/PDFPlus_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await output.writeAsBytes(await document.save());

      if (!mounted) return;
      _showDemoMessage(context, 'PDF created: ${output.path}');
      await OpenFilex.open(output.path);
    } catch (error) {
      if (mounted) _showDemoMessage(context, 'Could not create PDF: $error');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> handleAction() async {
    if (selectedFiles.isEmpty) {
      _showDemoMessage(context, 'Please select a file first.');
      return;
    }

    if (widget.tool.kind == ToolKind.imageToPdf) {
      await createPdfFromImages();
      return;
    }

    _showDemoMessage(
      context,
      '${widget.tool.title}: file selection works. PDF processing for this tool is the next development phase.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tool.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE4EAF3)),
            ),
            child: Column(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: widget.tool.tint.withOpacity(.11),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(widget.tool.icon,
                      color: widget.tool.tint, size: 39),
                ),
                const SizedBox(height: 17),
                Text(widget.tool.title,
                    style: const TextStyle(
                        color: navy,
                        fontSize: 21,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                Text(widget.tool.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF7B8AA1), fontSize: 13)),
                const SizedBox(height: 25),
                InkWell(
                  onTap: selectFiles,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: const Color(0xFF9BBFFF),
                          width: 1.3,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isImageTool
                              ? Icons.add_photo_alternate_outlined
                              : Icons.picture_as_pdf_outlined,
                          color: blue,
                          size: 42,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          selectedFiles.isEmpty
                              ? (isImageTool
                                  ? 'Tap to select images'
                                  : 'Tap to select PDF files')
                              : '${selectedFiles.length} file(s) selected',
                          style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        const Text('Choose from your device',
                            style: TextStyle(
                                color: Color(0xFF8391A6), fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                if (selectedFiles.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  ...selectedFiles.take(4).map(
                        (file) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file_outlined,
                                  color: blue, size: 17),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(file.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: navy, fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                      ),
                  if (selectedFiles.length > 4)
                    Text('+ ${selectedFiles.length - 4} more',
                        style: const TextStyle(
                            color: Color(0xFF7B8AA1), fontSize: 11)),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: busy ? null : handleAction,
                    icon: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.auto_awesome_rounded),
                    label: Text(busy
                        ? 'Creating PDF...'
                        : isImageTool
                            ? 'Create PDF'
                            : 'Continue'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: selectFiles,
                  icon: const Icon(Icons.folder_open_rounded, size: 18),
                  label: const Text('Browse files'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: blue, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo build: Image to PDF creates a real PDF. The remaining PDF processing tools will be implemented and tested in the next phase.',
                    style: TextStyle(
                        color: navy, fontSize: 11, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showDemoMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
}
