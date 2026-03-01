import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import 'examples/login_form.dart';
import 'examples/registration_form.dart';
import 'examples/multi_step_form.dart';
import 'examples/dynamic_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage for draft persistence
  await DraftManager.initStorage();

  runApp(const FiftyFormsExampleApp());
}

/// Example app demonstrating the fifty_forms package.
class FiftyFormsExampleApp extends StatelessWidget {
  const FiftyFormsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Forms Demo',
      debugShowCheckedModeBanner: false,
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

/// Home page with navigation to different form examples.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIFTY FORMS DEMO'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: FiftySpacing.lg),
            Text(
              'CHOOSE AN EXAMPLE',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: FiftyColors.slateGrey,
                    letterSpacing: 2,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: FiftySpacing.xxxl),
            _ExampleCard(
              title: 'LOGIN FORM',
              description: 'Simple form with email and password validation',
              icon: Icons.login,
              color: FiftyColors.burgundy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginFormDemo()),
              ),
            ),
            SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'REGISTRATION FORM',
              description:
                  'Complex form with multiple validators and async validation',
              icon: Icons.person_add,
              color: FiftyColors.burgundy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegistrationFormDemo()),
              ),
            ),
            SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'MULTI-STEP FORM',
              description: 'Wizard-style form with step navigation',
              icon: Icons.format_list_numbered,
              color: FiftyColors.burgundy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MultiStepFormDemo()),
              ),
            ),
            SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'DYNAMIC FORM',
              description: 'Form with dynamic array fields',
              icon: Icons.dynamic_form,
              color: FiftyColors.burgundy,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DynamicFormDemo()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(FiftySpacing.xl),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftySpacing.md),
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(width: FiftySpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FiftyColors.cream,
                          letterSpacing: 1,
                        ),
                  ),
                  SizedBox(height: FiftySpacing.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FiftyColors.slateGrey,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: FiftyColors.slateGrey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
