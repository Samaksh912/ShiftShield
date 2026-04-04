import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/router/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  Future<void> _getOtp() async {
    final mobileNumber = _mobileController.text.trim();
    if (mobileNumber.length != 10) return;

    setState(() => _isLoading = true);
    try {
      await ApiService.sendOtp(mobileNumber);
      await AuthService.savePhone(mobileNumber);
      if (!mounted) return;
      context.push(AppRoutes.verifyOtpPath(mobileNumber));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red.shade700),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not reach server. Is the backend running?'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.colors.primary.withOpacity(0.05),
                    context.colors.primary.withOpacity(0.04),
                    context.colors.primary.withOpacity(0.03),
                    context.colors.primary.withOpacity(0.015),
                    context.colors.primary.withOpacity(0.005),
                    context.colors.primary.withOpacity(0.0),
                  ],
                  stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.colors.tertiary.withOpacity(0.05),
                    context.colors.tertiary.withOpacity(0.04),
                    context.colors.tertiary.withOpacity(0.03),
                    context.colors.tertiary.withOpacity(0.015),
                    context.colors.tertiary.withOpacity(0.0),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  
                  // Back Button (Top Left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colors.outlineVariant.withOpacity(0.1)),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: context.colors.onSurface, size: 20),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.onboarding);
                          }
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  
                  // Hero Visual Area
                  SizedBox(
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 300,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                context.colors.primary.withOpacity(0.12),
                                context.colors.primary.withOpacity(0.08),
                                context.colors.primary.withOpacity(0.04),
                                context.colors.primary.withOpacity(0.0),
                              ],
                              stops: [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          width: 220,
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                context.colors.primary.withOpacity(0.18),
                                context.colors.primary.withOpacity(0.10),
                                context.colors.primary.withOpacity(0.05),
                                context.colors.primary.withOpacity(0.0),
                              ],
                              stops: [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                        BlendMask(
                          blendMode: BlendMode.screen,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC8rhNJkalp31ix0rDLqZL2yAgiMCXDDBn1q-DXrYLoXNDdlLr0jPQY3g1uWaHR1jijpewrF8EJ2S0Cwgnnto9zctE4Rbywg2Ndt9UdgZ0c1pIjrhjgrW19MuoDhLeUyZ0gWYdAXsZlfw-ny6Ul5X314KpMMUZSLk_B6q29eqU_7yZYpsoYGPf5JK0B0D57kda_QNFzM24inh0urjeFy4I3hNat5mzrU0WxnNdqBi27z2kZGwMPCHzShxruOm4VAk_3m625Himq7IM',
                            width: 380,
                            height: 280,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Headings
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                        color: context.colors.onSurface,
                      ),
                      children: [
                        TextSpan(text: 'WELCOME '),
                        TextSpan(
                          text: 'BACK',
                          style: GoogleFonts.spaceGrotesk(
                            color: context.colors.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter your mobile number to sign in with instant protection.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 48),
                  
                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(32),
                      border: Border(
                        top: BorderSide(color: Colors.white10, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 40,
                          offset: Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subtle Glow Edge at the top
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                context.colors.primary.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        Text(
                          'MOBILE NUMBER',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Input Field
                        Row(
                          children: [
                            Container(
                              height: 64,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: context.colors.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: Text(
                                '+91',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: context.colors.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2.0,
                                    color: context.colors.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                    hintText: '98765 43210',
                                    hintStyle: GoogleFonts.spaceGrotesk(
                                      color: context.colors.outline.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        
                        // CTA Section
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _getOtp,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: context.colors.primary.withOpacity(0.2),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [context.colors.primary, context.colors.primaryContainer],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'GET OTP',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 2.0,
                                              color: context.colors.onPrimaryFixed,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: context.colors.onPrimaryFixed,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Footer inside card
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                   context.push(AppRoutes.signup);
                                 },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                    children: [
                                      TextSpan(text: "Don't have an account? "),
                                      TextSpan(
                                        text: "Join the Fleet",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: context.colors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: context.colors.outline.withOpacity(0.1))),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'SHIELD PROTECTION',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 3.0,
                                        color: context.colors.outline.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: context.colors.outline.withOpacity(0.1))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 48),
                  
                  // Footer Decorative
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user, color: context.colors.primary.withOpacity(0.3), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'SHIELD SECURE PROTOCOL',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: context.colors.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;

  const BlendMask({
    super.key,
    required this.blendMode,
    this.opacity = 1.0,
    super.child,
  });

  @override
  RenderObject createRenderObject(context) {
    return RenderBlendMask(blendMode, opacity);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode blendMode;
  double opacity;

  RenderBlendMask(this.blendMode, this.opacity);

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()
        ..blendMode = blendMode
        ..color = Color.fromRGBO(255, 255, 255, opacity),
    );
    super.paint(context, offset);
    context.canvas.restore();
  }
}
