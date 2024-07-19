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

    #Signal for data
    data = pyqtSignal(int, int, int, int, arguments=['speed', 'rpm', 'temp', 'battery'])
    time = pyqtSignal(str, str, int, bool, arguments=['hour_text', 'minute_text', 'second', 'PM'])
    error = pyqtSignal(bool)

    def __init__(self):
        super().__init__()

        #100ms timer for data update
        self.timer1 = QTimer()
        self.timer1.setInterval(100)
        self.timer1.timeout.connect(self.update_data)

        #500ms timer for time update
        self.timer2 = QTimer()
        self.timer2.setInterval(500)
        self.timer2.timeout.connect(self.update_time)
        self.timer2.start()

        # Create worker for OBD2
        self.obj = Worker()
        self.thread = QThread()
        self.obj.moveToThread(self.thread)
        self.thread.started.connect(self.obj.load)
        self.obj.status.connect(self.onStatus)
        self.obj.data.connect(self.data)
        self.thread.start()

    # Once the startup animation has finished, attempt to read data
    @pyqtSlot()
    def load_data(self):
        
        self.obj.update()

    # After getting OBD data, start timer to regularly update
    def update_data(self):

        self.obj.update()

    # Attempt to load data again
    @pyqtSlot()
    def retry_connection(self):

        print("Retrying connection...")

        self.obj.load()

    def onStatus(self, i):

        # If status 0, OBD was sucessful. Start timer and load data
        if (i == 0):
            self.timer1.start()
            self.error.emit(False)
        
        # If status 1, OBD failed. 
        if (i == 1):
            self.error.emit(True)
            self.timer1.stop()

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
class Worker(QObject):

    # Signal for data
    data = pyqtSignal(int, int, int, int, arguments=['speed', 'rpm', 'temp', 'battery'])
    status = pyqtSignal(int)

    def load(self):

        time.sleep(5)

        # Create obd connection and start async
        print("Worker: OBD2 connection started...")
        
        self.connection = obd.Async(delay_cmds=0)
        self.connection.watch(obd.commands.RPM)
        self.connection.watch(obd.commands.SPEED)
        self.connection.watch(obd.commands.COOLANT_TEMP)
        self.connection.watch(obd.commands.CONTROL_MODULE_VOLTAGE)
        self.connection.start()

        time.sleep(1)

        if (self.connection.status() == OBDStatus.NOT_CONNECTED):
            print("Worker: OBD2 adapter not connected")
            self.status.emit(1)

        elif (self.connection.status() == OBDStatus.CAR_CONNECTED):
            print("Worker: OBD2 connection successful")
            self.status.emit(0)

        elif (self.connection.status() == OBDStatus.ELM_CONNECTED):
            print("Worker: OBD2 connection successful, but no connection to vehicle")
            self.status.emit(1)

        else:
            print("Worker: Unrecognized error...")


    def update(self):

        speed = self.connection.query(obd.commands.SPEED)
        rpm = self.connection.query(obd.commands.RPM)
        temp = self.connection.query(obd.commands.COOLANT_TEMP)
        battery = self.connection.query(obd.commands.CONTROL_MODULE_VOLTAGE)

        try:
            print(int(speed.value.to('mph').magnitude))
            print(int(rpm.value.magnitude))
            print(int(temp.value.to('fahrenheit').magnitude))
            print(int(battery.value.magnitude))
            self.status.emit(0)
            self.data.emit(int(speed.value.to('mph').magnitude), int(rpm.value.magnitude), int(temp.value.to('fahrenheit').magnitude), int(battery.value.magnitude))

        except:
            print("Worker: OBD2 connection failed... was the vehicle disconnected?")
            self.status.emit(1)
            self.data.emit(0, 0, 0, 10)

backend = Backend()
worker = Worker()
engine.rootObjects()[0].setProperty('backend', backend)
backend.update_time()

sys.exit(app.exec())