import 'package:ayat_app/src/core/constants/route_constants.dart';
import 'package:ayat_app/src/presentation/home/home.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QBaseScreen(
        title: "About us",
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const _LogoDisplay(),
              const _DescriptionDisplay(),
              const _ContactUsDisplay(),
              const _LinksDisplay(),
            ].spacerDirectional(height: 30),
          ),
        ));
  }
}

class _LogoDisplay extends StatelessWidget {
  const _LogoDisplay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.goNamed(AppRoutes.home.name),
        child: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              "images/uxquran.png",
              fit: BoxFit.fitWidth,
            )),
      ),
    );
  }
}

class _DescriptionDisplay extends StatelessWidget {
  const _DescriptionDisplay();

  @override
  Widget build(BuildContext context) {
    return Text(
      kAboutUsDescription,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
    );
  }
}

class _ContactUsDisplay extends StatelessWidget {
  const _ContactUsDisplay();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("For feedback and suggestions:"),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                  height: 50,
                  child: TextButton(
                      onPressed: _openEmail,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          kAboutUsSupportEmail,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                decorationThickness: 2,
                                color: Colors.transparent,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                      color: Theme.of(context).primaryColor,
                                      offset: const Offset(0, -5))
                                ],
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                        ),
                      ))),
            ),
          ],
        ),
      ],
    );
  }

  void _openEmail() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: kAboutUsSupportEmail,
      queryParameters: {
        'subject': 'uxQuran',
        'body': '',
      },
    );
    launchUrl(emailLaunchUri);
  }
}

class _LinksDisplay extends StatelessWidget {
  const _LinksDisplay();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Other Links:"),
        _LinkButton(
          onTapped: () => launchUrl(Uri.parse(kBlogUrl)),
          title: "Blog",
        ),
        _LinkButton(
          onTapped: () => launchUrl(Uri.parse(kTelegramChatbotUrl)),
          title: "Telegram chatbot",
        )
      ].spacerDirectional(height: 5),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final VoidCallback onTapped;
  final String title;

  const _LinkButton({
    required this.title,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextButton(
                onPressed: onTapped,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title, textAlign: TextAlign.start),
                )),
          ),
        ),
      ],
    );
  }
}
