package co.takva.masjidhub

import android.content.Context
import com.realsil.sdk.core.RtkCore
import com.realsil.sdk.core.RtkConfigure
import com.realsil.sdk.core.logger.ZLogger
import com.realsil.sdk.dfu.RtkDfu
import com.realsil.sdk.dfu.utils.DfuAdapter
import com.realsil.sdk.dfu.model.DfuConfig
import com.realsil.sdk.dfu.model.DfuProgressInfo
import com.realsil.sdk.dfu.utils.GattDfuAdapter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import com.realsil.sdk.dfu.model.ConnectionParameters
import com.realsil.sdk.dfu.utils.ConnectParams
import com.realsil.sdk.dfu.DfuConstants

public class MainActivity : FlutterActivity() {
    private val CHANNEL = "dfu_channel"
    private val EVENT_CHANNEL = "dfu_progress"
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initializeSdkComponents()
        setupMethodChannels(flutterEngine)
    }

    private fun initializeSdkComponents() {
        val isDebug = true

        val configure = RtkConfigure.Builder()
            .debugEnabled(isDebug)
            .printLog(true)
            .logTag("OTA")
            .globalLogLevel(ZLogger.INFO)
            .build()

        RtkCore.initialize(applicationContext, configure)
        RtkDfu.initialize(applicationContext, isDebug)
    }

    private fun setupMethodChannels(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> initializeDfu(call.arguments, result)
                "startDfu" -> startDfuProcedure(call.arguments, result)
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    private fun initializeDfu(arguments: Any?, result: MethodChannel.Result) {
        try {
            val args = arguments as? Map<*, *> ?: throw IllegalArgumentException("Arguments are not a Map")
            val isDebug = args["isDebug"] as? Boolean ?: throw IllegalArgumentException("isDebug is missing or not a Boolean")

            val configure = RtkConfigure.Builder()
                .debugEnabled(isDebug)
                .printLog(true)
                .logTag("OTA")
                .globalLogLevel(ZLogger.INFO)
                .build()

            RtkCore.initialize(applicationContext, configure)
            RtkDfu.initialize(applicationContext, isDebug)

            result.success(null)
        } catch (e: Exception) {
            result.error("DFU_INIT_ERROR", e.message, null)
        }
    }

    private fun startDfuProcedure(arguments: Any?, result: MethodChannel.Result) {
        try {
            val args = arguments as? Map<*, *> ?: throw IllegalArgumentException("Invalid arguments")
            val deviceAddress = args["deviceAddress"] as String
            val filePath = args["filePath"] as String

            val dfuAdapter = GattDfuAdapter.getInstance(applicationContext)
            val dfuConfig = DfuConfig().apply {
                setChannelType(DfuConfig.CHANNEL_TYPE_GATT)
                setAddress(deviceAddress)
                setFilePath(filePath)
                setVersionCheckEnabled(false) // Disable for testing, re-enable later
                setIcCheckEnabled(false)
                setBatteryCheckEnabled(false)
                connectionParameters = ConnectionParameters.Builder()
                    .minInterval(6)
                    .maxInterval(17)
                    .latency(0)
                    .timeout(500)
                    .build()
                setFlowControlEnabled(true)
                setFlowControlInterval(1)
                setFlowControlIntervalUnit(50)
                setNotificationTimeout(10 * 1000)
                setBufferCheckMtuUpdateEnabled(true)
                setOtaWorkMode(DfuConstants.OTA_MODE_SILENT_FUNCTION)
            }

            dfuAdapter.initialize(object : DfuAdapter.DfuHelperCallback() {
                override fun onStateChanged(state: Int) {
                    runOnUiThread {
                        eventSink?.success(mapOf("state" to state))
                    }
                    when (state) {
                        DfuAdapter.STATE_INIT_OK -> {
                            val connectParams = ConnectParams.Builder()
                                .address(deviceAddress)
                                .reconnectTimes(1) // Increase retry attempts
                                .build()
                            dfuAdapter.connectDevice(connectParams)
                        }
                        DfuAdapter.STATE_PREPARED -> {
                            val deviceInfo = dfuAdapter.otaDeviceInfo
                            dfuAdapter.startOtaProcedure(deviceInfo, dfuConfig)
                            runOnUiThread {
                                result.success(null)
                            }
                        }
                        DfuAdapter.STATE_DISCONNECTED -> {
                            runOnUiThread {
                                eventSink?.error("DFU_ERROR", "Device disconnected", null)
                            }
                        }
                    }
                }

                override fun onError(type: Int, code: Int) {
                    val errorType = when (type) {
                        0 -> "CONNECTION"
                        1 -> "DFU"
                        else -> "UNKNOWN"
                    }
                    runOnUiThread {
                        eventSink?.error("DFU_FAILED", "$errorType Error: $code", null)
                    }
                }

                override fun onProgressChanged(progressInfo: DfuProgressInfo?) {
                    progressInfo?.let {
                        runOnUiThread {
                            eventSink?.success(mapOf("progress" to it.totalProgress))
                        }
                    }
                }
            })
        } catch (e: Exception) {
            runOnUiThread {
                result.error("DFU_START_ERROR", e.message, null)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Release DFU adapter resources
        val dfuAdapter = GattDfuAdapter.getInstance(applicationContext)
        dfuAdapter.abort()
        dfuAdapter.close()
        eventSink?.endOfStream()
        eventSink = null
    }
}