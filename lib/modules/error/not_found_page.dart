import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/helpers/colors.dart';
import '../../widgets/my_widgets/my_button.dart';
import '../../widgets/my_widgets/my_text.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF9),
      body: Stack(
        children: [
          // Animated Background Circles
          _buildBackgroundCircles(),

          // Main Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 24 : 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Coffee Cup Icon with Animation
                      _buildAnimatedCoffeeCup(),

                      const SizedBox(height: 40),

                      // 404 Text
                      _build404Text(isMobile),

                      const SizedBox(height: 24),

                      // Title
                      MyText(
                        "Oops! Page Not Found",
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: 800,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Description
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: MyText(
                          "The page you're looking for seems to have gone for a coffee break. Don't worry, let's get you back on track!",
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Action Buttons
                      _buildActionButtons(context, isMobile),

                      const SizedBox(height: 32),

                      // Helpful Links
                      _buildHelpfulLinks(context, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryGreen.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kLightGreen.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 50,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryGreen.withOpacity(0.1),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: 100,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryGreen.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCoffeeCup() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kLightGreen.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryGreen.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryGreen,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryGreen.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.coffee_outlined,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _build404Text(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDigit("4", isMobile),
        const SizedBox(width: 8),
        _buildDigit("0", isMobile, isMiddle: true),
        const SizedBox(width: 8),
        _buildDigit("4", isMobile),
      ],
    );
  }

  Widget _buildDigit(String digit, bool isMobile, {bool isMiddle = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: isMiddle ? 900 : 700),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: isMobile ? 70 : 100,
            height: isMobile ? 70 : 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isMiddle ? kPrimaryGreen : kLightGreen,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                digit,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 40 : 56,
                  fontWeight: FontWeight.w900,
                  color: isMiddle ? kPrimaryGreen : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildGoHomeButton(context),
          const SizedBox(height: 12),
          _buildGoBackButton(context),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGoHomeButton(context),
        const SizedBox(width: 16),
        _buildGoBackButton(context),
      ],
    );
  }

  Widget _buildGoHomeButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: MyButton(
        onPressed: () {
          context.beamToReplacementNamed('/dashboard');
        },
        backgroundColor: kPrimaryGreen,
        borderRadiusAll: 12,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            MyText(
              "Go to Dashboard",
              color: Colors.white,
              fontWeight: 600,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoBackButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: OutlinedButton(
        onPressed: () {
          if (context.canBeamBack) {
            context.beamBack();
          } else {
            context.beamToReplacementNamed('/dashboard');
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: kPrimaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, color: kPrimaryGreen, size: 20),
            const SizedBox(width: 8),
            MyText(
              "Go Back",
              color: kPrimaryGreen,
              fontWeight: 600,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpfulLinks(BuildContext context, bool isMobile) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightGreen.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          MyText(
            "Quick Links",
            fontSize: 18,
            fontWeight: 700,
            color: kPrimaryGreen,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildQuickLink(
                context,
                icon: Icons.dashboard_outlined,
                label: "Dashboard",
                route: "/dashboard",
              ),
              _buildQuickLink(
                context,
                icon: Icons.inventory_2_outlined,
                label: "Products",
                route: "/products",
              ),
              _buildQuickLink(
                context,
                icon: Icons.receipt_long_outlined,
                label: "Orders",
                route: "/orders",
              ),
              _buildQuickLink(
                context,
                icon: Icons.campaign_outlined,
                label: "Campaigns",
                route: "/campaigns",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLink(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.beamToNamed(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kLightGreen.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kLightGreen),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: kPrimaryGreen),
            const SizedBox(width: 8),
            MyText(
              label,
              fontSize: 14,
              fontWeight: 600,
              color: kPrimaryGreen,
            ),
          ],
        ),
      ),
    );
  }
}

