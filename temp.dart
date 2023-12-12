
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          titleTextStyle: const TextStyle(fontSize: 30),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
          color: Colors.cyan,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const RegisterView(),
                    ),
                  );
                },
                child: const Text('Register'),
              )),
              SizedBox(
                  child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const LoginView(),
                    ),
                  );
                },
                child: const Text('Login'),
              ))
            ],
          ),
        ));
  }