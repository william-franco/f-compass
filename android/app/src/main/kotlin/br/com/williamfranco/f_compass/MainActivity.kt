package br.com.williamfranco.f_compass

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class MainActivity : FlutterActivity(), SensorEventListener {
    private val CHANNEL = "br.com.williamfranco.f_compass/compass"

    private lateinit var sensorManager: SensorManager
    private var rotationSensor: Sensor? = null
    private var methodChannel: MethodChannel? = null
    private var isListening = false

    private val rotationMatrix = FloatArray(9)
    private val orientationAngles = FloatArray(3)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        rotationSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
            ?: sensorManager.getDefaultSensor(Sensor.TYPE_GAME_ROTATION_VECTOR)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> result.success(rotationSensor != null)
                "startListening" -> {
                    if (rotationSensor == null) {
                        result.error("UNAVAILABLE", "Rotation sensor not found", null)
                    } else {
                        startListening()
                        result.success(null)
                    }
                }
                "stopListening" -> {
                    stopListening()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startListening() {
        if (isListening) return
        rotationSensor?.let { sensor ->
            sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_UI)
            isListening = true
        }
    }

    private fun stopListening() {
        if (!isListening) return
        sensorManager.unregisterListener(this)
        isListening = false
    }

    override fun onPause() {
        stopListening()
        super.onPause()
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values)
        SensorManager.getOrientation(rotationMatrix, orientationAngles)
        var azimuth = Math.toDegrees(orientationAngles[0].toDouble())
        if (azimuth < 0) azimuth += 360.0
        val heading = (azimuth * 10).roundToInt() / 10.0
        methodChannel?.invokeMethod("updateHeading", heading)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
