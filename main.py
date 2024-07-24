# Daniel Miller July 2024
# dashUI digital dashboard

import sys
import random

from PyQt5.QtGui import QGuiApplication, QFont, QCursor
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import Qt, QTimer, QObject, pyqtSignal, pyqtSlot, QRunnable, QThread

from time import strftime, localtime
from datetime import datetime

import obd, time
from obd import OBDStatus

from monitorcontrol import get_monitors

app = QGuiApplication(sys.argv)
app.setOrganizationName("test")
app.setOrganizationDomain("test.com")
app.setApplicationName("dashUI")

mainFont = QFont("noto sans")
app.setFont(mainFont)
app.setOverrideCursor(Qt.BlankCursor)

engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.load('main.qml')

class Backend(QObject):

    # Signala for QML
    data = pyqtSignal(int, int, int, float, arguments=['speed', 'rpm', 'temp', 'battery'])
    time = pyqtSignal(str, str, int, bool, arguments=['hour_text', 'minute_text', 'second', 'PM'])
    error = pyqtSignal(bool)
    
    # Signals for OBD2 worker
    updateOBD2 = pyqtSignal()
    retryOBD2 = pyqtSignal()

    # Signals for DDC/CI worker
    minBright = pyqtSignal()
    setBright = pyqtSignal(int)

    def __init__(self):
        super().__init__()

        #100ms timer for data update
        self.timer1 = QTimer()
        self.timer1.setInterval(100)
        self.timer1.timeout.connect(self.updateOBD2)

        #500ms timer for time update
        self.timer2 = QTimer()
        self.timer2.setInterval(500)
        self.timer2.timeout.connect(self.update_time)
        self.timer2.start()

        # Create worker for OBD2, connect signals and slots
        self.OBD2_worker = OBD2Worker()
        self.thread = QThread()

        self.OBD2_worker.status.connect(self.onStatus)
        self.OBD2_worker.data.connect(self.data)
        self.OBD2_worker.moveToThread(self.thread)

        self.thread.started.connect(self.OBD2_worker.load)
        self.updateOBD2.connect(self.OBD2_worker.update)
        self.retryOBD2.connect(self.OBD2_worker.load)

        self.thread.start()

        # Create worker for DDC/CI, connect signals and slots
        self.DDCCI_worker = DDCCIWorker()
        self.thread2 = QThread()

        self.DDCCI_worker.moveToThread(self.thread2)

        self.minBright.connect(self.DDCCI_worker.minBrightness)
        self.setBright.connect(self.DDCCI_worker.setBrightness)

        self.thread2.start()

    # Attempt to load data again
    @pyqtSlot()
    def retry_connection(self):

        print("Retrying connection...")
        
        self.retryOBD2.emit()

    # Update display brightness and contrast from settings page
    @pyqtSlot(int)
    def update_brightness(self, i):

        print("Updating brightness...")
        
        if (i == 0):
            self.minBright.emit()
        elif (i == 1):
            self.setBright.emit(50)

    # Respond to status from OBD2Worker
    def onStatus(self, i):

        # If status 0, OBD was sucessful. Start timer and load data
        if (i == 0):
            self.timer1.start()
            self.error.emit(False)
        
        # If status 1, OBD failed. 
        if (i == 1):
            self.timer1.stop()
            self.error.emit(True)

    def update_time(self):
        
        time = localtime()
        hour = strftime("%-I", localtime()) 
        minute = strftime("%M", localtime()) 

        if (strftime("%p").upper() == "PM"):
            PM = True
        else:
            PM = False
  
        self.time.emit(hour, minute, time.tm_sec, PM)

# Worker thread for OBD2 communication
class OBD2Worker(QObject):

    # Signal for data
    data = pyqtSignal(int, int, int, float, arguments=['speed', 'rpm', 'temp', 'battery'])
    status = pyqtSignal(int)

    def load(self):

        # Create obd connection and start async
        print("OBD2Worker: OBD2 connection started...")
        
        self.connection = obd.Async(delay_cmds=0)
        self.connection.watch(obd.commands.RPM)
        self.connection.watch(obd.commands.SPEED)
        self.connection.watch(obd.commands.COOLANT_TEMP)
        self.connection.watch(obd.commands.CONTROL_MODULE_VOLTAGE)
        self.connection.start()

        # Small delay so that connection object exists for query immediatly after
        time.sleep(1)

        if (self.connection.status() == OBDStatus.NOT_CONNECTED):
            print("OBD2Worker: OBD2 adapter not connected")
            self.status.emit(1)

        elif (self.connection.status() == OBDStatus.CAR_CONNECTED):
            print("OBD2Worker: OBD2 connection successful")
            self.status.emit(0)

        elif (self.connection.status() == OBDStatus.ELM_CONNECTED):
            print("OBD2Worker: OBD2 connection successful, but no connection to vehicle")
            self.status.emit(1)

        else:
            print("OBD2Worker: Unrecognized error...")

    def update(self):

        print("OBD2Worker: Updating data...")

        speed = self.connection.query(obd.commands.SPEED)
        rpm = self.connection.query(obd.commands.RPM)
        temp = self.connection.query(obd.commands.COOLANT_TEMP)
        battery = self.connection.query(obd.commands.CONTROL_MODULE_VOLTAGE)

        try:
            print(int(speed.value.to('mph').magnitude))
            print(int(rpm.value.magnitude))
            print(int(temp.value.to('fahrenheit').magnitude))
            print(float(battery.value.magnitude))
            self.status.emit(0)
            self.data.emit(int(speed.value.to('mph').magnitude), int(rpm.value.magnitude), int(temp.value.to('fahrenheit').magnitude), round(float(battery.value.magnitude),1))

        except:
            print("OBD2Worker: OBD2 connection failed... was the vehicle disconnected?")
            self.status.emit(1)
            self.data.emit(0, 0, 0, 10)

# Worker thread for DDC/CI communication
class DDCCIWorker(QObject):

    # Set LCD backlight to minimum brightness level for night. This also sets contrast to zero, as the panel is still too bright otherwise
    def minBrightness(self):

        print("DDCCIWorker: Setting LCD to min brightness...")

        try: 
            for monitor in get_monitors():
                with monitor:
                    monitor.set_contrast(0)
                    time.sleep(.1)
                    monitor.set_luminance(0)
        
        except:
            print("DDCCIWorker: Brightness adjustment failed... is the i2c kernel module enabled?")

    # Set LCD backlight to custom level. This will set contrast to default of 50. 
    def setBrightness(self, i):

        print("DDCCIWorker: Setting LCD to custom brightness...")

        try:
            for monitor in get_monitors():
                with monitor:
                    monitor.set_contrast(50)
                    time.sleep(.1)
                    monitor.set_luminance(i)

        except:
            print("DDCCIWorker: Brightness adjustment failed... is the i2c kernel module enabled?")

backend = Backend()
engine.rootObjects()[0].setProperty('backend', backend)
backend.update_time()

sys.exit(app.exec())