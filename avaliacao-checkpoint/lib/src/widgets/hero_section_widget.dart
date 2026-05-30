import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/banner_cta.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Image.asset('assets/hero_cta.png', width: 300),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text.rich(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: GoogleFonts.orbitron().fontFamily,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              const TextSpan(
                text: 'Hora de abraçar seu ',
                style: TextStyle(color: Color(0xFFFF55DF)),
                children: [
                  TextSpan(
                    text: 'lado geek',
                    style: TextStyle(color: Color(0xFF8FFF24)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF780BF7),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 10,
              shadowColor: const Color(0xFF780BF7).withOpacity(0.6),
            ),
            child: Text(
              'Ver as Novidades',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
