package com.newton.dam2_2627_a
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity(){

    // Canal para pasar a Dart (NFCAdmin) el tag que ha abierto la app.
    private var canalNfc: MethodChannel? = null

    // UID del tag que ABRIÓ la app. Dart lo pide con "getTagInicial" cuando ya
    // está listo (al arrancar, Dart todavía no escucha el canal).
    private var uidInicial: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        canalNfc = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "nfc_launch").apply {
            setMethodCallHandler { call, result ->
                if (call.method == "getTagInicial") {
                    result.success(uidInicial)
                    uidInicial = null // se entrega una sola vez
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // App cerrada + tag: guardamos el UID hasta que Dart lo pida.
        if (savedInstanceState == null) uidInicial = leerIntentNfc(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // App ya abierta + tag: Dart ya escucha, se lo enviamos directamente.
        leerIntentNfc(intent)?.let { uid -> canalNfc?.invokeMethod("onTag", uid) }
    }

    /** Devuelve el UID del tag en hexadecimal, o null si el intent no es de NFC. */
    private fun leerIntentNfc(intent: Intent?): String? {
        if (intent?.action != NfcAdapter.ACTION_TECH_DISCOVERED) return null
        val tag: Tag? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)
        }
        val uid = tag?.id?.joinToString("") { "%02X".format(it) } ?: ""
        Log.d("NFC", "he leido: $uid")
        return uid
    }
}
