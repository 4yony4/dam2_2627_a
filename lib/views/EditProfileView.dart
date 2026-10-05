// =====================================================================
// EditProfileView.dart — EDITAR EL PERFIL (ruta "/EditProfileview")
// ---------------------------------------------------------------------
// Muestra los datos del usuario logueado (nombre, edad y altura) en un
// formulario para que los pueda cambiar y guardarlos en Firestore.
// Se llega desde el menú de "tres puntos" de HomeView -> "Perfil".
//   - "Guardar"  -> valida, actualiza Dataholder y "Perfiles/{uid}" -> vuelve atrás
//   - "Cancelar" -> vuelve atrás sin guardar
// Dataholder: LEE y ESCRIBE perfilUsuario (name, edad, altura).
// Firestore: escribe "Perfiles/{uid}" con update().
// (No confundir con ProfileView, que CREA el perfil la primera vez.)
// =====================================================================
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FbObjects/Perfil.dart';

/// Pantalla para editar el perfil. Es un StatefulWidget porque mientras se
/// guarda cambia el estado (bGuardando) y hay que redibujar el botón.
class Editprofileview extends StatefulWidget{
  @override
  State<Editprofileview> createState() => _EditprofileviewState();
}

/// State de EditProfileView: controladores del formulario y métodos.
class _EditprofileviewState extends State<Editprofileview> {
  /// Clave del Form: permite validar todos los campos a la vez con validate().
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();

  /// Controladores de los tres campos del formulario.
  final TextEditingController nombreController=TextEditingController();
  final TextEditingController edadController=TextEditingController();
  final TextEditingController alturaController=TextEditingController();

  /// Acceso a Cloud Firestore.
  final FirebaseFirestore db=FirebaseFirestore.instance;

  /// true mientras se está guardando en Firestore (desactiva el botón).
  bool bGuardando=false;

  XFile? ficheroCargado;

  /// Rellena los campos con los datos actuales del perfil.
  /// Se hace en initState (UNA vez) y no en build(): si estuviera en build(),
  /// cada redibujado borraría lo que el usuario ha escrito.
  @override
  void initState() {
    super.initState();
    Perfil perfil=Dataholder.instance.perfilUsuario;
    // `?? ""`: si el dato es null, ponemos el campo vacío.
    nombreController.text=perfil.name ?? "";
    edadController.text=perfil.edad?.toString() ?? "";
    alturaController.text=perfil.altura?.toString() ?? "";
  }

  /// Los controladores reservan recursos: hay que liberarlos al cerrar la pantalla.
  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  /// Validador del nombre: no puede estar vacío.
  /// Un validador devuelve null si el valor es correcto, o el texto del error.
  String? validarNombre(String? valor){
    if(valor==null || valor.trim().isEmpty) return "Escribe tu nombre";
    return null;
  }

  /// Validador de la edad: número entero entre 0 y 150.
  /// int.tryParse devuelve null (en vez de lanzar un error) si no es un número.
  String? validarEdad(String? valor){
    int? edad=int.tryParse(valor?.trim() ?? "");
    if(edad==null) return "La edad debe ser un número entero";
    if(edad<0 || edad>150) return "Edad no válida";
    return null;
  }

  /// Validador de la altura: número decimal mayor que 0. Se acepta "1,80"
  /// cambiando la coma por punto, porque double.tryParse solo entiende el punto.
  String? validarAltura(String? valor){
    double? altura=double.tryParse((valor ?? "").trim().replaceAll(",", "."));
    if(altura==null) return "La altura debe ser un número";
    if(altura<=0) return "Altura no válida";
    return null;
  }

  /// Botón "Guardar": valida, actualiza el perfil en Dataholder y en Firestore,
  /// y vuelve a la pantalla anterior.
  Future<void> clickGuardar() async{
    // validate() ejecuta los validadores de todos los campos y pinta los errores.
    if(!formKey.currentState!.validate()) return;

    setState(() {
      bGuardando=true;
    });

    Perfil perfil=Dataholder.instance.perfilUsuario;

    if(perfil.avatar!=null){
      await Dataholder.instance.storageadmin.subirImagen(ficheroCargado!);
    }

    perfil.name=nombreController.text.trim();
    perfil.edad=int.parse(edadController.text.trim());
    perfil.altura=double.parse(alturaController.text.trim().replaceAll(",", "."));

    // uid del perfil o, si faltase, el del usuario de Firebase Auth.
    String uid=perfil.uid ?? FirebaseAuth.instance.currentUser!.uid;

    try{
      // set() con merge: true solo cambia estos campos y crea el documento
      // si no existiera (update() fallaría en ese caso).
      await db.collection("Perfiles").doc(uid).set(perfil.toFirestore(), SetOptions(merge: true));
      // `mounted`: tras un await la pantalla podría haberse cerrado ya.
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Perfil actualizado")),
      );
      Navigator.pop(context);
    }
    catch(error){
      if(!mounted) return;
      setState(() {
        bGuardando=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo guardar: $error"), backgroundColor: AppColores.error),
      );
    }
  }

  /// Cabecera verde con degradado, el icono del usuario y su email.
  Widget crearCabecera(){
    String email=FirebaseAuth.instance.currentUser?.email ?? "";
    return Container(
      width: double.infinity,
      // Abajo dejamos espacio extra porque la tarjeta del formulario "se monta" encima.
      padding: EdgeInsets.fromLTRB(AppEspacios.lg, AppEspacios.lg, AppEspacios.lg, AppEspacios.xl+AppEspacios.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColores.principal, AppColores.oscuro],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadios.cabecera)),
      ),
      child: Column(
        children: [
          crearAvatar(),
          SizedBox(height: AppEspacios.sm),
          Text("Editar perfil", style: AppTextos.tituloCabecera),
          if(email.isNotEmpty) ...[
            SizedBox(height: AppEspacios.xs),
            Text(email, style: TextStyle(color: AppColores.sobrePrincipalSuave)),
          ],
        ],
      ),
    );
  }

  /// Avatar de la cabecera: la foto del perfil recortada en círculo o, si
  /// todavía no hay ninguna, el icono por defecto.
  Widget crearAvatar(){
    Image? avatar=Dataholder.instance.perfilUsuario.avatar;
    double tamano=AppEspacios.iconoGrande+AppEspacios.xl;
    if(avatar==null){
      return Icon(Icons.account_circle_rounded, size: tamano, color: AppColores.sobrePrincipal);
    }
    // ClipOval recorta a su hijo en forma de círculo.
    return ClipOval(
      child: SizedBox(width: tamano, height: tamano, child: avatar),
    );
  }

  /// Botón "Avatar": abre la cámara, convierte la foto (XFile) en un widget
  /// Image, la guarda en el perfil de Dataholder y redibuja la cabecera.
  void elegirAvatarCamara() async{
    ImagePicker imagePicker = ImagePicker();

    ficheroCargado = await imagePicker.pickImage(source: ImageSource.camera);
    // null = el usuario ha cerrado la cámara sin hacer foto.
    if(ficheroCargado==null) return;

    // XFile -> bytes -> Image. Image.memory funciona en Android y en Web
    // (Image.file necesita dart:io, que no existe en Web).
    final bytes = await ficheroCargado?.readAsBytes();
    // `mounted`: tras un await la pantalla podría haberse cerrado ya.
    if(!mounted) return;
    setState(() {
      // fit: cover rellena el círculo entero sin deformar la foto.
      Dataholder.instance.perfilUsuario.avatar=Image.memory(bytes!, fit: BoxFit.cover);
    });
  }

  void elegirAvatarGaleria() async{
    ImagePicker imagePicker = ImagePicker();

    ficheroCargado = await imagePicker.pickImage(source: ImageSource.gallery);
    // null = el usuario ha cerrado la cámara sin hacer foto.
    if(ficheroCargado==null) return;

    // XFile -> bytes -> Image. Image.memory funciona en Android y en Web
    // (Image.file necesita dart:io, que no existe en Web).
    final bytes = await ficheroCargado?.readAsBytes();



    // `mounted`: tras un await la pantalla podría haberse cerrado ya.
    if(!mounted) return;
    setState(() {
      // fit: cover rellena el círculo entero sin deformar la foto.
      Dataholder.instance.perfilUsuario.avatar=Image.memory(bytes!, fit: BoxFit.cover);
    });
  }

  /// Dibuja la pantalla de edición.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PERFIL"),
      ),
      body: SafeArea(
        top: false,
        // SingleChildScrollView: al abrir el teclado se puede hacer scroll en vez de desbordar.
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppEspacios.xl),
          child: Column(
            children: [
              crearCabecera(),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppEspacios.anchoFormulario+AppEspacios.xl),
                  child: Transform.translate(
                    // La tarjeta sube y se solapa con la cabecera.
                    offset: Offset(0, -AppEspacios.xl),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppEspacios.md),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(AppEspacios.lg),
                          // Form agrupa los TextFormField para validarlos juntos.
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: nombreController,
                                  validator: validarNombre,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(labelText: "Nombre", prefixIcon: Icon(Icons.person_outline_rounded)),
                                ),
                                SizedBox(height: AppEspacios.md),
                                TextFormField(
                                  controller: edadController,
                                  validator: validarEdad,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(labelText: "Edad", prefixIcon: Icon(Icons.cake_outlined)),
                                ),
                                SizedBox(height: AppEspacios.md),
                                TextFormField(
                                  controller: alturaController,
                                  validator: validarAltura,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => clickGuardar(),
                                  decoration: InputDecoration(labelText: "Altura (m)", prefixIcon: Icon(Icons.height_rounded)),
                                ),
                                SizedBox(height: AppEspacios.md),

                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: elegirAvatarCamara,
                                        child: Text("Avatar Camara"),
                                      ),
                                    ),
                                    SizedBox(width: AppEspacios.md),
                                    Expanded(
                                      // onPressed: null desactiva el botón mientras se guarda.
                                      child: OutlinedButton(
                                        onPressed: elegirAvatarGaleria,
                                        child: Text("Avatar Galeria"),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppEspacios.lg),
                                // Row con dos Expanded: cada botón ocupa la mitad del ancho.
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: bGuardando ? null : () => Navigator.pop(context),
                                        child: Text("Cancelar"),
                                      ),
                                    ),
                                    SizedBox(width: AppEspacios.md),
                                    Expanded(
                                      // onPressed: null desactiva el botón mientras se guarda.
                                      child: FilledButton(
                                        onPressed: bGuardando ? null : clickGuardar,
                                        child: bGuardando
                                            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColores.sobrePrincipal))
                                            : Text("Guardar"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
