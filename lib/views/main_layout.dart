import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class MainLayout extends StatelessWidget {
  MainLayout({Key? key, required this.child}) : super(key: key);
  Widget child;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Drawer drawer() {
      return Drawer(
        child: ListView(
          children: [
            // const DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            //   child: Text(
            //     'Drawer Header',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 24,
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text('Autenticación',
                    style: Theme.of(context).textTheme.labelLarge)),
            const Divider(),
            // context.watch<AuthService>().isAuthenticated
            //     ? Container()
            //     : ListTile(
            //         title: const Text('Registrarse'),
            //         onTap: () => context.go('/auth/register'),
            //       ),
            context.watch<AuthService>().isAuthenticated
                ? Container()
                : ListTile(
                    title: const Text('Iniciar sesión'),
                    onTap: () => context.go('/auth/login'),
                  ),

            // FutureBuilder(
            //   future: context.watch<AuthService>().getCurrentUser(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       print('snapshqqqot: ${snapshot}');
            //       return ListTile(
            //           title: const Text('Mi perfil'),
            //           onTap: () => context.router.navigate(
            //                   AppLayoutRoute(children: [
            //                 ProfilePageRoute(username: snapshot.data!.username)
            //               ])));
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),

            context.watch<AuthService>().isAuthenticated
                ? ListTile(
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      context.read<AuthService>().logout();
                      context.go('/auth/login');
                    })
                : Container(),

            const SizedBox(
              height: 10,
            ),

            authenticatedWidget(
                context.watch<AuthService>().isAuthenticated,
                Center(
                    child: Text('Consultar',
                        style: Theme.of(context).textTheme.labelLarge))),

            authenticatedWidget(
                context.watch<AuthService>().isAuthenticated, const Divider()),
            authenticatedWidget(
                context.watch<AuthService>().isAuthenticated,
                ListTile(
                    title: const Text('Ingresos por RUT'),
                    selected: GoRouterState.of(context).fullPath == '/ingreso',
                    onTap: () {
                      context.go('/ingreso');
                    })),

            authenticatedWidget(
                context.watch<AuthService>().isAuthenticated,
                ListTile(
                    title: const Text('Ingresos por N°'),
                    selected: GoRouterState.of(context).fullPath ==
                        '/ingresoNCliente',
                    onTap: () {
                      context.go('/ingresoNCliente');
                    })),

            authenticatedWidget(
              context.watch<AuthService>().currentUser?.rol == 'admin',
              Center(
                  child: Text('Administración',
                      style: Theme.of(context).textTheme.labelLarge)),
            ),

            authenticatedWidget(
                context.watch<AuthService>().currentUser?.rol == 'admin',
                const Divider()),

            authenticatedWidget(
                context.watch<AuthService>().currentUser?.rol == 'admin',
                ListTile(
                    title: const Text('Resumen'),
                    selected: GoRouterState.of(context).fullPath == '/inicio',
                    onTap: () {
                      context.go('/inicio');
                    })),
            authenticatedWidget(
                context.watch<AuthService>().currentUser?.rol == 'admin',
                ListTile(
                  title: const Text('Planes'),
                  selected: GoRouterState.of(context).path == '/app/planes',
                  onTap: () {
                    context.go('/planes');
                  },
                )),
            authenticatedWidget(
                context.watch<AuthService>().currentUser?.rol == 'admin',
                ListTile(
                  title: const Text('Clientes'),
                  selected: GoRouterState.of(context).path == '/app/clientes',
                  onTap: () {
                    context.go('/clientes');
                  },
                )),
            authenticatedWidget(
                context.watch<AuthService>().currentUser?.rol == 'admin',
                ListTile(
                  title: const Text('Pagos'),
                  selected: GoRouterState.of(context).path == '/app/pagos',
                  onTap: () {
                    context.go('/pagos');
                  },
                ))
          ],
        ),
      );
    }

    AppBar buildDesktopAppBar() {
      return AppBar(
        title: const Text('Gym'),
/*
        actions: [
          context.watch<AuthService>().isAuthenticated
              ? TextButton(
                  onPressed: () async {
                    var result = await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return QuestionForm(
                            userId:
                                context.watch<AuthService>().currentUser!.id);
                      },
                    );
                    print("result: $result");
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.purple,
                      ),
                      Text('Crear pregunta',
                          style: TextStyle(color: Colors.purple)),
                    ],
                  ))
              : Container(),
          const SizedBox(width: 8),
          context.watch<AuthService>().isAuthenticated
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.go(
                        '/perfil/${Provider.of<AuthService>(context, listen: false).currentUser!.username}'),
                    child: ProfilePicture(
                        showIcons: false,
                        user: Provider.of<AuthService>(context, listen: false)
                            .currentUser!),
                  ))
              : Container(),

          //
          // CircleAvatar(
          //         child: Text(context
          //             .watch<AuthService>()
          //             .currentUser!
          //             .name
          //             .substring(0, 1)),
          //       )
          context.watch<AuthService>().isAuthenticated
              ? IconButton(
                  onPressed: () => context.read<AuthService>().logout(),
                  icon: Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.logout,
                          color: Colors.red,
                        )),
                  ))
              : Container(),
        ],
*/
      );
    }

    AppBar buildMobileAppBar() {
      return AppBar(
        title: const Text('Gym'),
/*
        actions: [
          context.watch<AuthService>().isAuthenticated
              ? IconButton(
                  onPressed: () async {
                    var result = await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return QuestionForm(
                            userId:
                                context.watch<AuthService>().currentUser!.id);
                      },
                    );
                    print("result: $result");
                  },
                  icon: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.purple,
                          ))))
              : Container(),
        ],
*/
      );
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
          key: scaffoldKey,
          appBar: (constraints.maxWidth > 800)
              ? buildDesktopAppBar()
              : buildMobileAppBar(),
          drawer: (constraints.maxWidth < 800) ? drawer() : null,
          body: (constraints.maxWidth > 800)
              ? Row(
                  children: <Widget>[
                    drawer(),
                    Expanded(child: ClipRect(child: child))
                  ],
                )
              : ClipRect(child: child));
      // if (constraints.maxWidth > 800) {
      //   return _buildDesktopContainers(context);
      // } else {
      //   return _buildMobileContainer(context);
      // }
    });
  }

  Widget authenticatedWidget(bool isAuthenticated, Widget widget) {
    return isAuthenticated ? widget : Container();
  }
}
